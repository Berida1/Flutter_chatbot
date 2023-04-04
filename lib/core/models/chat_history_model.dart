// To parse this JSON data, do
//
//     final chatHistoryModel = chatHistoryModelFromJson(jsonString);

import 'dart:convert';

ChatHistoryModel chatHistoryModelFromJson(String str) =>
    ChatHistoryModel.fromJson(json.decode(str));

class ChatHistoryModel {
  ChatHistoryModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum>? data;

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoryModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    this.id,
    this.question,
    this.answer,
    this.owner,
  });

  int? id;
  String? question;
  String? answer;
  int? owner;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "owner": owner,
      };
}
