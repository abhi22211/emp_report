// To parse this JSON data, do
//
//     final attendanceCountResponse = attendanceCountResponseFromJson(jsonString);

import 'dart:convert';

AttendanceCountResponse attendanceCountResponseFromJson(String str) => AttendanceCountResponse.fromJson(json.decode(str));

String attendanceCountResponseToJson(AttendanceCountResponse data) => json.encode(data.toJson());

class AttendanceCountResponse {
  AttendanceCountResponse({
    required this.status,
    required this.error,
    required this.message,
  });

  AttendanceCount? status;
  String error;
  String message;

  factory AttendanceCountResponse.fromJson(Map<String, dynamic> json) => AttendanceCountResponse(
    status: json["status"] == null ? null : AttendanceCount.fromJson(json["status"]),
    error: json["error"] == null ? null : json["error"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status!.toJson(),
    "error": error == null ? null : error,
    "message": message == null ? null : message,
  };
}

class AttendanceCount {
  AttendanceCount({
    required this.ttlpresent,
    required this.ttlabsent,
    required this.ttlleave,
    required this.ttlholiyday,
  });

  String ttlpresent;
  String ttlabsent;
  String ttlleave;
  String ttlholiyday;

  factory AttendanceCount.fromJson(Map<String, dynamic> json) => AttendanceCount(
    ttlpresent: json["ttlpresent"] == null ? "" : json["ttlpresent"],
    ttlabsent: json["ttlabsent"] == null ? "" : json["ttlabsent"],
    ttlleave: json["ttlleave"] == null ? "" : json["ttlleave"],
    ttlholiyday: json["ttlholiyday"] == null ? "" : json["ttlholiyday"],
  );

  Map<String, dynamic> toJson() => {
    "ttlpresent": ttlpresent == null ? null : ttlpresent,
    "ttlabsent": ttlabsent == null ? null : ttlabsent,
    "ttlleave": ttlleave == null ? null : ttlleave,
    "ttlholiyday": ttlholiyday == null ? null : ttlholiyday,
  };
}
