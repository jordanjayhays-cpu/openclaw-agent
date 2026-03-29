#!/usr/bin/env python3
"""
Parse Korea job orders from DMW API response
"""
import json
import sys

def parse_dmw_jobs():
    try:
        with open('/data/workspace/PROJECTS/PISCO/dmw-south-korea-raw.json', 'r') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error loading file: {e}")
        return
    
    companies = []
    
    # Navigate the DMW API response structure
    # The API returns {data: {data: [...], ...}}
    items = []
    if isinstance(data, dict):
        if 'data' in data:
            inner = data['data']
            if isinstance(inner, dict) and 'data' in inner:
                items = inner['data']
            elif isinstance(inner, list):
                items = inner
        elif isinstance(data, list):
            items = data
    
    print(f"Found {len(items)} total job orders")
    
    # Filter for Korea
    korea_items = []
    for item in items:
        # Check various fields for "korea"
        item_str = json.dumps(item).lower()
        if 'korea' in item_str or 'south korea' in item_str:
            korea_items.append(item)
            print(f"  Korea: {item.get('principal', item.get('agency', 'Unknown'))}")
    
    print(f"\nFound {len(korea_items)} South Korea job orders")
    
    # Extract company names
    korea_companies = []
    for item in korea_items:
        company = item.get('principal', item.get('agency', 'Unknown'))
        if company and company not in korea_companies:
            korea_companies.append(company)
    
    print(f"Unique companies: {len(korea_companies)}")
    
    # Save parsed list
    with open('/data/workspace/PROJECTS/PISCO/korea-companies.json', 'w') as f:
        json.dump({
            'companies': korea_companies,
            'count': len(korea_companies),
            'raw_count': len(korea_items)
        }, f, indent=2)
    
    print(f"\nSaved to korea-companies.json")
    return korea_companies

if __name__ == "__main__":
    parse_dmw_jobs()
