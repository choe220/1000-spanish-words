import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/widgets/white_text.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({
    Key? key,
    required this.word,
    required this.showAnswer,
  }) : super(key: key);

  final Word word;
  final bool showAnswer;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  FlutterTts flutterTts = FlutterTts();
  bool? _override;

  @override
  void initState() {
    super.initState();
  }

  Future _speak(String string) async {
    await flutterTts.setLanguage("es-MX");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(string);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => {
            if (_override == null)
              _override = !widget.showAnswer
            else
              _override = !_override!
          }),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Card(
          color: const Color.fromARGB(255, 83, 83, 83),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: WhiteText(
                      _override != null
                          ? _override!
                              ? widget.word.spanish
                              : widget.word.english
                          : !widget.showAnswer
                              ? widget.word.english
                              : widget.word.spanish,
                      fontSize: 100,
                    ),
                  ),
                ),
                if (widget.showAnswer || (_override != null && _override!))
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                      ),
                      onPressed: () async => await _speak(widget.word.spanish),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
