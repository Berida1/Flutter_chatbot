// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

class UserProfileModel {
  UserProfileModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.id,
    this.firstName,
    this.otherNames,
    this.lastName,
    this.email,
    this.phone,
    this.age,
    this.owner,
  });

  int? id;
  String? firstName;
  String? otherNames;
  String? lastName;
  String? email;
  String? phone;
  int? age;
  int? owner;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["firstName"],
        otherNames: json["otherNames"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        age: json["age"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "otherNames": otherNames,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "age": age,
        "owner": owner,
      };
}
