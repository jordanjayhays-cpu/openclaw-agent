#!/usr/bin/env node
/**
 * DMW Job Orders Scraper - With Browser
 * Uses Playwright to scrape JavaScript-rendered pages
 */
const { chromium } = require('playwright');

const DMW_URL = 'https://dmw.gov.ph/inquiry/approved-job-orders';

async function scrapeDMW() {
    console.log('🔍 Launching browser...');
    
    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    
    // Set user agent
    await page.setExtraHTTPHeaders({
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
    });
    
    try {
        console.log(`📋 Loading: ${DMW_URL}`);
        await page.goto(DMW_URL, { waitUntil: 'networkidle', timeout: 60000 });
        
        // Wait for the page to load
        console.log('⏳ Waiting for content...');
        await page.waitForTimeout(5000);
        
        // Try to find and click South Korea filter
        console.log('🔍 Looking for South Korea filter...');
        
        // Take a screenshot for debugging
        await page.screenshot({ path: 'dmw-screenshot.png' });
        console.log('📸 Screenshot saved: dmw-screenshot.png');
        
        // Try to find the country dropdown/filter
        const countrySelect = await page.$('select[name*="country"], select[id*="country"], select[placeholder*="country"]');
        
        if (countrySelect) {
            console.log('✅ Found country dropdown');
            await countrySelect.selectOption({ label: /south.*korea|korea/i });
            await page.waitForTimeout(2000);
        }
        
        // Get page content
        const content = await page.content();
        console.log('📄 Page loaded, content length:', content.length);
        
        // Try to find table data
        const tableRows = await page.$$('table tbody tr, .table-row, [class*="job-order"]');
        console.log(`📊 Found ${tableRows.length} table rows`);
        
        // Extract data
        const jobs = [];
        
        // Try to find job order cards or rows
        const jobCards = await page.$$('[class*="job"], [class*="order"], tr[data-id]');
        
        for (const card of jobCards) {
            const text = await card.innerText();
            if (text.toLowerCase().includes('korea')) {
                jobs.push(text);
            }
        }
        
        if (jobs.length > 0) {
            console.log(`\n✅ Found ${jobs.length} Korea job orders:`);
            jobs.forEach((job, i) => console.log(`${i+1}. ${job.substring(0, 100)}...`));
            
            // Save to file
            const fs = require('fs');
            fs.writeFileSync('korea-job-orders-raw.txt', jobs.join('\n---\n'));
            console.log('\n💾 Saved to: korea-job-orders-raw.txt');
        } else {
            console.log('\n❌ No Korea job orders found automatically');
            console.log('Manual steps:');
            console.log('1. Go to dmw.gov.ph/inquiry/approved-job-orders');
            console.log('2. Select "South Korea" from dropdown');
            console.log('3. Copy the table');
            console.log('4. Paste here');
        }
        
        // Try to get any visible text
        const bodyText = await page.$eval('body', el => el.innerText);
        console.log('\n📄 Page text (first 2000 chars):');
        console.log(bodyText.substring(0, 2000));
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    } finally {
        await browser.close();
    }
}

scrapeDMW();
