import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spanish_words/models/words.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key, required this.words}) : super(key: key);

  final List<Word> words;

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  Word? englishSelected;
  Word? spanishSelected;

  @override
  Widget build(BuildContext context) {
    print(englishSelected?.english);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widget.words.map(
              (e) => Card(
                color: e == englishSelected ? Colors.green : Colors.white,
                child: InkWell(
                  onTap: () => setState(() {
                    englishSelected = e;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(e.english),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...widget.words.map(
              (e) => Card(
                color: e == spanishSelected ? Colors.green : Colors.white,
                child: InkWell(
                  onTap: () => setState(() {
                    spanishSelected = e;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(e.spanish),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
