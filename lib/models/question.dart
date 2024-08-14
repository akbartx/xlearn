class Question {
  final int id;
  final String image;
  final List<String> options;
  final String answer;

  Question({
    required this.id,
    required this.image,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    print('Parsing Question from JSON: $json'); // Debugging log
    return Question(
      id: json['id'],
      image: json['image'],
      options: [json['option1'], json['option2'], json['option3'], json['option4']],
      answer: json['answer'],
    );
  }

  @override
  String toString() {
    return 'Question{id: $id, image: $image, options: $options, answer: $answer}';
  }
}
