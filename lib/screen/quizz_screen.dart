import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz_question.dart';
import 'package:quizz_app/screen/match_question.dart';
import 'package:quizz_app/screen/word_order_question.dart';
import 'package:quizz_app/screen/wordorder_question.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  QuizScreen({required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> shuffledQuestions;
  List<Question> matchQuestions = [];
  List<Question> otherQuestions = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Split questions into match and other types
    matchQuestions = widget.questions.where((q) => q.type == 'match').toList();
    otherQuestions = widget.questions.where((q) => q.type != 'match').toList();

    // Shuffle options within each match type question
    matchQuestions.forEach((question) {
      if (question.options != null) {
        question.options!.forEach((option) {
          List<MapEntry<String, String>> entries = option.entries.toList();
          entries.shuffle();
          option.clear();
          option.addEntries(entries);
        });
      }
    });

    // Combine shuffled match type questions with other types
    shuffledQuestions = [...matchQuestions, ...otherQuestions];
  }

  void goToNextQuestion() {
    setState(() {
      if (currentIndex < shuffledQuestions.length - 1) {
        currentIndex++;
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: _buildQuestionWidget(shuffledQuestions[currentIndex]),
    );
  }

  Widget _buildQuestionWidget(Question question) {
    if (question.type == 'match') {
      return MatchQuestion(
        question: question,
        onNextQuestion: goToNextQuestion,
        goToQuestionAtIndex: (index) {},
      );
    } else if (question.type == 'words-order') {
      return WordOrderQuestion(
        question: question,
        onNextQuestion: goToNextQuestion,
      );
    } else {
      return Container();
    }
  }
}
