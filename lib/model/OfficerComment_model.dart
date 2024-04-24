// To parse this JSON data, do
//
//     final officerResponse = officerResponseFromJson(jsonString);

import 'dart:convert';

OfficerResponse officerResponseFromJson(String str) => OfficerResponse.fromJson(json.decode(str));

String officerResponseToJson(OfficerResponse data) => json.encode(data.toJson());

class OfficerResponse {
  OfficerResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<OfficerReply> user;
  String error;
  String message;

  factory OfficerResponse.fromJson(Map<String, dynamic> json) => OfficerResponse(
    user: List<OfficerReply>.from(json["user"].map((x) => OfficerReply.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class OfficerReply {
  OfficerReply({
    required this.msId,
    required this.msById,
    required this.message,
    required this.msToId,
    required this.msDate,
  });

  String msId;
  String msById;
  String message;
  String msToId;
  DateTime msDate;

  factory OfficerReply.fromJson(Map<String, dynamic> json) => OfficerReply(
    msId: json["ms_id"],
    msById: json["ms_by_id"],
    message: json["message"],
    msToId: json["ms_to_id"],
    msDate: DateTime.parse(json["ms_date"]),
  );

  Map<String, dynamic> toJson() => {
    "ms_id": msId,
    "ms_by_id": msById,
    "message": message,
    "ms_to_id": msToId,
    "ms_date": msDate.toString(),
  };
}
