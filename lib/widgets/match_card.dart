import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/widgets/white_text.dart';

class MatchCard extends StatefulWidget {
  const MatchCard(
    this.word, {
    Key? key,
    required this.english,
    this.correct,
    required this.selected,
    required this.mute,
    required this.numCards,
    required this.onTapCallback,
  }) : super(key: key);

  final Word word;
  final bool english;
  final bool selected;
  final bool? correct;
  final bool mute;
  final int numCards;
  final Function onTapCallback;

  @override
  State<MatchCard> createState() => MatchCardState();
}

class MatchCardState extends State<MatchCard> {
  FlutterTts flutterTts = FlutterTts();

  Future _speak(String string) async {
    await flutterTts.setLanguage("es-MX");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(string);
  }

  @override
  Widget build(BuildContext context) {
    var height = (MediaQuery.of(context).size.height / widget.numCards - 15);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: height <= 70 ? height : 70,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.selected
                  ? const Color.fromARGB(255, 211, 211, 211)
                  : widget.correct != null && widget.correct!
                      ? Colors.green
                      : const Color.fromARGB(31, 255, 255, 255),
            ),
            color: widget.selected
                ? const Color.fromARGB(43, 255, 255, 255)
                : Colors.transparent,
          ),
          child: InkWell(
            onTap: () async {
              if (widget.correct != null && !widget.correct!) {
                widget.onTapCallback(widget.word, widget.english);
                if (!widget.english && !widget.mute) {
                  await _speak(widget.word.spanish);
                }
              }
            },
            child: Center(
              child: WhiteText(
                widget.english ? widget.word.english : widget.word.spanish,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
