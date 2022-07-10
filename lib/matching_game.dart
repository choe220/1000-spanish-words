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
  late List<Word> english;
  late List<Word> spanish;

  Word? englishSelected;
  Word? spanishSelected;

  @override
  void initState() {
    super.initState();
    english = widget.words.shuffle();
    spanish = widget.words.shuffle();
  }

  bool checkCorrect() {
    if (englishSelected == spanishSelected) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...english.map(
              (e) => Card(
                color: e == englishSelected ? Colors.green : Colors.white,
                child: InkWell(
                  onTap: () {
                    englishSelected = e;
                    var correct = checkCorrect();
                  },
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
            ...spanish.map(
              (e) => Card(
                color: e == spanishSelected ? Colors.green : Colors.white,
                child: InkWell(
                  onTap: () {
                    spanishSelected = e;
                    var correct = checkCorrect();
                  },
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
