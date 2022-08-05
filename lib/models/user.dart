import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/util.dart';

class User with ChangeNotifier {
  List<Word> words;
  List<Word>? currentSet;
  int attempts;
  List<dynamic> speechSensitivity;
  double numMatchCards;
  Map<String, bool> partsOfSpeech;

  User({
    required this.words,
    this.currentSet,
    this.attempts = 3,
    this.speechSensitivity = const [75, 80],
    this.numMatchCards = 5,
    this.partsOfSpeech = const {
      'Pronoun': true,
      'Noun': true,
      'Adjective': true,
      'Verb': true,
      'Adverb': true,
      'Preposition': true,
      'Conjunction': true,
      'Interjection': true,
    },
  });

  User.fromFirebase(Map<String, dynamic> data)
      : words = List<Word>.from(data['words'].map((e) => Word.fromJson(e))),
        currentSet = data['current_set'] != null
            ? List<Word>.from(data['current_set'].map((e) => Word.fromJson(e)))
            : null,
        attempts = data['attempts'] ?? 3,
        speechSensitivity = data['speechSensitivity'] ?? [75, 80],
        numMatchCards = data['num_match_cards'] ?? 5,
        partsOfSpeech = data['parts_of_speech'] != null
            ? Map<String, bool>.from(data['parts_of_speech'])
            : {
                'Pronoun': true,
                'Noun': true,
                'Adjective': true,
                'Verb': true,
                'Adverb': true,
                'Preposition': true,
                'Conjunction': true,
                'Interjection': true,
              };

  Map<String, dynamic> toFirebase() {
    return {
      'words': words.map((e) => e.toJson()).toList(),
      'current_set': currentSet?.map((e) => e.toJson()).toList(),
      'attempts': attempts,
      'speechSensitivity': speechSensitivity,
      'num_match_cards': numMatchCards,
      'parts_of_speech': partsOfSpeech,
    };
  }

  Future<void> saveToFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc('matt').set(toFirebase());
    notifyListeners();
  }

  Future<void> generateSet(List<Word>? set) async {
    if (currentSet != null) {
      for (Word word in currentSet!) {
        words.add(word);
      }
    }
    List<Word> filteredWords = [];
    for (Word word in words) {
      if (partsOfSpeech[word.partOfSpeech.capitalize()] == true) {
        filteredWords.add(word);
      }
    }
    filteredWords.shuffle();
    currentSet = filteredWords.sublist(0, 10);
    for (Word word in currentSet!) {
      words.remove(word);
    }
  }
}
