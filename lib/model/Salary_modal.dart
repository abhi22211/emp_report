// To parse this JSON data, do
//
//     final salaryResponse = salaryResponseFromJson(jsonString);

import 'dart:convert';

SalaryResponse salaryResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SalaryResponse.fromJson(jsonData);
}

String salaryResponseToJson(SalaryResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class SalaryResponse {
  List<Salary_Class>? userdata;
  String? error;
  String? message;

  SalaryResponse({
    this.userdata,
    this.error,
    this.message,
  });

  factory SalaryResponse.fromJson(Map<String, dynamic> json) =>  SalaryResponse(
    userdata:  List<Salary_Class>.from(json["userdata"].map((x) => Salary_Class.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "userdata":  List<dynamic>.from(userdata!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class Salary_Class {
  String? id;
  String? empId;
  String? deptId;
  String? desginName;
  String? months;
  String? years;
  String? salarySlip;
  String? entrydt;
  String? modifydt;

  Salary_Class({
    this.id,
    this.empId,
    this.deptId,
    this.desginName,
    this.months,
    this.years,
    this.salarySlip,
    this.entrydt,
    this.modifydt,
  });

  factory Salary_Class.fromJson(Map<String, dynamic> json) =>  Salary_Class(
    id: json["id"] == null ? "" : json["id"],
    empId: json["emp_id"]== null ? "" : json["emp_id"],
    deptId: json["dept_id"]== null ? "" : json["dept_id"],
    desginName: json["desgin_name"]== null ? "" : json["desgin_name"],
    months: json["months"]== null ? "" : json["months"],
    years: json["years"]== null ? "" : json["years"],
    salarySlip: json["salary_slip"]== null ? "" : json["salary_slip"],
    entrydt: json["entrydt"]== null ? "" : json["entrydt"],
    modifydt: json["modifydt"]== null ? "" : json["modifydt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "emp_id": empId,
    "dept_id": deptId,
    "desgin_name": desginName,
    "months": months,
    "years": years,
    "salary_slip": salarySlip,
    "entrydt": entrydt,
    "modifydt": modifydt,
  };
}
