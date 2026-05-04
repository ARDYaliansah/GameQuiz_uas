import wave
import struct
import math

def generate_tone(file_name, freqs, duration_ms, volume=0.5, sample_rate=44100):
    num_samples = int(sample_rate * (duration_ms / 1000.0))
    
    with wave.open(file_name, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            sample = 0
            for f in freqs:
                sample += math.sin(2.0 * math.pi * f * t)
            
            # Normalize and apply volume
            sample = (sample / len(freqs)) * volume * 32767.0
            
            # Apply a simple envelope (fade out)
            envelope = 1.0 - (i / num_samples)
            sample = int(sample * envelope)
            
            wav_file.writeframes(struct.pack('h', sample))

# Correct sound: C5, E5, G5 (C major chord)
generate_tone('assets/sounds/correct.wav', [523.25, 659.25, 783.99], 500)

# Wrong sound: Low buzz (E2, F2 close together to create dissonance)
generate_tone('assets/sounds/wrong.wav', [82.41, 87.31], 600)

print("Sounds generated successfully in assets/sounds/")
