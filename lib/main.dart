import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz_question.dart';
import 'package:quizz_app/screen/quizz_screen.dart'; // Import QuizScreen class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Question> questions =
      await loadQuestionsFromJsonFile('assets/question.json');
  runApp(MyApp(questions: questions));
}

class MyApp extends StatelessWidget {
  final List<Question> questions;

  MyApp({required this.questions});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(questions: questions), // Set QuizScreen as the home
    );
  }
}
