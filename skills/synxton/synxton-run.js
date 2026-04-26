#!/usr/bin/env node
/**
 * Synxton — Operations Runner
 * Usage: node synxton-run.js "Command" "[args]"
 * 
 * Commands:
 *   n8n-status    — Check Jordan's n8n workflow statuses
 *   cron-list     — List OpenClaw cron jobs
 *   github-builds  — Check GitHub Pages build status
 *   supabase-stats — Row counts from Supabase
 */

const N8N_URL = 'https://neuromatch.app.n8n.cloud';
const N8N_KEY = 'n8n_api_key_placeholder';
const GITHUB_TOKEN = process.env.GITHUB_TOKEN || '';
const REPO = 'jordanjayhays-cpu/openclaw-agent';

const colors = {
  reset: '\x1b[0m', cyan: '\x1b[36m', green: '\x1b[32m',
  yellow: '\x1b[33m', red: '\x1b[31m', blue: '\x1b[34m'
};

function log(c, p, m) { console.log(`${c}[${p}]${colors.reset} ${m}`); }

async function n8nStatus() {
  log(colors.blue, 'SYNXTON', 'Checking n8n workflows...');
  try {
    const resp = await fetch(`${N8N_URL}/api/v1/workflows`, {
      headers: { 'Authorization': N8N_KEY }
    });
    const data = await resp.json();
    if (data.data) {
      data.data.forEach(w => {
        const status = w.active ? '🟢 active' : '🔴 inactive';
        console.log(`  ${status}  ${w.name} (ID: ${w.id})`);
      });
    }
  } catch (e) {
    log(colors.red, 'ERROR', `n8n: ${e.message}`);
  }
}

async function githubBuilds() {
  log(colors.blue, 'SYNXTON', 'Checking GitHub Pages builds...');
  try {
    const resp = await fetch(`https://api.github.com/repos/${REPO}/pages/builds/latest`, {
      headers: { 'Authorization': `token ${GITHUB_TOKEN}` }
    });
    const data = await resp.json();
    const status = data.status === 'built' ? '🟢 built' : data.status === 'queued' ? '🟡 queued' : `🔴 ${data.status}`;
    console.log(`  ${status}  Last build: ${data.created_at?.slice(0, 16)?.replace('T', ' ')}`);
    if (data.error) console.log(`  ⚠️ ${data.error.message}`);
  } catch (e) {
    log(colors.red, 'ERROR', `GitHub: ${e.message}`);
  }
}

async function githubPages() {
  log(colors.blue, 'SYNXTON', 'Fetching GitHub Pages domain status...');
  try {
    const resp = await fetch(`https://api.github.com/repos/${REPO}/pages`, {
      headers: { 'Authorization': `token ${GITHUB_TOKEN}` }
    });
    const data = await resp.json();
    console.log(`  🌐 ${data.html_url || 'https://' + data.name + '.github.io/' + REPO.split('/')[0]}`);
    console.log(`  Status: ${data.status || 'unknown'}`);
    if (data.domain) console.log(`  Domain: ${data.domain}`);
  } catch (e) {
    log(colors.red, 'ERROR', `GitHub Pages: ${e.message}`);
  }
}

async function main() {
  const [,, cmd, ...args] = process.argv;
  const command = cmd || 'status';

  console.log(`\n${colors.cyan}══════════════════════════════════════`);
  console.log(`  SYNXTON — Operations Agent`);
  console.log(`  Command: ${command}`);
  console.log(`═══════════════════════════════════════${colors.reset}\n`);

  if (command === 'n8n-status') await n8nStatus();
  else if (command === 'github-builds') await githubBuilds();
  else if (command === 'github-pages') await githubPages();
  else {
    console.log('Available commands:');
    console.log('  n8n-status     — List all n8n workflows');
    console.log('  github-builds  — Check Pages build status');
    console.log('  github-pages   — Pages domain info');
  }

  console.log(`\n${colors.green}══════════════════════════════════════`);
  console.log(`  SYNXTON — Check Complete`);
  console.log(`═══════════════════════════════════════${colors.reset}\n`);
}

main().catch(e => {
  log(colors.red, 'FATAL', e.message);
  process.exit(1);
});
