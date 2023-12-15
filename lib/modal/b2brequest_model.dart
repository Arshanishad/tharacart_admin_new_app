// To parse this JSON data, do
//
//     final b2BRequestModel = b2BRequestModelFromJson(jsonString);

import 'dart:convert';

B2BRequestModel b2BRequestModelFromJson(String str) => B2BRequestModel.fromJson(json.decode(str));

String b2BRequestModelToJson(B2BRequestModel data) => json.encode(data.toJson());

class B2BRequestModel {
  String? gstin;
  String? documentType;
  bool ?ebExtension;
  bool? ebMcc;
  String? ebZone;
  String? email;
  bool? extension;
  String? idBack;
  String? idFront;
  String? imageUrl;
  bool? mcc;
  String? officialNo;
  String? pANumber;
  num? status;
  Map? taxpayerInfo;
  DateTime? time;
  String? userId;
  String ?userName;
  String ?zone;

  B2BRequestModel({
     this.gstin,
     this.documentType,
     this.ebExtension,
     this.ebMcc,
     this.ebZone,
     this.email,
     this.extension,
     this.idBack,
     this.idFront,
     this.imageUrl,
     this.mcc,
     this.officialNo,
     this.pANumber,
     this.status,
     this.taxpayerInfo,
     this.time,
     this.userId,
     this.userName,
     this.zone,
  });

  B2BRequestModel copyWith({
    String? gstin,
    String? documentType,
    bool? ebExtension,
    bool? ebMcc,
    String? ebZone,
    String? email,
    bool? extension,
    String? idBack,
    String? idFront,
    String? imageUrl,
    bool? mcc,
    String? officialNo,
    String? pANumber,
    num? status,
    Map? taxpayerInfo,
    DateTime? time,
    String? userId,
    String? userName,
    String? zone,
  }) =>
      B2BRequestModel(
        gstin: gstin ?? this.gstin,
        documentType: documentType ?? this.documentType,
        ebExtension: ebExtension ?? this.ebExtension,
        ebMcc: ebMcc ?? this.ebMcc,
        ebZone: ebZone ?? this.ebZone,
        email: email ?? this.email,
        extension: extension ?? this.extension,
        idBack: idBack ?? this.idBack,
        idFront: idFront ?? this.idFront,
        imageUrl: imageUrl ?? this.imageUrl,
        mcc: mcc ?? this.mcc,
        officialNo: officialNo ?? this.officialNo,
        pANumber: pANumber ?? this.pANumber,
        status: status ?? this.status,
        taxpayerInfo: taxpayerInfo ?? this.taxpayerInfo,
        time: time ?? this.time,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        zone: zone ?? this.zone,
      );
  factory B2BRequestModel.fromJson(Map<String, dynamic> json) => B2BRequestModel(
    gstin: json["GSTIN"] ?? "",
    documentType: json["documentType"] ?? "",
    ebExtension: json["ebExtension"] is bool ? json["ebExtension"] : false,
    ebMcc: json["ebMcc"] is bool ? json["ebMcc"] : false,
    ebZone: json["ebZone"] ?? "",
    email: json["email"] ?? "",
    extension: json["extension"] is bool ? json["extension"] : false,
    idBack: json["idBack"] ?? "",
    idFront: json["idFront"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
    mcc: json["mcc"] is bool ? json["mcc"] : false,
    officialNo: json["officialNo"] ?? "",
    pANumber: json["p/aNumber"] ?? "",
    status: json['status'] != null ? json['status'] is double ? json['status'] : json['status'].toDouble() : 0,
    taxpayerInfo: json["taxpayerInfo"] ?? {},
    time: json['time'] != null ? DateTime.now() : json['time'] is String ? DateTime.parse(json['time']) : json['time'].toDate(),
    userId: json["userId"] ?? "",
    userName: json["userName"] ?? "",
    zone: json["zone"] ?? "",
  );



  Map<String, dynamic> toJson() => {
    "GSTIN": gstin,
    "documentType": documentType,
    "ebExtension": ebExtension,
    "ebMcc": ebMcc,
    "ebZone": ebZone,
    "email": email,
    "extension": extension,
    "idBack": idBack,
    "idFront": idFront,
    "imageUrl": imageUrl,
    "mcc": mcc,
    "officialNo": officialNo,
    "p/aNumber": pANumber,
    "status": status,
    "taxpayerInfo": taxpayerInfo,
    "time": time,
    "userId": userId,
    "userName": userName,
    "zone": zone,
  };
}

