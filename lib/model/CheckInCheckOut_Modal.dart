// To parse this JSON data, do
//
//     final checkInCheckOutResponse = checkInCheckOutResponseFromJson(jsonString);

import 'dart:convert';

CheckInCheckOutResponse checkInCheckOutResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return CheckInCheckOutResponse.fromJson(jsonData);
}

String checkInCheckOutResponseToJson(CheckInCheckOutResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CheckInCheckOutResponse {
  List<CheckInCheckOut_Class>? user;
  int? error;
  String? message;

  CheckInCheckOutResponse({
    this.user,
    this.error,
    this.message,
  });

  factory CheckInCheckOutResponse.fromJson(Map<String, dynamic> json) =>  CheckInCheckOutResponse(
    user:  List<CheckInCheckOut_Class>.from(json["user"].map((x) => CheckInCheckOut_Class.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user":  List<dynamic>.from(user!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class CheckInCheckOut_Class {
  String? id;
  String? empId;
  String? reportingId;
  String? attendenceId;
  String? atdate;
  String? intime;
  String? outtime;
  String? createdAt;

  CheckInCheckOut_Class({
    this.id,
    this.empId,
    this.reportingId,
    this.attendenceId,
    this.atdate,
    this.intime,
    this.outtime,
    this.createdAt,
  });

  factory CheckInCheckOut_Class.fromJson(Map<String, dynamic> json) =>  CheckInCheckOut_Class(
    id: json["id"],
    empId: json["emp_id"],
    reportingId: json["reporting_id"],
    attendenceId: json["attendence_id"],
    atdate: json["atdate"],
    intime: json["intime"] == null?"":json["intime"],
    outtime: json["outtime"] == null?"":json["outtime"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "emp_id": empId,
    "reporting_id": reportingId,
    "attendence_id": attendenceId,
    "atdate": atdate,
    "intime": intime,
    "outtime": outtime,
    "created_at": createdAt,
  };
}
