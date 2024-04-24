// To parse this JSON data, do
//
//     final officersViewSurveyListResponse = officersViewSurveyListResponseFromJson(jsonString);

import 'dart:convert';

OfficersViewSurveyListResponse officersViewSurveyListResponseFromJson(String str) => OfficersViewSurveyListResponse.fromJson(json.decode(str));

String officersViewSurveyListResponseToJson(OfficersViewSurveyListResponse data) => json.encode(data.toJson());

class OfficersViewSurveyListResponse {
  OfficersViewSurveyListResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<OfficersviewSLclass> user;
  String error;
  String message;

  factory OfficersViewSurveyListResponse.fromJson(Map<String, dynamic> json) => OfficersViewSurveyListResponse(
    user: List<OfficersviewSLclass>.from(json["user"].map((x) => OfficersviewSLclass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class OfficersviewSLclass {

  OfficersviewSLclass({
    required this.id,
    required this.empId,
    required this.stateId,
    required this.distrctId,
    required this.assemblyId,
    required this.panchyatId,
    required this.wardId,
    required this.clientName,
    required this.clientMobile,
    //required this.image1,
    required this.knowRasaya,
    required this.isApp,
    required this.description,
    required this.createdAt,
    required this.sname,
    required this.dname,
    required this.asname,
    required this.pname,
    required this.wname,
  });

  String id;
  String empId;
  String stateId;
  String distrctId;
  String assemblyId;
  String panchyatId;
  String wardId;
  String clientName;
  String clientMobile;
  //String image1;
  String knowRasaya;
  String isApp;
  String description;
  DateTime createdAt;
  String sname;
  String dname;
  String asname;
  String pname;
  String wname;

  factory OfficersviewSLclass.fromJson(Map<String, dynamic> json) => OfficersviewSLclass(
    id: json["id"],
    empId: json["emp_id"],
    stateId: json["state_id"],
    distrctId: json["distrct_id"],
    assemblyId: json["assembly_id"],
    panchyatId: json["panchyat_id"],
    wardId: json["ward_id"],
    clientName: json["client_name"],
    clientMobile: json["client_mobile"],
    //image1: json["image1"],
    knowRasaya: json["know_rasaya"],
    isApp: json["is_app"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    sname: json["sname"],
    dname: json["dname"],
    asname: json["asname"],
    pname: json["pname"],
    wname: json["wname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "emp_id": empId,
    "state_id": stateId,
    "distrct_id": distrctId,
    "assembly_id": assemblyId,
    "panchyat_id": panchyatId,
    "ward_id": wardId,
    "client_name": clientName,
    "client_mobile": clientMobile,
    //"image1": image1,
    "know_rasaya": knowRasaya,
    "is_app": isApp,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "sname": sname,
    "dname": dname,
    "asname": asname,
    "pname": pname,
    "wname": wname,
  };
}
