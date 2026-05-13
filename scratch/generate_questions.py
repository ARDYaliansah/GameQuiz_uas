import json
import random

def generate_questions():
    questions = []
    q_id = 1
    
    # Image Proxy for reliability and speed
    PROXY = "https://images.weserv.nl/?url="

    data = {
        "Teknologi": [
            ("Apa kepanjangan dari CPU?", ["Central Processing Unit", "Computer Personal Unit", "Central Power Unit", "Core Processing Unit"], 0),
            ("Siapa pendiri Microsoft?", ["Steve Jobs", "Bill Gates", "Mark Zuckerberg", "Elon Musk"], 1),
            ("Bahasa apa yang digunakan Flutter?", ["Java", "Swift", "Dart", "Kotlin"], 2),
            ("Unit dasar informasi?", ["Byte", "Bit", "Kilobyte", "Megabyte"], 1),
            ("Protokol email?", ["HTTP", "FTP", "SMTP", "SSH"], 2),
            ("Kepanjangan RAM?", ["Read Access Memory", "Random Access Memory", "Ready Active Memory", "Remote Access Memory"], 1),
            ("OS buatan Apple?", ["Windows", "Android", "macOS", "Linux"], 2),
            ("Perangkat input?", ["Monitor", "Printer", "Keyboard", "Speaker"], 2),
            ("Kepanjangan WWW?", ["World Wide Web", "World West Web", "Web World Wide", "World Wire Web"], 0),
            ("Pencipta Android?", ["Microsoft", "Apple", "Google", "Facebook"], 2),
            ("Apa kepanjangan dari HTTP?", ["HyperText Transfer Protocol", "HyperText Total Process", "High Tech Transfer Protocol", "Hyper Transfer Text Process"], 0),
            ("Penyimpanan data permanen?", ["RAM", "CPU", "Hard Drive", "GPU"], 2),
            ("Pencipta Python?", ["Guido van Rossum", "James Gosling", "Dennis Ritchie", "Bjarne Stroustrup"], 0),
            ("Kepanjangan GPU?", ["Graphics Processing Unit", "General Processing Unit", "Global Processing Unit", "Graphical Power Unit"], 0),
            ("Tahun WWW diluncurkan?", ["1989", "1991", "1995", "1985"], 0),
            ("Pengembang Android?", ["Apple", "Microsoft", "Google", "Facebook"], 2),
            ("Nama browser web pertama?", ["Mosaic", "Netscape Navigator", "WorldWideWeb", "Internet Explorer"], 2),
            ("Pendiri Tesla?", ["Jeff Bezos", "Elon Musk", "Bill Gates", "Mark Zuckerberg"], 1),
            ("Kepanjangan SQL?", ["Structured Query Language", "Simple Query Language", "Standard Query Language", "Sequential Query Language"], 0),
            ("Protokol website aman?", ["HTTPS", "HTTP", "SSL", "FTP"], 0),
        ],
        "Sejarah": [
            ("Siapa Presiden pertama Indonesia?", ["Soekarno", "Mohammad Hatta", "Soeharto", "B.J. Habibie"], 0),
            ("Kapan Indonesia merdeka?", ["17 Agustus 1945", "1 Juni 1945", "20 Mei 1908", "10 November 1945"], 0),
            ("Penemu benua Amerika?", ["Christopher Columbus", "Vasco da Gama", "Marco Polo", "Ferdinand Magellan"], 0),
            ("Perang Dunia II berakhir pada tahun?", ["1945", "1939", "1918", "1950"], 0),
            ("Kerajaan Hindu tertua di Indonesia?", ["Kutai", "Tarumanegara", "Majapahit", "Sriwijaya"], 0),
            ("Penjahit bendera Merah Putih?", ["Fatmawati", "Kartini", "Cut Nyak Dhien", "Dewi Sartika"], 0),
            ("Borobudur di provinsi?", ["Jawa Tengah", "Jawa Timur", "Yogyakarta", "Jawa Barat"], 0),
            ("Penemu mesin uap?", ["James Watt", "Thomas Edison", "Alexander Graham Bell", "Isaac Newton"], 0),
            ("Revolusi Perancis dimulai?", ["1789", "1776", "1804", "1815"], 0),
            ("Kaisar pertama Romawi?", ["Augustus", "Julius Caesar", "Nero", "Constantine"], 0),
        ],
        "Film": [
            ("Sutradara Titanic?", ["James Cameron", "Steven Spielberg", "Christopher Nolan", "Quentin Tarantino"], 0),
            ("Oscar Best Picture pertama?", ["Wings", "Gone with the Wind", "Casablanca", "The Godfather"], 0),
            ("Pemeran Iron Man?", ["Robert Downey Jr.", "Chris Evans", "Chris Hemsworth", "Mark Ruffalo"], 0),
            ("Kerajaan di Black Panther?", ["Wakanda", "Asgard", "Atlantis", "Themyscira"], 0),
            ("Film animasi CGI penuh pertama?", ["Toy Story", "Shrek", "The Lion King", "Finding Nemo"], 0),
            ("Pengisi suara Shrek?", ["Mike Myers", "Eddie Murphy", "Cameron Diaz", "John Cleese"], 0),
            ("Nama robot di WALL-E?", ["WALL-E", "EVE", "M-O", "AUTO"], 0),
            ("Film pendapatan tertinggi?", ["Avatar", "Avengers: Endgame", "Titanic", "Star Wars: The Force Awakens"], 0),
            ("Pemeran Joker di The Dark Knight?", ["Heath Ledger", "Joaquin Phoenix", "Jack Nicholson", "Jared Leto"], 0),
            ("Film tentang mimpi di mimpi?", ["Inception", "Interstellar", "Tenet", "Memento"], 0),
        ],
        "Sains": [
            ("Planet terdekat Matahari?", ["Merkurius", "Venus", "Bumi", "Mars"], 0),
            ("Rumus kimia air?", ["H2O", "CO2", "NaCl", "O2"], 0),
            ("Penemu teori relativitas?", ["Albert Einstein", "Isaac Newton", "Galileo Galilei", "Stephen Hawking"], 0),
            ("Gas terbanyak di atmosfer?", ["Nitrogen", "Oksigen", "Karbon Dioksida", "Argon"], 0),
            ("Jumlah tulang manusia dewasa?", ["206", "300", "215", "190"], 0),
            ("Organ pemompa darah?", ["Jantung", "Paru-paru", "Hati", "Ginjal"], 0),
            ("Satuan arus listrik?", ["Ampere", "Volt", "Watt", "Ohm"], 0),
            ("Zat hijau daun?", ["Klorofil", "Hemoglobin", "Melanin", "Karoten"], 0),
            ("Galaksi tempat tinggal kita?", ["Bima Sakti", "Andromeda", "Sombrero", "Triangulum"], 0),
            ("Logam cair suhu ruang?", ["Merkuri", "Besi", "Emas", "Perak"], 0),
        ],
        "Tebak Gambar": [
            ("Siapa tokoh pada gambar ini?", ["Albert Einstein", "Newton", "Tesla", "Edison"], 0, "upload.wikimedia.org/wikipedia/commons/d/d3/Albert_Einstein_Head.jpg"),
            ("Apa nama menara ini?", ["Menara Eiffel", "Pisa", "Big Ben", "Burj"], 0, "upload.wikimedia.org/wikipedia/commons/a/af/Tour_Eiffel_2014.jpg"),
            ("Lukisan ini berjudul?", ["Mona Lisa", "Starry Night", "Last Supper", "Scream"], 0, "upload.wikimedia.org/wikipedia/commons/e/ec/Mona_Lisa_by_Leonardo_da_Vinci_from_C2RMF_retouched.jpg"),
            ("Hewan apa ini?", ["Panda", "Koala", "Beruang", "Rakun"], 0, "upload.wikimedia.org/wikipedia/commons/0/0f/Grosser_Panda.JPG"),
            ("Bangunan ini adalah?", ["Colosseum", "Parthenon", "Pyramid", "Taj Mahal"], 0, "upload.wikimedia.org/wikipedia/commons/d/d8/Colosseum_in_Rome-Italy.JPG"),
            ("Buah apa ini?", ["Durian", "Nangka", "Sirsak", "Rambutan"], 0, "upload.wikimedia.org/wikipedia/commons/4/45/Durian.jpg"),
            ("Hewan apa ini?", ["Gajah", "Jerapah", "Singa", "Harimau"], 0, "upload.wikimedia.org/wikipedia/commons/3/37/African_Elephant_Fragments.jpg"),
            ("Apa nama alat musik ini?", ["Angklung", "Gamelan", "Sasando", "Kolintang"], 0, "upload.wikimedia.org/wikipedia/commons/c/cd/Angklung_tradisional.jpg"),
            ("Situs ini di negara?", ["Peru", "Mesir", "Yordania", "Cina"], 0, "upload.wikimedia.org/wikipedia/commons/e/eb/Machu_Picchu%2C_Peru.JPG"),
            ("Planet apa ini?", ["Saturnus", "Jupiter", "Mars", "Bumi"], 0, "upload.wikimedia.org/wikipedia/commons/c/c7/Saturn_during_Equinox.jpg"),
            ("Gunung tertinggi di dunia?", ["Everest", "K2", "Fuji", "Semeru"], 0, "upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLP_edit.jpg"),
            ("Monumen terkenal di Indonesia?", ["Monas", "Borobudur", "Prambanan", "GWK"], 0, "upload.wikimedia.org/wikipedia/commons/b/b1/Merdeka_Square_Monas_02.jpg"),
            ("Jembatan terkenal di AS?", ["Golden Gate", "London Bridge", "Brooklyn", "Manhattan"], 0, "upload.wikimedia.org/wikipedia/commons/0/0c/GoldenGateBridge-001.jpg"),
            ("Ikon kota Sydney?", ["Opera House", "Harbour Bridge", "Bondi", "Manly"], 0, "upload.wikimedia.org/wikipedia/commons/4/40/Sydney_Opera_House_Sails.jpg"),
            ("Makanan khas Italia?", ["Pizza", "Sushi", "Ramen", "Taco"], 0, "upload.wikimedia.org/wikipedia/commons/a/a3/Eq_it-na_pizza-margherita_sep2005_sml.jpg"),
            ("Ikon kota London?", ["Big Ben", "Eiffel", "Colosseum", "Taj Mahal"], 0, "upload.wikimedia.org/wikipedia/commons/8/87/Palace_of_Westminster_from_the_dome_on_Methodist_Central_Hall.jpg"),
            ("Patung di Brazil?", ["Christ the Redeemer", "Liberty", "Sphinx", "Moai"], 0, "upload.wikimedia.org/wikipedia/commons/4/4f/Christ_the_Redeemer_-_Rio_de_Janeiro%2C_Brazil.jpg"),
            ("Ikon kota Paris?", ["Arc de Triomphe", "Louvre", "Eiffel", "Notre Dame"], 0, "upload.wikimedia.org/wikipedia/commons/e/e4/Arc_de_Triomphe%2C_Paris_21_October_2010.jpg"),
            ("Hewan tercepat di darat?", ["Cheetah", "Singa", "Kuda", "Macan"], 0, "upload.wikimedia.org/wikipedia/commons/3/34/Cheetah_at_the_Cincinnati_Zoo.jpg"),
            ("Bunga ini adalah?", ["Matahari", "Mawar", "Melati", "Tulip"], 0, "upload.wikimedia.org/wikipedia/commons/a/a9/A_sunflower.jpg"),
        ]
    }

    # Generate 20 levels per category
    for cat, pool in data.items():
        random.shuffle(pool)
        for level in range(1, 21):
            for i in range(10):
                idx = ( (level-1) * 10 + i ) % len(pool)
                sq = pool[idx]
                img_url = sq[3] if len(sq) > 3 else None
                
                # Apply Proxy to image URL
                if img_url:
                    img_url = f"{PROXY}{img_url}&w=600&h=400&fit=cover&output=webp"
                
                questions.append({
                    "id": f"q_{q_id}",
                    "text": sq[0],
                    "options": sq[1],
                    "correctAnswerIndex": sq[2],
                    "category": cat,
                    "level": level,
                    "explanation": f"Pertanyaan level {level} kategori {cat}.",
                    "imageUrl": img_url
                })
                q_id += 1
                
    return questions

if __name__ == "__main__":
    all_questions = generate_questions()
    with open("assets/data/questions.json", "w", encoding="utf-8") as f:
        json.dump(all_questions, f, indent=2, ensure_ascii=False)
    print(f"Generated {len(all_questions)} questions.")
