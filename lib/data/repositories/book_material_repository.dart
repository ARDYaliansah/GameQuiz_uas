import '../../data/models/question_model.dart';

class BookPage {
  final String title;
  final String prose;
  final String keyFact;
  final Question question;

  BookPage({
    required this.title,
    required this.prose,
    required this.keyFact,
    required this.question,
  });
}

class BookMaterialRepository {
  static final BookMaterialRepository _instance = BookMaterialRepository._internal();
  factory BookMaterialRepository() => _instance;
  BookMaterialRepository._internal();

  // Custom detailed materials for Sejarah Level 1
  final Map<int, List<Map<String, String>>> _sejarahMaterials = {
    1: [
      {
        "title": "Berakhirnya Perang Dunia II",
        "prose": "Perang Dunia II adalah konflik militer global paling mematikan dalam sejarah manusia, berlangsung dari tahun 1939 hingga 1945. Perang ini melibatkan sebagian besar negara di dunia yang terbagi menjadi dua aliansi militer yang saling bertentangan: Blok Sekutu dan Blok Poros. Setelah pertempuran sengit selama bertahun-tahun di berbagai belahan dunia, konflik dahsyat ini akhirnya resmi berakhir pada tahun 1945 menyusul jatuhnya bom atom di Hiroshima dan Nagasaki, serta penandatanganan dokumen menyerahnya Jepang tanpa syarat kepada Sekutu di atas kapal perang USS Missouri pada tanggal 2 September 1945.",
        "keyFact": "Perang Dunia II resmi berakhir pada tahun 1945 setelah Jepang menyerah tanpa syarat kepada Sekutu."
      },
      {
        "title": "Pelayaran Christopher Columbus",
        "prose": "Christopher Columbus adalah seorang penjelajah dan navigator asal Genoa, Italia, yang melakukan pelayaran legendaris melintasi Samudra Atlantik di bawah bendera Kerajaan Spanyol. Pada tahun 1492, dalam upayanya mencari rute perdagangan laut langsung menuju Asia (khususnya India), Columbus secara tidak sengaja berlabuh di Kepulauan Karibia. Peristiwa bersejarah ini menandai kontak awal antara peradaban Eropa dengan benua baru yang kemudian dikenal sebagai Benua Amerika. Pelayarannya membuka jalan bagi eksplorasi, kolonisasi, dan perdagangan transatlantik skala besar selama berabad-abad berikutnya.",
        "keyFact": "Christopher Columbus secara luas dikenal sebagai penjelajah Eropa pertama yang menemukan benua Amerika pada tahun 1492."
      },
      {
        "title": "Runtuhnya Absolutisme: Revolusi Perancis",
        "prose": "Revolusi Perancis yang meletus pada tahun 1789 merupakan pergolakan politik dan sosial paling berpengaruh dalam sejarah modern Eropa. Revolusi ini dipicu oleh krisis keuangan yang parah, ketimpangan sosial yang tajam antara kaum bangsawan dan rakyat jelata, serta ketidakpuasan mendalam terhadap kekuasaan absolut Raja Louis XVI. Penyerbuan Penjara Bastille pada 14 Juli 1789 menjadi simbol runtuhnya otoritas monarki absolut. Peristiwa besar ini mengubah struktur sosial dan politik Perancis secara radikal, menghapuskan feodalisme, memenggal monarki, dan memperkenalkan semboyan legendaris: Liberté, Égalité, Fraternité (Kebebasan, Keadilan, Persaudaraan).",
        "keyFact": "Revolusi Perancis dimulai pada tahun 1789 ditandai dengan penyerbuan Bastille dan runtuhnya monarki absolut."
      },
      {
        "title": "Bung Karno: Proklamator dan Pemimpin Bangsa",
        "prose": "Ir. Soekarno, atau yang akrab disapa Bung Karno, merupakan salah satu tokoh nasionalis paling terkemuka dalam sejarah perjuangan bangsa Indonesia. Lahir di Surabaya pada tahun 1901, beliau mendedikasikan seluruh hidupnya untuk memperjuangkan kemerdekaan dari penjajahan Belanda dan Jepang. Berkat retorikanya yang membakar semangat rakyat dan visi politiknya yang tajam, beliau bersama Drs. Mohammad Hatta memproklamasikan kemerdekaan Indonesia. Atas jasa-jasanya yang luar biasa, Bung Karno dipercaya sebagai Presiden pertama Republik Indonesia yang memimpin negara baru ini melewati masa-masa awal yang penuh gejolak.",
        "keyFact": "Ir. Soekarno adalah Presiden pertama Republik Indonesia dan dikenal luas sebagai Proklamator Kemerdekaan."
      },
      {
        "title": "Detik-Detik Proklamasi Kemerdekaan",
        "prose": "Kemerdekaan Indonesia diproklamasikan pada hari Jumat tanggal 17 Agustus 1945 (atau tanggal 17 Ramadan 1364 H menurut penanggalan Islam). Pembacaan teks proklamasi dilakukan oleh Ir. Soekarno didampingi Drs. Mohammad Hatta di kediaman Soekarno, Jalan Pegangsaan Timur No. 56, Jakarta Pusat. Peristiwa bersejarah ini terjadi di tengah kekosongan kekuasaan (vacuum of power) setelah Jepang menyerah kepada Sekutu akibat bom atom. Proklamasi ini menjadi tonggak berdirinya Negara Kesatuan Republik Indonesia (NKRI) yang bebas dari belenggu penjajahan asing.",
        "keyFact": "Indonesia merdeka secara resmi pada tanggal 17 Agustus 1945 ditandai dengan pembacaan teks Proklamasi oleh Bung Karno."
      },
      {
        "title": "Jasa Fatmawati dalam Bendera Pusaka",
        "prose": "Ibu Fatmawati, istri dari Presiden pertama Soekarno, memiliki peran historis yang sangat penting dalam momen proklamasi kemerdekaan Indonesia. Beliau adalah sosok yang menjahit Bendera Pusaka Merah Putih yang dikibarkan pertama kali pada upacara proklamasi tanggal 17 Agustus 1945. Menggunakan kain katun halus berwarna merah dan putih, Ibu Fatmawati menjahit bendera tersebut secara manual dengan tangan dalam kondisi fisik yang sedang hamil besar. Bendera hasil jahitan beliau kini dikenal sebagai Bendera Pusaka yang menjadi simbol persatuan dan kedaulatan bangsa.",
        "keyFact": "Ibu Fatmawati menjahit Bendera Merah Putih pertama (Bendera Pusaka) untuk dikibarkan pada upacara kemerdekaan Indonesia."
      },
      {
        "title": "Kutai Martapura: Awal Peradaban Aksara",
        "prose": "Kerajaan Kutai Martapura merupakan kerajaan bercorak Hindu tertua di Nusantara yang terletak di daerah Muara Kaman, tepi Sungai Mahakam, Kalimantan Timur. Diperkirakan berdiri sekitar abad ke-4 Masehi, keberadaan kerajaan ini dibuktikan dengan ditemukannya tujuh buah prasasti berbentuk tiang batu bernama Yupa. Yupa ditulis menggunakan aksara Pallawa dan bahasa Sanskerta, yang menggambarkan kedermawanan Raja Mulawarman, salah satu raja Kutai terbesar yang pernah menyedekahkan 20.000 ekor sapi kepada para pendeta kaum Brahmana.",
        "keyFact": "Kerajaan Kutai di Kalimantan Timur diakui oleh para sejarawan sebagai kerajaan Hindu tertua di Indonesia."
      },
      {
        "title": "Borobudur: Mahakarya Dinasti Syailendra",
        "prose": "Candi Borobudur adalah candi Buddha terbesar di dunia yang dibangun pada masa pemerintahan Dinasti Syailendra sekitar abad ke-8 dan ke-9 Masehi. Mahakarya arsitektur kuno ini terletak di wilayah Kabupaten Magelang, Provinsi Jawa Tengah. Borobudur dirancang menyerupai stupa raksasa dan mandala suci, dihiasi dengan 2.672 panel relief naratif yang indah serta 504 patung Buddha. Penemuan kembali Borobudur dari timbunan abu vulkanik dan hutan belantara pada awal abad ke-19 memicu upaya restorasi besar-besaran untuk melestarikan situs warisan dunia UNESCO ini.",
        "keyFact": "Candi Borobudur, monumen Buddha terbesar di dunia, terletak di Provinsi Jawa Tengah."
      },
      {
        "title": "Kekaisaran Romawi dan Augustus Caesar",
        "prose": "Augustus, yang awalnya bernama Octavianus, merupakan pendiri sekaligus kaisar pertama dari Kekaisaran Romawi yang memimpin dari tahun 27 SM hingga kematiannya pada tahun 14 M. Sebagai putra angkat sekaligus ahli waris Julius Caesar, Octavianus berhasil memenangkan perang saudara Romawi pasca-pembunuhan Julius. Setelah mengalahkan kekuatan Marcus Antonius dan Cleopatra, ia menghapuskan Republik Romawi yang sedang sekarat dan mendirikan sistem monarki otokratis yang stabil. Pemerintahannya menandai dimulainya era Pax Romana (Kedamaian Romawi), sebuah periode keemasan tanpa konflik besar internal selama lebih dari dua abad.",
        "keyFact": "Kaisar pertama Kekaisaran Romawi adalah Augustus (Octavianus), yang memulai era Pax Romana."
      },
      {
        "title": "James Watt dan Revolusi Industri",
        "prose": "James Watt adalah seorang penemu, insinyur mesin, dan instrumen asal Skotlandia yang karyanya sangat memicu lahirnya Revolusi Industri di Eropa. Pada akhir abad ke-18, Watt berhasil memodifikasi dan mematenkan desain mesin uap Newcomen yang sudah ada sebelumnya, dengan menambahkan kondensor terpisah. Inovasi cemerlang ini melipatgandakan efisiensi bahan bakar dan daya mesin uap secara drastis, sehingga mesin uap dapat digunakan secara luas untuk menggerakkan pabrik-pabrik tekstil, tambang, kapal laut, hingga lokomotif kereta api di seluruh dunia.",
        "keyFact": "James Watt merupakan tokoh legendaris yang memodifikasi mesin uap menjadi jauh lebih efisien, memicu lahirnya Revolusi Industri."
      }
    ]
  };

