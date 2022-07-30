import 'dart:convert';

List<Word> wordsFromJson(String str) =>
    List<Word>.from(json.decode(str)["words"].map((x) => Word.fromJson(x)));

class Word {
  Word({
    required this.english,
    required this.spanish,
    required this.weight,
    this.mastery,
    this.correct,
  });

  String english;
  String spanish;
  int weight;
  double? mastery;
  bool? correct;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        english: json["english"],
        spanish: json["spanish"],
        weight: json["weight"],
        mastery: json['mastery'],
      );

  Map<String, dynamic> toJson() => {
        "english": english,
        "spanish": spanish,
        "weight": weight,
        'mastery': mastery,
      };
}
