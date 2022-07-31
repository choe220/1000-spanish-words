import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanish_words/match_card.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  bool _mute = false;

  List<Word> english = [];
  List<Word> spanish = [];

  Word? englishSelected;
  Word? spanishSelected;

  List<Word> matches = [];

  @override
  void initState() {
    super.initState();

    for (var element in widget.user.currentSet!) {
      english.add(element);
      spanish.add(element);
    }
    english.shuffle();
    spanish.shuffle();
  }

  void updateSelected(Word word, bool english) {
    if (english) {
      englishSelected = word;
    }
    if (!english) {
      spanishSelected = word;
    }
    checkCorrect();
  }

  bool? checkCorrect() {
    if (englishSelected != null && spanishSelected != null) {
      if (englishSelected == spanishSelected) {
        if (englishSelected!.mastery != null) {
          if (englishSelected!.mastery! < 1) {
            englishSelected!.mastery = englishSelected!.mastery! + 0.05;
          }
        } else {
          englishSelected!.mastery = 0.05;
        }
        englishSelected!.mastery =
            double.parse(englishSelected!.mastery!.toStringAsFixed(2));
        matches.add(englishSelected!);
        englishSelected = null;
        spanishSelected = null;
        setState(() {});
        return true;
      } else {
        if (englishSelected!.mastery != null &&
            englishSelected!.mastery! >= 0.05) {
          englishSelected!.mastery = englishSelected!.mastery! - 0.05;
        } else {
          englishSelected!.mastery = 0;
        }
        englishSelected!.mastery =
            double.parse(englishSelected!.mastery!.toStringAsFixed(2));
        englishSelected = null;
        spanishSelected = null;
        setState(() {});
        return false;
      }
    }
    setState(() {});
    return null;
  }

  _updateMastery(User user) async {
    await user.saveToFirebase();
  }

  double _checkMasteryCompletion() {
    double completion = widget.user.currentSet!.fold(
        0,
        (previousValue, element) =>
            (previousValue + (element.mastery ?? 0)) /
            (widget.user.currentSet!.length + 1));
    return completion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      body: _checkMasteryCompletion() <= 1
          ? matches.length != 10
              ? SingleChildScrollView(
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // English
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...english.map((e) {
                                  return MatchCard(
                                    e,
                                    english: true,
                                    selected:
                                        e == englishSelected ? true : false,
                                    correct: matches.contains(e),
                                    mute: _mute,
                                    onTapCallback: updateSelected,
                                  );
                                })
                              ],
                            ),
                          ),

                          // Spanish
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...spanish.map((e) => MatchCard(
                                      e,
                                      english: false,
                                      selected:
                                          e == spanishSelected ? true : false,
                                      correct: matches.contains(e),
                                      mute: _mute,
                                      onTapCallback: updateSelected,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          onPressed: () => setState(() => _mute = !_mute),
                          icon: Icon(
                            _mute ? Icons.volume_mute : Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: FutureBuilder(
                    future: _updateMastery(widget.user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text(
                            'An Error Occured:\n${snapshot.error.toString()}');
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You\'ve Matched Them All!',
                            style: TextStyle(color: Colors.white, fontSize: 32),
                          ),
                          ElevatedButton(
                            onPressed: () => setState(() {
                              matches = [];
                              english.shuffle();
                              spanish.shuffle();
                            }),
                            child: const Text('Start Over'),
                          ),
                        ],
                      );
                    },
                  ),
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You\'ve Mastered This Set!',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      matches = [];
                      await widget.user.generateSet().then(
                          (value) async => await widget.user.saveToFirebase());
                      for (var element in widget.user.currentSet!) {
                        english.add(element);
                        spanish.add(element);
                      }
                      english.shuffle();
                      spanish.shuffle();
                      setState(() {});
                    },
                    child: const Text('Next Set'),
                  ),
                ],
              ),
            ),
    );
  }
}
