#!/usr/bin/env node
/**
 * NEUROMATCH SALES AGENT 🏭💰
 * Takes a lead → Asks discovery questions → Qualifies → Generates proposal → Follows up
 */

import readline from 'readline';
import fs from 'fs';

// Lead storage
const DB_FILE = '/data/workspace/neuromatch/factory/sales/leads.json';

// Simple JSON file store
function loadLeads() {
  if (!fs.existsSync(DB_FILE)) return [];
  return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
}

function saveLeads(leads) {
  fs.writeFileSync(DB_FILE, JSON.stringify(leads, null, 2));
}

// Discovery questions
const DISCOVERY = [
  "What problem are you trying to solve?",
  "What's your current solution (if any)?",
  "What would the ideal outcome look like?",
  "When do you need this by?",
  "Who else is involved in this decision?"
];

// Qualification criteria
const QUALIFY = {
  budget: { min: 500, label: 'budget' },
  authority: { label: 'decision maker or can recommend to one' },
  need: { label: 'has a clear problem' },
  timeline: { label: 'timeline under 3 months or flexible' }
};

function newLead(name, company, contact) {
  const leads = loadLeads();
  const lead = {
    id: Date.now().toString(),
    name, company, contact,
    stage: 'new', // new → discovery → qualified → proposal → won/lost
    answers: {},
    notes: [],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };
  leads.push(lead);
  saveLeads(leads);
  return lead;
}

function updateLead(id, updates) {
  const leads = loadLeads();
  const idx = leads.findIndex(l => l.id === id);
  if (idx === -1) return null;
  leads[idx] = { ...leads[idx], ...updates, updatedAt: new Date().toISOString() };
  saveLeads(leads);
  return leads[idx];
}

function getLead(id) {
  const leads = loadLeads();
  return leads.find(l => l.id === id);
}

function addNote(id, note) {
  const lead = getLead(id);
  if (!lead) return null;
  lead.notes.push({ text: note, date: new Date().toISOString() });
  return updateLead(id, { notes: lead.notes });
}

function qualify(lead) {
  // Simple scoring
  let score = 0;
  const reasons = [];
  
  const a = lead.answers;
  
  if (a.budget && parseInt(a.budget) >= QUALIFY.budget.min) {
    score += 25;
  } else if (a.budget) {
    reasons.push(`Budget ${a.budget} below minimum ${QUALIFY.budget.min}`);
  }
  
  if (a.authority === 'yes') { score += 25; }
  else if (a.authority === 'somewhat') { score += 10; reasons.push('Not final decision maker'); }
  
  if (a.need && a.need.length > 20) { score += 25; }
  else if (a.need) { reasons.push('Vague need stated'); }
  
  if (a.timeline && a.timeline !== 'none') { score += 25; }
  else { reasons.push('No timeline'); }
  
  return { score: Math.min(score, 100), reasons };
}

function generateProposal(lead) {
  const a = lead.answers;
  const budget = parseInt(a.budget) || 1000;
  
  return `
=============================================================================
PROPOSAL FOR ${lead.company.toUpperCase()}
Generated: ${new Date().toLocaleDateString()}
=============================================================================

PREPARED FOR: ${lead.name}, ${lead.company}
CONTACT: ${lead.contact}

-------------------------------------------------------------------------------
THE PROBLEM
-------------------------------------------------------------------------------
${a.need || 'To be discussed'}

-------------------------------------------------------------------------------
PROPOSED SOLUTION
-------------------------------------------------------------------------------
Neuromatch will deliver a custom solution addressing:

1. [Insert specific deliverable based on discovery]
2. [Insert second deliverable]
3. [Insert third deliverable]

Timeline: ${a.timeline || 'To be determined'}
Point of Contact: ${lead.name}

-------------------------------------------------------------------------------
INVESTMENT
-------------------------------------------------------------------------------
Option A - Essential: $${(budget * 0.6).toFixed(0)}
Option B - Professional: $${budget.toFixed(0)}
Option C - Enterprise: $${(budget * 1.5).toFixed(0)}

Payment Terms: 50% upfront, 50% on delivery

-------------------------------------------------------------------------------
NEXT STEPS
-------------------------------------------------------------------------------
1. You approve this proposal (reply YES)
2. Neuromatch sends invoice
3. Project begins upon payment

Questions? Reply to this proposal directly.

This proposal is valid for 14 days.
=============================================================================
`.trim();
}

