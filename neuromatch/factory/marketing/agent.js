#!/usr/bin/env node
/**
 * NEUROMATCH MARKETING AGENT 📢
 * Generates content that brings in leads for Sales Agent
 */

import fs from 'fs';
import { writeFileSync, appendFileSync } from 'fs';

const POSTS_DIR = '/data/workspace/neuromatch/factory/marketing/posts';
const POSTS_FILE = `${POSTS_DIR}/posts.json`;
const ANALYTICS_FILE = `${POSTS_DIR}/analytics.md`;

// Ensure directory exists
if (!fs.existsSync(POSTS_DIR)) {
  fs.mkdirSync(POSTS_DIR, { recursive: true });
}

// Post templates
const TEMPLATES = {
  twitter: {
    name: 'Twitter/X Post',
    generate: (idea) => ({
      platform: 'twitter',
      content: `I just built ${idea.name} in a weekend.

${idea.pitch}

What's something you wish existed? 👇`,
      hook: 'Built this instead of sleeping',
      cta: 'Follow for more'
    })
  },
  
  linkedin: {
    name: 'LinkedIn Post',
    generate: (idea) => ({
      platform: 'linkedin',
      content: `The problem: ${idea.problem}

Most people just accept this as normal.

I decided to do something about it.

Introducing ${idea.name}: ${idea.oneLiner}

${idea.features.map(f => `• ${f}`).join('\n')}

Link in bio. Would love feedback.`,
      hook: 'How I turned a frustration into a product',
      cta: 'Drop a comment if this resonates'
    })
  },
  
  reddit: {
    name: 'Reddit Post',
    generate: (idea) => ({
      platform: 'reddit',
      subreddit: idea.subreddit || 'r/SideProject',
      title: `I made "${idea.name}" - ${idea.oneLiner}`,
      content: `Hey everyone,

I was frustrated with ${idea.problem} so I built ${idea.name}.

What it does: ${idea.oneLiner}

Key features:
${idea.features.map(f => `• ${f}`).join('\n')}

Is this something you'd actually use? Looking for honest feedback.

${idea.pricing ? `Pricing: ${idea.pricing}` : 'Free to try.'}`,
      hook: 'Made something for a problem I had',
      cta: 'Tell me what you think'
    })
  },
  
  coldEmail: {
    name: 'Cold Email Template',
    generate: (idea, lead) => ({
      platform: 'email',
      to: lead?.email || '[recipient]',
      subject: `Quick question about ${lead?.company || 'your'} ${idea.category}`,
      content: `Hi ${lead?.name || 'there'},

I noticed ${lead?.company || 'your company'} ${lead?.painPoint || 'might be dealing with something I just solved'}.

I built ${idea.name} to fix "${idea.problem}". ${idea.oneLiner}

${idea.features.length > 0 ? `It does a few things:\n${idea.features.slice(0, 3).map(f => `• ${f}`).join('\n')}` : ''}

Would you be open to a 10-minute chat this week? I have some questions about ${idea.category} that I think you'd have good answers to.

No pitch, just curious.

Best,
Jordan`,
      hook: 'Personalized outreach based on their pain point',
      cta: 'Reply YES if interested'
    })
  },
  
  blog: {
    name: 'Blog Post Outline',
    generate: (idea) => ({
      platform: 'blog',
      title: `Why "${idea.problem}" Is a $X Problem (And How to Solve It)`,
      outline: [
        'Hook: Start with the frustration',
        'Scene: Describe the problem vividly',
        'Pivot: Here\'s what most people do (and why it doesn\'t work)',
        'Solution: Introduce the concept',
        'Proof: How ' + idea.name + ' solves it',
        'CTA: Try it free',
      ],
      seoKeywords: [idea.category, idea.problem, 'automation', 'solution'],
      hook: 'Problem-aware content that ranks',
      cta: 'Subscribe for more'
    })
  }
};

// Platform-specific subreddits and hashtags
const COMMUNITIES = {
  twitter: { hashtags: ['#buildinpublic', '#startup', '#indiehacker'] },
  linkedin: { tags: ['Entrepreneurship', 'Startups', 'Innovation'] },
  reddit: {
    subreddits: ['r/SideProject', 'r/indiehackers', 'r/startups', 'r/Entrepreneur', 'r/SaaS']
  }
};

