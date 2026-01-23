import os
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.environ.get("SARVAM_API_KEY") or os.environ.get("VITE_SARVAM_API_KEY")

print(f"Checking API Key: {API_KEY[:5]}...{API_KEY[-4:] if API_KEY else 'None'}")

if not API_KEY:
    print("❌ Key is missing!")
    exit(1)

# Test with a simple request to Sarvam (listing models or just a small dummy transcript request)
# Since Sarvam might not have a 'list models' endpoint publicly documented for all, we'll try a basic translation or STT check if possible.
# Actually, let's just checking if we can hit the endpoint without 401.

# We'll try to synthesize speech (TTS) as a quick test, or just standard STT with a dummy file if needed.
# Let's try to hit the HEALTH or Version endpoint if it exists, otherwise just assume if we get 401 it fails.

url = "https://api.sarvam.ai/speech-to-text-translate" # Synchronous endpoint
print(f"Testing connectivity to: {url}")
headers = {"api-subscription-key": API_KEY}

# We need a file to test STT, but we can verify auth by sending garbage and seeing if we get 400 (Good, Auth worked) or 401 (Bad Auth).
response = requests.post(url, headers=headers)

print(f"Status Code: {response.status_code}")
if response.status_code == 401:
    print("❌ API Key Rejected (401 Unauthorized)")
elif response.status_code == 400 or response.status_code == 422:
    print("✅ API Key Accepted (Server returned 400/422 as expected for empty body)")
else:
    print(f"❓ Response: {response.text}")
