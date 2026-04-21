#!/usr/bin/env node
/**
 * NEUROMATCH SELF-IMPROVEMENT ENGINE 🚀
 * Analyzes errors, finds patterns, generates fixes
 * Runs autonomously — no prompting needed
 */

import fs from 'fs';
import path from 'path';

const LEARNINGS_FILE = '/data/workspace/.learnings/LEARNINGS.md';
const ERRORS_FILE = '/data/workspace/.learnings/ERRORS.md';
const FEATURES_FILE = '/data/workspace/.learnings/FEATURE_REQUESTS.md';
const IMPROVEMENTS_DIR = '/data/workspace/self-improvement/improvements';
const BRIEFING_FILE = '/data/workspace/self-improvement/briefing.md';
const FIXES_DIR = '/data/workspace/self-improvement/fixes';

if (!fs.existsSync(IMPROVEMENTS_DIR)) fs.mkdirSync(IMPROVEMENTS_DIR, { recursive: true });
if (!fs.existsSync(FIXES_DIR)) fs.mkdirSync(FIXES_DIR, { recursive: true });

// Parse markdown entries
function parseEntries(file) {
  if (!fs.existsSync(file)) return [];
  const content = fs.readFileSync(file, 'utf8');
  const entries = content.split('---').filter(e => e.trim());
  return entries.map(entry => {
    const lines = entry.trim().split('\n');
    const result = { raw: entry };
    lines.forEach(line => {
      const [key, ...rest] = line.split(':');
      if (key && rest.length) {
        result[key.trim().toLowerCase()] = rest.join(':').trim();
      }
    });
    return result;
  });
}

// Find patterns in errors/learnings
function findPatterns(entries) {
  const patterns = {};
  entries.forEach(entry => {
    if (entry.tags) {
      entry.tags.split(',').forEach(tag => {
        const t = tag.trim();
        if (!patterns[t]) patterns[t] = [];
        patterns[t].push(entry);
      });
    }
    if (entry['pattern-key']) {
      const pk = entry['pattern-key'];
      if (!patterns[pk]) patterns[pk] = [];
      patterns[pk].push(entry);
    }
  });
  return patterns;
}

// Generate fix for a pattern
function generateFix(pattern, entries) {
  const fix = {
    id: `FIX-${Date.now()}`,
    pattern,
    occurrences: entries.length,
    severity: entries.length >= 3 ? 'HIGH' : entries.length >= 2 ? 'MEDIUM' : 'LOW',
    entries: entries.map(e => e.raw?.substring(0, 200)).slice(0, 5),
    fix: '',
    created: new Date().toISOString()
  };

  // Generate fix based on pattern type
  const p = pattern.toLowerCase();
  
  if (p.includes('take-initiative') || p.includes('action')) {
    fix.fix = `Before asking Jordan anything:
1. Can I build this without asking? Build it.
2. Can I figure this out from memory? Check memory first.
3. Can I make a reasonable assumption? Make it and note it.
4. ONLY ask if blocked.`;
  } else if (p.includes('context') || p.includes('memory')) {
    fix.fix = `Session start checklist (mandatory):
1. Read MEMORY.md
2. Read today's memory file
3. Check .learnings/ for recent corrections
4. Lead with "Welcome back — here's where we left off..."`;
  } else if (p.includes('web') || p.includes('search')) {
    fix.fix = `Web search priority order:
1. Felo API (if key set)
2. web_fetch on public APIs
3. web_search with retry
4. Ask Jordan to run locally if blocked`;
  } else if (p.includes('proactive')) {
    fix.fix = `Every session:
1. Check if there's something I can do WITHOUT being asked
2. If yes: do it and tell Jordan what I did
3. Don't ask "do you want me to..." 
4. Just say "I did X for you"`;
  } else {
    fix.fix = `General fix needed for: ${pattern}
Manually review: ${entries.length} related entries`;
  }

  return fix;
}

