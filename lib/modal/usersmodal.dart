
class UserModal {
  bool b2b;
  List b2cBag;
  List b2cBagIds;
  List bag;
  List bagIds;
  List wishlist;
  String currentMonthMedal;
  String email;
  String fullName;
  String group;
  String gst;
  String lastMonthMedal;
  String mobileNumber;
  String photoUrl;
  String pinCode;
  String? referralCode;
  String state;
  String userId;
   DateTime? createdTime;
   DateTime? currentMonth;
   DateTime? lastMonth;
   DateTime? lastUpdate;
  double lastMonthB2bAmount;
  double lastMonthB2cAmount;
  double wallet;
  double referralCommission;
  double currentB2bAmount;
  double currentB2cAmount;
  UserModal({
    required this.b2b,
    required this.b2cBag,
    required this.b2cBagIds,
    required this.bag,
    required this.bagIds,
     this.createdTime,
     this.currentMonth,
    required this.currentMonthMedal,
    required this.email,
    required this.fullName,
    required this.group,
    required this.gst,
     this.lastMonth,
    required this.lastMonthMedal,
     this.lastUpdate,
    required this.lastMonthB2bAmount,
    required this.lastMonthB2cAmount,
    required this.mobileNumber,
    required this.photoUrl,
    required this.pinCode,
    required this.referralCode,
    required this.state,
    required this.userId,
    required this.wishlist,
    required this.wallet,
    required this.currentB2bAmount,
    required this.currentB2cAmount,
    required this.referralCommission,
  });

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      b2b: json['b2b'] ?? false,
      b2cBag: json['b2cBag'] ?? [],
      b2cBagIds: json['b2cBagIds'] ?? [],
      bag: json['bag'] ?? [],
      bagIds: json['bagIds'] ?? [],
      createdTime: json['createdTime']==null?DateTime.now():json['createdTime'].toDate(),
      currentB2bAmount: (json['currentB2bAmount'] as num?)?.toDouble() ?? 0.0,
      currentB2cAmount: (json['currentB2cAmount'] as num?)?.toDouble() ?? 0.0,
      currentMonth: json['currentMonth']==null?DateTime.now(): json['currentMonth'].toDate(),
       lastMonth: json['lastMonth']==null?DateTime.now():json['lastMonth'].toDate(),
      currentMonthMedal: json['currentMonthMedal'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      group: json['group'] ?? '',
      gst: json['gst'] ?? '',
      lastMonthMedal: json['lastMonthMedal'] ?? '',
      lastUpdate: json['lastUpdate']==null?DateTime.now():json['lastUpdate'].toDate(),
      lastMonthB2bAmount:
      (  json['lastMonthB2bAmount'] as num?)?.toDouble()??0.0,
      lastMonthB2cAmount:
      (json['lastMonthB2cAmount'] as num?)?.toDouble()??0.0,
      mobileNumber: json['mobileNumber'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      pinCode: json['pinCode'] ?? '',
      referralCode: json['referralCode']  ?? '',
      referralCommission:
          (json['referralCommission'] as num?)?.toDouble() ?? 0.0,
      state: json['state'] ?? '',
      userId: json['userId'] ?? '',
      wallet: (json['wallet'] as num?)?.toDouble() ?? 0.0,
      wishlist: json['wishlist'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['b2b'] = b2b ?? this.b2b;
    data['b2cBag'] = b2cBag ?? this.b2cBag;
    data['b2cBagIds'] = b2cBagIds ?? this.b2cBagIds;
    data['bag'] = bag ?? this.bag;
    data['bagIds'] = bagIds ?? this.bagIds;
    data['createdTime'] = createdTime ?? this.createdTime;
    data['currentB2bAmount'] = currentB2bAmount ?? this.currentB2bAmount;
    data['currentB2cAmount'] = currentB2cAmount ?? this.currentB2cAmount;
    data['currentMonth'] = currentMonth ?? this.currentMonth;
    data['currentMonthMedal'] = currentMonthMedal ?? this.currentMonthMedal;
    data['email'] = email ?? this.email;
    data['fullName'] = fullName ?? this.fullName;
    data['group'] = group ?? this.group;
    data['gst'] = gst ?? this.gst;
    data['lastMonth'] = lastMonth ?? this.lastMonth;
    data['lastMonthMedal'] = lastMonthMedal ?? this.lastMonthMedal;
    data['lastUpdate'] = lastUpdate ?? this.lastUpdate;
    data['lastMonthB2bAmount'] = lastMonthB2bAmount ?? this.lastMonthB2bAmount;
    data['lastMonthB2cAmount'] = lastMonthB2cAmount ?? this.lastMonthB2cAmount;
    data['mobileNumber'] = mobileNumber ?? this.mobileNumber;
    data['photoUrl'] = photoUrl ?? this.photoUrl;
    data['pincode'] = pinCode ?? this.pinCode;
    data['referralCode'] = referralCode ?? this.referralCode;
    data['referralCommission'] = referralCommission ?? this.referralCommission;
    data['state'] = state ?? this.state;
    data['userId'] = userId ?? this.userId;
    data['wallet'] = wallet ?? this.wallet;
    data['wishlist'] = wishlist ?? this.wishlist;
    return data;
  }

  UserModal copyWith(
      {bool? b2b,
      List? b2cBag,
      List? b2cBagIds,
      List? bag,
      List? bagIds,
      DateTime? createdTime,
      double? currentB2bAmount,
      double? currentB2cAmount,
      DateTime? currentMonth,
      String? currentMonthMedal,
      String? email,
      String? fullName,
      String? group,
      String? gst,
      DateTime? lastMonth,
      String? lastMonthMedal,
      DateTime? lastUpdate,
      double? lastMonthB2bAmount,
      double? lastMonthB2cAmount,
      String? mobileNumber,
      String? photoUrl,
      String? pinCode,
      String? referralCode,
      double? referralCommission,
      String? state,
      String? userId,
      double? wallet,
      List? wishlist}) {
    return UserModal(
      b2b: b2b ?? this.b2b,
      b2cBag: b2cBag ?? this.b2cBag,
      b2cBagIds: b2cBagIds ?? this.b2cBagIds,
      bag: bag ?? this.bag,
      bagIds: bagIds ?? this.bagIds,
      createdTime: createdTime ?? this.createdTime,
      currentB2bAmount: currentB2bAmount ?? this.currentB2bAmount,
      currentB2cAmount: currentB2cAmount ?? this.currentB2cAmount,
      currentMonth: currentMonth ?? this.currentMonth,
      currentMonthMedal: currentMonthMedal ?? this.currentMonthMedal,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      group: group ?? this.group,
      gst: gst ?? this.gst,
      lastMonth: lastMonth ?? this.lastMonth,
      lastMonthMedal: lastMonthMedal ?? this.lastMonthMedal,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      pinCode: pinCode ?? this.pinCode,
      referralCode: referralCode ?? this.referralCode,
      referralCommission: referralCommission ?? this.referralCommission,
      state: state ?? this.state,
      userId: userId ?? this.userId,
      wallet: wallet ?? this.wallet,
      wishlist: wishlist ?? this.wishlist,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      lastMonthB2bAmount: lastMonthB2cAmount ?? this.lastMonthB2cAmount,
      lastMonthB2cAmount: lastMonthB2cAmount ?? this.lastMonthB2cAmount,
    );
  }
}
