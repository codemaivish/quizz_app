import 'dart:convert';
import 'package:flutter/services.dart';

class Question {
  final String type;
  final List<Map<String, String>>? options;
  final String? question;
  final List<String>? extraWords;
  final String? answer; // Include the answer property

  Question({
    required this.type,
    this.options,
    this.question,
    this.extraWords,
    this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'] as String,
      options: json['options'] != null
          ? (json['options'] as List)
              .map((item) => Map<String, String>.from(item as Map))
              .toList()
          : null,
      question: json['question'] as String?,
      extraWords: json['extra_words'] != null
          ? List<String>.from(json['extra_words'] as List)
          : null,
      answer: json['answer'] as String?, // Parse the answer from JSON
    );
  }
}

List<Question> loadQuestionsFromJson(String jsonString) {
  final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
  return (jsonData['questions'] as List)
      .map((item) => Question.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<Question>> loadQuestionsFromJsonFile(String filePath) async {
  String jsonString = await rootBundle.loadString(filePath);
  List<Question> questions = loadQuestionsFromJson(jsonString);
  return questions;
}
