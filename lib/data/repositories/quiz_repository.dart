import '../models/question_model.dart';

class QuizRepository {
  List<Question> getQuestionsByCategory(String category) {
    return _allQuestions.where((q) => q.category == category).toList();
  }

  List<String> getCategories() {
    return ['Teknologi', 'Sejarah', 'Film', 'Sains', 'Tebak Gambar'];
  }

  final List<Question> _allQuestions = [
    // Teknologi
    Question(
      id: 't1',
      text: 'Apa kepanjangan dari CPU?',
      options: ['Central Processing Unit', 'Computer Personal Unit', 'Central Power Unit', 'Core Processing Unit'],
      correctAnswerIndex: 0,
      category: 'Teknologi',
      explanation: 'CPU adalah otak dari komputer yang menangani semua instruksi.',
    ),
    Question(
      id: 't2',
      text: 'Siapa pendiri Microsoft?',
      options: ['Steve Jobs', 'Bill Gates', 'Mark Zuckerberg', 'Elon Musk'],
      correctAnswerIndex: 1,
      category: 'Teknologi',
      explanation: 'Bill Gates mendirikan Microsoft bersama Paul Allen.',
    ),
    Question(
      id: 't3',
      text: 'Bahasa pemrograman apa yang digunakan untuk membuat Flutter?',
      options: ['Java', 'Swift', 'Dart', 'Kotlin'],
      correctAnswerIndex: 2,
      category: 'Teknologi',
      explanation: 'Dart adalah bahasa yang dikembangkan oleh Google untuk Flutter.',
    ),

    // Sejarah
    Question(
      id: 's1',
      text: 'Tahun berapa Indonesia merdeka?',
      options: ['1944', '1945', '1946', '1947'],
      correctAnswerIndex: 1,
      category: 'Sejarah',
      explanation: 'Indonesia memproklamasikan kemerdekaan pada 17 Agustus 1945.',
    ),
    Question(
      id: 's2',
      text: 'Siapa presiden pertama Indonesia?',
      options: ['Moh. Hatta', 'Soeharto', 'Soekarno', 'B.J. Habibie'],
      correctAnswerIndex: 2,
      category: 'Sejarah',
      explanation: 'Ir. Soekarno adalah presiden pertama Republik Indonesia.',
    ),

    // Film
    Question(
      id: 'f1',
      text: 'Film apa yang memenangkan Oscar Best Picture tahun 2020?',
      options: ['1917', 'Joker', 'Parasite', 'Once Upon a Time in Hollywood'],
      correctAnswerIndex: 2,
      category: 'Film',
      explanation: 'Parasite adalah film non-bahasa Inggris pertama yang memenangkan Best Picture.',
    ),

    // Tebak Gambar
    Question(
      id: 'ig1',
      text: 'Benda apa yang ada di gambar ini?',
      options: ['Laptop', 'Televisi', 'Radio', 'Kamera'],
      correctAnswerIndex: 0,
      category: 'Tebak Gambar',
      explanation: 'Ini adalah gambar sebuah laptop, perangkat komputer portabel.',
      imageUrl: 'assets/images/laptop.png',
    ),
    Question(
      id: 'ig2',
      text: 'Menara terkenal ini berada di kota mana?',
      options: ['London', 'Paris', 'Roma', 'Berlin'],
      correctAnswerIndex: 1,
      category: 'Tebak Gambar',
      explanation: 'Menara Eiffel terletak di Paris, Prancis.',
      imageUrl: 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?q=80&w=1000&auto=format&fit=crop',
    ),
    Question(
      id: 'ig3',
      text: 'Apa nama hewan yang ada di gambar ini?',
      options: ['Harimau', 'Singa', 'Macan Tutul', 'Cheetah'],
      correctAnswerIndex: 1,
      category: 'Tebak Gambar',
      explanation: 'Singa sering dijuluki sebagai raja hutan.',
      imageUrl: 'https://images.unsplash.com/photo-1546182990-dffeafbe841d?q=80&w=1000&auto=format&fit=crop',
    ),
  ];
}
