// To parse this JSON data, do
//
//     final stateResponse = stateResponseFromJson(jsonString);

import 'dart:convert';

StateResponse stateResponseFromJson(String str) => StateResponse.fromJson(json.decode(str));

String stateResponseToJson(StateResponse data) => json.encode(data.toJson());

class StateResponse {
  StateResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<StateClass> user;
  String error;
  String message;


  factory StateResponse.fromJson(Map<String, dynamic> json) => StateResponse(
    user: List<StateClass>.from(json["user"].map((x) => StateClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class StateClass {
  StateClass({
    this.id,
    this.sname,
  });

  String? id;
  String? sname;

  factory StateClass.fromJson(Map<String, dynamic> json) => StateClass(
    id: json["id"],
    sname: json["sname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sname": sname,
  };
}
