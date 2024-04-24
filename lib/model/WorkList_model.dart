// To parse this JSON data, do
//
//     final empWorkListResponse = empWorkListResponseFromJson(jsonString);

import 'dart:convert';

EmpWorkListResponse empWorkListResponseFromJson(String str) => EmpWorkListResponse.fromJson(json.decode(str));

String empWorkListResponseToJson(EmpWorkListResponse data) => json.encode(data.toJson());

class EmpWorkListResponse {
  EmpWorkListResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<EmpWorkClass> user;
  String error;
  String message;

  factory EmpWorkListResponse.fromJson(Map<String, dynamic> json) => EmpWorkListResponse(
    user: List<EmpWorkClass>.from(json["user"].map((x) => EmpWorkClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class EmpWorkClass {
  EmpWorkClass({
    required this.workReportId,
    required this.workDetail,
    required this.reportDate,
    required this.addDate,
    required this.empId,
  });

  String workReportId;
  String workDetail;
  DateTime reportDate;
  String addDate;
  String empId;

  factory EmpWorkClass.fromJson(Map<String, dynamic> json) => EmpWorkClass(
    workReportId: json["work_report_id"],
    workDetail: json["work_detail"],
    reportDate: DateTime.parse(json["report_date"]),
    addDate: json["add_date"],
    empId: json["emp_id"],
  );

  Map<String, dynamic> toJson() => {
    "work_report_id": workReportId,
    "work_detail": workDetail,
    "report_date": "${reportDate.year.toString().padLeft(4, '0')}-${reportDate.month.toString().padLeft(2, '0')}-${reportDate.day.toString().padLeft(2, '0')}",
    "add_date": addDate.toString(),
    "emp_id": empId,
  };
}
