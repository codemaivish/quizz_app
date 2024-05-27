import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz_question.dart';
import 'package:collection/collection.dart';

class WordOrderQuestion extends StatefulWidget {
  final Question question;
  final VoidCallback onNextQuestion;

  WordOrderQuestion({
    required this.question,
    required this.onNextQuestion,
  });

  @override
  _WordOrderQuestionState createState() => _WordOrderQuestionState();
}

class _WordOrderQuestionState extends State<WordOrderQuestion> {
  List<String> selectedWords = [];
  List<String> tappedWords = [];
  bool showAnswer = true; // Initialize to true to show the answer by default

  @override
  Widget build(BuildContext context) {
    // Merge extra words and answer, shuffle them
    List<String> mergedWords = [];
    if (widget.question.extraWords != null) {
      mergedWords.addAll(widget.question.extraWords!);
    }
    if (widget.question.answer != null) {
      mergedWords.addAll(widget.question.answer!.split(' '));
    }
    mergedWords.shuffle();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display the main question text
          Text(
            widget.question.question!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              // Display merged words (extra words + answer)
              if (mergedWords.isNotEmpty) ...[
                ...mergedWords.map((word) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tappedWords.add(word);
                      });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: tappedWords.contains(word)
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
          SizedBox(height: 20),
          // Display tapped words
          Wrap(
            alignment: WrapAlignment.center,
            children: tappedWords.map((word) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Text(
                  word,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
