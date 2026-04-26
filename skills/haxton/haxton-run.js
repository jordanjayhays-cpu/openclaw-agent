#!/usr/bin/env node
/**
 * Haxton — Outreach Copy Generator
 * Usage: node haxton-run.js "Outreach type" "[prospect details]"
 * 
 * Types: email | linkedin | whatsapp | landing
 */

const FELO_KEY = 'fk-AO9iq37Z3jWpsIox3vGeigoUF68xxgYDuTH6K2ngETO8laVf';

const colors = {
  reset: '\x1b[0m', cyan: '\x1b[36m', green: '\x1b[32m',
  yellow: '\x1b[33m', red: '\x1b[31m', magenta: '\x1b[35m'
};

function log(c, p, m) { console.log(`${c}[${p}]${colors.reset} ${m}`); }

async function generate(type, details) {
  const prompts = {
    email: `Write a 3-email cold outreach sequence for: ${details}. 
Format as:
EMAIL 1 - Cold [Subject line variants]
EMAIL 2 - Follow-up (Day 3)
EMAIL 3 - Value-add (Day 7)
Each email: max 100 words, no fluff, one clear CTA. Problem-aware, value-first.`,

    linkedin: `Write a LinkedIn DM sequence for: ${details}.
Format as:
CONNECTION REQUEST - 25 words max, warm, no pitch
FOLLOW-UP 1 - Day 1 after connecting, 1 sentence
FOLLOW-UP 2 - Day 4, offer value
FOLLOW-UP 3 - Day 7, soft close with CTA`,

    whatsapp: `Write 4 WhatsApp message templates for: ${details}.
Format as:
INTRO - Short, warm, one sentence
FOLLOW-UP - Day 2
VALUE-ADD - Day 4, share something useful
CLOSE - Day 7, soft ask`,

    landing: `Write landing page hero copy for: ${details}.
Include: headline (8 words), subheadline (12 words), CTA button text (3 words), 3 bullet benefits.`
  };

  const prompt = prompts[type] || prompts.email;
  log(colors.cyan, 'HAXTON', `Generating ${type} outreach...`);
  
  try {
    const resp = await fetch('https://openapi.felo.ai/v2/chat', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${FELO_KEY}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ query: prompt })
    });
    const data = await resp.json();
    return data.data?.answer || 'No output returned.';
  } catch (e) {
    log(colors.red, 'ERROR', e.message);
    return '';
  }
}

async function main() {
  const [,, type, ...detailParts] = process.argv;
  const details = detailParts.join(' ') || 'a new Madrid massage studio called Siam Thai, owner Juan Garcia, looking for more customers';
  
  console.log(`\n${colors.magenta}══════════════════════════════════════`);
  console.log(`  HAXTON — Outreach Agent`);
  console.log(`  Type: ${type || 'email'} | Details: ${details}`);
  console.log(`═══════════════════════════════════════${colors.reset}\n`);

  const output = await generate(type || 'email', details);
  console.log(output);
  
  console.log(`\n${colors.green}══════════════════════════════════════`);
  console.log(`  HAXTON — Draft Complete`);
  console.log(`  → Jordan reviews → executes`);
  console.log(`═══════════════════════════════════════${colors.reset}\n`);
}

main().catch(e => {
  log(colors.red, 'FATAL', e.message);
  process.exit(1);
});
