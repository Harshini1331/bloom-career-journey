import requests
import os
import sys

# Force UTF-8 stdout if possible, but rely on ASCII for safety
sys.stdout.reconfigure(encoding='utf-8')

API_KEY = "AIzaSyBgwC4pnTy7hnZYCZb2LW15H7WcrrjuJlI"
url = f"https://generativelanguage.googleapis.com/v1beta/models?key={API_KEY}"

print(f"Querying: {url}")

try:
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        models = data.get('models', [])
        print("\nAvailable Models for this Key:")
        found_any = False
        for m in models:
            if 'generateContent' in m.get('supportedGenerationMethods', []):
                print(f"- {m['name']} ({m.get('displayName', 'No display name')})")
                found_any = True
        
        if not found_any:
            print("No models found that support 'generateContent'.")
            
    else:
        print(f"Error: {response.status_code}")
        print(response.text)

except Exception as e:
    print(f"Exception: {e}")
