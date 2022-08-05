import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:spanish_words/models/words.dart';

class User with ChangeNotifier {
  List<Word> words;
  List<Word>? currentSet;
  int attempts;
  List<dynamic> speechSensitivity;
  double numMatchCards;

  User({
    required this.words,
    this.currentSet,
    this.attempts = 3,
    this.speechSensitivity = const [75, 80],
    this.numMatchCards = 5,
  });

  User.fromFirebase(Map<String, dynamic> data)
      : words = List<Word>.from(data['words'].map((e) => Word.fromJson(e))),
        currentSet = data['current_set'] != null
            ? List<Word>.from(data['current_set'].map((e) => Word.fromJson(e)))
            : null,
        attempts = data['attempts'] ?? 3,
        speechSensitivity = data['speechSensitivity'] ?? const [75, 80],
        numMatchCards = data['num_match_cards'] ?? 5;

  Map<String, dynamic> toFirebase() {
    return {
      'words': words.map((e) => e.toJson()).toList(),
      'current_set': currentSet?.map((e) => e.toJson()).toList(),
      'attempts': attempts,
      'speechSensitivity': speechSensitivity,
      'num_match_cards': numMatchCards,
    };
  }

  Future<void> saveToFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc('matt').set(toFirebase());
    notifyListeners();
  }

  Future<void> generateSet(List<Word>? set) async {
    var random = Random();
    if (currentSet != null) {
      for (Word word in currentSet!) {
        words.add(word);
      }
    }
    if (set == null) {
      currentSet =
          List.generate(10, (_) => words[random.nextInt(words.length)]);
    } else {
      currentSet = List.generate(10, (_) => set[random.nextInt(words.length)]);
    }
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
