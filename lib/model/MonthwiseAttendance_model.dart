// To parse this JSON data, do
//
//     final attendanceMonthWiseResponse = attendanceMonthWiseResponseFromJson(jsonString);
import 'dart:convert';

AttendanceMonthWiseResponse attendanceMonthWiseResponseFromJson(String str) => AttendanceMonthWiseResponse.fromJson(json.decode(str));

String attendanceMonthWiseResponseToJson(AttendanceMonthWiseResponse data) => json.encode(data.toJson());

class AttendanceMonthWiseResponse {
  AttendanceMonthWiseResponse({
    required this.userdata,
    required this.error,
    required this.message,
  });

  List<MonthwiseAttendanceClass>? userdata;
  String error;
  String message;

  factory AttendanceMonthWiseResponse.fromJson(Map<String, dynamic> json) => AttendanceMonthWiseResponse(
    userdata: json["userdata"] == null ? null : List<MonthwiseAttendanceClass>.from(json["userdata"].map((x) => MonthwiseAttendanceClass.fromJson(x))),
    error: json["error"] == null ? null : json["error"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "userdata": userdata == null ? null : List<dynamic>.from(userdata!.map((x) => x.toJson())),
    "error": error == null ? null : error,
    "message": message == null ? null : message,
  };
}

class MonthwiseAttendanceClass {

  MonthwiseAttendanceClass({
    required this.atid,
    required this.id,
    required this.atdate,
    required this.atStatus,
    required this.empName,
  });

  String atid;
  String id;
  String atdate;
  String atStatus;
  String empName;

  factory MonthwiseAttendanceClass.fromJson(Map<String, dynamic> json) => MonthwiseAttendanceClass(
    atid: json["atid"] == null ? null : json["atid"],
    id: json["id"] == null ? null : json["id"],
    atdate: json["atdate"] == null ? null : json["atdate"],
    atStatus: json["at_status"] == null ? null : json["at_status"],
    empName: json["emp_name"] == null ? null : json["emp_name"],
  );

  Map<String, dynamic> toJson() => {
    "atid": atid == null ? null : atid,
    "id": id == null ? null : id,
    "atdate": atdate == null ? null : atdate,
    "at_status": atStatus == null ? null : atStatus,
    "emp_name": empName == null ? null : empName,
  };
}