  // Custom detailed materials for Teknologi Level 1
  final Map<int, List<Map<String, String>>> _teknologiMaterials = {
    1: [
      {
        "title": "Komunikasi Elektronik: Protokol SMTP",
        "prose": "Surat elektronik atau email telah menjadi sarana komunikasi digital yang sangat krusial. Agar email dapat dikirim dari satu server ke server lainnya di internet, sistem komputer menggunakan protokol standar. Protokol utama yang bertugas khusus untuk mengirimkan email adalah SMTP (Simple Mail Transfer Protocol). SMTP bekerja di latar belakang untuk memastikan pesan Anda terkirim dengan aman ke kotak surat penerima.",
        "keyFact": "SMTP (Simple Mail Transfer Protocol) adalah protokol standar internet untuk transmisi dan pengiriman surat elektronik (email)."
      },
      {
        "title": "Keamanan Siber: Protokol HTTPS",
        "prose": "Di era modern, keamanan data saat berselancar di web adalah prioritas utama. Ketika Anda mengakses situs web perbankan atau berbelanja online, data sensitif Anda harus dilindungi dari peretas. Untuk itulah digunakan HTTPS (Hypertext Transfer Protocol Secure). Protokol ini mengenkripsi seluruh komunikasi antara browser Anda dan server web, menjadikannya jauh lebih aman dibandingkan HTTP biasa.",
        "keyFact": "HTTPS merupakan versi aman dari HTTP yang menggunakan enkripsi SSL/TLS untuk melindungi komunikasi data di internet."
      },
      {
        "title": "Pengenalan SQL dan Basis Data",
        "prose": "Hampir setiap aplikasi modern menyimpan datanya dalam sebuah basis data (database). Untuk berinteraksi, mengambil, atau memanipulasi data tersebut, para programmer menggunakan bahasa khusus yang disebut SQL (Structured Query Language). SQL dirancang untuk mengelola data dalam sistem manajemen basis data relasional, menjadikannya salah satu keahlian teknologi paling populer di dunia kerja.",
        "keyFact": "SQL adalah singkatan dari Structured Query Language, bahasa standar yang digunakan untuk mengelola basis data relasional."
      },
      {
        "title": "Guido van Rossum dan Kelahiran Python",
        "prose": "Python adalah salah satu bahasa pemrograman paling populer di dunia karena sintaksisnya yang bersih dan mudah dibaca. Bahasa ini diciptakan oleh seorang programmer berkebangsaan Belanda bernama Guido van Rossum pada akhir tahun 1980-an dan resmi dirilis pada tahun 1991. Van Rossum menamai bahasa ini terinspirasi dari acara komedi BBC favoritnya, Monty Python's Flying Circus.",
        "keyFact": "Bahasa pemrograman Python dirancang dan pertama kali dikembangkan oleh Guido van Rossum."
      },
      {
        "title": "WorldWideWeb: Penjelajah Web Pertama",
        "prose": "Ketika Sir Tim Berners-Lee menemukan web pada tahun 1989-1990, beliau juga menciptakan cara bagi orang-orang untuk melihat halaman web tersebut. Beliau menulis program penjelajah web pertama di dunia dan menamainya WorldWideWeb (kemudian diubah menjadi Nexus agar tidak membingungkan dengan jaringan web itu sendiri). Ini adalah awal mula dari browser modern seperti Chrome atau Firefox yang kita gunakan saat ini.",
        "keyFact": "Browser web pertama di dunia diciptakan oleh Tim Berners-Lee dan diberi nama WorldWideWeb."
      },
      {
        "title": "Dasar Web: Mengenal HTTP",
        "prose": "Setiap kali Anda memasukkan alamat website di browser, Anda akan melihat teks 'http' atau 'https' di bagian awal alamat. Istilah HTTP merupakan singkatan dari HyperText Transfer Protocol. Protokol ini adalah dasar dari pertukaran data pada World Wide Web, yang mendefinisikan bagaimana pesan diformat dan ditransmisikan antara server web dan browser.",
        "keyFact": "HTTP adalah singkatan dari HyperText Transfer Protocol, protokol utama pengiriman dokumen web."
      },
      {
        "title": "Pemrosesan Visual: Mengenal GPU",
        "prose": "Bagi para gamer, desainer grafis, dan peneliti kecerdasan buatan, komponen ini sangatlah penting. GPU (Graphics Processing Unit) adalah sirkuit elektronik khusus yang dirancang untuk mempercepat pembuatan gambar dan rendering visual. Berbeda dengan CPU yang menangani tugas komputasi umum, GPU memiliki ribuan inti kecil yang bekerja paralel untuk memproses data grafis secara instan.",
        "keyFact": "GPU singkatan dari Graphics Processing Unit, komponen yang bertugas memproses rendering grafis dan visual komputer."
      },
      {
        "title": "Otak dari Komputer: CPU",
        "prose": "Komputer terdiri dari berbagai komponen rumit, namun semuanya diatur oleh satu pusat pengendali utama. Komponen ini sering disebut sebagai 'otak' komputer, yaitu CPU (Central Processing Unit). CPU bertugas mengeksekusi instruksi program komputer dengan melakukan operasi aritmatika, logika, pengendalian, dan masukan/keluaran dasar yang ditentukan oleh sistem.",
        "keyFact": "CPU singkatan dari Central Processing Unit, berfungsi sebagai otak utama pengendali sistem komputer."
      },
      {
        "title": "Sejarah Singkat Sistem Operasi Android",
        "prose": "Android saat ini merupakan sistem operasi perangkat seluler paling dominan di dunia. Awalnya, Android didirikan oleh Andy Rubin dan rekan-rekannya pada tahun 2003. Namun, pada tahun 2005, perusahaan raksasa mesin pencari Google mengakuisisi Android Inc. Google kemudian mengembangkan, memoles, dan merilisnya secara gratis sebagai proyek sumber terbuka (open source), melambungkan popularitasnya secara global.",
        "keyFact": "Sistem operasi Android diakuisisi dan dikembangkan secara besar-besaran oleh Google hingga menjadi penguasa pasar smartphone."
      },
      {
        "title": "Bill Gates dan Revolusi PC Microsoft",
        "prose": "Microsoft didirikan pada tahun 1975 oleh Bill Gates bersama sahabat masa kecilnya, Paul Allen. Visi Gates yang ambisius adalah menempatkan 'sebuah komputer di setiap meja dan di setiap rumah.' Sistem operasi MS-DOS dan kemudian Windows buatan mereka berhasil merevolusi dunia teknologi informasi selamanya.",
        "keyFact": "Microsoft didirikan oleh Bill Gates dan Paul Allen pada tahun 1975, memicu revolusi penggunaan komputer pribadi."
      }
    ]
  };

