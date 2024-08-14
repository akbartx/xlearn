import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 300; // 5 minutes in seconds
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isQuizStarted = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzes().then((_) {
        print('Quizzes fetched successfully');
      }).catchError((error) {
        print('Error fetching quizzes: $error');
      });
    });
  }

  void _startQuiz() {
    setState(() {
      _isQuizStarted = true;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _playSound('assets/sounds/times_up.mp3');
            _saveScoreToLeaderboard();
            _showResult();
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _playSound(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  void _checkAnswer(String answer) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    if (quizProvider.quizList[_currentQuestionIndex].answer == answer) {
      _score += 5; // Setiap jawaban benar mendapatkan 5 poin
      _playSound('assets/sounds/correct.mp3');
      _animationController.forward(from: 0.0);
    } else {
      _playSound('assets/sounds/wrong.mp3');
    }
    setState(() {
      if (_currentQuestionIndex < quizProvider.quizList.length - 1) {
        _currentQuestionIndex++;
      } else {
        _timer?.cancel();
        _saveScoreToLeaderboard(); // Simpan skor ke leaderboard
        _showResult();
      }
    });
  }

  void _saveScoreToLeaderboard() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Logika untuk mengakses data user dari userProvider
    final user = userProvider.user;

    if (user == null) {
      print('User data is null');
      return;
    }

    final response = await http.post(
      Uri.parse('https://xlearn.initoko.com/api/leaderboard'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'no_telepon': user.noTelepon,
        'token': user.token,
        'quiz_id': quizProvider.quizList[_currentQuestionIndex].id,
        'score': _score,
      }),
    );

    if (response.statusCode == 201) {
      print('Score saved to leaderboard');
    } else {
      print('Failed to save score to leaderboard with status code: ${response.statusCode}');
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Score kamu: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _timeLeft = 300;
                _isQuizStarted = false;
              });
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    print('Quiz List Length: ${quizProvider.quizList.length}'); // Debugging log

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _startQuiz,
              child: Text('Start Quiz'),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
            if (_isQuizStarted) ...[
              Text(
                'Time Left: ${(_timeLeft / 60).floor()}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 24),
              ),
            ],
            SizedBox(height: 20),
            Expanded(
              child: quizProvider.quizList.isNotEmpty
                  ? ListView.builder(
                itemCount: quizProvider.quizList.length,
                itemBuilder: (context, index) {
                  final quiz = quizProvider.quizList[index];
                  print('Displaying quiz: $quiz'); // Debugging log
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.network(
                            'https://xlearn.initoko.com${quiz.image}',
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: quiz.options.map((option) {
                              return ElevatedButton(
                                onPressed: _isQuizStarted
                                    ? () => _checkAnswer(option)
                                    : null,
                                child: Text(option),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
