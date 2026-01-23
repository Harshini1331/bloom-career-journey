import os
import asyncio
import json
import base64
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from sarvamai import AsyncSarvamAI
from dotenv import load_dotenv

# Load environment variables (locally)
load_dotenv()

app = FastAPI()

# Allow CORS for local development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

API_KEY = os.environ.get("SARVAM_API_KEY") or os.environ.get("VITE_SARVAM_API_KEY")

if not API_KEY:
    print("❌ WARNING: SARVAM_API_KEY is not set.")

@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "sarvam-proxy"}

@app.websocket("/ws/stream")
async def websocket_endpoint(client_ws: WebSocket, language_code: str = "hi-IN"):
    """
    WebSocket Secure Proxy:
    Client -> (PCM Audio) -> Proxy -> (Sarvam SDK) -> Sarvam AI
    Client <- (Transcript) <- Proxy <- (Sarvam SDK) <- Sarvam AI
    """
    await client_ws.accept()
    print(f"🔌 Client connected to proxy (Language: {language_code})")

    if not API_KEY:
        await client_ws.close(code=1008, reason="Server API Key missing")
        return

    # Initialize Sarvam Client
    client = AsyncSarvamAI(api_subscription_key=API_KEY)

    try:
        print(f"🔄 Connecting to Sarvam Streaming API... (Model: saarika:v2.5, Lang: {language_code})")
        # Connect to Sarvam
        # We enforce 16kHz for stability as per Sarvam best practices
        # Connect to Sarvam with flush_signal enabled for manual control
        async with client.speech_to_text_streaming.connect(
            model="saarika:v2.5",
            language_code=language_code,
            sample_rate=16000,
            input_audio_codec="pcm_s16le", 
            high_vad_sensitivity=True,
            vad_signals=True,
            flush_signal=True # Enable manual flush
        ) as sarvam_ws:
            print("🚀 Connected to Sarvam AI successfully!")
            print(f"DEBUG: sarvam_ws type: {type(sarvam_ws)}")
            # print(f"DEBUG: sarvam_ws dir: {dir(sarvam_ws)}")
            # If using _websocket hack, ensure we can read from it too
            if hasattr(sarvam_ws, '_websocket'):
                 print("DEBUG: Found _websocket attribute.")

            # Helper to create WAV header for 16kHz Mono 16-bit PCM
            import struct
            def create_wav_header(pcm_data):
                sample_rate = 16000
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

            # 1. Input Loop: Client -> Sarvam
            async def receive_from_client():
                try:
                    while True:
                        # Client sends Base64 string OR JSON command
                        data = await client_ws.receive_text()
                        
                        if not data:
                            print("⚠️ Received empty data from client")
                            continue

                        # Check for special commands
                        if data.strip() == "STOP":
                            print("🛑 Received STOP command. Flushing Sarvam buffer...")
                            await sarvam_ws.flush()
                            continue

                        # Decode Base64 from Client (Raw PCM)
                        try:
                            pcm_bytes = base64.b64decode(data)
                        except Exception as decode_err:
                            print(f"⚠️ Failed to decode base64 chunk: {decode_err}")
                            continue

                        # WRAP IN WAV HEADER
                        # Sarvam API demands 'audio/wav' encoding for every message
                        wav_bytes = create_wav_header(pcm_bytes)
                        wav_b64 = base64.b64encode(wav_bytes).decode('utf-8')

                        # Construct JSON payload manually (bypassing SDK Pydantic check)
                        payload = {
                            "audio": {
                                "data": wav_b64,
                                "encoding": "audio/wav",
                                "sample_rate": 16000
                            }
                        }

                        # Send JSON to Sarvam via raw socket
                        try:
                            # Use _websocket.send (sync or async depending on library version, usually async)
                            # sarvam_ws._websocket is a websockets.client.WebSocketClientProtocol
                            await sarvam_ws._websocket.send(json.dumps(payload))
                        except Exception as send_err:
                            print(f"❌ Error sending to Sarvam: {send_err}")
                            break

                except WebSocketDisconnect:
                    print("Client disconnected normally (WebSocketDisconnect)")
                except Exception as e:
                    print(f"❌ Error reading from client: {e}")

            # 2. Output Loop: Sarvam -> Client
            async def send_to_client():
                try:
                    # CRITICAL FIX: Iterate the underlying socket directly
                    # The SDK wrapper might not yield messages if we didn't use .transcribe()
                    socket_iterator = sarvam_ws._websocket if hasattr(sarvam_ws, '_websocket') else sarvam_ws
                    
                    print(f"🔄 Starting output loop using: {type(socket_iterator)}")

                    async for message in socket_iterator:
                        # Forward raw JSON message to client
                        try:
                            # Depending on library, message might be bytes or str
                             if isinstance(message, bytes):
                                 message = message.decode('utf-8')
                             
                             # print(f"📩 Received from Sarvam: {message[:100]}...") # Log partial
                             await client_ws.send_text(message)
                        except Exception as parse_err:
                            print(f"⚠️ Error parsing/sending from Sarvam: {parse_err}")

                except Exception as e:
                    print(f"❌ Error reading from Sarvam: {e}")

            # Run both bidirectional streams
            await asyncio.gather(receive_from_client(), send_to_client())

    except Exception as e:
        import traceback
        traceback.print_exc() # Print full stack trace to console
        print(f"❌ Proxy Connection Error or Sarvam Disconnect: {e}")
        try:
            await client_ws.close(code=1011, reason=f"Proxy Error: {str(e)}")
        except:
            pass
    finally:
        print("🔌 Client disconnected (Cleanup)")

if __name__ == "__main__":
    import uvicorn
    # Listen on 0.0.0.0 to allow access from other devices if needed, but localhost is fine
    # Increased keep-alive to 60s to prevent timeout during silence/processing gaps
    uvicorn.run(app, host="0.0.0.0", port=8000, timeout_keep_alive=60)
