// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return ProfileResponse.fromJson(jsonData);
}

String profileResponseToJson(ProfileResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ProfileResponse {
  List<Profile_Class>? user;
  String? error;
  String? message;

  ProfileResponse({
    this.user,
    this.error,
    this.message,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>  ProfileResponse(
    user:  List<Profile_Class>.from(json["user"].map((x) => Profile_Class.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user":  List<dynamic>.from(user!.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class Profile_Class {
  String? empId;
  String? empName;
  String? empEmail;
  String? empCode;
  String? doj;
  String? empPhone;
  String? empAdress;
  String? blood_grp;
  String? emp_pass;
  String? workloaction;
  String? desgin_name;
  String? gender;
  String? metrial_status;
  String? dept_id;
  String? profileimg;
  String? create_date;
  String? leaving_date;
  String? rep_offer_id;
  String? emp_status;
  String? desg_name;
  String? depart_name;
  String? state_name;
  String? city_name;
  String? pincode;
  String? kycdoc;
  String? contactname;
  String? emecontactno;
  String? relation;
  String? qualifaction;
  String? percentage;
  String? boardname;
  String? passyear;
  String? bankname;
  String? branchname;
  String? accountno;
  String? ifsc;
  String? nomneename;
  String? nomineecontact;
  String? nomneerelation;

  Profile_Class({
    this.empId,
    this.empName,
    this.empEmail,
    this.empCode,
    this.doj,
    this.empPhone,
    this.empAdress,
    this.blood_grp,
    this.emp_pass,
    this.workloaction,
    this.desgin_name,
    this.gender,
    this.metrial_status,
    this.dept_id,
    this.profileimg,
    this.create_date,
    this.leaving_date,
    this.rep_offer_id,
    this.emp_status,
    this.desg_name,
    this.depart_name,
    this.state_name,
    this.city_name,
    this.pincode,
    this.kycdoc,
    this.contactname,
    this.emecontactno,
    this.relation,
    this.qualifaction,
    this.percentage,
    this.boardname,
    this.passyear,
    this.bankname,
    this.branchname,
    this.accountno,
    this.ifsc,
    this.nomneename,
    this.nomineecontact,
    this.nomneerelation,
  });

  factory Profile_Class.fromJson(Map<String, dynamic> json) =>  Profile_Class(
    empId: json["emp_id"],
    empName: json["emp_name"],
    empEmail: json["emp_email"],
    empCode: json["emp_code"],
    doj: json["doj"],
    empPhone: json["emp_phone"],
    empAdress: json["emp_adress"],
    blood_grp: json["blood_grp"],
    emp_pass: json["emp_pass"],
    workloaction: json["workloaction"],
    desgin_name: json["desgin_name"],
    gender: json["gender"],
    metrial_status: json["metrial_status"],
    dept_id: json["dept_id"],
    profileimg: json["profileimg"],
    create_date: json["create_date"],
    leaving_date: json["leaving_date"],
    rep_offer_id: json["rep_offer_id"],
    emp_status: json["emp_status"],
    desg_name: json["desg_name"],
    depart_name: json["depart_name"],
    state_name: json["state_name"],
    city_name: json["city_name"],
    pincode: json["pincode"],
    kycdoc: json["kycdoc"],
    contactname: json["contactname"],
    emecontactno: json["emecontactno"],
    relation: json["relation"],
    qualifaction: json["qualifaction"],
    percentage: json["percentage"],
    boardname: json["boardname"],
    passyear: json["passyear"],
    bankname: json["bankname"],
    branchname: json["branchname"],
    accountno: json["accountno"],
    ifsc: json["ifsc"],
    nomneename: json["nomneename"],
    nomineecontact: json["nomineecontact"],
    nomneerelation: json["nomneerelation"],
  );

  Map<String, dynamic> toJson() => {
    "emp_id": empId,
    "emp_name": empName,
    "emp_email": empEmail,
    "emp_code": empCode,
    "doj": doj,
    "emp_phone": empPhone,
    "emp_adress": empAdress,
    "blood_grp": blood_grp,
    "emp_pass": emp_pass,
    "workloaction": workloaction,
    "desgin_name": desgin_name,
    "gender": gender,
    "metrial_status": metrial_status,
    "dept_id": dept_id,
    "profileimg": profileimg,
    "create_date": create_date,
    "leaving_date": leaving_date,
    "rep_offer_id": rep_offer_id,
    "emp_status": emp_status,
    "desg_name": desg_name,
    "depart_name": depart_name,
    "state_name": state_name,
    "city_name": city_name,
    "pincode": pincode,
    "kycdoc": kycdoc,
    "contactname": contactname,
    "emecontactno": emecontactno,
    "relation": relation,
    "qualifaction": qualifaction,
    "percentage": percentage,
    "boardname": boardname,
    "passyear": passyear,
    "bankname": bankname,
    "branchname": branchname,
    "accountno": accountno,
    "ifsc": ifsc,
    "nomneename": nomneename,
    "nomineecontact": nomineecontact,
    "nomneerelation": nomneerelation,
  };
}
