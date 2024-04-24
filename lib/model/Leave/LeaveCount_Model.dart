// To parse this JSON data, do
//
//     final leaveCountResponse = leaveCountResponseFromJson(jsonString);

import 'dart:convert';

LeaveCount_Class leaveCountResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return LeaveCount_Class.fromJson(jsonData);
}

String leaveCountResponseToJson(LeaveCount_Class data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LeaveCount_Class {
  String? ttlleave;
  String? error;
  String? message;

  LeaveCount_Class({
    this.ttlleave,
    this.error,
    this.message,
  });

  factory LeaveCount_Class.fromJson(Map<String, dynamic> json) =>  LeaveCount_Class(
    ttlleave: json["ttlleave"],
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "ttlleave": ttlleave,
    "error": error,
    "message": message,
  };
}
