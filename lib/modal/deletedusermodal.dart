
class DeletedUserModal {
   bool b2b;
   List b2cBag;
   List b2cBagIds;
   List bag;
   List bagIds;
   double currentB2bAmount;
   double currentB2cAmount;
   DateTime? currentMonth;
   String email;
   String fullName;
   String gst;
   DateTime? lastMonth;
   double lastMonthB2bAmount;
   double lastMonthB2cAmount;
   String mobileNumber;
   String photoUrl;
   String userId;
   double wallet;
   List wishlist;
   String? referralCode;
   String? group;
   String?state;
   String? pinCode;

   DeletedUserModal({
      this.pinCode,
      this.state,
      this.group,
      this.referralCode,
      required this.b2b,
      required this.b2cBag,
      required this.b2cBagIds,
      required this.bag,
      required this.bagIds,
      required this.currentB2bAmount,
      required this.currentB2cAmount,
       this.currentMonth,
      required this.email,
      required this.fullName,
      required this.gst,
       this.lastMonth,
      required this.lastMonthB2bAmount,
      required this.lastMonthB2cAmount,
      required this.mobileNumber,
      required this.photoUrl,
      required this.userId,
      required this.wallet,
      required this.wishlist,
   });

   factory DeletedUserModal.fromJson(Map<String, dynamic> json) {
      return DeletedUserModal(
         pinCode: json['pinCode']??'',
         state: json['state']??'',
         group: json['group']??'',
         referralCode: json['referralCode']??'',
         b2b: json['b2b'] ?? false,
         b2cBag: json['b2cBag'] ?? [],
         b2cBagIds: json['b2cBagIds'] ?? [],
         bag: json['bag'] ?? [],
         bagIds: json['bagIds'] ?? [],
         currentB2bAmount: (json['currentB2bAmount'] as num?)?.toDouble() ??
             0.0,
         currentB2cAmount: (json['currentB2cAmount'] as num?)?.toDouble() ??
             0.0,
         currentMonth: json['currentMonth']==null ? DateTime.now():json['currentMonth'].toDate(),
         email: json['email'] ?? '',
         fullName: json['fullName'] ?? '',
         gst: json['gst'] ?? '',
         lastMonth: json['lastMonth']==null?DateTime.now():json['lastMonth'].toDate(),
         lastMonthB2bAmount:
         (  json['lastMonthB2bAmount'] as num?)?.toDouble()??0.0,
         lastMonthB2cAmount:
         (json['lastMonthB2cAmount'] as num?)?.toDouble()??0.0,
         mobileNumber: json['mobileNumber'] ?? '',
         photoUrl: json['photoUrl'] ?? '',
         userId: json['userId'] ?? '',
         wallet: (json['wallet'] as num?)?.toDouble() ?? 0.0,
         wishlist: json['wishlist'] ?? [],
      );
   }


   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['pinCode']=pinCode??this.pinCode;
      data['state']=state??this.state;
      data['group']=group??this.group;
      data['referralCode']=referralCode??this.referralCode;
      data['b2b'] = b2b ?? this.b2b;
      data['b2cBag'] = b2cBag ?? this.b2cBag;
      data['b2cBagIds'] = b2cBagIds ?? this.b2cBagIds;
      data['bag'] = bag ?? this.bag;
      data['bagIds'] = bagIds ?? this.bagIds;
      data['currentB2bAmount'] = currentB2bAmount ?? this.currentB2bAmount;
      data['currentB2cAmount'] = currentB2cAmount ?? this.currentB2cAmount;
      data['currentMonth'] = currentMonth ?? this.currentMonth;
      data['email'] = email ?? this.email;
      data['fullName'] = fullName ?? this.fullName;
      data['gst'] = gst ?? this.gst;
      data['lastMonth'] = lastMonth ?? this.lastMonth;
      data['lastMonthB2bAmount'] = lastMonthB2bAmount ?? this.lastMonthB2bAmount;
      data['lastMonthB2cAmount'] = lastMonthB2cAmount ?? this.lastMonthB2cAmount;
      data['mobileNumber'] = mobileNumber ?? this.mobileNumber;
      data['photoUrl'] = photoUrl ?? this.photoUrl;
      data['userId'] = userId ?? this.userId;
      data['wallet'] = wallet ?? this.wallet;
      data['wishlist'] = wishlist ?? this.wishlist;
      return data;
   }
   DeletedUserModal copyWith({
      String?state,
      String?group,
      String?referralCode,
      bool? b2b,
      List? b2cBag,
      List ?b2cBagIds,
      List ?bag,
      List ?bagIds,
      double? currentB2bAmount,
      double ?currentB2cAmount,
      DateTime? currentMonth,
      String ?email,
      String ?fullName,
      String ?gst,
      DateTime? lastMonth,
      double ?lastMonthB2bAmount,
      double ?lastMonthB2cAmount,
      String ?mobileNumber,
      String ?photoUrl,
      String ?userId,
      double ?wallet,
      List ?wishlist,

   }){
      return DeletedUserModal(
         state: state??this.state,
         group: group??this.group,
         referralCode: referralCode??this.referralCode,
          b2b: b2b?? this.b2b,
          b2cBag: b2cBag??this.b2cBag,
          b2cBagIds: b2cBagIds??this.b2cBagIds,
          bag: bag??this.bag,
          bagIds: bagIds??this.bagIds,
          currentB2bAmount: currentB2bAmount??this.currentB2bAmount,
          currentB2cAmount: currentB2cAmount??this.currentB2cAmount,
          currentMonth: currentMonth??this.currentMonth,
          email: email??this.email,
          fullName: fullName??this.fullName,
          gst: gst??this.gst,
          lastMonth: lastMonth??this.lastMonth,
          lastMonthB2bAmount: lastMonthB2bAmount??this.lastMonthB2bAmount,
          lastMonthB2cAmount: lastMonthB2cAmount??this.currentB2cAmount,
          mobileNumber: mobileNumber??this.mobileNumber,
          photoUrl: photoUrl??this.photoUrl,
          userId: userId??this.userId,
          wallet: wallet??this.wallet,
          wishlist: wishlist??this.wishlist,
      );
   }

}