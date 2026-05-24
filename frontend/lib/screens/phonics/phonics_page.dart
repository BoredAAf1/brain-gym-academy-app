import 'package:flutter/material.dart';

import 'package:brain_gym_academy_app/widgets/app_page.dart';
import 'package:brain_gym_academy_app/widgets/section_title.dart';

class PhonicsPage extends StatelessWidget {
  const PhonicsPage({super.key});

  static const List<PhonicsSound> sounds = [
    PhonicsSound(sound: 's', symbol: '/s/', words: ['sun', 'sip', 'sand', 'sock', 'soap']),
    PhonicsSound(sound: 'a', symbol: '/a/', words: ['ant', 'apple', 'ax', 'ash', 'arrow']),
    PhonicsSound(sound: 't', symbol: '/t/', words: ['tap', 'top', 'tent', 'toy', 'tail']),
    PhonicsSound(sound: 'i', symbol: '/i/', words: ['ink', 'insect', 'igloo', 'it', 'ill']),
    PhonicsSound(sound: 'p', symbol: '/p/', words: ['pin', 'pan', 'pen', 'pot', 'pig']),
  ];

  static const List<String> trickyWords = [
    'she',
    'he',
    'the',
    'me',
    'to',
    'do',
    'was',
    'all',
    'we',
    'are',
  ];

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Phonics',
      subtitle: 'Starter phonics content kept in the fresh project while we rebuild cleanly.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sounds.map(
            (sound) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${sound.sound}  ${sound.symbol}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sound.words.map((word) => Chip(label: Text(word))).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const SectionTitle('Tricky Words'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: trickyWords.map((word) => Chip(label: Text(word))).toList(),
          ),
        ],
      ),
    );
  }
}

class PhonicsSound {
  const PhonicsSound({
    required this.sound,
    required this.symbol,
    required this.words,
  });

  final String sound;
  final String symbol;
  final List<String> words;
}