function formatLead(lead) {
  const q = qualify(lead);
  return `
📋 ${lead.company}
Stage: ${lead.stage.toUpperCase()}
Contact: ${lead.name} | ${lead.contact}
Score: ${q.score}/100 ${q.score >= 75 ? '✅' : q.score >= 50 ? '🟡' : '❌'}
Created: ${new Date(lead.createdAt).toLocaleDateString()}
Notes: ${lead.notes.length}
  `.trim();
}

// CLI interface
const rl = readline.createInterface({ input: process.stdin, output: process.stdout });

function ask(question) {
  return new Promise(resolve => rl.question(question, resolve));
}

async function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  
  if (command === 'add') {
    // node sales/agent.js add "Name" "Company" "email@co.com"
    const [, name = await ask('Name: '), company = await ask('Company: '), contact = await ask('Email: ')] = args;
    const lead = newLead(name.trim(), company.trim(), contact.trim());
    console.log(`\n✅ Lead created: ${lead.id}`);
    console.log(formatLead(lead));
    
  } else if (command === 'list') {
    const leads = loadLeads();
    console.log(`\n📊 ${leads.length} leads\n`);
    leads.forEach(l => console.log(formatLead(l) + '\n'));
    
  } else if (command === 'discover' && args[1]) {
    const lead = getLead(args[1]);
    if (!lead) { console.log('Lead not found'); process.exit(1); }
    
    console.log(`\n🔍 Discovery for ${lead.company}\n`);
    console.log('Answer each question (or press Enter to skip):\n');
    
    const answers = {};
    for (const q of DISCOVERY) {
      const answer = await ask(`${q}: `);
      answers[q] = answer;
    }
    
    updateLead(lead.id, { answers, stage: 'discovery' });
    const q = qualify({ answers });
    console.log(`\n📊 Qualification Score: ${q.score}/100`);
    if (q.reasons.length) console.log('Flags:', q.reasons.join(', '));
    
    if (q.score >= 75) {
      console.log('\n✅ QUALIFIED — ready for proposal');
      updateLead(lead.id, { stage: 'qualified' });
    } else {
      console.log('\n🟡 Needs more work before proposal');
    }
    
  } else if (command === 'proposal' && args[1]) {
    const lead = getLead(args[1]);
    if (!lead) { console.log('Lead not found'); process.exit(1); }
    
    console.log(generateProposal(lead));
    updateLead(lead.id, { stage: 'proposal' });
    
  } else if (command === 'note' && args[1]) {
    const note = args.slice(2).join(' ');
    const updated = addNote(args[1], note);
    if (updated) console.log('✅ Note added');
    else console.log('Lead not found');
    
  } else if (command === 'stage' && args[1] && args[2]) {
    const valid = ['new', 'discovery', 'qualified', 'proposal', 'won', 'lost'];
    if (!valid.includes(args[2])) {
      console.log(`Invalid stage. Use: ${valid.join(', ')}`);
      process.exit(1);
    }
    updateLead(args[1], { stage: args[2] });
    console.log(`✅ Stage updated to ${args[2]}`);
    
  } else if (command === 'help') {
    console.log(`
🏭 NEUROMATCH SALES AGENT COMMANDS

node sales/agent.js add [name] [company] [email]
  → Add a new lead

node sales/agent.js list
  → List all leads

node sales/agent.js discover [lead-id]
  → Run discovery questions for a lead

node sales/agent.js proposal [lead-id]
  → Generate proposal for qualified lead

node sales/agent.js note [lead-id] [note text]
  → Add a note to a lead

node sales/agent.js stage [lead-id] [stage]
  → Update lead stage (new|discovery|qualified|proposal|won|lost)
    `.trim());
    
  } else {
    console.log('Use: node sales/agent.js [command] [args]');
    console.log('Try: node sales/agent.js help');
  }
  
  rl.close();
}

main().catch(e => { console.error(e); process.exit(1); });
