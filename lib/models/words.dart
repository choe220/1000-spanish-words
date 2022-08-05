import 'dart:convert';

List<Word> wordsFromJson(String str) =>
    List<Word>.from(json.decode(str)["words"].map((x) => Word.fromJson(x)));

class Word {
  Word({
    required this.english,
    required this.spanish,
    required this.weight,
    required this.partOfSpeech,
    this.mastery,
    this.flagged,
    this.correct,
  });

  String english;
  String spanish;
  String partOfSpeech;
  int weight;
  double? mastery;
  bool? flagged;
  bool? correct;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        english: json["english"],
        spanish: json["spanish"],
        partOfSpeech: json['part_of_speech'],
        weight: json["weight"] ?? 0,
        flagged: json['flagged'] ?? false,
        mastery: json['mastery']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "english": english,
        "spanish": spanish,
        'part_of_speech': partOfSpeech,
        "weight": weight,
        'flagged': flagged,
        'mastery': mastery,
      };
}
