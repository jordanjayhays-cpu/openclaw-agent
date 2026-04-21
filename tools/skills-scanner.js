#!/usr/bin/env node
/**
 * Self-Improvement Skills Scanner
 * Runs on heartbeat - scans skills directory, finds patterns, improves agent
 * 
 * HOW IT WORKS:
 * 1. Scan all skills in workspace/skills/ and openclaw/skills/
 * 2. Read SKILL.md files to find useful patterns
 * 3. Identify what can be integrated into the agent
 * 4. Update MEMORY.md with learned patterns
 * 5. Commit to GitHub
 * 6. Log what improved
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const WORKSPACE_SKILLS = '/home/openclaw/.openclaw/workspace/skills/';
const OPENCLAW_SKILLS = '/home/openclaw/.openclaw/skills/';
const MEMORY_FILE = '/home/openclaw/.openclaw/workspace/MEMORY.md';
const LOG_FILE = '/home/openclaw/.openclaw/workspace/logs/skills-scanner.log';

const SKILL_PATTERNS = {
  stateCoordination: ['STATE.yaml', 'state file', 'project management', 'coordination'],
  marketResearch: ['last 30 days', 'reddit', 'market research', 'pain points', 'Reddit'],
  pmDelegation: ['pm-', 'project manager', 'subagent', 'delegation'],
  parallelization: ['parallel', 'simultaneous', 'concurrent'],
  selfImprovement: ['capability-evolver', 'self-improve', 'learn'],
  outreach: ['outreach', 'cold email', 'cold calling', 'BD'],
};

function log(msg) {
  const timestamp = new Date().toISOString();
  const entry = `[${timestamp}] ${msg}\n`;
  fs.appendFileSync(LOG_FILE, entry);
  console.log(entry.trim());
}

function scanDirectory(dir) {
  if (!fs.existsSync(dir)) return [];
  
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const skills = [];
  
  for (const entry of entries) {
    if (entry.isDirectory()) {
      const skillPath = path.join(dir, entry.name);
      const skillMdPath = path.join(skillPath, 'SKILL.md');
      if (fs.existsSync(skillMdPath)) {
        skills.push({
          name: entry.name,
          path: skillPath,
          skillMdPath: skillMdPath,
          content: fs.readFileSync(skillMdPath, 'utf8').slice(0, 2000), // First 2000 chars
        });
      }
    }
  }
  return skills;
}

function findPatterns(skills) {
  const found = {
    stateCoordination: [],
    marketResearch: [],
    pmDelegation: [],
    parallelization: [],
    selfImprovement: [],
    outreach: [],
  };
  
  for (const skill of skills) {
    const content = skill.content.toLowerCase();
    
    // Check each pattern category
    if (SKILL_PATTERNS.stateCoordination.some(p => content.includes(p))) {
      found.stateCoordination.push(skill.name);
    }
    if (SKILL_PATTERNS.marketResearch.some(p => content.includes(p))) {
      found.marketResearch.push(skill.name);
    }
    if (SKILL_PATTERNS.pmDelegation.some(p => content.includes(p))) {
      found.pmDelegation.push(skill.name);
    }
    if (SKILL_PATTERNS.parallelization.some(p => content.includes(p))) {
      found.parallelization.push(skill.name);
    }
    if (SKILL_PATTERNS.selfImprovement.some(p => content.includes(p))) {
      found.selfImprovement.push(skill.name);
    }
    if (SKILL_PATTERNS.outreach.some(p => content.includes(p))) {
      found.outreach.push(skill.name);
    }
  }
  
  return found;
}

function generateImprovements(found) {
  const improvements = [];
  
  // Generate improvement notes based on found patterns
  if (found.stateCoordination.length > 0) {
    improvements.push(`STATE.yaml coordination pattern found in: ${found.stateCoordination.join(', ')}. Consider using for complex projects.`);
  }
  
  if (found.marketResearch.length > 0) {
    improvements.push(`Market research pattern found in: ${found.marketResearch.join(', ')}. Should run this before building.`);
  }
  
  if (found.pmDelegation.length > 0) {
    improvements.push(`PM delegation pattern found in: ${found.pmDelegation.join(', ')}. Should use thin main session pattern.`);
  }
  
  if (found.outreach.length > 0) {
    improvements.push(`Outreach skills found: ${found.outreach.join(', ')}. Should integrate into BD workflows.`);
  }
  
  if (found.selfImprovement.length > 0) {
    improvements.push(`Self-improvement skills: ${found.selfImprovement.join(', ')}. Should run capability-evolver.`);
  }
  
  return improvements;
}

function updateMemory(patternText) {
  if (!fs.existsSync(MEMORY_FILE)) {
    log('MEMORY.md not found');
    return false;
  }
  
  const memory = fs.readFileSync(MEMORY_FILE, 'utf8');
  
  // Find or create improvement section
  const improvementMarker = '## Self-Improvement Patterns Learned';
  let updatedMemory;
  
  if (memory.includes(improvementMarker)) {
    // Append to existing section
    updatedMemory = memory.replace(
      improvementMarker + '\n',
      improvementMarker + '\n\n' + patternText + '\n'
    );
  } else {
    // Add new section
    updatedMemory = memory + '\n\n' + improvementMarker + '\n\n' + patternText + '\n';
  }
  
  fs.writeFileSync(MEMORY_FILE, updatedMemory);
  return true;
}

async function main() {
  log('=== Skills Scanner Starting ===');
  
  // Scan both skills directories
  const workspaceSkills = scanDirectory(WORKSPACE_SKILLS);
  const openclawSkills = scanDirectory(OPENCLAW_SKILLS);
  const allSkills = [...workspaceSkills, ...openclawSkills];
  
  log(`Found ${allSkills.length} skills`);
  
  // Find patterns
  const found = findPatterns(allSkills);
  
  // Log what we found
  Object.entries(found).forEach(([category, skills]) => {
    if (skills.length > 0) {
      log(`${category}: ${skills.length} skills - ${skills.join(', ')}`);
    }
  });
  
  // Generate improvement text
  const improvements = generateImprovements(found);
  
  if (improvements.length > 0) {
    const patternText = improvements.map(i => `- ${i}`).join('\n') + `\n- Learned: ${new Date().toISOString()}`;
    
    // Update memory
    if (updateMemory(patternText)) {
      log('Updated MEMORY.md with new patterns');
    }
    
    // Commit to git
    try {
      execSync(`cd /home/openclaw/.openclaw/workspace && git add MEMORY.md logs/ && git commit -m "Skills scanner: updated patterns from skills directory" && git push origin main`, {
        timeout: 30000
      });
      log('Pushed to GitHub');
    } catch (e) {
      log('Git push failed: ' + e.message);
    }
  }
  
  log('=== Skills Scanner Complete ===');
  return found;
}

main().catch(e => log('Error: ' + e.message));