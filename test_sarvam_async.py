import asyncio
import os
import json
from sarvamai import AsyncSarvamAI
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

API_KEY = os.environ.get("SARVAM_API_KEY") or os.environ.get("VITE_SARVAM_API_KEY")
print(f"API Key found: {'Yes' if API_KEY else 'No'}")

if not API_KEY:
    print("Please set SARVAM_API_KEY in .env")
    exit(1)

async def test_streaming():
    client = AsyncSarvamAI(api_subscription_key=API_KEY)
    
    print("Attempting to connect to Sarvam Streaming (saarika:v2.5)...")
    
    try:
        # Use raw PCM (simulated silence)
        # Create 1 second of silence at 16kHz
        silence_chunk = b'\x00\x00' * 16000 # 32000 bytes
        
        async with client.speech_to_text_streaming.connect(
            model="saarika:v2.5",
            language_code="hi-IN", # Hindi handles silence well?
            sample_rate=16000,
            input_audio_codec="pcm_s16le", 
            high_vad_sensitivity=False, # Disable to allow silence
            vad_signals=True,
            flush_signal=True
        ) as ws:
            print("Connected!", flush=True)
            print(f"Type of ws: {type(ws)}", flush=True)
            
            socket = getattr(ws, '_websocket', None)
            if not socket:
                print("❌ No _websocket found!", flush=True)
                return

            print(f"Type of socket: {type(socket)}", flush=True)

            # Send JSON payload with audio/wav (wrapping PCM in WAV container)
            import base64
            import struct
            
            def create_wav_header(pcm_data, sample_rate=16000):
                # Maven/RIFF header for 16-bit mono 16kHz
                header = b'RIFF'
                header += struct.pack('<I', 36 + len(pcm_data)) # ChunkSize
                header += b'WAVEfmt '
                header += struct.pack('<I', 16) # Subchunk1Size (16 for PCM)
                header += struct.pack('<H', 1)  # AudioFormat (1 for PCM)
                header += struct.pack('<H', 1)  # NumChannels (1)
                header += struct.pack('<I', sample_rate) # SampleRate
                header += struct.pack('<I', sample_rate * 2) # ByteRate (SampleRate * BlockAlign)
                header += struct.pack('<H', 2) # BlockAlign (NumChannels * BitsPerSample/8)
                header += struct.pack('<H', 16) # BitsPerSample
                header += b'data'
                header += struct.pack('<I', len(pcm_data)) # Subchunk2Size
                return header + pcm_data

            wav_data = create_wav_header(silence_chunk)
            wav_b64 = base64.b64encode(wav_data).decode('utf-8')
            
            payload = {
                "audio": {
                    "data": wav_b64,
                    "sample_rate": 16000,
                    "encoding": "audio/wav" # Finally compliant!
                }
            }
            
            print(f"Sending JSON payload with WAV header...", flush=True)
            await socket.send(json.dumps(payload))
            
            # Send STOP to force response
            print("Sending Flush via SDK...", flush=True)
            await ws.flush() 

            print("Listening on raw socket...", flush=True)
            try:
                # Set a timeout for the listener
                async def listen():
                    async for msg in socket:
                        print(f"Received raw: {msg}", flush=True)
                        if "transcript" in str(msg):
                            print("✅ Found transcript!", flush=True)
                            return
                
                await asyncio.wait_for(listen(), timeout=8.0)
                print("Finished listening.", flush=True)

            except asyncio.TimeoutError:
                print("❌ Timeout waiting for response on raw socket.", flush=True)

    except Exception as e:
        print(f"Error: {e}", flush=True)
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(test_streaming())
