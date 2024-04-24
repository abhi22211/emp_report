// To parse this JSON data, do
//
//     final bannerResponse = bannerResponseFromJson(jsonString);

import 'dart:convert';

BannerResponse bannerResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return BannerResponse.fromJson(jsonData);
}

String bannerResponseToJson(BannerResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BannerResponse {
  List<Banner_class>? user;
  String? textmessage;

  BannerResponse({
    this.user,
    this.textmessage,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) => new BannerResponse(
    user: new List<Banner_class>.from(json["user"].map((x) => Banner_class.fromJson(x))),
    textmessage: json["textmessage"],
  );

  Map<String, dynamic> toJson() => {
    "user": new List<dynamic>.from(user!.map((x) => x.toJson())),
    "textmessage": textmessage,
  };
}

class Banner_class {
  String? bannerImage;

  Banner_class({
    this.bannerImage,
  });

  factory Banner_class.fromJson(Map<String, dynamic> json) => new Banner_class(
    bannerImage: json["banner_image"],
  );

  Map<String, dynamic> toJson() => {
    "banner_image": bannerImage,
  };
}
