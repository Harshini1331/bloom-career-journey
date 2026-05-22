import requests
import re

url = "https://verify.msg91.com/otp-provider.js"
try:
    res = requests.get(url)
    if res.status_code == 200:
        content = res.text
        print(f"Downloaded {len(content)} bytes.")
        
        # Search for URLs
        urls = re.findall(r'https?://[^\s"\']+', content)
        print("\nFound URLs:")
        for u in set(urls):
            if "msg91" in u or "verify" in u:
                print(f"  - {u}")
                
        # Search for API paths
        paths = re.findall(r'/api/v5/[^\s"\']+', content)
        print("\nFound /api/v5 paths:")
        for p in set(paths):
            print(f"  - {p}")
            
    else:
        print(f"Error downloading: {res.status_code}")
except Exception as e:
    print(f"Exception: {e}")
