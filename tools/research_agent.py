#!/usr/bin/env python3
"""
Web Research Agent for Jordan
Uses web scraping to research real companies and people
"""

import subprocess
import json
import sys
from datetime import datetime

BOT_TOKEN = "8768116245:AAG1kj2x8kQU25U2wXehMxzTpWPls-sXlzA"
CHAT_ID = "6463127078"

def send_telegram(msg):
    cmd = f'''curl -s -X POST "https://api.telegram.org/bot{BOT_TOKEN}/sendMessage" -d "chat_id={CHAT_ID}&text={msg}&parse_mode=HTML"'''
    subprocess.run(cmd, shell=True)

def search_duckduckgo(query):
    """Use ddgr or curl to search DuckDuckGo"""
    try:
        result = subprocess.run(
            ['ddgr', '-n', '5', '--json', query],
            capture_output=True, text=True, timeout=30
        )
        if result.returncode == 0:
            return result.stdout
    except:
        pass
    
    # Fallback: use curl with DuckDuckGo HTML
    cmd = f'curl -s "https://html.duckduckgo.com/html/?q={query.replace(" ", "+")}" | head -100'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout

def scrape_url(url):
    """Fetch actual content from a URL"""
    cmd = f'curl -s -L --max-time 10 "{url}" | python3 -c "import sys; print(sys.stdin.read()[:3000])" 2>/dev/null'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout

def research_company(company_name, contact_name=""):
    """Main research function"""
    print(f"Researching: {company_name}")
    
    results = {
        "company": company_name,
        "contact": contact_name,
        "search_time": datetime.now().isoformat(),
        "findings": []
    }
    
    # Search for company news
    search_query = f"{company_name} news 2026"
    print(f"Searching: {search_query}")
    search_results = search_duckduckgo(search_query)
    results["findings"].append({
        "type": "search",
        "query": search_query,
        "raw": search_results[:1500]
    })
    
    # Try to find company website
    if contact_name:
        person_query = f"{contact_name} {company_name}"
        print(f"Searching person: {person_query}")
        person_results = search_duckduckgo(person_query)
        results["findings"].append({
            "type": "person_search",
            "query": person_query,
            "raw": person_results[:1500]
        })
    
    return results

def format_telegram_report(results):
    """Format research as Telegram message"""
    company = results["company"]
    findings = results["findings"]
    
    msg = f"🔍 <b>Research Complete: {company}</b>\n\n"
    
    for finding in findings:
        if finding["type"] == "search":
            msg += f"<b>News/Search Results:</b>\n"
            # Extract titles from HTML
            raw = finding["raw"]
            lines = [l.strip() for l in raw.split('\n') if '<a href=' in l and len(l.strip()) > 50]
            for line in lines[:5]:
                # Extract title
                if '">' in line:
                    title = line.split('">')[1].split('<')[0][:80]
                    if title:
                        msg += f"• {title}\n"
    
    return msg[:4000]  # Telegram limit

if __name__ == "__main__":
    if len(sys.argv) > 1:
        query = " ".join(sys.argv[1:])
        print(f"Running research on: {query}")
        
        # Run research
        results = research_company(query)
        
        # Send to Telegram
        report = format_telegram_report(results)
        send_telegram(report)
        
        print("Research complete!")
        print(json.dumps(results, indent=2)[:2000])
    else:
        print("Usage: python3 research_agent.py 'Company Name' [Contact Name]")