#!/usr/bin/env node
/**
 * NEUROMATCH PRODUCT AGENT 🧪
 * Manages the roadmap, writes specs, tracks bugs
 * Feeds directly into Lovable for Jordan to build
 */

import fs from 'fs';

const FEATURES_FILE = '/data/workspace/neuromatch/factory/product/features.json';
const BUGS_FILE = '/data/workspace/neuromatch/factory/product/bugs.json';
const SPECS_DIR = '/data/workspace/neuromatch/factory/product/specs';
const RELEASES_FILE = '/data/workspace/neuromatch/factory/product/releases.json';

if (!fs.existsSync(SPECS_DIR)) fs.mkdirSync(SPECS_DIR, { recursive: true });

function loadJSON(file, fallback = []) {
  if (!fs.existsSync(file)) return fallback;
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function saveJSON(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

// Feature management
function addFeature(name, description, priority = 'medium', fromSales = false) {
  const features = loadJSON(FEATURES_FILE);
  const feature = {
    id: Date.now().toString(),
    name,
    description,
    priority, // low, medium, high, critical
    status: 'backlog', // backlog, in-progress, done
    fromSales,
    createdAt: new Date().toISOString(),
    spec: null
  };
  features.push(feature);
  saveJSON(FEATURES_FILE, features);
  return feature;
}

function getFeatures(filter = 'all') {
  const features = loadJSON(FEATURES_FILE);
  if (filter === 'all') return features;
  if (filter === 'backlog') return features.filter(f => f.status === 'backlog');
  if (filter === 'in-progress') return features.filter(f => f.status === 'in-progress');
  if (filter === 'done') return features.filter(f => f.status === 'done');
  return features;
}

// Spec writer
function writeSpec(featureId, specContent) {
  const features = loadJSON(FEATURES_FILE);
  const idx = features.findIndex(f => f.id === featureId);
  if (idx === -1) return null;
  
  const specFile = `${SPECS_DIR}/${featureId}.md`;
  fs.writeFileSync(specFile, specContent);
  
  features[idx].spec = specFile;
  saveJSON(FEATURES_FILE, features);
  return specFile;
}

function generateSpec(feature) {
  return `# SPEC: ${feature.name}

## Overview
${feature.description}

## Problem Being Solved
[What pain point does this address?]

## User Story
As a [user type], I want [action] so that [benefit].

## Core Feature
[One sentence: what does this DO?]

## User Flow
1. User lands on [screen]
2. User does [action]
3. System responds with [result]
4. User sees [outcome]

## Layout & UI
- Mobile-first design
- Single column layout
- Primary action button prominent
- Minimal form fields

## Functionality
### Must Have (MVP)
- [ ] [Feature 1]
- [ ] [Feature 2]
- [ ] [Feature 3]

### Nice to Have (v2)
- [ ] [Feature]
- [ ] [Feature]

## Technical
- Stack: Next.js + Tailwind (Lovable default)
- Backend: Supabase or Firebase
- No complex auth for MVP

## Success Metrics
- [ ] Users complete the core action
- [ ] Time on task < 30 seconds
- [ ] Zero error states in testing

## Lovable Prompt
\`\`\`
Build a [one-liner describing the app].

Core features:
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

Design: Clean, minimal, [style].
No login required for MVP.

Tech: Next.js + Tailwind
\`\`\`

---

*Spec generated: ${new Date().toLocaleDateString()}*
*For: Neuromatch Product Agent*
`;
}

// Bug management
function addBug(description, severity = 'medium') {
  const bugs = loadJSON(BUGS_FILE);
  const bug = {
    id: Date.now().toString(),
    description,
    severity, // low, medium, high, critical
    status: 'open', // open, in-progress, fixed
    createdAt: new Date().toISOString()
  };
  bugs.push(bug);
  saveJSON(BUGS_FILE, bugs);
  return bug;
}

function getBugs(filter = 'all') {
  const bugs = loadJSON(BUGS_FILE);
  if (filter === 'open') return bugs.filter(b => b.status === 'open');
  return bugs;
}

// Release notes
function createRelease(version, notes) {
  const releases = loadJSON(RELEASES_FILE);
  releases.unshift({
    version,
    notes,
    date: new Date().toISOString(),
    features: getFeatures('done').slice(-10)
  });
  saveJSON(RELEASES_FILE, releases);
  return releases[0];
}

// CLI
const rl = require('readline').createInterface({ input: process.stdin, output: process.stdout });
function ask(q) { return new Promise(r => rl.question(q, r)); }

async function main() {
  const args = process.argv.slice(2);
  const cmd = args[0];

  if (cmd === 'add-feature') {
    const name = args[1] || await ask('Feature name: ');
    const desc = args[2] || await ask('Description: ');
    const priority = args[3] || 'medium';
    const feature = addFeature(name, desc, priority, true);
    console.log(`\n✅ Feature added: ${feature.id}`);
    console.log(`Priority: ${priority} | Status: ${feature.status}`);
    
  } else if (cmd === 'list-features') {
    const filter = args[1] || 'all';
    const features = getFeatures(filter);
    console.log(`\n🧪 ${features.length} features (${filter})\n`);
    features.forEach(f => {
      console.log(`${f.id.slice(-4)} | ${f.priority.toUpperCase().padEnd(8)} | ${f.status.padEnd(12)} | ${f.name}`);
      if (f.spec) console.log(`   Spec: ${f.spec}`);
    });
    
  } else if (cmd === 'spec') {
    const featureId = args[1];
    if (!featureId) {
      const features = getFeatures('backlog');
      console.log('\n📝 Select feature for spec:\n');
      features.forEach((f, i) => console.log(`${i + 1}. ${f.name}`));
      const sel = await ask('\nPick number: ');
      const selected = features[parseInt(sel) - 1];
      if (selected) {
        const spec = generateSpec(selected);
        const file = writeSpec(selected.id, spec);
        console.log(`\n✅ Spec written to: ${file}`);
        console.log('\n' + spec);
      }
    } else {
      const features = loadJSON(FEATURES_FILE);
      const feature = features.find(f => f.id === featureId);
      if (feature) {
        const spec = generateSpec(feature);
        const file = writeSpec(feature.id, spec);
        console.log(`\n✅ Spec written to: ${file}`);
        console.log('\n' + spec);
      } else {
        console.log('Feature not found');
      }
    }
    
  } else if (cmd === 'start-feature') {
    const featureId = args[1];
    const features = loadJSON(FEATURES_FILE);
    const idx = features.findIndex(f => f.id === featureId);
    if (idx >= 0) {
      features[idx].status = 'in-progress';
      saveJSON(FEATURES_FILE, features);
      console.log(`✅ Feature ${featureId} started`);
    } else {
      console.log('Feature not found');
    }
    
  } else if (cmd === 'done-feature') {
    const featureId = args[1];
    const features = loadJSON(FEATURES_FILE);
    const idx = features.findIndex(f => f.id === featureId);
    if (idx >= 0) {
      features[idx].status = 'done';
      saveJSON(FEATURES_FILE, features);
      console.log(`✅ Feature ${featureId} marked done`);
    } else {
      console.log('Feature not found');
    }
    
  } else if (cmd === 'add-bug') {
    const desc = args.slice(1).join(' ') || await ask('Bug description: ');
    const bug = addBug(desc, 'medium');
    console.log(`\n🐛 Bug added: ${bug.id}`);
    
  } else if (cmd === 'list-bugs') {
    const bugs = getBugs(args[1]);
    console.log(`\n🐛 ${bugs.length} bugs\n`);
    bugs.forEach(b => {
      console.log(`${b.id.slice(-4)} | ${b.severity.toUpperCase().padEnd(8)} | ${b.status.padEnd(10)} | ${b.description}`);
    });
    
  } else if (cmd === 'release') {
    const version = args[1] || await ask('Version (e.g. 1.0.0): ');
    const notes = args.slice(2).join(' ') || await ask('Release notes: ');
    const release = createRelease(version, notes);
    console.log(`\n🚀 Release ${version} created`);
    
  } else if (cmd === 'help') {
    console.log(`
🧪 NEUROMATCH PRODUCT AGENT

node product/agent.js add-feature [name] [description] [priority]
  → Add a feature to the backlog

node product/agent.js list-features [filter]
  → List features (all|backlog|in-progress|done)

node product/agent.js spec [feature-id]
  → Generate a spec for a feature (interactive if no id)

node product/agent.js start-feature [id]
  → Mark feature as in-progress

node product/agent.js done-feature [id]
  → Mark feature as done

node product/agent.js add-bug [description]
  → Report a bug

node product/agent.js list-bugs [filter]
  → List bugs (all|open)

node product/agent.js release [version] [notes]
  → Create a release

Workflow:
1. Sales finds a lead with a need
2. Jordan adds feature: node product/agent.js add-feature "Name" "Description"
3. Jordan generates spec: node product/agent.js spec
4. Paste spec into Lovable
5. Mark done: node product/agent.js done-feature [id]
    `.trim());
  } else {
    console.log('Use: node product/agent.js [command]');
    console.log('Try: node product/agent.js help');
  }
  
  rl.close();
}

main().catch(e => { console.error(e); process.exit(1); });
