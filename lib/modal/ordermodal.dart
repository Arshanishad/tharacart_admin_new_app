import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  DateTime acceptedDate;
  DateTime deliveredDate;
  Timestamp invoiceDate;
  Timestamp placedDate;
  DateTime shippedDate;
  Timestamp? cancelledDate;
  String awb_code;
  String promoCode;
  String partner;
  String referralCode;
  String shipRocketOrderId;
   List? search;
  int invoiceNo;
  double price;
  double tip;
  double total;
  int orderStatus;
   List? items;
   List? shops;
   List? token;
  String branchId;
  String trackingUrl;
  String userId;
  bool view;
  String paymentCart;
  String shippingMethod;
  String orderId;
  String deliveryPin;
  String driverId;
  String driverName;
  double gst;
  double deliveryCharge;
  double discount;
  Map shippingAddress;
  OrderModel(
      {
        this.cancelledDate,
      required this.price,
      required this.trackingUrl,
      required this.userId,
      required this.partner,
      required this.discount,
        this.items,
      required this.invoiceNo,
      required this.orderStatus,
        this.search,
      required this.acceptedDate,
      required this.awb_code,
      required this.branchId,
      required this.deliveredDate,
      required this.deliveryCharge,
      required this.deliveryPin,
      required this.driverId,
      required this.driverName,
      required this.gst,
      required this.invoiceDate,
      required this.orderId,
      required this.paymentCart,
      required this.placedDate,
      required this.promoCode,
      required this.referralCode,
      required this.shippedDate,
      required this.shippingAddress,
      required this.shippingMethod,
      required this.shipRocketOrderId,
        this.shops,
      required this.tip,
        this.token,
      required this.total,
      required this.view});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      cancelledDate: json['cancelledDate'] == null? Timestamp.now() :json['cancelledDate'],
      price: json['price'].toDouble() ?? 0,
      trackingUrl: json['trackingUrl'] ?? "",
      userId: json['userId'] ?? "",
      partner: json['partner'] ?? "",
      discount: json['discount'].toDouble() ?? 0,
       items: json['items'] ?? [],
      invoiceNo: json['invoiceNo'] ?? 0,
      orderStatus: json['orderStatus'] ?? 0,
       search: json['search'] ?? [],
      acceptedDate: json['acceptedDate'] == null
          ? DateTime.now()
          : json['acceptedDate'].toDate(),
      awb_code: json['awb_code'] ?? "",
      branchId: json['branchId'] ?? "",
      deliveredDate: json['deliveredDate'] == null
          ? DateTime.now()
          : json['deliveredDate'].toDate(),
      deliveryCharge: json['deliveryCharge'].toDouble() ?? 0,
      deliveryPin: json['deliveryPin'] ?? "",
      driverId: json['driverId'] ?? "",
      driverName: json['driverName'] ?? "",
      gst: json['gst'].toDouble() ?? 0,
      invoiceDate:
          json['invoiceDate'] == null ? Timestamp.now() : json['invoiceDate'],
      orderId: json['orderId'] ?? "",
      paymentCart: json['paymentCart'] ?? "",
      placedDate:
          json['placedDate'] == null ? Timestamp.now() : json['placedDate'],
      promoCode: json['promoCode'] ?? "",
      referralCode: json['referralCode'] ?? "",
      shippedDate: json['shippedDate'] == null
          ? DateTime.now()
          : json['shippedDate'].toDate(),
      shippingAddress: json['shippingAddress'] ?? {},
      shippingMethod: json['shippingMethod'] ?? "",
      shipRocketOrderId: json['shipRocketOrderId'] ?? "",
       shops: json['shops'] ?? [],
      tip: json['tip'].toDouble() ?? 0,
      token: json['token'] ?? [],
      total: json['total'].toDouble() ?? 0,
      view: json['view'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId ?? '';
    data['trackingUrl'] = trackingUrl ?? '';
    data['awb_code'] = awb_code ?? '';
    data['branchId'] = branchId ?? '';
    data['deliveryPin'] = deliveryPin ?? '';
    data['partner'] = partner ?? '';
    data['driverId'] = driverId ?? '';
    data['referralCode'] = referralCode;
    data['orderId'] = orderId;
    data['paymentCart'] = paymentCart;
    data['driverName'] = driverName ?? "";
    data['promoCode'] = promoCode ?? "";
    data['shippedDate'] = shippedDate ?? DateTime.now();
    data['acceptedDate'] = acceptedDate ?? DateTime.now();
    data['invoiceDate'] = invoiceDate ?? DateTime.now();
    data['deliveredDate'] = deliveredDate ?? DateTime.now();
    data['cancelledDate']=cancelledDate??DateTime.now();
    data['placedDate'] = placedDate ?? DateTime.now();
    data['shippingMethod'] = shippingMethod ?? "";
    data['shipRocketOrderId'] = shipRocketOrderId ?? "";
    data['shippingAddress'] = shippingAddress ?? {};
    data['discount'] = discount ?? 0;
    data['invoiceNo'] = invoiceNo ?? 0;
    data['orderStatus'] = orderStatus ?? 0;
    data['deliveryCharge'] = deliveryCharge ?? 0;
    data['tip'] = tip ?? 0;
    data['total'] = total ?? 0;
    data['items'] = items ?? [];
    data['search'] = search ?? [];
    data['shops'] = shops ?? [];
    data['token'] = token ?? [];
    data['view'] = view ?? false;
    return data;
  }

  OrderModel copyWith({
    DateTime? acceptedDate,
    DateTime? deliveredDate,
    Timestamp? invoiceDate,
    Timestamp? placedDate,
    DateTime? shippedDate,
    String? awb_code,
    String? promoCode,
    String? partner,
    String? referralCode,
    String? shipRocketOrderId,
    List? search,
    int? invoiceNo,
    double? price,
    double? tip,
    double? total,
    int? orderStatus,
    List? items,
    List? shops,
    List? token,
    String? branchId,
    String? trackingUrl,
    String? userId,
    bool? view,
    String? paymentCart,
    String? shippingMethod,
    String? orderId,
    String? deliveryPin,
    String? driverId,
    String? driverName,
    double? gst,
    double? deliveryCharge,
    double? discount,
    Timestamp? cancelledDate,
  }) {
    return OrderModel(
      cancelledDate: cancelledDate ?? this.cancelledDate,
      price: price ?? this.price,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      userId: userId ?? this.userId,
      partner: partner ?? this.partner,
      discount: discount ?? this.discount,
      items: items ?? this.items,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      orderStatus: orderStatus ?? this.orderStatus,
      search: search ?? this.search,
      acceptedDate: acceptedDate ?? this.acceptedDate,
      awb_code: awb_code ?? this.awb_code,
      branchId: branchId ?? this.branchId,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      deliveryPin: deliveryPin ?? this.deliveryPin,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      gst: gst ?? this.gst,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      orderId: orderId ?? this.orderId,
      paymentCart: paymentCart ?? this.paymentCart,
      placedDate: placedDate ?? this.placedDate,
      promoCode: promoCode ?? this.promoCode,
      referralCode: referralCode ?? this.referralCode,
      shippedDate: shippedDate ?? this.shippedDate,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      shipRocketOrderId: shipRocketOrderId ?? this.shipRocketOrderId,
      shops: shops ?? this.shops,
      tip: tip ?? this.tip,
       token: token ?? this.token,
      total: total ?? this.total,
      view: view ?? this.view,
    );
  }
}