// Generate all content for an idea
function generateAllContent(idea, lead = null) {
  const content = {};
  for (const [key, template] of Object.entries(TEMPLATES)) {
    content[key] = template.generate(idea, lead);
  }
  return content;
}

// Save generated content
function saveContent(idea, content) {
  const filename = `${POSTS_DIR}/${idea.name.toLowerCase().replace(/\s+/g, '-')}.json`;
  
  if (fs.existsSync(POSTS_FILE)) {
    const existing = JSON.parse(fs.readFileSync(POSTS_FILE, 'utf8'));
    existing.push({ idea, content, createdAt: new Date().toISOString() });
    fs.writeFileSync(POSTS_FILE, JSON.stringify(existing, null, 2));
  } else {
    fs.writeFileSync(POSTS_FILE, JSON.stringify([{ idea, content, createdAt: new Date().toISOString() }], null, 2));
  }
  
  return filename;
}

// Log analytics/event
function logAnalytics(event) {
  const log = `[${new Date().toISOString()}] ${event.type}: ${event.message}\n`;
  appendFileSync(ANALYTICS_FILE, log);
}

// CLI
const rl = require('readline').createInterface({ input: process.stdin, output: process.stdout });
function ask(q) { return new Promise(r => rl.question(q, r)); }

async function main() {
  const args = process.argv.slice(2);
  const cmd = args[0];

  if (cmd === 'generate') {
    // Generate content for an idea
    const idea = {
      name: args[1] || await ask('App name: '),
      category: args[2] || await ask('Category (e.g. productivity, finance): '),
      problem: args[3] || await ask('The problem it solves: '),
      oneLiner: args[4] || await ask('One-liner description: '),
      features: args[5] ? args[5].split(',') : [],
      pricing: args[6] || null,
      subreddit: args[7] || 'r/SideProject'
    };
    
    if (idea.features.length === 0) {
      const features = await ask('Features (comma-separated): ');
      idea.features = features.split(',').map(f => f.trim()).filter(Boolean);
    }
    
    console.log('\n📝 Generating content for:', idea.name);
    
    const content = generateAllContent(idea);
    const savedTo = saveContent(idea, content);
    
    console.log('\n✅ Content saved to:', savedTo);
    console.log('\n--- TWITTER ---\n' + content.twitter.content);
    console.log('\n--- LINKEDIN ---\n' + content.linkedin.content);
    console.log('\n--- REDDIT ---\n' + content.reddit.title + '\n' + content.reddit.content);
    console.log('\n--- COLD EMAIL ---\nTo: ' + content.coldEmail.to + '\nSubject: ' + content.coldEmail.subject + '\n' + content.coldEmail.content);
    
    logAnalytics({ type: 'content_generated', message: idea.name });
    
  } else if (cmd === 'list') {
    if (!fs.existsSync(POSTS_FILE)) {
      console.log('No content generated yet.'); 
    } else {
      const posts = JSON.parse(fs.readFileSync(POSTS_FILE, 'utf8'));
      console.log(`\n📊 ${posts.length} campaigns generated\n`);
      posts.forEach((p, i) => {
        console.log(`${i + 1}. ${p.idea.name} - ${p.idea.category} - ${p.createdAt}`);
      });
    }
    
  } else if (cmd === 'reddit-communities') {
    console.log('\n📍 Best subreddits for your product:\n');
    COMMUNITIES.reddit.subreddits.forEach(sub => console.log('• ' + sub));
    
  } else if (cmd === 'help') {
    console.log(`
🏭 NEUROMATCH MARKETING AGENT

node marketing/agent.js generate [name] [category] [problem] [oneliner] [features...] [pricing] [subreddit]
  → Generate all content for an idea

node marketing/agent.js list
  → Show all generated campaigns

node marketing/agent.js reddit-communities
  → List best subreddits for promotion

Example:
node marketing/agent.js generate "ReplyForge" "productivity" "writing follow-up emails" "AI writes emails in your style" "email parsing,template library,draft generation" "9/mo" "r/SideProject"
    `.trim());
  } else {
    console.log('Use: node marketing/agent.js [command]');
    console.log('Try: node marketing/agent.js help');
  }
  
  rl.close();
}

main().catch(e => { console.error(e); process.exit(1); });
