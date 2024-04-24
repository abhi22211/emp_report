// To parse this JSON data, do
//
//     final attendanceCoordinate = attendanceCoordinateFromJson(jsonString);

import 'dart:convert';

AttendanceCoordinate attendanceCoordinateFromJson(String str) {
  final jsonData = json.decode(str);
  return AttendanceCoordinate.fromJson(jsonData);
}

String attendanceCoordinateToJson(AttendanceCoordinate data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AttendanceCoordinate {
  List<Coordinate_Class>? data;
  String? success;
  String? message;

  AttendanceCoordinate({
    this.data,
    this.success,
    this.message,
  });

  factory AttendanceCoordinate.fromJson(Map<String, dynamic> json) =>  AttendanceCoordinate(
    data:  List<Coordinate_Class>.from(json["data"].map((x) => Coordinate_Class.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data":  List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "message": message,
  };
}

class Coordinate_Class {
  String? lat;
  String? lang;
  String? loaction;

  Coordinate_Class({
    this.lat,
    this.lang,
    this.loaction,
  });

  factory Coordinate_Class.fromJson(Map<String, dynamic> json) =>  Coordinate_Class(
    lat: json["lat"] == null ?"0.0":json["lat"],
    lang: json["lang"] == null ?"0.0":json["lang"],
    loaction: json["loaction"] == null ?"":json["loaction"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lang": lang,
    "loaction": loaction,
  };
}
