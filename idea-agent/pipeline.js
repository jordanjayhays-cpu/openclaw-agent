#!/usr/bin/env node
/**
 * Idea Agent - Complete Pipeline
 * 1. Scrape what people are searching for
 * 2. Analyze patterns & pain points
 * 3. Generate polished app pitches ready for Lovable
 */

import { chromium } from 'playwright';

const REDDIT_SUBS = ['SideProject', 'indiehackers', 'Entrepreneur', 'startups', 'SaaS', 'bootstrapped'];

const PROBLEM_KEYWORDS = [
  'how to', 'why does', 'best way', 'too expensive', 'keep forgetting',
  'wish there was', 'tired of', 'frustrated', "can't find", 'struggling',
  'workaround', 'alternative to', 'help with', 'anyone else', 'hard to',
  'annoying', 'broken', 'missing feature', 'no good', 'looking for'
];

const CATEGORY_PATTERNS = {
  productivity: ['schedule', 'remind', 'focus', 'distract', 'organize', 'task', 'to do', 'inbox', 'email'],
  finance: ['money', 'budget', 'save', 'spend', 'invoice', 'pay', 'expense', 'cheap', 'afford'],
  health: ['sleep', 'workout', 'fit', 'health', 'meditation', 'stress', 'anxious', 'tired'],
  developer: ['code', 'git', 'deploy', 'api', 'bug', 'debug', 'github', 'repo'],
  social: ['linkedin', 'twitter', 'post', 'followers', 'content', 'engagement', 'audience'],
  communication: ['message', 'reply', 'respond', 'DM', 'email', 'cold email', 'outreach'],
  ecommerce: ['shop', 'store', 'product', 'order', 'ship', 'return', 'amazon', 'price'],
  education: ['learn', 'course', 'study', 'tutorial', 'book', 'practice', 'skill']
};

async function scrapeReddit(browser, sub) {
  const page = await browser.newPage();
  const problems = [];
  
  try {
    await page.goto(`https://www.reddit.com/r/${sub}/hot.json?limit=50`, {
      timeout: 15000,
      waitUntil: 'domcontentloaded'
    });
    
    await page.waitForSelector('h3', { timeout: 5000 }).catch(() => {});
    
    const posts = await page.$$eval('h3', els => 
      els.map(e => e.textContent?.trim()).filter(Boolean).slice(0, 20)
    );
    
    posts.forEach(post => {
      const lower = post.toLowerCase();
      PROBLEM_KEYWORDS.forEach(kw => {
        if (lower.includes(kw)) {
          problems.push({ source: `r/${sub}`, text: post, keyword: kw });
        }
      });
    });
  } catch (e) {
    // Skip blocked
  }
  
  await page.close();
  return problems;
}

async function scrapeGoogleTrends(browser) {
  const page = await browser.newPage();
  const trends = [];
  
  try {
    // Set user agent
    await page.setExtraHTTPHeaders({
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
    });
    
    await page.goto('https://trends.google.com/trends/trendingsearches/realtime?geo=US', {
      timeout: 20000,
      waitUntil: 'networkidle'
    });
    
    const items = await page.$$eval('[class*="title"], [class*="search-term"]', els =>
      els.slice(0, 30).map(e => e.textContent?.trim()).filter(Boolean)
    );
    
    trends.push(...items);
  } catch (e) {}
  
  await page.close();
  return trends;
}

async function scrapeAlsoAsked(browser) {
  const page = await browser.newPage();
  const questions = [];
  
  try {
    await page.goto('https://alsoasked.com', { timeout: 15000 });
    await page.waitForTimeout(2000);
    
    const popular = await page.$$eval('[data-query], .query', els =>
      els.slice(0, 20).map(e => e.dataset?.query || e.textContent?.trim()).filter(Boolean)
    );
    
    questions.push(...popular);
  } catch (e) {}
  
  await page.close();
  return questions;
}

function categorize(text) {
  const lower = text.toLowerCase();
  for (const [cat, keywords] of Object.entries(CATEGORY_PATTERNS)) {
    if (keywords.some(kw => lower.includes(kw))) return cat;
  }
  return 'general';
}

function generatePitch(category, problem, searchVol) {
  const templates = {
    productivity: {
      name: pickName(category, problem),
      pitch: `People are actively searching for "${problem}". Build a ${category} app that solves this.`,
      features: [
        'One-click core action',
        'Minimal setup required', 
        'Works offline or with sync',
        'Beautiful, simple UI'
      ],
      monitize: pickMonetization(category),
      why: 'High intent searchers who want solutions NOW'
    },
    finance: {
      name: pickName(category, problem),
      pitch: `"${problem}" - a frustrated searcher ready to pay for relief.`,
      features: ['Clear pricing', 'Secure data handling', 'Quick results', 'Mobile-first'],
      monitize: 'Freemium + premium features',
      why: 'Financial pain = high willingness to pay'
    },
    health: {
      name: pickName(category, problem),
      pitch: `"${problem}" - people searching for help with their wellbeing.`,
      features: ['Gentle UX', 'No account needed to start', 'Progress tracking', 'Reminders'],
      monitize: 'Subscription for streaks + insights',
      why: 'Health apps have strong retention + recurring revenue'
    },
    developer: {
      name: pickName(category, problem),
      pitch: `Devs searching "${problem}" need tooling that doesn't suck.`,
      features: ['CLI + GUI', 'Fast + lightweight', 'Good docs', 'Open source friendly'],
      monitize: 'Open core + paid support',
      why: 'Developers pay for tools that save them time'
    },
    social: {
      name: pickName(category, problem),
      pitch: `"${problem}" - creators and professionals need better solutions.`,
      features: ['Schedule ahead', 'Analytics', 'Multi-platform', 'Template library'],
      monitize: 'Monthly subscription for power features',
      why: 'Social presence = business necessity for many'
    },
    communication: {
      name: pickName(category, problem),
      pitch: `"${problem}" - people hate doing this manually.`,
      features: ['Template system', 'Personalization variables', 'Sequence tracking', 'Warmup tools'],
      monitize: 'Per-email or monthly seat',
      why: 'Outreach at scale = immediate ROI'
    },
    ecommerce: {
      name: pickName(category, problem),
      pitch: `"${problem}" - shoppers and sellers both need this.`,
      features: ['Price tracking', 'Deal alerts', 'Review aggregation', 'Side-by-side compare'],
      monitize: 'Affiliate + premium tools',
      why: 'E-commerce is massive and growing'
    },
    education: {
      name: pickName(category, problem),
      pitch: `"${problem}" - lifelong learners want better methods.`,
      features: ['Spaced repetition', 'Progress tracking', 'Community', 'Certifications'],
      monitize: 'Course sales + premium community',
      why: 'Education = recession-proof + passion market'
    },
    general: {
      name: pickName(category, problem),
      pitch: `"${problem}" - a clear pain point with search volume.`,
      features: ['Solve the core problem', 'Beautiful UX', 'Shareable results', 'Fast load'],
      monitize: 'Freemium with paid tiers',
      why: 'Solve real pain = natural conversion'
    }
  };
  
  return templates[category] || templates.general;
}

