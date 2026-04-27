/**
 * Axton Security Bot
 * Scans workspace for malicious code, bad dependencies, and vulnerabilities
 * Reports findings via Telegram
 * 
 * Usage: node security-bot.js [workspace-path]
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// === CONFIG ===
const WORKSPACE = process.argv[2] || '/home/openclaw/.openclaw/workspace';
const TELEGRAM_BOT_TOKEN = '7814383548:AAEQ3ncR5B7xR3oW1yjyR-U7WkryxR4C2cI';
const TELEGRAM_CHAT_ID = '6463127078';

// === MALICIOUS PATTERNS (with false-positive filtering) ===
const CRITICAL_PATTERNS = [
  { 
    pattern: /eval\s*\(\s*(?!['"`]\s*['"`])/gi, 
    severity: 'CRITICAL', 
    label: 'eval() with dynamic input',
    ignore: ['toast(', 'console.log', 'JSON.parse', 'String()']
  },
  { 
    pattern: /Function\s*\(\s*['"`]/gi, 
    severity: 'CRITICAL', 
    label: 'Dynamic Function() with string',
    ignore: []
  },
  { 
    pattern: /curl\s+.*\|\s*sh/gi, 
    severity: 'CRITICAL', 
    label: 'Pipe curl to shell — infection vector',
    ignore: []
  },
  { 
    pattern: /wget\s+.*\|\s*sh/gi, 
    severity: 'CRITICAL', 
    label: 'Pipe wget to shell — infection vector',
    ignore: []
  },
  { 
    pattern: /rm\s+-rf\s+\/[^s]/gi, 
    severity: 'CRITICAL', 
    label: 'Recursive rm from root — destructive',
    ignore: []
  },
  { 
    pattern: /fork\s*\(\s*['\"\/]|process\.fork/gi, 
    severity: 'CRITICAL', 
    label: 'Process fork with path — fork bomb',
    ignore: []
  },
  { 
    pattern: /\x60[\s\S]{500,}\x60/gi, 
    severity: 'HIGH', 
    label: 'Very large template literal (>500 chars) — manual review needed',
    ignore: []
  },
  { 
    pattern: /__import__\s*\(/gi, 
    severity: 'CRITICAL', 
    label: 'Python __import__ — arbitrary code exec',
    ignore: []
  },
  { 
    pattern: /os\.system\s*\(/gi, 
    severity: 'CRITICAL', 
    label: 'Python os.system — shell injection',
    ignore: []
  },
  { 
    pattern: /child_process\.exec\s*\([^)]*\$\{(?!{)/gi, 
    severity: 'CRITICAL', 
    label: 'Shell injection via template string',
    ignore: []
  },
  { 
    pattern: /document\.cookie\s*=/gi, 
    severity: 'HIGH', 
    label: 'Setting document.cookie — XSS risk',
    ignore: []
  },
  { 
    pattern: /innerHTML\s*=\s*(?!['"`]<\w)/gi, 
    severity: 'HIGH', 
    label: 'Dynamic innerHTML assignment — XSS',
    ignore: []
  },
  { 
    pattern: /new\s+Function\s*\([^)]*\.\s*split\s*\(/gi, 
    severity: 'HIGH', 
    label: 'Dynamic code from string split — obfuscation',
    ignore: []
  },
];

const HIGH_PATTERNS = [
  { 
    pattern: /https?:\/\/(?!api\.|localhost|127\.|fonts\.|maps\.|www\.|images\.unsplash|lovable\.dev|corsproxy|cloudflare|github\.com|console\.cloud\.google)/gi, 
    severity: 'MEDIUM', 
    label: 'Hardcoded external URL — potential exfil',
    ignore: []
  },
  { 
    pattern: /password\s*[=:]\s*['"][^'"]{8,}/gi, 
    severity: 'HIGH', 
    label: 'Hardcoded password in code',
    ignore: []
  },
  { 
    pattern: /api[_-]?key\s*[=:]\s*['"]sb_[^'"]+/gi, 
    severity: 'HIGH', 
    label: 'Hardcoded Supabase key',
    ignore: []
  },
  { 
    pattern: /api[_-]?key\s*[=:]\s*['"]sk-[^'"]+/gi, 
    severity: 'HIGH', 
    label: 'Hardcoded API secret key',
    ignore: []
  },
  { 
    pattern: /socket\s*\.\s*(connect|emit)\s*\([^)]*\b(ip|port|host)\b/gi, 
    severity: 'HIGH', 
    label: 'Socket to external host — potential C2',
    ignore: []
  },
  { 
    pattern: /process\.env\.(SUPABASE|GITHUB|STRIPE|TOKEN|SECRET|PRIVATE)/gi, 
    severity: 'MEDIUM', 
    label: 'Sensitive env var access in code',
    ignore: []
  },
  { 
    pattern: /\.git\/objects\/[a-f0-9]{38,}/gi, 
    severity: 'CRITICAL', 
    label: 'Git object manipulation attempt',
    ignore: []
  },
];

const SKIP_PATHS = ['node_modules', '.git', 'dist', 'build', '.next', '.nuxt', 'coverage', '__pycache__', 'public', '.openclaw'];
const SKIP_FILES = ['package-lock.json', 'bun.lockb', '.eslintrc', 'tailwind.config'];

// === UTILS ===
async function sendTelegram(msg) {
  const https = require('https');
  const data = JSON.stringify({ chat_id: TELEGRAM_CHAT_ID, text: msg, parse_mode: 'Markdown' });
  return new Promise((resolve, reject) => {
    const req = https.request({
      hostname: 'api.telegram.org',
      path: `/bot${TELEGRAM_BOT_TOKEN}/sendMessage`,
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) }
    }, res => { let d = ''; res.on('data', c => d += c); res.on('end', resolve); });
    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

function scanContent(filePath, content) {
  const findings = [];
  const allPatterns = [...CRITICAL_PATTERNS, ...HIGH_PATTERNS];
  
  for (const check of allPatterns) {
    // Skip known good files
    if (SKIP_FILES.some(f => filePath.includes(f))) continue;
    
    const matches = content.match(check.pattern);
    if (!matches) continue;
    
    // Filter out false positives
    const realMatches = matches.filter(m => {
      return !check.ignore.some(ign => m.includes(ign));
    });
    
    if (realMatches.length > 0) {
      findings.push({
        severity: check.severity,
        label: check.label,
        count: realMatches.length,
        sample: realMatches[0].slice(0, 80)
      });
    }
  }
  return findings;
}

function scanNpmAudit() {
  try {
    const output = execSync('npm audit --json 2>/dev/null', { 
      cwd: WORKSPACE, 
      timeout: 30000,
      encoding: 'utf8' 
    });
    const data = JSON.parse(output);
    const vulns = data.advisories ? Object.values(data.advisories) : [];
    const critical = vulns.filter(v => v.severity === 'critical');
    const high = vulns.filter(v => v.severity === 'high');
    return { critical, high, total: vulns.length };
  } catch(e) {
    if (e.status === 0) return { critical: [], high: [], total: 0 }; // no vulns
    return null; // npm audit not available or error
  }
}

function scanDir(dir, depth = 0) {
  if (depth > 4) return [];
  const results = [];
  let entries;
  try {
    entries = fs.readdirSync(dir);
  } catch(e) { return []; }
  
  for (const entry of entries) {
    if (SKIP_PATHS.some(s => entry.includes(s))) continue;
    const fullPath = path.join(dir, entry);
    try {
      const stat = fs.statSync(fullPath);
      if (stat.isDirectory()) {
        results.push(...scanDir(fullPath, depth + 1));
      } else {
        const ext = path.extname(entry);
        if (['.js', '.ts', '.tsx', '.jsx', '.py', '.sh', '.rb', '.php', '.html'].includes(ext)) {
          try {
            const content = fs.readFileSync(fullPath, 'utf8');
            const findings = scanContent(fullPath, content);
            if (findings.length > 0) {
              results.push({ path: fullPath.replace(WORKSPACE, ''), findings });
            }
          } catch(e) {}
        }
      }
    } catch(e) {}
  }
  return results;
}

function formatFindings(files) {
  if (files.length === 0) return null;
  let msg = '*🔒 Axton Security Alert*\n\n';
  for (const f of files.slice(0, 10)) {
    msg += `📄 ${f.path}\n`;
    for (const finding of f.findings) {
      const emoji = finding.severity === 'CRITICAL' ? '🔴' : finding.severity === 'HIGH' ? '🟠' : '🟡';
      msg += `  ${emoji} ${finding.label} (${finding.count}x)\n`;
      msg += `  \`${finding.sample.trim()}\`\n`;
    }
    msg += '\n';
  }
  return msg;
}

function formatNpmAudit(audit) {
  if (!audit || audit.total === 0) return null;
  let msg = '*📦 Npm Security Audit*\n\n';
  msg += `Found ${audit.total} vulnerabilities\n`;
  if (audit.critical.length > 0) {
    msg += `🔴 Critical: ${audit.critical.length}\n`;
    audit.critical.slice(0, 3).forEach(v => {
      msg += `  • ${v.module_name}: ${v.title}\n`;
    });
  }
  if (audit.high.length > 0) {
    msg += `🟠 High: ${audit.high.length}\n`;
    audit.high.slice(0, 3).forEach(v => {
      msg += `  • ${v.module_name}: ${v.title}\n`;
    });
  }
  return msg;
}

// === MAIN ===
(async () => {
  const mode = process.argv[3] || 'full';
  const start = Date.now();
  let report = `🔒 *Security Scan Complete*\n`;
  report += `Workspace: \`${WORKSPACE}\`\n`;
  report += `Mode: ${mode}\n\n`;
  
  if (mode === 'full' || mode === 'code') {
    const files = scanDir(WORKSPACE);
    report += `Files scanned: ${files.reduce((a, f) => a + f.findings.length, 0) > 0 ? '⚠️ threats found' : '✅ clean'}\n`;
    const findings = formatFindings(files);
    if (findings) report += findings + '\n';
  }
  
  if (mode === 'full' || mode === 'npm') {
    const audit = scanNpmAudit();
    const npmReport = formatNpmAudit(audit);
    if (npmReport) report += npmReport + '\n';
    else if (audit) report += `📦 npm audit: ✅ no vulnerabilities\n\n`;
  }
  
  report += `Scan time: ${((Date.now() - start) / 1000).toFixed(1)}s`;
  
  console.log(report);
  try {
    await sendTelegram(report);
  } catch(e) {
    console.log('Telegram send failed:', e.message);
  }
})();
