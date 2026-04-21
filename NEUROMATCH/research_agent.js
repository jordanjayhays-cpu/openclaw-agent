/**
 * NeuroMatch Brain Research Agent
 * Researches why brain scans matter - real medical data
 */

const fs = require('fs');
const { execSync } = require('child_process');

async function curl(url) {
  try {
    return execSync(`curl -s -L --max-time 15 -A "Mozilla/5.0" "${url}"`, { encoding: 'utf8', timeout: 20000 });
  } catch (e) { return null; }
}

async function scrapeWikipedia(topic) {
  const html = await curl(`https://en.wikipedia.org/wiki/${topic.replace(/ /g, '_')}`);
  if (!html || html.length < 500) return null;
  
  // Extract paragraphs
  const paragraphs = [];
  const matches = html.match(/<p[^>]*>([^<]+)<\/p>/g) || [];
  for (const m of matches.slice(0, 5)) {
    let text = m.replace(/<[^>]+>/g, '').trim();
    if (text.length > 100) paragraphs.push(text.slice(0, 300));
  }
  return paragraphs;
}

async function searchWeb(query) {
  const html = await curl(`https://duckduckgo.com/html/?q=${encodeURIComponent(query)}&kl=us-en`);
  if (!html || html.length < 500) return [];
  
  const snippets = [];
  const matches = html.match(/class="result__snippet"[^>]*>([^<]+)</g) || [];
  for (const m of matches.slice(0, 5)) {
    let text = m.replace(/<[^>]+>/g, '').trim();
    if (text.length > 30) snippets.push(text.slice(0, 200));
  }
  return snippets;
}

async function main() {
  console.log('🧠 NEUROMATCH RESEARCH — Why Brain Scans Matter\n');
  console.log('='.repeat(50));
  
  const research = {
    timestamp: new Date().toISOString(),
    topics: {}
  };
  
  // Topic 1: MRI benefits
  console.log('\n📊 Research: MRI Brain Scan Benefits');
  const mriData = await scrapeWikipedia('Magnetic_resonance_imaging');
  const mriSearch = await searchWeb('brain MRI scan benefits early detection');
  research.topics.mri = {
    wikipedia: mriData || [],
    search: mriSearch
  };
  
  // Topic 2: Early detection of brain tumors
  console.log('📊 Research: Brain Tumor Early Detection');
  const tumorData = await scrapeWikipedia('Brain_tumor');
  const tumorSearch = await searchWeb('brain tumor early detection survival rate MRI');
  research.topics.brain_tumor = {
    wikipedia: tumorData || [],
    search: tumorSearch
  };
  
  // Topic 3: Alzheimer and dementia
  console.log('📊 Research: Alzheimer Detection');
  const alzheimerData = await scrapeWikipedia("Alzheimer's_disease");
  const alzheimerSearch = await searchWeb('Alzheimer MRI early detection benefits');
  research.topics.alzheimer = {
    wikipedia: alzheimerData || [],
    search: alzheimerSearch
  };
  
  // Topic 4: Stroke prevention
  console.log('📊 Research: Stroke Prevention');
  const strokeData = await scrapeWikipedia('Stroke');
  const strokeSearch = await searchWeb('brain scan stroke prevention detection MRI');
  research.topics.stroke = {
    wikipedia: strokeData || [],
    search: strokeSearch
  };
  
  // Topic 5: Mental health / concussions
  console.log('📊 Research: Concussion and CTE');
  const concussionData = await scrapeWikipedia('Concussion');
  const concussionSearch = await searchWeb('brain scan concussion CTE detection');
  research.topics.concussion = {
    wikipedia: concussionData || [],
    search: concussionSearch
  };
  
  // Save research
  fs.writeFileSync('brain_scan_research.json', JSON.stringify(research, null, 2));
  
  // Output summary
  console.log('\n' + '='.repeat(50));
  console.log('📊 RESEARCH COMPLETE\n');
  
  Object.entries(research.topics).forEach(([topic, data]) => {
    console.log(`\n--- ${topic.replace('_', ' ').toUpperCase()} ---`);
    if (data.wikipedia && data.wikipedia.length > 0) {
      console.log(`Wikipedia: ${data.wikipedia[0].slice(0, 200)}...`);
    }
    if (data.search && data.search.length > 0) {
      console.log(`Search: ${data.search[0].slice(0, 200)}...`);
    }
  });
  
  return research;
}

main().catch(console.error);