function pickName(category, problem) {
  const prefixes = {
    productivity: ['Flow', 'Focus', 'Clarity', 'Peak', 'Swift'],
    finance: ['Penny', 'Wise', 'Fair', 'Clear', 'Budget'],
    health: ['Vital', 'Balance', 'Pulse', 'Calm', 'Rise'],
    developer: ['Dev', 'Stack', 'Git', 'Deploy', 'Ship'],
    social: ['Reach', 'Boost', 'Viral', 'Content', 'Social'],
    communication: ['Reply', 'Inbox', 'Contact', 'Letter', 'Message'],
    ecommerce: ['Deal', 'Price', 'Shop', 'Cart', 'Smart'],
    education: ['Learn', 'Study', 'Mind', 'Brain', 'Skill'],
    general: ['App', 'Tool', 'Helper', 'Easy', 'Quick']
  };
  
  const prefix = prefixes[category]?.[Math.floor(Math.random() * 5)] || 'Smart';
  const words = problem.split(' ').slice(0, 2);
  return `${prefix}${words.map(w => w.charAt(0).toUpperCase() + w.slice(1)).join('')}`;
}

function pickMonetization(category) {
  const options = {
    productivity: 'Freemium + Team plans',
    finance: 'Free + Premium subscription',
    health: 'Monthly subscription + IAP',
    developer: 'Open core + paid support',
    social: 'Monthly subscription',
    communication: 'Per-user monthly',
    ecommerce: 'Affiliate + premium',
    education: 'Course sales + subscription',
    general: 'Freemium'
  };
  return options[category] || 'Freemium';
}

async function run() {
  console.log('🔴 IDEA AGENT - Starting scrape...\n');
  
  const browser = await chromium.launch({ headless: true });
  const allProblems = [];
  
  // Scrape Reddit
  console.log('💬 Scraping Reddit...');
  for (const sub of REDDIT_SUBS) {
    const problems = await scrapeReddit(browser, sub);
    allProblems.push(...problems);
    console.log(`   r/${sub}: ${problems.length} problems found`);
    await new Promise(r => setTimeout(r, 800));
  }
  
  // Scrape Google Trends
  console.log('\n📊 Scraping Google Trends...');
  const trends = await scrapeGoogleTrends(browser);
  console.log(`   Trending: ${trends.length} items`);
  
  // Scrape AlsoAsked
  console.log('\n🔍 Scraping AlsoAsked...');
  const questions = await scrapeAlsoAsked(browser);
  console.log(`   Questions: ${questions.length}`);
  
  await browser.close();
  
  // Combine and dedupe
  const allText = [
    ...allProblems.map(p => p.text),
    ...trends,
    ...questions
  ].filter(Boolean);
  
  const unique = [...new Set(allText)];
  
  console.log(`\n✅ Total unique data points: ${unique.length}\n`);
  
  // Categorize and generate pitches
  console.log('🧠 Generating pitches...\n');
  
  const pitches = unique.slice(0, 50).map(text => {
    const category = categorize(text);
    return {
      category,
      problem: text.length > 100 ? text.substring(0, 100) + '...' : text,
      ...generatePitch(category, text, 1)
    };
  });
  
  // Group by category
  const byCategory = {};
  pitches.forEach(p => {
    if (!byCategory[p.category]) byCategory[p.category] = [];
    byCategory[p.category].push(p);
  });
  
  // Output
  console.log('='.repeat(60));
  console.log('📱 GENERATED PITCHES - READY FOR LOVABLE\n');
  console.log('='.repeat(60));
  
  let num = 1;
  for (const [cat, items] of Object.entries(byCategory)) {
    console.log(`\n## ${cat.toUpperCase()} (${items.length} ideas)\n`);
    
    items.slice(0, 5).forEach(item => {
      console.log(`${num}. **${item.name}**`);
      console.log(`   Pitch: ${item.pitch}`);
      console.log(`   Key features: ${item.features.join(', ')}`);
      console.log(`   Monetization: ${item.monitize}`);
      console.log(`   Why it'll work: ${item.why}`);
      console.log('');
      num++;
    });
  }
  
  console.log('='.repeat(60));
  console.log(`\n🎯 ${num - 1} pitches generated from REAL search data`);
  console.log('\nPick a number and I\'ll build the full spec for Lovable!');
  
  return { pitches, byCategory };
}

run().catch(console.error);
