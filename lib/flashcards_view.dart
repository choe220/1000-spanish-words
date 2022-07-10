import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spanish_words/flashcard.dart';
import 'package:spanish_words/models/words.dart';

class FlashcardsView extends StatefulWidget {
  const FlashcardsView({Key? key, required this.words}) : super(key: key);

  final List<Word> words;

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> {
  int _index = 0;
  late List<Word> listToShow;

  List<Word> updateDataInList(List words) {
    var random = Random();
    return List.generate(10, (_) => words[random.nextInt(words.length)]);
  }

  @override
  void initState() {
    super.initState();
    listToShow = updateDataInList(widget.words);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_index + 1} / 10',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        FlashCard(word: listToShow[_index]),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() => listToShow = updateDataInList(widget.words));
              },
              child: const Text('Next Set'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF006874),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_index == 0) {
                        setState(() => _index = 10);
                      } else {
                        setState(() => _index -= 1);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF006874),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_index == 9) {
                        setState(() => _index = 0);
                      } else {
                        setState(() => _index += 1);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
