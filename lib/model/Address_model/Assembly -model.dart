// To parse this JSON data, do
//
//     final assemblyResponse = assemblyResponseFromJson(jsonString);

import 'dart:convert';

AssemblyResponse assemblyResponseFromJson(String str) => AssemblyResponse.fromJson(json.decode(str));

String assemblyResponseToJson(AssemblyResponse data) => json.encode(data.toJson());

class AssemblyResponse {
  AssemblyResponse({
    required this.user,
    required this.error,
    required this.message,
  });

  List<AssemblyClass> user;
  String error;
  String message;

  factory AssemblyResponse.fromJson(Map<String, dynamic> json) => AssemblyResponse(
    user: List<AssemblyClass>.from(json["user"].map((x) => AssemblyClass.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class AssemblyClass {
  AssemblyClass({
    this.id,
    this.asname,
    this.districtId,
    this.assemblycode,
    this.entrydt,
    this.lastmodifydt,
  });

  String? id;
  String? asname;
  String? districtId;
  String? assemblycode;
  String? entrydt;
  String? lastmodifydt;

  factory AssemblyClass.fromJson(Map<String, dynamic> json) => AssemblyClass(
    id: json["id"],
    asname: json["asname"],
    districtId: json["district_id"],
    assemblycode: json["assemblycode"],
    entrydt: json["entrydt"],
    lastmodifydt: json["lastmodifydt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "asname": asname,
    "district_id": districtId,
    "assemblycode": assemblycode,
    "entrydt": entrydt,
    "lastmodifydt": lastmodifydt,
  };
}
