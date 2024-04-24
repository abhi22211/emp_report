// To parse this JSON data, do
//
//     final wardResponse = wardResponseFromJson(jsonString);

import 'dart:convert';

WardResponse wardResponseFromJson(String str) => WardResponse.fromJson(json.decode(str));

String wardResponseToJson(WardResponse data) => json.encode(data.toJson());

class WardResponse {
  WardResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<WardClass> user;
  String error;
  String message;

  factory WardResponse.fromJson(Map<String, dynamic> json) => WardResponse(
    user: List<WardClass>.from(json["user"].map((x) => WardClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class WardClass {
  WardClass({
    this.id,
    this.wname,
    this.panchhayatId,
    this.entrydt,
    this.lastmodifydt,
  });

  String? id;
  String? wname;
  String? panchhayatId;
  String? entrydt;
  String? lastmodifydt;

  factory WardClass.fromJson(Map<String, dynamic> json) => WardClass(
    id: json["id"],
    wname: json["wname"],
    panchhayatId: json["panchhayat_id"],
    entrydt: json["entrydt"],
    lastmodifydt: json["lastmodifydt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "wname": wname,
    "panchhayat_id": panchhayatId,
    "entrydt": entrydt,
    "lastmodifydt": lastmodifydt,
  };
}
