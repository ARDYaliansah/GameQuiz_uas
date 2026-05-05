import wave
import struct
import math
import os

def generate_tone(file_name, freqs, duration_ms, volume=0.5, sample_rate=44100):
    # Ensure directory exists
    os.makedirs(os.path.dirname(file_name), exist_ok=True)
    
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

def generate_background_music(file_name, duration_seconds=5):
    sample_rate = 44100
    num_samples = sample_rate * duration_seconds
    
    with wave.open(file_name, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        # Simple alternating notes: C4 and G3
        notes = [261.63, 196.00]
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            
            # Change note every 1 second
            note_idx = int(t) % len(notes)
            freq = notes[note_idx]
            
            # Use a square-ish wave for better audibility on small speakers
            sample = math.sin(2.0 * math.pi * freq * t)
            if sample > 0:
                sample = 0.5
            else:
                sample = -0.5
            
            # Soft fade at the very beginning and end of the 5s loop
            if i < 4410: # 0.1s fade in
                envelope = i / 4410
            elif i > num_samples - 4410: # 0.1s fade out
                envelope = (num_samples - i) / 4410
            else:
                envelope = 1.0
                
            final_sample = int(sample * envelope * 0.3 * 32767.0)
            wav_file.writeframes(struct.pack('h', final_sample))

generate_background_music('assets/sounds/background.wav', 5)

print("Sounds generated successfully in assets/sounds/")
