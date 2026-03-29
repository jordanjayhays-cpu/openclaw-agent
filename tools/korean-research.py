#!/usr/bin/env python3
"""
Korean Company Research Tool for PISCO
Automatically researches Korean companies for Filipino worker placement
"""
import requests
import json
import time
from datetime import datetime
import os

# Company types to research
INDUSTRIES = {
    'manufacturing': [
        'Hyundai Motor Group suppliers',
        'Samsung Electronics contractors',
        'LG Electronics partners',
        'Kia Motors suppliers',
        'SK Hynix facilities',
    ],
    'construction': [
        'Hyundai Engineering & Construction',
        'SK Engineering & Construction',
        'Daewoo Engineering & Construction',
        'Lotte Engineering & Construction',
        'GS Engineering & Construction',
    ],
    'shipbuilding': [
        'HD Hyundai Heavy Industries',
        'Samsung Heavy Industries',
        'Daewoo Shipbuilding & Marine Engineering',
        'Hanwha Ocean',
    ],
    'agriculture': [
        'Nonghyup (National Agricultural Cooperative)',
        'Korea Agriculture Federation',
        'Rural Development Administration partners',
    ]
}

# Search API (using DuckDuckGo via textise)
SEARCH_URL = "https://api.duckduckgo.com/"

def search_company(name):
    """Get basic info about a Korean company"""
    try:
        params = {
            'q': f"{name} South Korea employees",
            'format': 'json',
            'no_html': 1
        }
        response = requests.get(SEARCH_URL, params=params, timeout=5)
        if response.status_code == 200:
            data = response.json()
            return {
                'name': name,
                'found': True,
                'summary': data.get('AbstractText', '')[:500],
                'source': data.get('Image', ''),
            }
    except Exception as e:
        return {'name': name, 'found': False, 'error': str(e)}
    
    return {'name': name, 'found': False}

def research_companies():
    """Research all companies in the list"""
    results = {
        'researched_at': datetime.now().isoformat(),
        'companies': []
    }
    
    print("🔍 Researching Korean Companies for PISCO")
    print("=" * 60)
    
    for industry, companies in INDUSTRIES.items():
        print(f"\n📊 {industry.upper()}")
        print("-" * 40)
        
        for company in companies:
            print(f"  🔍 {company}...", end=" ", flush=True)
            
            info = search_company(company)
            info['industry'] = industry
            results['companies'].append(info)
            
            if info.get('found'):
                print("✅")
            else:
                print("❌")
            
            time.sleep(1)  # Rate limiting
    
    return results

def save_results(results, filename='korean-companies-research.json'):
    """Save research results"""
    with open(filename, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"\n✅ Saved to {filename}")
    print(f"📊 Total companies researched: {len(results['companies'])}")
    
    found = sum(1 for c in results['companies'] if c.get('found'))
    print(f"✅ Found: {found}")
    print(f"❌ Not found: {len(results['companies']) - found}")

def main():
    print("🌏 PISCO - Korean Company Research Tool")
    print("=" * 60)
    
    results = research_companies()
    save_results(results)
    
    print("\n📋 Companies ready for outreach:")
    for company in results['companies']:
        if company.get('found'):
            print(f"  ✅ {company['name']} ({company['industry']})")

if __name__ == "__main__":
    main()
