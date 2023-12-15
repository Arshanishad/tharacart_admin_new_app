
class AdminModel {
  bool verified;
  DateTime created_time;
  String uid;
  String email;
  bool delete;
  String photo_url;
  String display_name;

  AdminModel({
    required this.verified,
    required this.created_time,
    required this.uid,
    required this.email,
    required this.delete,
    required this.photo_url,
    required this.display_name,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
        verified: json['verified'] as bool ,
        created_time: json['created_time'].toDate(),
        uid: json['uid'] as String,
        email: json['email'] as String,
        delete: json['delete'] as bool ,
        photo_url: json['photo_url'] as String,
        display_name: json['display_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["verified"] = verified ?? this.verified;
    data["created_time"] = created_time ?? this.created_time;
    data["uid"] = uid ?? this.uid;
    data["email"] = email ?? this.email;
    data["delete"] = delete ?? this.delete;
    data["photo_url"] = photo_url ?? this.photo_url;
    data["display_name"] =display_name ?? this.photo_url;
    return data;
  }
  AdminModel copyWith({
  bool? verified,
  DateTime? created_time,
  String? uid,
  String? email,
  bool? delete,
  String? photo_url,
  String? display_name,
  }) {
    return  AdminModel(
        verified: verified??this.verified,
        created_time: created_time??this.created_time,
        uid: uid??this.uid,
        email: email??this.email,
        delete: delete??this.delete,
        photo_url: photo_url??this.photo_url,
        display_name: display_name??this.display_name,
    );
  }
}