  // Helper helper to generate readable prose for fallback content
  String _generateTitle(Question question) {
    String txt = question.text.replaceAll('?', '').trim();
    if (txt.startsWith('Siapa ')) txt = txt.substring(6);
    if (txt.startsWith('Apa ')) txt = txt.substring(4);
    if (txt.startsWith('Kapan ')) txt = txt.substring(6);
    if (txt.startsWith('Di mana ')) txt = txt.substring(8);
    if (txt.startsWith('Mengapa ')) txt = txt.substring(8);
    if (txt.startsWith('Bagaimana ')) txt = txt.substring(10);
    
    if (txt.length > 25) {
      return txt.substring(0, 22) + "...";
    }
    return txt.isNotEmpty ? txt[0].toUpperCase() + txt.substring(1) : "Pembelajaran Mandiri";
  }

  String _generateProse(Question question) {
    final correctOption = question.options[question.correctAnswerIndex];
    final cleanQ = question.text.replaceAll('?', '').trim();
    
    switch (question.category) {
      case 'Teknologi':
        return "Dalam dunia Teknologi modern, perkembangan inovasi sangat bergantung pada fondasi sistem yang solid. Terkait hal mengenai **$cleanQ**, pengetahuan dasar mencatat bahwa jawabannya adalah **$correctOption**.\n\nMemahami aspek ini memberikan wawasan tentang bagaimana teknologi bekerja di balik layar, mempermudah adaptasi kita terhadap infrastruktur perangkat lunak maupun keras di masa depan.";
      case 'Sains':
        return "Sains mengajarkan kita metode eksplorasi alam yang didasarkan pada logika dan pembuktian empiris. Untuk pertanyaan seputar **$cleanQ**, hasil penelitian ilmiah menyimpulkan jawaban yang benar adalah **$correctOption**.\n\nHal ini merupakan bukti keajaiban alam dan keteraturan sistem kehidupan, fisika, kimia, atau astronomi yang membentuk realitas kehidupan sehari-hari.";
      case 'Film':
        return "Dunia perfilman dan seni visual merefleksikan nilai budaya, kreativitas, dan emosi manusia. Berdasarkan fakta sinematik seputar **$cleanQ**, data industri mencatat bahwa hal yang benar adalah **$correctOption**.\n\nKarya-karya seni audio-visual ini tidak hanya menghibur, tetapi juga memicu dialog sosial dan mengabadikan peristiwa bersejarah dalam memori kolektif penonton.";
      case 'Sejarah':
        return "Sejarah adalah cermin masa lalu yang menerangi jalan bagi peradaban masa kini dan masa depan. Mengenai peristiwa atau fakta **$cleanQ**, catatan dokumen sejarah yang sah menyatakan bahwa kebenarannya adalah **$correctOption**.\n\nMelalui rekam jejak perjuangan, tokoh penting, dan peristiwa ini, kita dapat memetik hikmah berharga dan memahami asal-usul tatanan dunia saat ini.";
      default:
        return "Materi pembelajaran mandiri kali ini mengajak kita mengeksplorasi topik penting mengenai **$cleanQ**. Berdasarkan referensi tepercaya yang dihimpun, informasi akurat mengenai hal ini mengarah pada **$correctOption**.\n\nPengetahuan umum seperti ini sangat berguna dalam melatih ketajaman nalar, memperkaya wawasan intelektual, serta mempersiapkan diri untuk tantangan berikutnya.";
    }
  }

  List<BookPage> getBookPages(String category, int level, List<Question> questions) {
    List<BookPage> pages = [];
    
    // Check if we have pre-defined materials
    List<Map<String, String>>? sourceList;
    if (category == 'Sejarah') {
      sourceList = _sejarahMaterials[level];
    } else if (category == 'Teknologi') {
      sourceList = _teknologiMaterials[level];
    }

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      
      if (sourceList != null && i < sourceList.length) {
        final data = sourceList[i];
        pages.add(
          BookPage(
            title: data["title"] ?? _generateTitle(question),
            prose: data["prose"] ?? _generateProse(question),
            keyFact: data["keyFact"] ?? "Fakta Kunci: Jawaban yang benar adalah ${question.options[question.correctAnswerIndex]}.",
            question: question,
          ),
        );
      } else {
        // Fallback dynamic generation
        pages.add(
          BookPage(
            title: _generateTitle(question),
            prose: _generateProse(question),
            keyFact: "Fakta Utama: Jawaban yang tepat untuk '${question.text}' adalah ${question.options[question.correctAnswerIndex]}.",
            question: question,
          ),
        );
      }
    }
    
    return pages;
  }
}
