// To parse this JSON data, do
//
//     final panchayatResponse = panchayatResponseFromJson(jsonString);

import 'dart:convert';

PanchayatResponse panchayatResponseFromJson(String str) => PanchayatResponse.fromJson(json.decode(str));

String panchayatResponseToJson(PanchayatResponse data) => json.encode(data.toJson());

class PanchayatResponse {
  PanchayatResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<PanchayatClass> user;
  String error;
  String message;

  factory PanchayatResponse.fromJson(Map<String, dynamic> json) => PanchayatResponse(
    user: List<PanchayatClass>.from(json["user"].map((x) => PanchayatClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class PanchayatClass {
  PanchayatClass({
    this.id,
    this.pname,
    this.assemblyid,
    this.entrydt,
    this.lastmodifydt,
  });

  String? id;
  String? pname;
  String? assemblyid;
  String? entrydt;
  String? lastmodifydt;

  factory PanchayatClass.fromJson(Map<String, dynamic> json) => PanchayatClass(
    id: json["id"],
    pname: json["pname"],
    assemblyid: json["assemblyid"],
    entrydt: json["entrydt"],
    lastmodifydt: json["lastmodifydt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pname": pname,
    "assemblyid": assemblyid,
    "entrydt": entrydt,
    "lastmodifydt": lastmodifydt,
  };
}
