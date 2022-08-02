import 'dart:convert';

List<Word> wordsFromJson(String str) =>
    List<Word>.from(json.decode(str)["words"].map((x) => Word.fromJson(x)));

class Word {
  Word({
    required this.english,
    required this.spanish,
    required this.weight,
    this.mastery,
    this.flagged,
    this.correct,
  });

  String english;
  String spanish;
  int weight;
  double? mastery;
  bool? flagged;
  bool? correct;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        english: json["english"],
        spanish: json["spanish"],
        weight: json["weight"],
        flagged: json['flagged'],
        mastery: json['mastery']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "english": english,
        "spanish": spanish,
        "weight": weight,
        'flagged': flagged,
        'mastery': mastery,
      };
}
