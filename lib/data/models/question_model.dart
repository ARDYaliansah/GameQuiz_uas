class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;
  final String explanation;
  final String? imageUrl;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    this.explanation = '',
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'category': category,
      'explanation': explanation,
      'imageUrl': imageUrl,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      category: map['category'] ?? '',
      explanation: map['explanation'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }
}
