import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/util.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

class SpeechGame extends StatefulWidget {
  const SpeechGame({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<SpeechGame> createState() => _SpeechGameState();
}

class _SpeechGameState extends State<SpeechGame> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool? _correct;
  late Word _currentWord;
  String _lastWords = '';

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _currentWord = _generateWord();
  }

  Word _generateWord() {
    return widget
        .user.currentSet![Random().nextInt(widget.user.currentSet!.length)];
  }

  void _startListening() async {
    _correct = null;
    await _speechToText.listen(
      localeId: 'es_MX',
      onResult: _onSpeechResult,
      partialResults: false,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    _lastWords = result.recognizedWords;
    double similarity = StringSimilarity.compareTwoStrings('healed', 'sealed');

    if (similarity > 0.75) {
      _lastWords = _currentWord.spanish;
      debugPrint('Eh similar enough');
    }

    if (int.tryParse(_lastWords) != null) {
      String? replaced = replaceNumbers(_lastWords);
      if (replaced != null) _lastWords = replaced;
    }
    _correct = _lastWords.trim().toLowerCase() ==
        _currentWord.spanish.trim().toLowerCase();
    setState(() {});
    if (_correct!) {
      await widget.user
          .incrementMastery(_currentWord)
          .then((value) async => await widget.user.saveToFirebase());
      await Future.delayed(const Duration(seconds: 2));
      _lastWords = '';
      _currentWord = _generateWord();
      _correct = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _currentWord.english,
                  style: const TextStyle(
                    fontSize: 45.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _speechEnabled
                      ? _speechToText.isNotListening
                          ? 'Tap the microphone to start listening...'
                          : 'Listening...'
                      : 'Speech not available',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _lastWords,
                  style: TextStyle(
                    color: _correct != null
                        ? _correct!
                            ? Colors.green
                            : Colors.red
                        : Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                        style: _speechToText.isListening
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.redAccent))
                            : const ButtonStyle(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(_speechToText.isNotListening
                                ? Icons.mic_off
                                : Icons.mic),
                            Expanded(
                                child: Text(
                              _speechToText.isNotListening
                                  ? 'Speak'
                                  : 'Stop Speaking',
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
