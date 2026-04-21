#!/usr/bin/env node
/**
 * NEUROMATCH CEO DASHBOARD 🏭
 * Coordinates Sales, Marketing, and Product agents
 * Shows Jordan a single view of the whole company
 */

import fs from 'fs';
import path from 'path';

const SALES_DIR = '/data/workspace/neuromatch/factory/sales';
const MARKETING_DIR = '/data/workspace/neuromatch/factory/marketing';
const PRODUCT_DIR = '/data/workspace/neuromatch/factory/product';

function loadJSON(file, fallback = []) {
  if (!fs.existsSync(file)) return fallback;
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

// Color output
const reset = '\x1b[0m';
const green = '\x1b[32m';
const yellow = '\x1b[33m';
const red = '\x1b[31m';
const blue = '\x1b[34m';
const bold = '\x1b[1m';

function banner() {
  console.log(`
${bold}${blue}╔══════════════════════════════════════════════════════════════╗
║                  🏭 NEUROMATCH CEO DASHBOARD 🏭                       ║
╚══════════════════════════════════════════════════════════════╝${reset}
`);
}

function salesSummary() {
  const leads = loadJSON(`${SALES_DIR}/leads.json`, []);
  const qualified = leads.filter(l => l.stage === 'qualified' || l.stage === 'proposal');
  const won = leads.filter(l => l.stage === 'won');
  const lost = leads.filter(l => l.stage === 'lost');
  
  console.log(`${bold}📊 SALES${reset}`);
  console.log(`${green}Won:${reset} ${won.length} | ${yellow}In Pipeline:${reset} ${qualified.length} | ${red}Lost:${reset} ${lost.length} | Total Leads: ${leads.length}`);
  
  if (qualified.length > 0) {
    console.log(`\n${yellow}Hot Leads:${reset}`);
    qualified.forEach(l => {
      console.log(`  • ${l.company} (${l.contact}) - ${l.stage}`);
    });
  }
  
  if (won.length > 0) {
    console.log(`\n${green}💰 Won Deals:${reset}`);
    won.forEach(l => {
      const budget = l.answers?.budget || 'TBD';
      console.log(`  • ${l.company} - $${budget}`);
    });
  }
  
  console.log();
}

function marketingSummary() {
  const posts = loadJSON(`${MARKETING_DIR}/posts/posts.json`, []);
  
  console.log(`${bold}📢 MARKETING${reset}`);
  console.log(`Content Campaigns: ${posts.length}`);
  
  if (posts.length > 0) {
    const latest = posts[posts.length - 1];
    console.log(`Latest: ${latest.idea.name} - ${latest.createdAt}`);
  }
  
  console.log();
}

function productSummary() {
  const features = loadJSON(`${PRODUCT_DIR}/features.json`, []);
  const bugs = loadJSON(`${PRODUCT_DIR}/bugs.json`, []);
  const releases = loadJSON(`${PRODUCT_DIR}/releases.json`, []);
  
  const backlog = features.filter(f => f.status === 'backlog');
  const inProgress = features.filter(f => f.status === 'in-progress');
  const done = features.filter(f => f.status === 'done');
  const openBugs = bugs.filter(b => b.status === 'open');
  
  console.log(`${bold}🧪 PRODUCT${reset}`);
  console.log(`${green}Done:${reset} ${done.length} | ${yellow}In Progress:${reset} ${inProgress.length} | ${blue}Backlog:${reset} ${backlog.length} | ${red}Bugs:${reset} ${openBugs.length}`);
  
  if (inProgress.length > 0) {
    console.log(`\n${yellow}🔨 Building:${reset}`);
    inProgress.forEach(f => console.log(`  • ${f.name}`));
  }
  
  if (backlog.length > 0) {
    console.log(`\n${blue}📋 Next Up:${reset}`);
    backlog.slice(0, 5).forEach(f => console.log(`  • ${f.name}`));
    if (backlog.length > 5) console.log(`  ...and ${backlog.length - 5} more`);
  }
  
  if (releases.length > 0) {
    console.log(`\n${green}🚀 Latest Release:${reset} ${releases[0].version} - ${releases[0].date}`);
  }
  
  console.log();
}

function financeSummary() {
  const leads = loadJSON(`${SALES_DIR}/leads.json`, []);
  const won = leads.filter(l => l.stage === 'won');
  
  // Simple revenue estimate
  let revenue = 0;
  won.forEach(l => {
    const budget = parseInt(l.answers?.budget) || 0;
    revenue += budget;
  });
  
  console.log(`${bold}💰 FINANCE${reset}`);
  console.log(`Revenue (from won deals): $${revenue}`);
  console.log(`Active deals in pipeline: ${leads.filter(l => ['qualified', 'proposal'].includes(l.stage)).length}`);
  console.log();
}

function healthCheck() {
  console.log(`${bold}🏥 SYSTEM HEALTH${reset}`);
  
  const checks = [
    { name: 'Sales Agent', path: `${SALES_DIR}/agent.js`, dir: SALES_DIR },
    { name: 'Marketing Agent', path: `${MARKETING_DIR}/agent.js`, dir: MARKETING_DIR },
    { name: 'Product Agent', path: `${PRODUCT_DIR}/agent.js`, dir: PRODUCT_DIR }
  ];
  
  checks.forEach(check => {
    const exists = fs.existsSync(check.path);
    const dirExists = fs.existsSync(check.dir);
    console.log(`  ${exists ? green + '✓' : red + '✗'} ${check.name} ${exists ? green + 'OK' : red + 'MISSING'}${reset}`);
  });
  
  console.log();
}

function nextActions() {
  console.log(`${bold}🎯 NEXT ACTIONS${reset}`);
  
  const leads = loadJSON(`${SALES_DIR}/leads.json`, []);
  const features = loadJSON(`${PRODUCT_DIR}/features.json`, []);
  const posts = loadJSON(`${MARKETING_DIR}/posts/posts.json`, []);
  
  const needsProposal = leads.filter(l => l.stage === 'discovery').length;
  const needsFollowup = leads.filter(l => l.stage === 'proposal').length;
  const needsSpec = features.filter(f => f.status === 'in-progress' && !f.spec).length;
  const noContent = posts.length === 0;
  
  if (needsProposal > 0) console.log(`  1. Generate proposals for ${needsProposal} discovery leads`);
  if (needsFollowup > 0) console.log(`  2. Follow up on ${needsFollowup} pending proposals`);
  if (needsSpec > 0) console.log(`  3. Write specs for ${needsSpec} features in progress`);
  if (noContent) console.log(`  1. Generate marketing content for your first product`);
  
  if (!needsProposal && !needsFollowup && !needsSpec && !noContent) {
    console.log(`  ✅ Nothing urgent. Add leads with: node sales/agent.js add`);
  }
  
  console.log();
}

function quickStart() {
  console.log(`${bold}⚡ QUICK START${reset}`);
  console.log(`
  # Add a lead
  node factory/sales/agent.js add "Company Name" "contact@co.com" "Their problem"
  
  # Generate marketing content  
  node factory/marketing/agent.js generate "AppName" "category" "problem" "one-liner"
  
  # Add a feature from sales lead
  node factory/product/agent.js add-feature "Feature Name" "What it does"
  
  # Generate spec for Lovable
  node factory/product/agent.js spec
  
  # Mark feature done after building
  node factory/product/agent.js done-feature [id]
  `);
  console.log();
}

function run() {
  banner();
  healthCheck();
  salesSummary();
  marketingSummary();
  productSummary();
  financeSummary();
  nextActions();
  
  console.log(`${bold}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}`);
  console.log(`Generated: ${new Date().toLocaleString()}`);
  console.log();
}

run();
