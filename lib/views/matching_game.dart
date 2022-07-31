import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanish_words/match_card.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key, required this.words}) : super(key: key);

  final List<Word> words;

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

    for (var element in widget.words) {
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
        englishSelected!.mastery = englishSelected!.mastery! + 0.05;
        matches.add(englishSelected!);
        englishSelected = null;
        spanishSelected = null;
        setState(() {});
        return true;
      } else {
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
    await user
        .incrementMasteryForSet(matches)
        .then((value) async => await user.saveToFirebase());
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      body: matches.length != 10
          ? Stack(
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
                              selected: e == englishSelected ? true : false,
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
                                selected: e == spanishSelected ? true : false,
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
            )
          : Center(
              child: FutureBuilder(
                future: _updateMastery(user),
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
            ),
    );
  }
}
