import 'package:flutter/material.dart';

class AboutTeacherScreen extends StatelessWidget {
  const AboutTeacherScreen({Key? key}) : super(key: key);

  /// Convenience helper to open this screen using a direct push.
  static void open(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutTeacherScreen()),
    );
  }

  Widget _statCard(BuildContext context, IconData icon, String label, Color bg) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 22, backgroundColor: Colors.white, child: Icon(icon, color: bg, size: 22)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: textStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final softBlue = const Color(0xFFB3E5FC);
    final softPurple = const Color(0xFFD1C4E9);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About the Teacher'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF7E8), Color(0xFFE8F4FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with playful label
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFE6F4FF),
                            ),
                            child: Text('ALL', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF0D47A1))),
                          ),
                          const SizedBox(width: 10),
                          Text('ABOUT', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF1B5E20))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('ME', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 2, color: const Color(0xFFE65100))),
                      const SizedBox(height: 8),
                      Text('This is the teacher behind Brain Gym Academy.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Profile row
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFB2DFDB), width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primary.withOpacity(0.4), width: 4),
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/teachers/teacher_headshot.jpeg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 64, color: primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi! My name is', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text('Meenu Pathak', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Text('Lead Instructor at Brain Gym Academy', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Biography area with playful checkered border
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB2DFDB),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                        ),
                        child: Text('Here is my family!', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'With over 15 years of dedicated experience in early childhood and cognitive education, our founder and lead instructor has transformed the learning journeys of countless students. As a certified expert instructor in Abacus, Vedic Maths, Phonics, and Handwriting Improvement, she combines time-tested techniques with a modern, engaging approach to help children unlock their full potential.',
                          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(context, Icons.timer, '15+\nYears Exp', softBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(context, Icons.emoji_events, 'State/National\nChampions', softPurple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(context, Icons.verified, 'Certified\nExpert', const Color(0xFFB9F6CA)),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFFF59D), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('My Favorite Things', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFF57C00))),
                      const SizedBox(height: 10),
                      Text('Joyful classroom activities, child-centered learning, and helping students become confident thinkers.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87, height: 1.5)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFCE93D8), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Fun Facts About Me', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A))),
                      const SizedBox(height: 10),
                      Text('Highly interactive board games, creative teaching aids, and a passion for turning practice into inspiration.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87, height: 1.5)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
