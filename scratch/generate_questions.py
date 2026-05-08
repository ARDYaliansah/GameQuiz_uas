import json
import random

categories = ['Teknologi', 'Sejarah', 'Film', 'Sains', 'Tebak Gambar']
levels_per_category = 20
questions_per_level = 10

def generate_questions():
    all_questions = []
    
    # Pre-defined high quality questions for first levels
    # Teknologi
    tech_questions = [
        ("Apa kepanjangan dari CPU?", ["Central Processing Unit", "Computer Personal Unit", "Central Power Unit", "Core Processing Unit"], 0, "CPU adalah otak dari komputer."),
        ("Siapa pendiri Microsoft?", ["Steve Jobs", "Bill Gates", "Mark Zuckerberg", "Elon Musk"], 1, "Bill Gates mendirikan Microsoft bersama Paul Allen."),
        ("Bahasa apa yang digunakan Flutter?", ["Java", "Swift", "Dart", "Kotlin"], 2, "Dart dikembangkan oleh Google."),
        ("Unit dasar informasi?", ["Byte", "Bit", "Kilobyte", "Megabyte"], 1, "Bit adalah unit terkecil."),
        ("Protokol email?", ["HTTP", "FTP", "SMTP", "SSH"], 2, "SMTP untuk pengiriman email."),
        ("Kepanjangan RAM?", ["Read Access Memory", "Random Access Memory", "Ready Active Memory", "Remote Access Memory"], 1, "RAM adalah penyimpanan sementara."),
        ("OS buatan Apple?", ["Windows", "Android", "macOS", "Linux"], 2, "macOS digunakan di komputer Mac."),
        ("Perangkat input?", ["Monitor", "Printer", "Keyboard", "Speaker"], 2, "Keyboard untuk memasukkan data."),
        ("Kepanjangan WWW?", ["World Wide Web", "World West Web", "Web World Wide", "World Wire Web"], 0, "WWW diciptakan Tim Berners-Lee."),
        ("Pencipta Android?", ["Microsoft", "Apple", "Google", "Facebook"], 2, "Google mengakuisisi Android pada 2005."),
    ]
    
    # Sejarah
    history_questions = [
        ("Tahun berapa Indonesia merdeka?", ["1944", "1945", "1946", "1947"], 1, "17 Agustus 1945."),
        ("Presiden pertama RI?", ["Moh. Hatta", "Soeharto", "Soekarno", "Habibie"], 2, "Ir. Soekarno."),
        ("Penjahit Bendera Pusaka?", ["Fatmawati", "Kartini", "Cut Nyak Dhien", "Megawati"], 0, "Ibu Fatmawati."),
        ("Kota yang dibom atom 6 Agt 1945?", ["Tokyo", "Osaka", "Hiroshima", "Nagasaki"], 2, "Hiroshima."),
        ("Kerajaan tertua di RI?", ["Majapahit", "Sriwijaya", "Kutai", "Tarumanegara"], 2, "Kutai di Kalimantan Timur."),
        ("Pengetik naskah Proklamasi?", ["Sayuti Melik", "Sukarni", "Wikana", "Subardjo"], 0, "Sayuti Melik."),
        ("Patih Majapahit?", ["Gajah Mada", "Hayam Wuruk", "Ken Arok", "Raden Wijaya"], 0, "Gajah Mada."),
        ("Tahun berakhir PD II?", ["1940", "1942", "1945", "1950"], 2, "1945."),
        ("Penemu Benua Amerika?", ["Vasco", "Columbus", "Magellan", "Polo"], 1, "Christopher Columbus."),
        ("Dinasti pembangun Borobudur?", ["Sanjaya", "Syailendra", "Isyana", "Girindra"], 1, "Dinasti Syailendra."),
    ]

    # Film
    film_questions = [
        ("Oscar Best Picture 2020?", ["1917", "Joker", "Parasite", "Hollywood"], 2, "Parasite."),
        ("Sutradara Inception?", ["Spielberg", "Nolan", "Cameron", "Tarantino"], 1, "Christopher Nolan."),
        ("Karakter utama Pirates Caribbean?", ["Jack Sparrow", "Will Turner", "Barbossa", "Davy Jones"], 0, "Jack Sparrow."),
        ("Sekolah Harry Potter?", ["Nevermore", "Hogwarts", "Sky High", "Xavier"], 1, "Hogwarts."),
        ("Animasi pertama Disney?", ["Pinocchio", "Bambi", "Snow White", "Dumbo"], 2, "Snow White (1937)."),
        ("Aktor Iron Man?", ["Chris Evans", "RDJ", "Hemsworth", "Ruffalo"], 1, "Robert Downey Jr."),
        ("Negara asal Squid Game?", ["Jepang", "China", "Korea Selatan", "Thailand"], 2, "Korea Selatan."),
        ("Film horor Pennywise?", ["Saw", "It", "Conjuring", "Insidious"], 1, "It oleh Stephen King."),
        ("Pengisi suara Woody?", ["Tim Allen", "Tom Hanks", "Billy Crystal", "John Goodman"], 1, "Tom Hanks."),
        ("Film terlaris (Avengers)?", ["Titanic", "Endgame", "Star Wars", "Jurassic World"], 1, "Avengers: Endgame."),
    ]

    # Sains
    science_questions = [
        ("Planet terdekat ke Matahari?", ["Venus", "Bumi", "Merkurius", "Mars"], 2, "Merkurius adalah planet pertama."),
        ("Zat yang dibutuhkan tanaman untuk fotosintesis?", ["Oksigen", "Karbon Dioksida", "Nitrogen", "Hidrogen"], 1, "CO2 dibutuhkan bersama cahaya matahari."),
        ("Simbol kimia untuk Air?", ["H2O", "CO2", "NaCl", "O2"], 0, "H2O adalah Di-hidrogen Monoksida."),
        ("Siapa penemu hukum gravitasi?", ["Einstein", "Newton", "Tesla", "Galileo"], 1, "Isaac Newton."),
        ("Gas terbanyak di atmosfer Bumi?", ["Oksigen", "Nitrogen", "Argon", "Karbon Dioksida"], 1, "Nitrogen mencapai sekitar 78%."),
        ("Organ tubuh pemompa darah?", ["Paru-paru", "Hati", "Jantung", "Ginjal"], 2, "Jantung memompa darah ke seluruh tubuh."),
        ("Suhu beku air (Celcius)?", ["-10", "0", "10", "100"], 1, "Air membeku pada 0 derajat Celcius."),
        ("Penyusun terkecil makhluk hidup?", ["Jaringan", "Organ", "Sel", "Atom"], 2, "Sel adalah unit fungsional terkecil."),
        ("Planet merah adalah sebutan untuk?", ["Jupiter", "Saturnus", "Mars", "Venus"], 2, "Mars berwarna kemerahan karena besi oksida."),
        ("Kecepatan cahaya kira-kira?", ["300.000 km/s", "100.000 km/s", "500.000 km/s", "1.000.000 km/s"], 0, "Cahaya merambat sangat cepat."),
    ]

    # Tebak Gambar
    image_questions = [
        ("Benda apa ini?", ["Laptop", "Televisi", "Radio", "Kamera"], 0, "Ini adalah laptop.", "assets/images/laptop.png"),
        ("Menara ini di mana?", ["London", "Paris", "Roma", "Berlin"], 1, "Menara Eiffel di Paris.", "https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?q=80&w=1000"),
        ("Hewan apa ini?", ["Harimau", "Singa", "Macan Tutul", "Cheetah"], 1, "Singa si raja hutan.", "https://images.unsplash.com/photo-1546182990-dffeafbe841d?q=80&w=1000"),
        ("Buah apa ini?", ["Apel", "Jeruk", "Pisang", "Mangga"], 0, "Apel merah yang segar.", "https://images.unsplash.com/photo-1560806887-1e4cd0b6bcd6?q=80&w=1000"),
        ("Kendaraan apa ini?", ["Mobil", "Motor", "Sepeda", "Bus"], 2, "Sepeda adalah alat transportasi ramah lingkungan.", "https://images.unsplash.com/photo-1485965120184-e220f721d03e?q=80&w=1000"),
        ("Bangunan apa ini?", ["Piramida", "Candi", "Masjid", "Gereja"], 0, "Piramida Giza di Mesir.", "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?q=80&w=1000"),
        ("Negara mana?", ["Jepang", "Korea", "China", "Thailand"], 0, "Gunung Fuji di Jepang.", "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1000"),
        ("Siapa tokoh ini?", ["Einstein", "Newton", "Darwin", "Tesla"], 0, "Albert Einstein, fisikawan jenius.", "https://images.unsplash.com/photo-1581092160562-40aa08e78837?q=80&w=1000"),
        ("Olahraga apa ini?", ["Sepak Bola", "Basket", "Tenis", "Bulu Tangkis"], 1, "Bola basket masuk ke ring.", "https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1000"),
        ("Bunga apa ini?", ["Mawar", "Melati", "Matahari", "Tulip"], 2, "Bunga matahari yang cerah.", "https://images.unsplash.com/photo-1597848212624-a19eb35e2651?q=80&w=1000"),
    ]

    base_questions = {
        'Teknologi': tech_questions,
        'Sejarah': history_questions,
        'Film': film_questions,
        'Sains': science_questions,
        'Tebak Gambar': image_questions
    }

    q_id_counter = 1
    for cat in categories:
        for lvl in range(1, levels_per_category + 1):
            source = base_questions[cat]
            for i in range(questions_per_level):
                # For first level, use predefined. For others, mix and match or reuse with variation
                # In a real app, you'd have 1000 unique ones.
                q_data = source[i % len(source)]
                
                text = q_data[0]
                options = list(q_data[1])
                correct = q_data[2]
                expl = q_data[3]
                img = q_data[4] if len(q_data) > 4 else None
                
                # Add variation for levels > 1
                if lvl > 1:
                    text = f"[Lvl {lvl}] {text}"
                    # Maybe shuffle options for level difficulty
                    # random.shuffle(options)
                
                all_questions.append({
                    "id": f"q_{q_id_counter}",
                    "text": text,
                    "options": options,
                    "correctAnswerIndex": correct,
                    "category": cat,
                    "level": lvl,
                    "explanation": expl,
                    "imageUrl": img
                })
                q_id_counter += 1
                
    return all_questions

questions = generate_questions()
with open('assets/data/questions.json', 'w', encoding='utf-8') as f:
    json.dump(questions, f, ensure_ascii=False, indent=2)

print(f"Generated {len(questions)} questions.")
