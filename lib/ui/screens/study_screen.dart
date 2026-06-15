import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/quiz_provider.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/repositories/book_material_repository.dart';
import '../../data/services/audio_service.dart';
import '../../data/models/question_model.dart';
import 'quiz_screen.dart';

enum BookTheme { cream, sepia, dark }

enum BookFont { lora, merriweather, playfair, sans }

class StudyScreen extends StatefulWidget {
  final String category;
  final int level;
  final Color categoryColor;

  const StudyScreen({
    super.key,
    required this.category,
    required this.level,
    required this.categoryColor,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late final PageController _pageController;
  late final List<Question> _questions;
  late final List<BookPage> _bookPages;

  int _currentPage = 0;
  BookTheme _selectedTheme = BookTheme.cream;
  BookFont _selectedFont = BookFont.lora;
  double _fontSizeMultiplier = 1.0;

  // Track inline answers selected by the user for self-quizzing
  final Map<int, int> _inlineSelectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questions = QuizRepository().getQuestionsByCategoryAndLevelForStudy(
      widget.category,
      widget.level,
    );
    _bookPages = BookMaterialRepository().getBookPages(
      widget.category,
      widget.level,
      _questions,
    );
    _loadSettings();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        final themeIndex = prefs.getInt('book_reader_theme') ?? 0;
        _selectedTheme = BookTheme.values[themeIndex];

        final fontIndex = prefs.getInt('book_reader_font') ?? 0;
        _selectedFont = BookFont.values[fontIndex];

        _fontSizeMultiplier = prefs.getDouble('book_reader_font_size') ?? 1.0;
      });
    } catch (e) {
      print('Error loading book reader settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('book_reader_theme', _selectedTheme.index);
      await prefs.setInt('book_reader_font', _selectedFont.index);
      await prefs.setDouble('book_reader_font_size', _fontSizeMultiplier);
    } catch (e) {
      print('Error saving book reader settings: $e');
    }
  }

  void _startQuiz() {
    context.read<QuizProvider>().startQuiz(widget.category, widget.level);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  Color _getCoverColor(String category) {
    switch (category) {
      case 'Teknologi':
        return const Color(0xFF1B4965);
      case 'Sejarah':
        return const Color(0xFF5E0B15);
      case 'Film':
        return const Color(0xFF2B2D42);
      case 'Sains':
        return const Color(0xFF134611);
      case 'Tebak Gambar':
        return const Color(0xFF3D348B);
      default:
        return const Color(0xFF4A3728);
    }
  }

  Color _getPaperColor(BookTheme theme) {
    switch (theme) {
      case BookTheme.cream:
        return const Color(0xFFFCF8F2);
      case BookTheme.sepia:
        return const Color(0xFFF4ECD8);
      case BookTheme.dark:
        return const Color(0xFF1A1917);
    }
  }

  Color _getTextColor(BookTheme theme) {
    switch (theme) {
      case BookTheme.cream:
        return const Color(0xFF2B2521);
      case BookTheme.sepia:
        return const Color(0xFF3F3025);
      case BookTheme.dark:
        return const Color(0xFFE5DEC9);
    }
  }

  Color _getSecondaryTextColor(BookTheme theme) {
    switch (theme) {
      case BookTheme.cream:
        return const Color(0xFF6E6258);
      case BookTheme.sepia:
        return const Color(0xFF7A685D);
      case BookTheme.dark:
        return const Color(0xFF9E988D);
    }
  }

  Color _getBorderColor(BookTheme theme) {
    switch (theme) {
      case BookTheme.cream:
        return const Color(0xFFE5DEC9);
      case BookTheme.sepia:
        return const Color(0xFFDFCFAF);
      case BookTheme.dark:
        return const Color(0xFF2D2D2D);
    }
  }

  TextStyle _getBookTextStyle(
    BookFont font,
    BookTheme theme,
    double sizeMultiplier,
  ) {
    Color color = _getTextColor(theme);
    double baseSize = 16.0 * sizeMultiplier;

    switch (font) {
      case BookFont.lora:
        return GoogleFonts.lora(fontSize: baseSize, color: color, height: 1.6);
      case BookFont.merriweather:
        return GoogleFonts.merriweather(
          fontSize: baseSize,
          color: color,
          height: 1.6,
        );
      case BookFont.playfair:
        return GoogleFonts.playfairDisplay(
          fontSize: baseSize,
          color: color,
          height: 1.6,
        );
      case BookFont.sans:
        return GoogleFonts.outfit(
          fontSize: baseSize,
          color: color,
          height: 1.5,
        );
    }
  }

  String _getChapterName(String category, int level) {
    if (category == 'Sejarah') {
      switch (level) {
        case 1:
          return 'Sejarah Dunia & Indonesia';
        case 2:
          return 'Peradaban Kuno';
        default:
          return 'Peristiwa Penting Dunia';
      }
    } else if (category == 'Teknologi') {
      switch (level) {
        case 1:
          return 'Dasar Komputasi & Internet';
        case 2:
          return 'Sistem Operasi & Kode';
        default:
          return 'Teknologi Modern';
      }
    }
    return 'Materi Pokok';
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'Tidak ada materi belajar untuk level ini.',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final totalPages =
        _bookPages.length +
        3; // Cover (0), TOC (1), Pages (2..N+1), Back Cover (N+2)

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Kitab Belajar: ${widget.category}',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_currentPage > 0)
            IconButton(
              icon: const Icon(Icons.tune_rounded, color: Colors.white),
              onPressed: _showSettingsBottomSheet,
              tooltip: 'Pengaturan Pembaca',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF070A15), Color(0xFF15192E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Book container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: totalPages,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildBookCover();
                          } else if (index == 1) {
                            return _buildTableOfContents();
                          } else if (index == totalPages - 1) {
                            return _buildBackCover();
                          } else {
                            return _buildContentPage(
                              _bookPages[index - 2],
                              index,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Page navigator bar
              _buildPageNavigatorBar(totalPages),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover() {
    final Color coverColor = _getCoverColor(widget.category);
    return Container(
      decoration: BoxDecoration(
        color: coverColor,
        border: Border.all(
          color: const Color(0xFFD4AF37), // Gold border
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Embossed lines / Leather pattern overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Spine shadow
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 20,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // Gold corners
          Positioned(
            top: 12,
            right: 12,
            child: Icon(
              Icons.star_rounded,
              color: const Color(0xFFD4AF37).withOpacity(0.6),
              size: 24,
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Icon(
              Icons.star_rounded,
              color: const Color(0xFFD4AF37).withOpacity(0.6),
              size: 24,
            ),
          ),

          // Cover contents
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Gold foil circle with category icon
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.25),
                    border: Border.all(
                      color: const Color(0xFFD4AF37), // Gold
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIcon(widget.category),
                    size: 64,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'KITAB MATERI PINTAR',
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD4AF37),
                    letterSpacing: 3.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.category.toUpperCase(),
                  style: GoogleFonts.cinzel(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    shadows: [
                      const Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(width: 70, height: 2, color: const Color(0xFFD4AF37)),
                const SizedBox(height: 16),
                Text(
                  'LEVEL ${widget.level} • BUKU SEJARAH LENGKAP',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // Open Book Button
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BUKA BUKU',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chrome_reader_mode_rounded, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableOfContents() {
    final paperColor = _getPaperColor(_selectedTheme);
    final textColor = _getTextColor(_selectedTheme);
    final secColor = _getSecondaryTextColor(_selectedTheme);
    final borderColor = _getBorderColor(_selectedTheme);

    return Container(
      color: paperColor,
      child: Stack(
        children: [
          // Spine shadow
          _buildSpineShadowOverlay(),

          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'DAFTAR ISI',
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 80,
                    height: 2,
                    color: widget.categoryColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _bookPages.length,
                    itemBuilder: (context, idx) {
                      final page = _bookPages[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: borderColor.withOpacity(0.3),
                              width: 0.8,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _pageController.animateToPage(
                              idx + 2,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 4.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${idx + 1}.',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: widget.categoryColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    page.title,
                                    style: GoogleFonts.lora(
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Hal ${idx + 2}',
                                  style: GoogleFonts.outfit(
                                    color: secColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 10,
                                  color: secColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage(BookPage page, int pageIdx) {
    final paperColor = _getPaperColor(_selectedTheme);
    final brandColor = widget.categoryColor;

    final textStyle = _getBookTextStyle(
      _selectedFont,
      _selectedTheme,
      _fontSizeMultiplier,
    );
    final titleStyle = _getBookTextStyle(
      BookFont.lora,
      _selectedTheme,
      1.25 * _fontSizeMultiplier,
    ).copyWith(fontWeight: FontWeight.bold);

    return Container(
      color: paperColor,
      child: Stack(
        children: [
          // Spine shadow
          _buildSpineShadowOverlay(),

          // Page Ribbon design
          Positioned(
            top: 0,
            right: 28,
            child: Container(
              width: 14,
              height: 40,
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 3,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Page Content
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Chapter Metadata Header
                  Row(
                    children: [
                      Icon(
                        _getIcon(widget.category),
                        size: 13,
                        color: brandColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'BAB ${widget.level}: ${_getChapterName(widget.category, widget.level)}'
                            .toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: brandColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Chapter/Topic Title
                  Text(page.title, style: titleStyle),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 2.5,
                    color: brandColor.withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),

                  // Question Image (if any)
                  if (page.question.imageUrl != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: page.question.imageUrl!.startsWith('http')
                            ? Image.network(
                                page.question.imageUrl!,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImageError(),
                              )
                            : Image.asset(
                                page.question.imageUrl!,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImageError(),
                              ),
                      ),
                    ),
                  ],

                  // Beautiful book prose with Drop Cap
                  _buildProseWithDropCap(page.prose, textStyle, brandColor),

                  const SizedBox(height: 28),

                  // Key Fact Highlight Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: brandColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.bookmark_added_rounded,
                          color: brandColor,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            page.keyFact,
                            style: textStyle.copyWith(
                              fontStyle: FontStyle.italic,
                              fontSize: (textStyle.fontSize ?? 16) * 0.92,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Inline Interactive Quiz
                  _buildInlineQuiz(page, pageIdx),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCover() {
    final paperColor = _getPaperColor(_selectedTheme);
    final textColor = _getTextColor(_selectedTheme);
    final secColor = _getSecondaryTextColor(_selectedTheme);

    return Container(
      color: paperColor,
      child: Stack(
        children: [
          // Spine shadow
          _buildSpineShadowOverlay(),

          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.auto_stories_rounded,
                  size: 76,
                  color: widget.categoryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Buku Selesai Dibaca!',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  'Luar biasa! Anda telah menyelesaikan seluruh bab pembelajaran untuk kategori ${widget.category} Level ${widget.level}. Saatnya menguji pemahaman Anda di kuis nyata!',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: secColor,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Statistics Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.categoryColor.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${_bookPages.length}',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Topik Dibaca',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: secColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1.5,
                        height: 40,
                        color: secColor.withOpacity(0.2),
                      ),
                      Column(
                        children: [
                          Text(
                            '${_inlineSelectedAnswers.length}',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Uji Pemahaman',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: secColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700), // Golden yellow
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MULAI KUIS SEKARANG',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.sports_esports_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Text(
                    'Baca Ulang Buku',
                    style: GoogleFonts.outfit(
                      color: widget.categoryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProseWithDropCap(
    String prose,
    TextStyle textStyle,
    Color brandColor,
  ) {
    if (prose.isEmpty) return const SizedBox();
    final firstChar = prose[0];
    final rest = prose.substring(1);

    return Text.rich(
      TextSpan(
        style: textStyle.copyWith(height: 1.6),
        children: [
          TextSpan(
            text: firstChar,
            style: textStyle.copyWith(
              fontSize: (textStyle.fontSize ?? 16) * 2.8,
              fontWeight: FontWeight.bold,
              color: brandColor,
              height: 0.8,
              fontFamily: textStyle.fontFamily,
            ),
          ),
          TextSpan(text: rest),
        ],
      ),
    );
  }

  Widget _buildInlineQuiz(BookPage page, int pageIdx) {
    final question = page.question;
    final selectedIdx = _inlineSelectedAnswers[pageIdx];
    final hasAnswered = selectedIdx != null;
    final brandColor = widget.categoryColor;

    final textColor = _getTextColor(_selectedTheme);
    final secColor = _getSecondaryTextColor(_selectedTheme);
    final borderColor = _getBorderColor(_selectedTheme);

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _selectedTheme == BookTheme.dark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline_rounded, color: brandColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Uji Pemahaman Cepat',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(question.options.length, (optIdx) {
            final isSelected = selectedIdx == optIdx;
            final isCorrect = optIdx == question.correctAnswerIndex;

            Color buttonBgColor = Colors.transparent;
            Color buttonBorderColor = borderColor;
            Color optionTextColor = textColor;
            Widget? suffixIcon;

            if (hasAnswered) {
              if (isCorrect) {
                buttonBgColor = const Color(0xFF00FF87).withOpacity(0.12);
                buttonBorderColor = const Color(0xFF00FF87);
                optionTextColor = _selectedTheme == BookTheme.dark
                    ? Colors.white
                    : const Color(0xFF006636);
                suffixIcon = const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF00FF87),
                  size: 16,
                );
              } else if (isSelected) {
                buttonBgColor = const Color(0xFFFF4B2B).withOpacity(0.12);
                buttonBorderColor = const Color(0xFFFF4B2B);
                optionTextColor = _selectedTheme == BookTheme.dark
                    ? Colors.white
                    : const Color(0xFF991A00);
                suffixIcon = const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFFFF4B2B),
                  size: 16,
                );
              } else {
                optionTextColor = secColor.withOpacity(0.5);
              }
            } else {
              if (isSelected) {
                buttonBgColor = brandColor.withOpacity(0.1);
                buttonBorderColor = brandColor;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: hasAnswered
                    ? null
                    : () async {
                        setState(() {
                          _inlineSelectedAnswers[pageIdx] = optIdx;
                        });
                        if (isCorrect) {
                          await AudioService().playCorrectSound();
                        } else {
                          await AudioService().playWrongSound();
                          await AudioService().vibrate();
                        }
                      },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: buttonBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: buttonBorderColor, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: hasAnswered && isCorrect
                            ? const Color(0xFF00FF87)
                            : hasAnswered && isSelected
                            ? const Color(0xFFFF4B2B)
                            : isSelected
                            ? brandColor
                            : secColor.withOpacity(0.3),
                        child: Text(
                          String.fromCharCode(65 + optIdx),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.options[optIdx],
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: isSelected || (hasAnswered && isCorrect)
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: optionTextColor,
                          ),
                        ),
                      ),
                      if (suffixIcon != null) suffixIcon,
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSpineShadowOverlay() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: 18,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(
                _selectedTheme == BookTheme.dark ? 0.35 : 0.12,
              ),
              Colors.black.withOpacity(0.0),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  Widget _buildPageNavigatorBar(int totalPages) {
    final bool isFirstPage = _currentPage == 0;
    final bool isLastPage = _currentPage == totalPages - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          IconButton(
            onPressed: isFirstPage
                ? null
                : () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            disabledColor: Colors.white24,
          ),

          // Central progress indicator or label
          Expanded(
            child: Center(
              child: Text(
                _currentPage == 0
                    ? 'SAMPUL DEPAN'
                    : _currentPage == 1
                    ? 'DAFTAR ISI'
                    : _currentPage == totalPages - 1
                    ? 'SAMPUL BELAKANG'
                    : 'HALAMAN ${_currentPage - 1} DARI ${_bookPages.length}',
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          // Next button
          IconButton(
            onPressed: isLastPage
                ? null
                : () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
            disabledColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 170,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.white54,
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'Teknologi':
        return Icons.settings_input_component_rounded;
      case 'Sejarah':
        return Icons.account_balance_rounded;
      case 'Film':
        return Icons.theaters_rounded;
      case 'Sains':
        return Icons.biotech_rounded;
      case 'Tebak Gambar':
        return Icons.auto_fix_high_rounded;
      default:
        return Icons.auto_awesome_mosaic_rounded;
    }
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final textColor = _getTextColor(_selectedTheme);
            final secColor = _getSecondaryTextColor(_selectedTheme);
            final currentBg = _selectedTheme == BookTheme.dark
                ? const Color(0xFF222222)
                : Colors.white;

            return Container(
              decoration: BoxDecoration(
                color: currentBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: secColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'PENGATURAN KITAB',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Warna Kertas',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildThemeOption(
                        title: 'Klasik',
                        theme: BookTheme.cream,
                        bgColor: const Color(0xFFFCF8F2),
                        textColor: const Color(0xFF2B2521),
                        borderColor: const Color(0xFFE5DEC9),
                        setModalState: setModalState,
                      ),
                      const SizedBox(width: 12),
                      _buildThemeOption(
                        title: 'Kuno',
                        theme: BookTheme.sepia,
                        bgColor: const Color(0xFFF4ECD8),
                        textColor: const Color(0xFF3F3025),
                        borderColor: const Color(0xFFDFCFAF),
                        setModalState: setModalState,
                      ),
                      const SizedBox(width: 12),
                      _buildThemeOption(
                        title: 'Malam',
                        theme: BookTheme.dark,
                        bgColor: const Color(0xFF1E1E1E),
                        textColor: const Color(0xFFE5DEC9),
                        borderColor: const Color(0xFF2D2D2D),
                        setModalState: setModalState,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ukuran Huruf',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: secColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _fontSizeMultiplier <= 0.8
                                ? null
                                : () {
                                    setModalState(() {
                                      _fontSizeMultiplier -= 0.1;
                                    });
                                    setState(() {});
                                    _saveSettings();
                                  },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: textColor,
                            ),
                          ),
                          Text(
                            '${(_fontSizeMultiplier * 100).toInt()}%',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          IconButton(
                            onPressed: _fontSizeMultiplier >= 1.5
                                ? null
                                : () {
                                    setModalState(() {
                                      _fontSizeMultiplier += 0.1;
                                    });
                                    setState(() {});
                                    _saveSettings();
                                  },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Jenis Huruf',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFontOption(
                        'Lora (Serif)',
                        BookFont.lora,
                        setModalState,
                      ),
                      _buildFontOption(
                        'Merriweather',
                        BookFont.merriweather,
                        setModalState,
                      ),
                      _buildFontOption(
                        'Playfair',
                        BookFont.playfair,
                        setModalState,
                      ),
                      _buildFontOption(
                        'Outfit (Sans)',
                        BookFont.sans,
                        setModalState,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption({
    required String title,
    required BookTheme theme,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    required StateSetter setModalState,
  }) {
    final isSelected = _selectedTheme == theme;
    return Expanded(
      child: InkWell(
        onTap: () {
          setModalState(() {
            _selectedTheme = theme;
          });
          setState(() {
            _selectedTheme = theme;
          });
          _saveSettings();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? widget.categoryColor : borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.outfit(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontOption(
    String name,
    BookFont font,
    StateSetter setModalState,
  ) {
    final isSelected = _selectedFont == font;
    final textColor = _getTextColor(_selectedTheme);
    final borderColor = _getBorderColor(_selectedTheme);

    return ChoiceChip(
      label: Text(name),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setModalState(() {
            _selectedFont = font;
          });
          setState(() {
            _selectedFont = font;
          });
          _saveSettings();
        }
      },
      selectedColor: widget.categoryColor.withOpacity(0.2),
      backgroundColor: Colors.transparent,
      labelStyle: GoogleFonts.outfit(
        color: isSelected ? widget.categoryColor : textColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(
        color: isSelected ? widget.categoryColor : borderColor,
        width: isSelected ? 1.5 : 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
