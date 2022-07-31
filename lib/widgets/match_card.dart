import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spanish_words/models/words.dart';

class MatchCard extends StatefulWidget {
  const MatchCard(this.word,
      {Key? key,
      required this.english,
      this.correct,
      required this.selected,
      required this.mute,
      required this.onTapCallback})
      : super(key: key);

  final Word word;
  final bool english;
  final bool selected;
  final bool? correct;
  final bool mute;
  final Function onTapCallback;

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  FlutterTts flutterTts = FlutterTts();

  Future _speak(String string) async {
    await flutterTts.setLanguage("es-MX");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(string);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        color: widget.selected
            ? const Color.fromARGB(255, 211, 211, 211)
            : widget.correct != null && widget.correct!
                ? Colors.green
                : Colors.white,
        child: InkWell(
          onTap: () async {
            if (widget.correct != null && !widget.correct!) {
              widget.onTapCallback(widget.word, widget.english);
              if (!widget.english && !widget.mute) {
                await _speak(widget.word.spanish);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              widget.english ? widget.word.english : widget.word.spanish,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
