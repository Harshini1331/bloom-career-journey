import asyncio
import websockets
import json
import base64
import time
import random
import struct

# CONFIGURATION
SERVER_URL = "ws://127.0.0.1:8000/ws/stream?language_code=en-IN"
CONCURRENT_USERS = 10  # Start small (local single-process server might choke on >20)
DURATION_SECONDS = 10
REQ_DELAY_MS = 200 # Send a chunk every 200ms (approx realtime)

STATISTICS = {
    "connected": 0,
    "failed": 0,
    "transcripts_received": 0,
    "errors": 0,
    "disconnects": 0
}

def create_wav_header(pcm_data, sample_rate=16000):
    header = b'RIFF'
    header += struct.pack('<I', 36 + len(pcm_data)) 
    header += b'WAVEfmt '
    header += struct.pack('<I', 16) 
    header += struct.pack('<H', 1) 
    header += struct.pack('<H', 1) 
    header += struct.pack('<I', sample_rate) 
    header += struct.pack('<I', sample_rate * 2) 
    header += struct.pack('<H', 2) 
    header += struct.pack('<H', 16) 
    header += b'data'
    header += struct.pack('<I', len(pcm_data)) 
    return header + pcm_data

async def simulate_user(user_id):
    try:
        async with websockets.connect(SERVER_URL) as websocket:
            STATISTICS["connected"] += 1
            # print(f"User {user_id}: Connected")
            
            start_time = time.time()
            
            # Simulate streaming loop
            while time.time() - start_time < DURATION_SECONDS:
                # Generate random noise or silence (16kHz PCM)
                # 3200 samples = 200ms
                chunk_size = 3200
                pcm_data = bytes([random.getrandbits(8) for _ in range(chunk_size * 2)])
                
                # Base64 encode raw PCM (Proxy will wrap it)
                b64_audio = base64.b64encode(pcm_data).decode("utf-8")
                
                # Send to proxy (Proxy expects raw base64 string, NOT JSON, unless we changed frontend?)
                # Wait, sarvamStreamingService sends raw base64 string.
                # Proxy wraps it.
                await websocket.send(b64_audio)
                
                # Try to read responses (non-blocking)
                try:
                    msg = await asyncio.wait_for(websocket.recv(), timeout=0.01)
                    if "transcript" in str(msg):
                        STATISTICS["transcripts_received"] += 1
                        # print(f"User {user_id}: Got transcript")
                except asyncio.TimeoutError:
                    pass
                except Exception as e:
                    print(f"User {user_id}: Read Error: {e}")
                    STATISTICS["errors"] += 1
                    break
                
                await asyncio.sleep(REQ_DELAY_MS / 1000)

            # Send STOP
            await websocket.send("STOP")
            # print(f"User {user_id}: Finished")
            
    except Exception as e:
        # print(f"User {user_id}: Connection Failed: {e}")
        STATISTICS["failed"] += 1
    finally:
        pass

async def main():
    print(f"🚀 Starting Stress Test: {CONCURRENT_USERS} users for {DURATION_SECONDS} seconds...")
    
    tasks = []
    for i in range(CONCURRENT_USERS):
        tasks.append(simulate_user(i))
        # Stagger starts slightly to avoid instant hammer
        await asyncio.sleep(0.1)
    
    await asyncio.gather(*tasks)
    
    print("\n📊 TEST RESULTS 📊")
    print(f"Total Users Simulated: {CONCURRENT_USERS}")
    print(f"Successful Connections: {STATISTICS['connected']}")
    print(f"Failed Connections:     {STATISTICS['failed']}")
    print(f"Transcripts Received:   {STATISTICS['transcripts_received']}")
    print(f"Total Errors:           {STATISTICS['errors']}")
    
    if STATISTICS['failed'] > 0:
        print("\n⚠️  Failures detected! Your single-process backend might be overloaded.")
    else:
        print("\n✅  Backend handled the load successfully.")

if __name__ == "__main__":
    asyncio.run(main())
