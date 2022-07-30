import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:spanish_words/models/words.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({
    Key? key,
    required this.word,
    required this.showAnswer,
    required this.showAnswerCallback,
  }) : super(key: key);

  final Word word;
  final bool showAnswer;
  final Function showAnswerCallback;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  Future _speak(String string) async {
    await flutterTts.setLanguage("es-MX");

    await flutterTts.awaitSpeakCompletion(true);
    var result = await flutterTts.speak(string);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.showAnswerCallback(),
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
                    child: Text(
                      !widget.showAnswer
                          ? widget.word.english
                          : widget.word.spanish,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                      ),
                    ),
                  ),
                ),
                if (widget.showAnswer)
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
