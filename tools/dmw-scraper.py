#!/usr/bin/env python3
"""
DMW Job Orders Scraper for PISCO
Fetches approved job orders from DMW website
"""
import urllib.request
import urllib.parse
import json
import time
from datetime import datetime

# DMW API endpoints found in the frontend
DMW_API_URL = "https://master-api.dmw.gov.ph/api"
DMW_KEY = "a4296e51-8cd0-4de7-a3de-324ed6a2913e"

# Fallback: Try different endpoints
ENDPOINTS = [
    "/inquiry/approved-job-orders",
    "/job-orders",
    "/approved-job-orders",
    "/api/inquiry/approved-job-orders",
]

HEADERS = {
    "Authorization": f"ApiKey {DMW_KEY}",
    "Content-Type": "application/json",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
}

def fetch_job_orders(country=None):
    """Fetch job orders from DMW API"""
    
    for endpoint in ENDPOINTS:
        url = DMW_API_URL + endpoint
        print(f"Trying: {url}")
        
        try:
            req = urllib.request.Request(url, headers=HEADERS)
            response = urllib.request.urlopen(req, timeout=10)
            if response.status:
                data = json.loads(response.read().decode())
                print(f"✅ Success with {endpoint}")
                return data
        except Exception as e:
            print(f"❌ Error: {e}")
        
        time.sleep(1)
    
    return None

def filter_korea(orders):
    """Filter job orders for South Korea"""
    if not orders:
        return []
    
    korea_orders = []
    
    # Handle different data structures
    items = orders.get('data', orders) if isinstance(orders, dict) else orders
    
    if not isinstance(items, list):
        items = [items]
    
    for order in items:
        # Check various country field names
        country_field = (
            order.get('country') or 
            order.get('country_name') or
            order.get('destination') or
            str(order).lower()
        )
        
        if country_field and 'korea' in str(country_field).lower():
            korea_orders.append(order)
    
    return korea_orders

def save_results(orders, filename='korea-job-orders.json'):
    """Save results to file"""
    output = {
        'fetched_at': datetime.now().isoformat(),
        'count': len(orders),
        'orders': orders
    }
    
    with open(filename, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"✅ Saved {len(orders)} orders to {filename}")
    return output

def main():
    print("🔍 PISCO - DMW Job Orders Scraper")
    print("=" * 50)
    
    # Try to fetch
    data = fetch_job_orders()
    
    if data:
        korea_orders = filter_korea(data)
        save_results(korea_orders)
        
        print(f"\n📊 Found {len(korea_orders)} South Korea job orders")
        
        # Show sample
        if korea_orders:
            print("\n📋 Sample order:")
            print(json.dumps(korea_orders[0], indent=2)[:500])
    else:
        print("\n❌ Could not fetch from DMW API")
        print("Possible reasons:")
        print("- API endpoint changed")
        print("- API requires authentication")
        print("- Rate limiting")
        print("\nNext steps:")
        print("1. Check DMW website manually")
        print("2. Ask Dohun Kim for the list")
        print("3. Try different API approach")

if __name__ == "__main__":
    main()
