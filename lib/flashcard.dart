import 'package:flutter/material.dart';
import 'package:spanish_words/models/words.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({Key? key, required this.word}) : super(key: key);

  final Word word;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        _showAnswer = !_showAnswer;
      }),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Card(
          color: const Color.fromARGB(255, 83, 83, 83),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _showAnswer ? widget.word.english : widget.word.spanish,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
