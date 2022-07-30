import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanish_words/views/matching_game.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/views/flashcards_view.dart';

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
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                'Top 1000 Spanish Words',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FlashcardsView(user: user),
                      ),
                    ),
                child: const Text('Flashcards')),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MatchingGame(
                        words: user.currentSet!,
                      ),
                    ),
                  );
                },
                child: const Text('Matching Game'))
          ],
        ),
      ),
    );
  }
}
