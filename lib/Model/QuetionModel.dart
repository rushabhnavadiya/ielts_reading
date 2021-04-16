// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/services.dart';
Future<QuestionModel> loadQuestionData() async {
  final data = await rootBundle.loadString("assets/AC_reading.json");
  return questionModelFromJson(data);
}
QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  QuestionModel({
    this.data,
  });

  List<Questions> data;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    data: List<Questions>.from(json["data"].map((x) => Questions.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Questions {
  Questions({
    this.id,
    this.question,
  });

  String id;
  String question;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
    id: json["id"],
    question: json["Question"] == null ? null : json["Question"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Question": question == null ? null : question,
  };
}
