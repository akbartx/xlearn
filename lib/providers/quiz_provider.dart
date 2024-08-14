import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/question.dart';

class QuizProvider with ChangeNotifier {
  List<Question> _quizList = [];

  List<Question> get quizList => _quizList;

  Future<void> fetchQuizzes() async {
    final response = await http.get(Uri.parse('https://xlearn.initoko.com/api/quiz'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Data fetched from API: $data'); // Debugging log

      try {
        _quizList = data.map((item) => Question.fromJson(item)).toList();
        print('Parsed Quiz List: $_quizList'); // Debugging log
        notifyListeners();
      } catch (e) {
        print('Error parsing data: $e'); // Debugging log
      }
    } else {
      print('Failed to load quizzes with status code: ${response.statusCode}'); // Debugging log
      throw Exception('Failed to load quizzes');
    }
  }
}
