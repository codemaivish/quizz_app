import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:quizz_app/model/quiz_question.dart';

class MatchQuestion extends StatefulWidget {
  final Question question;
  final VoidCallback onNextQuestion;
  final Function(int) goToQuestionAtIndex;

  MatchQuestion({
    required this.question,
    required this.onNextQuestion,
    required this.goToQuestionAtIndex,
  });

  @override
  _MatchQuestionState createState() => _MatchQuestionState();
}

class _MatchQuestionState extends State<MatchQuestion> {
  String? selectedNumber;
  String? selectedWord;
  late ConfettiController _confettiController;
  bool showConfetti = false;
  Set<String> matchedNumbers = Set();
  Set<String> matchedWords = Set();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void checkMatch() {
    if (selectedNumber != null && selectedWord != null) {
      bool isCorrect = false;
      for (var option in widget.question.options ?? []) {
        if (option.containsKey(selectedNumber) &&
            option[selectedNumber] == selectedWord) {
          isCorrect = true;
          matchedNumbers.add(selectedNumber!);
          matchedWords.add(selectedWord!);
          break;
        }
      }

      if (isCorrect) {
        _confettiController.play();
        setState(() {
          showConfetti = true;
        });
      }

      showFeedbackPopup(context, isCorrect);
      resetSelection();
    }
  }

  void resetSelection() {
    setState(() {
      selectedNumber = null;
      selectedWord = null;
    });
  }

  void showFeedbackPopup(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
          content: Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 100,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  setState(() {
                    showConfetti = false;
                  });
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.question.options?.length ?? 0,
                itemBuilder: (context, index) {
                  var option = widget.question.options![index];
                  String number = option.keys.first;
                  String word = option.values.first;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedNumber = number;
                            checkMatch();
                          });
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: matchedNumbers.contains(number)
                                ? Colors.lightBlueAccent
                                : selectedNumber == number
                                    ? Colors.blueAccent
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              number,
                              style: TextStyle(
                                color: matchedNumbers.contains(number)
                                    ? Colors.white
                                    : selectedNumber == number
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedWord = word;
                            checkMatch();
                          });
                        },
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: matchedWords.contains(word)
                                ? Colors.lightBlueAccent
                                : selectedWord == word
                                    ? Colors.blueAccent
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              word,
                              style: TextStyle(
                                color: matchedWords.contains(word)
                                    ? Colors.white
                                    : selectedWord == word
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (showConfetti)
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  maxBlastForce: 100,
                  minBlastForce: 80,
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  gravity: 0.1,
                ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showConfetti = false;
              });
              widget.onNextQuestion();
            },
            child: Text('Next Question'),
          ),
        ],
      ),
    );
  }
}
