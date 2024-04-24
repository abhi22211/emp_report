// To parse this JSON data, do
//
//     final leaveListResponse = leaveListResponseFromJson(jsonString);

import 'dart:convert';

LeaveListResponse leaveListResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return LeaveListResponse.fromJson(jsonData);
}

String leaveListResponseToJson(LeaveListResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LeaveListResponse {
  List<EmployeeLeaveList_Class>? user;
  String? error;
  String? message;

  LeaveListResponse({
    this.user,
    this.error,
    this.message,
  });

  factory LeaveListResponse.fromJson(Map<String, dynamic> json) =>  LeaveListResponse(
    user:  List<EmployeeLeaveList_Class>.from(json["user"].map((x) => EmployeeLeaveList_Class.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user":  List<dynamic>.from(user!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class EmployeeLeaveList_Class {
  String? empName;
  String? empCode;
  String? desgName;
  String? departName;
  String? leaveDate;
  String? empId;
  String? status;
  String? id;

  EmployeeLeaveList_Class({
    this.empName,
    this.empCode,
    this.desgName,
    this.departName,
    this.leaveDate,
    this.empId,
    this.status,
    this.id,
  });

  factory EmployeeLeaveList_Class.fromJson(Map<String, dynamic> json) =>  EmployeeLeaveList_Class(
    empName: json["emp_name"],
    empCode: json["emp_code"],
    desgName: json["desg_name"],
    departName: json["depart_name"],
    leaveDate: json["leave_date"],
    empId: json["emp_id"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "emp_name": empName,
    "emp_code": empCode,
    "desg_name": desgName,
    "depart_name": departName,
    "leave_date": leaveDate,
    "emp_id": empId,
    "status": status,
    "id": id,
  };
}
