class KataSifat {
  final int id;
  final String englishWord;
  final String indonesianWord;

  KataSifat({required this.id, required this.englishWord, required this.indonesianWord});

  factory KataSifat.fromJson(Map<String, dynamic> json) {
    return KataSifat(
      id: json['id'],
      englishWord: json['english_word'],
      indonesianWord: json['indonesian_word'],
    );
  }
}
