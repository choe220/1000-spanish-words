import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:spanish_words/models/words.dart';

class User with ChangeNotifier {
  List<Word> words;
  List<Word>? currentSet;

  User({required this.words, this.currentSet});

  User.fromFirebase(Map<String, dynamic> data)
      : words = List<Word>.from(data['words'].map((e) => Word.fromJson(e))),
        currentSet = data['current_set'] != null
            ? List<Word>.from(data['current_set'].map((e) => Word.fromJson(e)))
            : null;

  Map<String, dynamic> toFirebase() {
    return {
      'words': words.map((e) => e.toJson()).toList(),
      'current_set': currentSet?.map((e) => e.toJson()).toList(),
    };
  }

  Future<void> saveToFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc('matt').set(toFirebase());
    notifyListeners();
  }

  Future<void> generateSet() async {
    var random = Random();
    if (currentSet != null) {
      for (Word word in currentSet!) {
        words.add(word);
      }
    }
    currentSet = List.generate(10, (_) => words[random.nextInt(words.length)]);
    for (Word word in currentSet!) {
      words.remove(word);
    }
  }

  Future<void> incrementMasteryForSet() async {
    for (var word in currentSet!) {
      Word userWord =
          currentSet!.firstWhere((element) => element.english == word.english);
      if (userWord.mastery != null && userWord.mastery! < 1) {
        userWord.mastery = userWord.mastery! + 0.05;
      } else {
        userWord.mastery = 0.05;
      }
    }
  }

  Future<void> incrementMastery(Word word) async {
    Word userWord =
        currentSet!.firstWhere((element) => element.english == word.english);
    if (userWord.mastery != null && userWord.mastery! < 1) {
      userWord.mastery = userWord.mastery! + 0.05;
    } else {
      userWord.mastery = 0.05;
    }
  }
}
