# blueprint gamequiz
Halo! Sebagai mahasiswa IT, membangun aplikasi kuis dengan Flutter adalah pilihan yang sangat cerdas. Flutter memungkinkan kamu membuat UI yang cantik dan mulus dengan cepat.

Agar aplikasi ini menghibur dan tidak membosankan, kuncinya bukan pada kerumitan kodingnya, melainkan pada User Experience (UX) dan Game Loop yang menyenangkan.

Berikut adalah blueprint perencanaan untuk aplikasi kuis kamu:

1. Arsitektur & Struktur Data
Untuk skala mahasiswa, gunakan pendekatan Clean Architecture yang sederhana agar kode kamu rapi.

Model: Data class untuk Question (pertanyaan, pilihan jawaban, jawaban benar, kategori).

Logic (State Management): Gunakan Provider atau Bloc. Ini penting untuk mengatur skor, sisa waktu, dan perpindahan soal secara reaktif.

Local Storage: Gunakan shared_preferences untuk menyimpan High Score pemain.

2. Fitur "Penghibur" (Core Gameplay)
Jangan hanya buat tanya-jawab saja. Tambahkan elemen gamification:

Countdown Timer: Memberikan tekanan yang memicu adrenalin (misal: 10-15 detik per soal).

Life System (Nyawa): Pemain punya 3 nyawa. Salah menjawab = kehilangan 1 nyawa. Game over jika habis.

Streak Bonus: Berikan poin tambahan jika pemain menjawab benar 3 kali berturut-turut.

Sound Effects: Suara "ding" saat benar dan "buzz" saat salah sangat berpengaruh pada psikologi pemain.

3. Desain UI/UX (User Interface)
Buat tampilan yang modern dan tidak kaku. Gunakan palet warna yang cerah tapi nyaman di mata.

Alur Layar (Flow):
Splash Screen: Logo game yang menarik.

Home Screen: Tombol "Play", "High Score", dan "Settings".

Category Selection: Pilih topik (misal: Teknologi, Sejarah, Film).

Quiz Screen: Tempat aksi berlangsung.

Result Screen: Skor akhir, pesan motivasi (misal: "Hebat!" atau "Coba lagi!"), dan tombol share.

4. Struktur Widget Utama di Flutter
Gunakan komponen bawaan Flutter untuk mempercepat proses:

LinearProgressIndicator: Untuk menampilkan sisa waktu atau progress soal.

Card & InkWell: Untuk pilihan jawaban agar memiliki efek sentuhan (ripple effect).

AnimatedSwitcher: Untuk transisi halus saat berpindah antar soal.
