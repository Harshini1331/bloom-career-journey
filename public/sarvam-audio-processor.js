class SarvamAudioProcessor extends AudioWorkletProcessor {
    constructor() {
        super();
        this.targetSampleRate = 16000;
        this.bufferSize = 4096; // Buffer size for outgoing chunks
        this.buffer = new Float32Array(this.bufferSize);
        this.bufferIndex = 0;
        this._partialSample = 0;
    }

    process(inputs, outputs, parameters) {
        const input = inputs[0];
        if (!input || !input.length) return true;

        const channel0 = input[0];
        // AudioWorklet input sample rate is global 'sampleRate'
        // We need to decimate from sampleRate (e.g. 48000) to 16000

        // Simple Linear Interpolation / Decimation
        const ratio = sampleRate / this.targetSampleRate;

        for (let i = 0; i < channel0.length; i += ratio) {
            // Find the two nearest samples
            const index = Math.floor(i);
            const nextIndex = Math.ceil(i);
            const fraction = i - index;

            const sample = channel0[index] || 0;
            const nextSample = channel0[nextIndex] || sample;

            // Interpolate
            const interpolated = sample + (nextSample - sample) * fraction;

            this.buffer[this.bufferIndex++] = interpolated;

            if (this.bufferIndex >= this.bufferSize) {
                this.port.postMessage(this.buffer.slice());
                this.bufferIndex = 0;
            }
        }

        return true;
    }
}

registerProcessor('sarvam-audio-processor', SarvamAudioProcessor);
