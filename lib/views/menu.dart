import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanish_words/views/matching_game.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/views/flashcards_view.dart';
import 'package:spanish_words/views/settings.dart';
import 'package:spanish_words/views/speech_game.dart';
import 'package:spanish_words/views/words_list.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  List<Word> shuffle(List<Word> array, int seed) {
    var random = Random(seed);
    List<Word> newArray = array;

    // Go through all elementsof list
    for (var i = newArray.length - 1; i > 0; i--) {
      // Pick a random number according to the lenght of list
      var n = random.nextInt(i + 1);
      var temp = newArray[i];
      newArray[i] = newArray[n];
      newArray[n] = temp;
    }
    return newArray;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Top 1000 Spanish Words',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                          onPressed: () async => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FlashcardsView(user: user),
                                ),
                              ),
                          child: const Text('Flashcards')),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MatchingGame(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: const Text('Matching Game'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SpeechGame(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: const Text('Speech Game'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordsList(
                                words: (user.words + user.currentSet!),
                              ),
                            ),
                          );
                        },
                        child: const Text('Search For Words'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
                child: const Text('Settings'),
              ),
            ),
            const SizedBox(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
