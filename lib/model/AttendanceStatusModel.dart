// To parse this JSON data, do
//
//     final attendanceStatusResponse = attendanceStatusResponseFromJson(jsonString);

import 'dart:convert';

AttendanceStatusResponse attendanceStatusResponseFromJson(String str) => AttendanceStatusResponse.fromJson(json.decode(str));

String attendanceStatusResponseToJson(AttendanceStatusResponse data) => json.encode(data.toJson());

class AttendanceStatusResponse {
  AttendanceStatusResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<AttendanceStatusClass>? user;
  String error;
  String message;

  factory AttendanceStatusResponse.fromJson(Map<String, dynamic> json) => AttendanceStatusResponse(
    user: json["user"] == null ? null : List<AttendanceStatusClass>.from(json["user"].map((x) => AttendanceStatusClass.fromJson(x))),
    error: json["error"] == null ? null : json["error"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": user == null ? null : List<dynamic>.from(user!.map((x) => x.toJson())),
    "error": error == null ? null : error,
    "message": message == null ? null : message,
  };
}

class AttendanceStatusClass {
  AttendanceStatusClass({
    required this.id,
    required this.atStatus,
    required this.status,
  });

  String id;
  String atStatus;
  String status;

  factory AttendanceStatusClass.fromJson(Map<String, dynamic> json) => AttendanceStatusClass(
    id: json["id"] == null ? null : json["id"],
    atStatus: json["at_status"] == null ? null : json["at_status"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "at_status": atStatus == null ? null : atStatus,
    "status": status == null ? null : status,
  };
}
