import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spanish_words/flashcard.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';

class FlashcardsView extends StatefulWidget {
  final User user;

  const FlashcardsView({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> {
  int _index = 0;
  bool showAnswer = false;

  void updateShowAnswer() {
    print(showAnswer);
    setState(() => showAnswer = !showAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      body: Column(
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
          FlashCard(
            word: widget.user.currentSet![_index],
            showAnswer: showAnswer,
            showAnswerCallback: updateShowAnswer,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  widget.user.generateSet().then((_) => widget.user
                      .saveToFirebase()
                      .then((_) => setState(() {})));
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
                        showAnswer = false;
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
                        showAnswer = false;
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
      ),
    );
  }
}
