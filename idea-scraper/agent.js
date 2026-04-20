#!/usr/bin/env node
/**
 * Idea Scraper Agent
 * Scrapes the web for problems people are searching for solutions to
 * Generates app ideas from real search demand
 */

import { chromium } from 'playwright';

const SEARCH_SOURCES = [
  {
    name: 'Google Trends',
    url: 'https://trends.google.com/trends/trendingsearches/realtime',
    selector: '.feed-list-item'
  },
  {
    name: 'AnswerThePublic',
    url: 'https://answerthepublic.com',
    searchBase: 'https://answerthepublic.com/searches/'
  },
  {
    name: 'AlsoAsked',
    url: 'https://alsoasked.com'
  },
  {
    name: 'Reddit Problems',
    subreddits: ['r/SideProject', 'r/indiehackers', 'r/Entrepreneur', 'r/startups', 'r/SaaS']
  }
];

const PROBLEM_PATTERNS = [
  'how to',
  'why does',
  'best way to',
  'too expensive',
  'keep forgetting',
  'hate that',
  'wish there was',
  'tired of',
  'frustrated with',
  "can't find",
  'struggling with',
  'anyone else hate',
  'workaround for',
  'alternative to'
];

async function scrapeGoogleTrends() {
  console.log('📊 Scraping Google Trends...');
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  const trends = [];
  
  try {
    await page.goto('https://trends.google.com/trends/trendingsearches/realtime', {
      waitUntil: 'networkidle',
      timeout: 30000
    });
    
    // Get trending searches
    const items = await page.$$eval('.feed-item', items => 
      items.slice(0, 20).map(item => ({
        title: item.querySelector('.title')?.textContent?.trim(),
        queries: item.querySelectorAll('.search-term')?.length || 0
      }))
    );
    
    trends.push(...items.filter(i => i.title));
  } catch (e) {
    console.log('⚠️ Google Trends blocked, trying alternate...');
  }
  
  await browser.close();
  return trends;
}

async function scrapeReddit(subreddit) {
  console.log(`💬 Scraping r/${subreddit}...`);
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  const problems = [];
  
  try {
    await page.goto(`https://www.reddit.com/${subreddit}/hot.json`, {
      timeout: 15000
    });
    
    await page.waitForSelector('.Post', { timeout: 5000 });
    
    const posts = await page.$$eval('h3', titles => 
      titles.slice(0, 15).map(t => t.textContent?.trim()).filter(Boolean)
    );
    
    posts.forEach(post => {
      PROBLEM_PATTERNS.forEach(pattern => {
        if (post.toLowerCase().includes(pattern)) {
          problems.push({ source: `r/${subreddit}`, text: post, pattern });
        }
      });
    });
  } catch (e) {
    console.log(`⚠️ r/${subreddit} blocked`);
  }
  
  await browser.close();
  return problems;
}

async function scrapeAlsoAsked() {
  console.log('🔍 Scraping AlsoAsked...');
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  const questions = [];
  
  try {
    await page.goto('https://alsoasked.com', { timeout: 15000 });
    
    // Look for popular search clusters
    const popular = await page.$$eval('[data-query]', els => 
      els.slice(0, 20).map(el => el.dataset.query || el.textContent?.trim())
        .filter(Boolean)
    );
    
    questions.push(...popular);
  } catch (e) {
    console.log('⚠️ AlsoAsked blocked');
  }
  
  await browser.close();
  return questions;
}

function generateAppIdeas(searchData) {
  console.log('\n🧠 Generating app ideas from search data...\n');
  
  const ideas = [];
  
  // Categorize and generate ideas
  const categories = {
    productivity: [],
    communication: [],
    finance: [],
    health: [],
    developer: [],
    social: [],
    e-commerce: [],
    education: []
  };
  
  searchData.forEach(item => {
    const text = JSON.stringify(item).toLowerCase();
    
    if (text.includes('email') || text.includes('inbox') || text.includes('message')) {
      categories.communication.push(item);
    } else if (text.includes('money') || text.includes('budget') || text.includes('save')) {
      categories.finance.push(item);
    } else if (text.includes('fit') || text.includes('sleep') || text.includes('health')) {
      categories.health.push(item);
    } else if (text.includes('code') || text.includes('git') || text.includes('deploy')) {
      categories.developer.push(item);
    } else if (text.includes('learn') || text.includes('course') || text.includes('study')) {
      categories.education.push(item);
    } else {
      categories.productivity.push(item);
    }
  });
  
  // Generate ideas from categories
  Object.entries(categories).forEach(([cat, items]) => {
    if (items.length >= 2) {
      ideas.push({
        category: cat,
        demand: items.length,
        apps: generateFromCluster(items, cat)
      });
    }
  });
  
  return ideas;
}

function generateFromCluster(items, category) {
  const templates = {
    productivity: [
      'Auto-scheduler that blocks time for deep work',
      'Distraction blocker with smart breaks',
      'Unified inbox for all your notifications',
      'Daily standup generator from your notes',
      'Meeting note taker that extracts action items'
    ],
    communication: [
      'Email parser that drafts replies in your style',
      'LinkedIn outreach message generator',
      'Slack summary for when you were away',
      'Email unsubscribe manager',
      'Template-based message responder'
    ],
    finance: [
      'Receipt scanner that categorizes spending',
      'Subscription canceler helper',
      'Split bill calculator for groups',
      'Price comparison tracker',
      'Invoice generator for freelancers'
    ],
    health: [
      'Sleep tracker with smart alarm',
      'Water reminder with intake logging',
      'Workout logger that suggests variations',
      'Meditation timer with streaks',
      'Posture reminder app'
    ],
    developer: [
      'Git commit message generator',
      'README.md generator from repo',
      'API documentation builder',
      'Code review summarizer',
      'Dependency update notifier'
    ],
    social: [
      'Post scheduler for multiple platforms',
      'Bio generator for each social network',
      'Engagement analyzer for your content',
      'Follow-up reminder for networking',
      'Content calendar manager'
    ],
    'e-commerce': [
      'Price drop alert tracker',
      'Return shipment generator',
      'Product comparison builder',
      'Wishlist price watcher',
      'Review request sender'
    ],
    education: [
      'Flashcard generator from notes',
      'Quiz builder from any text',
      'Study planner with spaced repetition',
      'Course progress tracker',
      'Summary generator for articles'
    ]
  };
  
  return templates[category] || [];
}

async function run() {
  console.log('🔴 Idea Scraper Agent Starting...\n');
  
  const allData = [];
  
  // Scrape each source
  try {
    const trends = await scrapeGoogleTrends();
    allData.push(...trends);
  } catch (e) {}
  
  for (const sub of SEARCH_SOURCES[3].subreddits) {
    try {
      const problems = await scrapeReddit(sub);
      allData.push(...problems);
    } catch (e) {}
    await new Promise(r => setTimeout(r, 1000)); // Rate limit
  }
  
  console.log(`\n✅ Collected ${allData.length} data points\n`);
  
  // Generate ideas
  const ideas = generateAppIdeas(allData);
  
  // Output results
  console.log('📱 GENERATED APP IDEAS:\n');
  console.log('=' .repeat(50));
  
  ideas.forEach(({ category, demand, apps }) => {
    console.log(`\n🔹 ${category.toUpperCase()} (${demand} related searches)`);
    apps.forEach((app, i) => console.log(`   ${i + 1}. ${app}`));
  });
  
  return ideas;
}

run().catch(console.error);
