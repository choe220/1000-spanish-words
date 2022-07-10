import 'package:flutter/material.dart';
import 'package:spanish_words/models/words.dart';

class MatchCard extends StatefulWidget {
    const MatchCard(this.word, {Key? key, this.english, this.checkCallback}) : super(key: key);

    final Word word;
    final bool english;
    final Function checkCallback;

    @override
    State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
    bool correct = false;
    bool selected = false;

    @override
    Widget build(BuildContext context) {
        return Card(
            color: widget.word == englishSelected ? Colors.green : Colors.white,
            child: InkWell(
                onTap: () {
                    widget.checkCallback(widget.word);
                    var correct = checkCorrect();
                },
                child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(widget.english ? widget.word.english : widget.word.spanish),
                ),
            ),
        );
    }
}