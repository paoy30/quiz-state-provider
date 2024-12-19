import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Quiz(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: QuizPage(),
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var quiz = Provider.of<Quiz>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 67, 126, 235),
        shadowColor: const Color.fromARGB(255, 51, 57, 68),
      ),
      body: quiz.isQuizFinished
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your score: ${quiz.totalScore}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ReviewPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Review Questions',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.greenAccent,
                    ),
                    onPressed: quiz.resetQuiz,
                    child: const Text(
                      'Restart Quiz',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                LinearProgressIndicator(
                  value: (quiz.questionIndex + 1) / quiz.questions.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blueAccent,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    quiz.questions[quiz.questionIndex]['questionText'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        quiz.questions[quiz.questionIndex]['answers'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => quiz.answerQuestion(
                              quiz.questions[quiz.questionIndex]['answers']
                                  [index]['score'],
                              quiz.questions[quiz.questionIndex]['answers']
                                  [index]['text']),
                          child: Text(
                            quiz.questions[quiz.questionIndex]['answers'][index]
                                ['text'],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,  // Menetapkan warna teks menjadi putih
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var quiz = Provider.of<Quiz>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Review'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: quiz.questions.length,
        itemBuilder: (ctx, index) {
          final question = quiz.questions[index];
          final userAnswer = quiz.userAnswers[index];
          final correctAnswer = question['answers']
              .firstWhere((answer) => answer['score'] == 1)['text'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${question['questionText']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your answer: $userAnswer',
                    style: TextStyle(
                      fontSize: 16,
                      color: userAnswer == correctAnswer
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Correct answer: $correctAnswer',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Quiz with ChangeNotifier {
  final List<Map<String, dynamic>> _questions = [
  {
    'questionText': 'What is Flutter?',
    'answers': [
      {'text': 'A programming language', 'score': 0},
      {'text': 'A web framework', 'score': 0},
      {'text': 'A mobile UI framework', 'score': 1},
      {'text': 'A game', 'score': 0},
    ],
  },
  {
    'questionText': 'Which language is used to write Flutter apps?',
    'answers': [
      {'text': 'Dart', 'score': 1},
      {'text': 'Java', 'score': 0},
      {'text': 'C++', 'score': 0},
      {'text': 'Python', 'score': 0},
    ],
  },
  {
    'questionText': 'Who develops Flutter?',
    'answers': [
      {'text': 'Microsoft', 'score': 0},
      {'text': 'Apple', 'score': 0},
      {'text': 'Google', 'score': 1},
      {'text': 'Facebook', 'score': 0},
    ],
  },
  {
    'questionText': 'What is the widget for unbounded scrolling in Flutter?',
    'answers': [
      {'text': 'SingleChildScrollView', 'score': 1},
      {'text': 'ListView', 'score': 0},
      {'text': 'Column', 'score': 0},
      {'text': 'GridView', 'score': 0},
    ],
  },
  {
    'questionText': 'Which of these is a state management solution in Flutter?',
    'answers': [
      {'text': 'Redux', 'score': 1},
      {'text': 'Vuex', 'score': 0},
      {'text': 'MobX', 'score': 1},
      {'text': 'BLoC', 'score': 1},
    ],
  },
  {
    'questionText': 'Which Flutter widget has no visual representation?',
    'answers': [
      {'text': 'Container', 'score': 0},
      {'text': 'SizedBox', 'score': 1},
      {'text': 'AppBar', 'score': 0},
      {'text': 'Text', 'score': 0},
    ],
  },
  {
    'questionText': 'What is used to define a theme in Flutter?',
    'answers': [
      {'text': 'ThemeData', 'score': 1},
      {'text': 'ColorScheme', 'score': 0},
      {'text': 'MaterialApp', 'score': 0},
      {'text': 'Scaffold', 'score': 0},
    ],
  },
  {
    'questionText': 'What does “Hot Reload” do in Flutter?',
    'answers': [
      {'text': 'Reloads the whole app', 'score': 0},
      {'text': 'Restarts the app from scratch', 'score': 0},
      {'text': 'Rebuilds UI without losing state', 'score': 1},
      {'text': 'Clears cache memory', 'score': 0},
    ],
  },
  {
    'questionText': 'Which widget is used to create an input field?',
    'answers': [
      {'text': 'Text', 'score': 0},
      {'text': 'TextField', 'score': 1},
      {'text': 'Container', 'score': 0},
      {'text': 'Button', 'score': 0},
    ],
  },
  {
    'questionText': 'Which Flutter widget is used to arrange children vertically?',
    'answers': [
      {'text': 'Row', 'score': 0},
      {'text': 'Column', 'score': 1},
      {'text': 'ListView', 'score': 0},
      {'text': 'Stack', 'score': 0},
    ],
  },
  ];

  int _questionIndex = 0;
  int _totalScore = 0;
  final List<String> _userAnswers = [];

  void answerQuestion(int score, String answer) {
    _totalScore += score;
    _userAnswers.add(answer);
    _questionIndex++;
    notifyListeners();
  }

  int get questionIndex => _questionIndex;
  int get totalScore => _totalScore;
  List<Map<String, dynamic>> get questions => _questions;
  List<String> get userAnswers => _userAnswers;

  bool get isQuizFinished => _questionIndex >= _questions.length;

  void resetQuiz() {
    _questionIndex = 0;
    _totalScore = 0;
    _userAnswers.clear();
    notifyListeners();
  }
}
