// To parse this JSON data, do
//
//     final updateLeaveResponse = updateLeaveResponseFromJson(jsonString);

import 'dart:convert';

UpdateLeaveResponse updateLeaveResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return UpdateLeaveResponse.fromJson(jsonData);
}

String updateLeaveResponseToJson(UpdateLeaveResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UpdateLeaveResponse {
  List<LeaveUpdate_Class>? user;
  String? error;
  String? message;

  UpdateLeaveResponse({
    this.user,
    this.error,
    this.message,
  });

  factory UpdateLeaveResponse.fromJson(Map<String, dynamic> json) =>  UpdateLeaveResponse(
    user:  List<LeaveUpdate_Class>.from(json["user"].map((x) => LeaveUpdate_Class.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user":  List<dynamic>.from(user!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class LeaveUpdate_Class {
  String? id;
  String? title;
  String? message;
  String? leaveDate;
  String? status;
  String? empName;
  String? departName;
  String? empId;
  String? reportingId;

  LeaveUpdate_Class({
    this.id,
    this.title,
    this.message,
    this.leaveDate,
    this.status,
    this.empName,
    this.departName,
    this.empId,
    this.reportingId,
  });

  factory LeaveUpdate_Class.fromJson(Map<String, dynamic> json) =>  LeaveUpdate_Class(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    leaveDate: json["leave_date"],
    status: json["status"],
    empName: json["emp_name"],
    departName: json["depart_name"],
    empId: json["emp_id"],
    reportingId: json["reporting_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "leave_date": leaveDate,
    "status": status,
    "emp_name": empName,
    "depart_name": departName,
    "emp_id": empId,
    "reporting_id": reportingId,
  };
}