// Generate daily briefing
function generateBriefing() {
  const learnings = parseEntries(LEARNINGS_FILE);
  const errors = parseEntries(ERRORS_FILE);
  const features = parseEntries(FEATURES_FILE);
  
  const pendingLearnings = learnings.filter(l => l.status === 'pending');
  const pendingErrors = errors.filter(e => e.status === 'pending');
  const pendingFeatures = features.filter(f => f.status === 'pending');
  const highPriority = [...pendingLearnings, ...pendingErrors]
    .filter(e => e.priority === 'high' || e.priority === 'critical');

  const briefing = `# 📋 SELF-IMPROVEMENT BRIEFING
Generated: ${new Date().toLocaleString()}

## Jordan's State
- Financial: STRUGGLING — needs first dollar
- Emotional: Devastated by speech failure, needs wins
- Projects: Neuromatch factory built, needs customers
- Goal: Top 1% agent — proactive, not reactive

## What I Know About Jordan
- Hates repeating himself
- Wants action, not questions
- Values ownership
- In survival mode — first dollar > perfect

## Pending Improvements
${pendingLearnings.length} learning entries pending
${pendingErrors.length} error entries pending
${pendingFeatures.length} feature requests pending

## High Priority Items
${highPriority.length === 0 ? 'None — good!' : highPriority.map(e => `- ${e.summary || e.raw.substring(0, 100)}`).join('\n')}

## Recommended Actions
1. Review high-priority pending items
2. Run the CEO dashboard to check Neuromatch status
3. Check if there are leads needing follow-up
4. Consider what I can build for Jordan WITHOUT asking

## Pattern Warnings
${findPatterns([...learnings, ...errors]).length} patterns detected across errors and learnings
Run: node self-improvement/improve.js analyze

---
*This briefing is read at session start. Keep it short and actionable.*
`;

  fs.writeFileSync(BRIEFING_FILE, briefing);
  return briefing;
}

// Run full analysis
function runAnalysis() {
  console.log('🔍 Running self-improvement analysis...\n');
  
  const learnings = parseEntries(LEARNINGS_FILE);
  const errors = parseEntries(ERRORS_FILE);
  const features = parseEntries(FEATURES_FILE);
  
  const allEntries = [...learnings.map(l => ({ ...l, type: 'learning' })), 
                      ...errors.map(e => ({ ...e, type: 'error' }))];
  
  const patterns = findPatterns(allEntries);
  
  console.log(`📊 Found ${learnings.length} learnings, ${errors.length} errors, ${features.length} features`);
  console.log(`🔗 Detected ${Object.keys(patterns).length} patterns\n`);
  
  // Generate fixes for high-occurrence patterns
  const fixes = [];
  for (const [pattern, entries] of Object.entries(patterns)) {
    if (entries.length >= 2) {
      const fix = generateFix(pattern, entries);
      fixes.push(fix);
      
      const fixFile = `${FIXES_DIR}/${fix.id}.json`;
      fs.writeFileSync(fixFile, JSON.stringify(fix, null, 2));
      console.log(`⚠️  ${fix.severity}: ${pattern} (${entries.length}x) → fix saved`);
    }
  }
  
  console.log(`\n✅ ${fixes.length} fixes generated`);
  
  // Generate briefing
  const briefing = generateBriefing();
  console.log(`\n📋 Briefing updated: ${BRIEFING_FILE}`);
  
  return { learnings, errors, features, patterns, fixes };
}

// CLI
const args = process.argv.slice(2);
const cmd = args[0];

if (cmd === 'analyze') {
  runAnalysis();
} else if (cmd === 'briefing') {
  console.log(generateBriefing());
} else if (cmd === 'fix' && args[1]) {
  const fixFile = `${FIXES_DIR}/${args[1]}.json`;
  if (fs.existsSync(fixFile)) {
    const fix = JSON.parse(fs.readFileSync(fixFile, 'utf8'));
    console.log(`\n🔧 FIX: ${fix.pattern}\n`);
    console.log(fix.fix);
  } else {
    console.log('Fix not found');
  }
} else if (cmd === 'watch') {
  console.log('👁️  Self-improvement watch mode');
  console.log('Checking for new errors every session...');
  console.log('\nTo auto-run on session start, add to HEARTBEAT.md');
} else {
  console.log(`
🚀 NEUROMATCH SELF-IMPROVEMENT ENGINE

node improve.js analyze
  → Scan errors/learnings, detect patterns, generate fixes

node improve.js briefing
  → Generate session start briefing

node improve.js fix [fix-id]
  → Show specific fix details

node improve.js watch
  → Show watch mode info

This runs automatically to keep me improving.
Every error logged = data for pattern detection.
Every correction = learning captured.
  `.trim());
}
