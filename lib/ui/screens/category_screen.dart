import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../data/repositories/quiz_repository.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = QuizRepository().getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kategori'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _CategoryCard(category: categories[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<QuizProvider>().startQuiz(category);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIcon(category), size: 50, color: Colors.purpleAccent),
              const SizedBox(height: 10),
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'Teknologi': return Icons.computer_rounded;
      case 'Sejarah': return Icons.history_edu_rounded;
      case 'Film': return Icons.movie_rounded;
      case 'Sains': return Icons.science_rounded;
      default: return Icons.category_rounded;
    }
  }
}
