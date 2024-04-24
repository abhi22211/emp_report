// To parse this JSON data, do
//
//     final districtResponse = districtResponseFromJson(jsonString);

import 'dart:convert';

DistrictResponse districtResponseFromJson(String str) => DistrictResponse.fromJson(json.decode(str));

String districtResponseToJson(DistrictResponse data) => json.encode(data.toJson());

class DistrictResponse {
  DistrictResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<DistrictClass> user;
  String error;
  String message;

  factory DistrictResponse.fromJson(Map<String, dynamic> json) => DistrictResponse(
    user: List<DistrictClass>.from(json["user"].map((x) => DistrictClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class DistrictClass {
  DistrictClass({
    this.id,
    this.dname,
    this.stateId,
    this.entrydt,
    this.did,
    this.lastmodifydt,
  });

  String? id;
  String? dname;
  String? stateId;
  DateTime? entrydt;
  String? did;
  DateTime? lastmodifydt;

  factory DistrictClass.fromJson(Map<String, dynamic> json) => DistrictClass(
    id: json["id"],
    dname: json["dname"],
    stateId: json["state_id"],
    entrydt: DateTime.parse(json["entrydt"]),
    did: json["did"],
    lastmodifydt: DateTime.parse(json["lastmodifydt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dname": dname,
    "state_id": stateId,
    "entrydt": entrydt?.toIso8601String(),
    "did": did,
    "lastmodifydt": lastmodifydt?.toIso8601String(),
  };
}
