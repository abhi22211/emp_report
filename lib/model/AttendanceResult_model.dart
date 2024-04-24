// To parse this JSON data, do
//
//     final attendanceResultResponse = attendanceResultResponseFromJson(jsonString);

import 'dart:convert';

AttendanceResultResponse attendanceResultResponseFromJson(String str) => AttendanceResultResponse.fromJson(json.decode(str));

String attendanceResultResponseToJson(AttendanceResultResponse data) => json.encode(data.toJson());

class AttendanceResultResponse {
  AttendanceResultResponse({
    required this.userdata,
    required this.error,
    required this.message,
  });

  List<AttendanceClass>? userdata;
  String error;
  String message;

  factory AttendanceResultResponse.fromJson(Map<String, dynamic> json) => AttendanceResultResponse(
    userdata: json["userdata"] == null ? null : List<AttendanceClass>.from(json["userdata"].map((x) => AttendanceClass.fromJson(x))),
    error: json["error"] == null ? null : json["error"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "userdata": userdata == null ? null : List<dynamic>.from(userdata!.map((x) => x.toJson())),
    "error": error == null ? null : error,
    "message": message == null ? null : message,
  };
}

class AttendanceClass {
  AttendanceClass({
    required this.attendence_id,
    required this.atStatus,
    required this.empName,
    required this.empId,
  });

  String attendence_id;
  String atStatus;
  String empName;
  String empId;

  factory AttendanceClass.fromJson(Map<String, dynamic> json) => AttendanceClass(
    attendence_id: json["attendence_id"] == null ? null : json["attendence_id"],
    atStatus: json["at_status"] == null ? null : json["at_status"],
    empName: json["emp_name"] == null ? null : json["emp_name"],
    empId: json["emp_id"] == null ? null : json["emp_id"],
  );

  Map<String, dynamic> toJson() => {
    "attendence_id": attendence_id == null ? null : attendence_id,
    "at_status": atStatus == null ? null : atStatus,
    "emp_name": empName == null ? null : empName,
    "emp_id": empId == null ? null : empId,
  };
}
