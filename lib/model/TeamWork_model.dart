// To parse this JSON data, do
//
//     final teamResponse = teamResponseFromJson(jsonString);

import 'dart:convert';

TeamResponse teamResponseFromJson(String str) => TeamResponse.fromJson(json.decode(str));

String teamResponseToJson(TeamResponse data) => json.encode(data.toJson());

class TeamResponse {
  TeamResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<TeamWorkClass> user;
  String error;
  String message;

  factory TeamResponse.fromJson(Map<String, dynamic> json) => TeamResponse(
    user: List<TeamWorkClass>.from(json["user"].map((x) => TeamWorkClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class TeamWorkClass {
  TeamWorkClass({
    required this.workDetail,
    required this.workReportId,
    required this.reportDate,
    required this.empId,
    required this.empName,
    required this.desginName,
    required this.departName,
    required this.desgName,
    required this.message,
  });

  String workDetail;
  String workReportId;
  DateTime reportDate;
  String empId;
  String empName;
  String desginName;
  String departName;
  String desgName;
  String message;

  factory TeamWorkClass.fromJson(Map<String, dynamic> json) => TeamWorkClass(
    workDetail: json["work_detail"],
    workReportId: json["work_report_id"],
    reportDate: DateTime.parse(json["report_date"]),
    empId: json["emp_id"],
    empName: json["emp_name"],
    desginName: json["desgin_name"],
    departName: json["depart_name"],
    desgName: json["desg_name"],
    message: json["message"] == null ? "" :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "work_detail": workDetail,
    "work_report_id": workReportId,
    "report_date": "${reportDate.year.toString().padLeft(4, '0')}-${reportDate.month.toString().padLeft(2, '0')}-${reportDate.day.toString().padLeft(2, '0')}",
    "emp_id": empId,
    "emp_name": empName,
    "desgin_name": desginName,
    "depart_name": departName,
    "desg_name": desgName,
    "message": message == null ? null :message,
  };
}
