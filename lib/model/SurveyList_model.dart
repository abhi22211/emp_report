// To parse this JSON data, do
//
//     final surveyListResponse = surveyListResponseFromJson(jsonString);

import 'dart:convert';

SurveyListResponse surveyListResponseFromJson(String str) => SurveyListResponse.fromJson(json.decode(str));

String surveyListResponseToJson(SurveyListResponse data) => json.encode(data.toJson());

class SurveyListResponse {
  SurveyListResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<SurveyClass>? user;
  String error;
  String message;

  factory SurveyListResponse.fromJson(Map<String, dynamic> json) => SurveyListResponse(
    user: json["user"] == null ? null : List<SurveyClass>.from(json["user"].map((x) => SurveyClass.fromJson(x))),
    error: json["error"] == null ? null : json["error"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": user == null ? null : List<dynamic>.from(user!.map((x) => x.toJson())),
    "error": error == null ? null : error,
    "message": message == null ? null : message,
  };
}

class SurveyClass {
  SurveyClass({
    this.id,
    this.empId,
    this.clientName,
    this.clientMobile,
    this.knowRasaya,
    this.isApp,
    this.description,
    this.createdAt,
    this.sname,
    this.dname,
    this.asname,
    this.pname,
    this.wname,
    this.image1,
  });

  String? id;
  String? empId;
  String? clientName;
  String? clientMobile;
  String? knowRasaya;
  String? isApp;
  String? description;
  String? createdAt;
  String? sname;
  String? dname;
  String? asname;
  String? pname;
  String? wname;
  String? image1;

  factory SurveyClass.fromJson(Map<String, dynamic> json) => SurveyClass(
    id: json["id"] == null ? null : json["id"],
    empId: json["emp_id"] == null ? null : json["emp_id"],
    clientName: json["client_name"] == null ? null : json["client_name"],
    clientMobile: json["client_mobile"]== null ? null :json["client_mobile"],
    knowRasaya: json["know_rasaya"] == null ? null : json["know_rasaya"],
    isApp: json["is_app"] == null ? null : json["is_app"],
    description: json["description"] == null ? null : json["description"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    sname: json["sname"] == null ? null : json["sname"],
    dname: json["dname"] == null ? null : json["dname"],
    asname: json["asname"] == null ? null : json["asname"],
    pname: json["pname"] == null ? null : json["pname"],
    wname: json["wname"] == null ? null : json["wname"],
    image1: json["image1"] == null ? null : json["image1"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "emp_id": empId == null ? null : empId,
    "client_name": clientName == null ? null : clientName,
    "client_mobile": clientMobile == null ? null :clientMobile,
    "know_rasaya": knowRasaya == null ? null : knowRasaya,
    "is_app": isApp == null ? null : isApp,
    "description": description == null ? null : description,
    "created_at": createdAt == null ? null : createdAt,
    "sname": sname == null ? null : sname,
    "dname": dname == null ? null : dname,
    "asname": asname == null ? null : asname,
    "pname": pname == null ? null : pname,
    "wname": wname == null ? null : wname,
    "image1": image1 == null ? null : image1,
  };
}
