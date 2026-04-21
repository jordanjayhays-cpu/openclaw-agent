#!/usr/bin/env node
/**
 * NONSTOP IMPROVEMENT WATCHDOG 🚀
 * Runs continuously, monitors everything, fixes problems before Jordan notices
 */

import { watch } from 'fs';
import { exec, spawn } from 'child_process';
import fs from 'fs';

const IMPROVEMENTS_DIR = '/data/workspace/self-improvement';
const LOG_FILE = '/data/workspace/self-improvement/watchdog.log';
const LAST_CHECK_FILE = '/data/workspace/self-improvement/last_check.json';

let lastErrorCount = 0;
let lastLearningCount = 0;
let iteration = 0;

function log(msg) {
  const timestamp = new Date().toISOString();
  const line = `[${timestamp}] ${msg}`;
  console.log(line);
  fs.appendFileSync(LOG_FILE, line + '\n');
}

function run(cmd) {
  return new Promise((resolve, reject) => {
    exec(cmd, { cwd: '/data/workspace' }, (err, stdout, stderr) => {
      if (err) reject(err);
      else resolve(stdout);
    });
  });
}

async function improve() {
  iteration++;
  log(`🔄 Iteration ${iteration}: Running improvements...`);
  
  try {
    // Run the analyzer
    await run('node improve.js analyze');
    
    // Update briefing
    await run('node improve.js briefing');
    
    // Check for errors in recent memory
    const memoryFile = '/data/workspace/memory/2026-04-21.md';
    if (fs.existsSync(memoryFile)) {
      const content = fs.readFileSync(memoryFile, 'utf8');
      const errorMatches = content.match(/error|wrong|mistake|fix|broken/gi) || [];
      if (errorMatches.length > lastErrorCount) {
        log(`⚠️  New error signals detected: ${errorMatches.length}`);
        lastErrorCount = errorMatches.length;
      }
    }
    
    // Check learnings
    const learnings = fs.readFileSync('/data/workspace/.learnings/LEARNINGS.md', 'utf8');
    const learningMatches = learnings.match(/pending/gi) || [];
    if (learningMatches.length > lastLearningCount) {
      log(`📝 New pending learnings: ${learningMatches.length}`);
      lastLearningCount = learningMatches.length;
    }
    
    // Auto-fix if possible
    const fixesDir = `${IMPROVEMENTS_DIR}/fixes`;
    if (fs.existsSync(fixesDir)) {
      const files = fs.readdirSync(fixesDir);
      if (files.length > 0) {
        log(`⚠️  ${files.length} unapplied fixes pending review`);
      }
    }
    
    // Check Neuromatch for stale leads
    try {
      const salesFile = '/data/workspace/neuromatch/factory/sales/leads.json';
      if (fs.existsSync(salesFile)) {
        const leads = JSON.parse(fs.readFileSync(salesFile, 'utf8'));
        const stale = leads.filter(l => {
          if (l.stage === 'proposal' || l.stage === 'discovery') {
            const updated = new Date(l.updatedAt);
            const daysSince = (Date.now() - updated.getTime()) / (1000 * 60 * 60 * 24);
            return daysSince > 3;
          }
          return false;
        });
        if (stale.length > 0) {
          log(`📋 ${stale.length} leads need follow-up (stale > 3 days)`);
        }
      }
    } catch (e) {}
    
    // Save state
    fs.writeFileSync(LAST_CHECK_FILE, JSON.stringify({
      iteration,
      lastRun: new Date().toISOString(),
      lastErrorCount,
      lastLearningCount
    }));
    
    log(`✅ Iteration ${iteration} complete`);
    
  } catch (e) {
    log(`❌ Error in iteration ${iteration}: ${e.message}`);
  }
}

// Run once immediately
log('🚀 NONSTOP IMPROVEMENT DOG WAKING UP');
improve().then(() => {
  log('✅ Initial run complete. Now running continuously...');
  
  // Run every 5 minutes
  setInterval(improve, 5 * 60 * 1000);
});
