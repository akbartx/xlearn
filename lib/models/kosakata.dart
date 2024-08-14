class Kosakata {
  final int id;
  final String englishWordVerb1;
  final String englishWordVerb2;
  final String indonesianWord;

  Kosakata({
    required this.id,
    required this.englishWordVerb1,
    required this.englishWordVerb2,
    required this.indonesianWord,
  });

  factory Kosakata.fromJson(Map<String, dynamic> json) {
    return Kosakata(
      id: json['id'],
      englishWordVerb1: json['english_word_verb1'],
      englishWordVerb2: json['english_word_verb2'],
      indonesianWord: json['indonesian_word'],
    );
  }
}
