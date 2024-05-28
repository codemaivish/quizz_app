import 'package:flutter/material.dart';
import 'package:quizz_app/model/quiz_question.dart';
import 'package:collection/collection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      // Load the audio file from assets
      final ByteData data =
          await rootBundle.load('assets/audio/question_audio.mp3');
      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      // Create a temporary file
      final File tempFile = File('${tempDir.path}/question_audio.mp3');
      // Write the data to the temporary file
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      // Play the audio file from the temporary file
      await audioPlayer.play(DeviceFileSource(tempFile.path));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _checkAnswer() {
    String answer = tappedWords.join(' ');
    if (answer == widget.question.answer) {
      widget.onNextQuestion();
    } else {
      _showAlertDialog('Wrong Answer', 'Please try again.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
        );
      },
    );
  }

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
          Image.asset('assets/download.jpeg',
              height: 150), // Add your image here
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the main question text
              Expanded(
                child: Text(
                  widget.question.question!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: _playAudio,
              ),
            ],
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
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _checkAnswer,
            child: Text('Next Question'),
          ),
        ],
      ),
    );
  }
}
