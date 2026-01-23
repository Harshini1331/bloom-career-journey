import asyncio
import websockets
import base64
import json
import traceback

async def test_proxy():
    uri = "ws://127.0.0.1:8000/ws/stream?language_code=hi-IN"
    print(f"Connecting to {uri}...", flush=True)
    try:
        async with websockets.connect(uri) as websocket:
            print(" Connected to Proxy!", flush=True)
            
            # Send silence
            silence = b'\x00' * 3200 # 0.1s of silence
            b64_data = base64.b64encode(silence).decode('utf-8')
            
            print("Sending audio chunk...", flush=True)
            await websocket.send(b64_data)
            
            print("Waiting for response...", flush=True)
            try:
                msg = await asyncio.wait_for(websocket.recv(), timeout=5.0)
                print(f"Received: {msg}", flush=True)
            except asyncio.TimeoutError:
                print("Timeout waiting for response (expected if strict VAD is on)", flush=True)
            
            # Keep open for a bit
            await asyncio.sleep(1)
            print("Closing check...", flush=True)
            
    except websockets.exceptions.ConnectionClosed as e:
        print(f" Connection Closed: {e.code} {e.reason}", flush=True)
    except Exception as e:
        print(f" Error: {e}", flush=True)
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(test_proxy())
