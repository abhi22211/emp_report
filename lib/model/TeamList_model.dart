// To parse this JSON data, do
//
//     final teamListResponse = teamListResponseFromJson(jsonString);

import 'dart:convert';

TeamListResponse teamListResponseFromJson(String str) => TeamListResponse.fromJson(json.decode(str));

String teamListResponseToJson(TeamListResponse data) => json.encode(data.toJson());

class TeamListResponse {
  TeamListResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<TeamList> user;
  String error;
  String message;

  factory TeamListResponse.fromJson(Map<String, dynamic> json) => TeamListResponse(
    user: List<TeamList>.from(json["user"].map((x) => TeamList.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}
class TeamList {
  TeamList({
     this.emp_id,
     this.emp_name,
     this.emp_email,
     this.emp_code,
     this.doj,
     this.emp_adress,
     this.emp_pass,
     this.dept_id,
     this.depart_name,
     this.desg_name,
     this.emp_phone,
     this.blood_grp,
     this.emp_status,
     this.profileimg,
     this.gender,
     this.metrial_status,
     this.workloaction,
  });

  String? emp_id;
  String? emp_name;
  String? emp_email;
  String? emp_code;
  String? doj;
  String? emp_adress;
  String? emp_pass;
  String? dept_id;
  String? depart_name;
  String? desg_name;
  String? emp_phone;
  String? blood_grp;
  String? emp_status;
  String? profileimg;
  String? gender;
  String? metrial_status;
  String? workloaction;

  factory TeamList.fromJson(Map<String, dynamic> json) => TeamList(
    emp_id: json["emp_id"],
    emp_name: json["emp_name"],
    emp_email: json["emp_email"],
    emp_code: json["emp_code"],
    doj: json["doj"],
    emp_adress: json["emp_adress"],
    emp_pass: json["emp_pass"],
    dept_id: json["dept_id"],
    depart_name: json["depart_name"],
    desg_name: json["desg_name"],
    emp_phone: json["emp_phone"],
    blood_grp: json["blood_grp"],
    emp_status: json["emp_status"],
    profileimg: json["profileimg"] == null ? "":json["profileimg"],
    gender: json["gender"],
    metrial_status: json["metrial_status"],
    workloaction: json["workloaction"],
  );

  Map<String, dynamic> toJson() => {
    "emp_id": emp_id,
    "emp_name": emp_name,
    "emp_email": emp_email,
    "emp_code": emp_code,
    "doj": doj,
    "emp_adress": emp_adress,
    "emp_pass": emp_pass,
    "dept_id": dept_id,
    "depart_name": depart_name,
    "desg_name": desg_name,
    "emp_phone": emp_phone,
    "blood_grp": blood_grp,
    "emp_status": emp_status,
    "profileimg": profileimg,
    "gender": gender,
    "metrial_status": metrial_status,
    "workloaction": workloaction,
  };
}
