// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:number_to_words/number_to_words.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';
// import '../../../core/common/upload_message.dart';
// import '../../../core/theme/pallete.dart';
// import '../../../main.dart';
// import '../../../modal/invoice model.dart';
// import '../../../modal/ordermodal.dart';
// import '../../home/screen/home_page_widget.dart';
// import 'address_popup.dart';
//
//
//
// class EditOrderDetails extends StatefulWidget {
//   EditOrderDetails({
//     Key? key,
//     required this.id,
//     required this.name,
//     required this.email,
//   }) : super(key: key);
//   final String id;
//   final String name;
//   final String email;
//   @override
//   _EditOrderDetailsState createState() => _EditOrderDetailsState();
// }
//
// class _EditOrderDetailsState extends State<EditOrderDetails> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   TextEditingController statusController = TextEditingController();
//   TextEditingController awbCode = TextEditingController();
//   TextEditingController trackingUrl = TextEditingController();
//   bool listView = false;
//   Map colorMap = new Map();
//
//   _launchURL(String urls) async {
//     var url = urls;
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   List orderData = [];
//   var orderItems;
//   Map address = {};
//   Map billingAddress = {};
//   String gst = '';
//   bool b2b = false;
//   List<DropdownMenuItem> fetchedRiders = [];
//   late Map<String, dynamic> selectedRider;
//
//   setSearchParam(String caseNumber) {
//     List<String> caseSearchList = [];
//     String temp = "";
//     List<String> nameSplits = caseNumber.split(" ");
//     for (int i = 0; i < nameSplits.length; i++) {
//       String name = "";
//       for (int k = i; k < nameSplits.length; k++) {
//         name = name + nameSplits[k] + " ";
//       }
//       temp = "";
//       for (int j = 0; j < name.length; j++) {
//         temp = temp + name[j];
//         caseSearchList.add(temp.toUpperCase());
//       }
//     }
//     return caseSearchList;
//   }
//
//   Future<void> getOrderItems() async {
//     List ordersItems = [];
//     for (int i = 0; i < Order!.items!.length; i++) {
//       Map tempOrderData = new Map();
//       // tempOrderData['quantity'] = Order.items[i].quantity;////////////////////////////////////////////
//       DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore
//           .instance
//           .collection('products')
//           .doc(Order?.items?[i].id)
//           .get();
//       tempOrderData['productImage'] = docRef.data()?['imageId'][0];
//       tempOrderData['productName'] = docRef.data()?['name'];
//       tempOrderData['price'] = Order?.items?[i].price;
//       ordersItems.add(tempOrderData);
//     }
//     if (mounted) {
//       setState(() {
//         orderData = ordersItems;
//       });
//     }
//   }
//
//   getAddress() async {
//     address = {};
//     billingAddress = {};
//
//     DocumentSnapshot doc = await FirebaseFirestore.instance
//         .collection('orders')
//         .doc(widget.id)
//         .get();
//
//     DocumentSnapshot user = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(Order?.userId)
//         .get();
//
//     address = doc.get('shippingAddress');
//     print('customer place ' + address['state']);
//
//     if (Order?.orderStatus == 3 && user.get('b2b') == true) {
//       gst = user.get('gst');
//       b2b = user.get('b2b');
//     }
//
//     if (b2b == true) {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('b2bRequests')
//           .doc(Order?.userId)
//           .get();
//
//       List<Map<String, dynamic>> taxpayerInfo = [];
//
//       if (doc.exists) {
//         if (doc.get('status') == 1) {
//           taxpayerInfo.add(doc.get('taxpayerInfo'));
//
//           billingAddress = {};
//         }
//       }
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   shipRocket() async {
//     List items = [];
//     if (token != null || token != '') {
//       print('1');
//       DocumentSnapshot invoiceNoDoc = await FirebaseFirestore.instance
//           .collection('invoiceNo')
//           .doc(currentBranchId)
//           .get();
//       FirebaseFirestore.instance
//           .collection('invoiceNo')
//           .doc(currentBranchId)
//           .update({
//         'orderId': FieldValue.increment(1),
//       });
//       int orderId = invoiceNoDoc.get('orderId');
//       orderId++;
//       var header = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       };
//       print('2');
//       print(token);
//       print('pppp');
//       double amount = 0;
//       String method = '';
//       if (Order?.shippingMethod == 'Cash On Delivery') {
//         amount = Order!.total + Order!.gst + 33;
//         method = "COD";
//       } else {
//         amount = (Order!.total + Order!.gst);
//         method = "Prepaid";
//       }
// ///////////////////////////////////////////////////////////////
//       // for (var data in Order.items) {
//       //   items.add({
//       //     'name': data['name'],
//       //     'sku': data['productCode'],
//       //     'units': data['quantity'].toInt(),
//       //     'selling_price': data['price'],
//       //     'tax': data['gst'].toInt(),
//       //     'hsn': data['hsnCode'],
//       //   });
//       // }
//
//       var request = http.Request(
//           'POST',
//           Uri.parse(
//               'https://apiv2.shiprocket.in/v1/external/orders/create/adhoc'));
//       request.body = json.encode({
//         "order_id": 'THARAE$orderId',
//         "order_date": DateTime.now().toString().substring(0, 16),
//         "pickup_location": "THARA CART",
//         "billing_customer_name": Order?.shippingAddress['name'],
//         "billing_last_name": "",
//         "billing_city": Order?.shippingAddress['city'],
//         "billing_pincode": Order?.shippingAddress['pinCode'],
//         "billing_state": Order?.shippingAddress['state'],
//         "billing_address": Order?.shippingAddress['address'],
//         "billing_country": "India",
//         "billing_email": widget.email,
//         "billing_phone": Order?.shippingAddress['mobileNumber'],
//         "shipping_is_billing": true,
//         "shipping_customer_name": Order?.shippingAddress['name'],
//         "shipping_address": Order?.shippingAddress['address'],
//         "shipping_address_2": Order?.shippingAddress['area'],
//         "shipping_city": Order?.shippingAddress['city'],
//         "shipping_pincode": Order?.shippingAddress['pinCode'],
//         "shipping_country": "India",
//         "shipping_state": Order?.shippingAddress['state'],
//         "shipping_email": widget.email,
//         "shipping_phone": Order?.shippingAddress['mobileNumber'],
//         "order_items": items,
//         "payment_method": method,
//         "shipping_charges": Order?.deliveryCharge.toInt(),
//         "total_discount": Order?.discount.toInt(),
//         "sub_total": amount.toInt(),
//         "length": '10.0',
//         "breadth": '15.0',
//         "height": '20.0',
//         "weight": '2.5'
//       });
//       request.headers.addAll(header);
//
//       http.StreamedResponse response = await request.send();
//       print('-----');
//       if (response.statusCode == 200) {
//         print('1');
//         print(await response.stream.bytesToString());
//         // final ordersRecordData = createOrdersRecordData(///////////////////////////////////////////////////////////////
//         //     orderStatus: 1,
//         //     acceptedDate: Timestamp.now(),
//         //     shipRocketOrderId: 'THARAE$orderId');
//         // await FirebaseFirestore.instance
//         //     .collection('orders')
//         //     .doc(widget.id)
//         //     .update(ordersRecordData);
//         //  await widget.order.reference.update(ordersRecordData);
//         showUploadMessage(context, 'Order Accepted...');
//         Navigator.pop(context);
//       } else {
//         print(response.statusCode);
//         print(response.reasonPhrase);
//         print(await response.stream.bytesToString());
//         // showUploadMessage(context, response.reasonPhrase);
//       }
//     }
//   }
//
//   ExpressBees() async {
//     List items = [];
//     if (expreesBeetoken != null || expreesBeetoken != '') {
//       DocumentSnapshot invoiceNoDoc = await FirebaseFirestore.instance
//           .collection('invoiceNo')
//           .doc(currentBranchId)
//           .get();
//       FirebaseFirestore.instance
//           .collection('invoiceNo')
//           .doc(currentBranchId)
//           .update({
//         'orderId': FieldValue.increment(1),
//       });
//       int orderId = invoiceNoDoc.get('orderId');
//       orderId++;
//       var header = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $expreesBeetoken'
//       };
//
//       print(token);
//       double amount = 0;
//       double codCharge = 0;
//       if (Order?.shippingMethod == 'Cash On Delivery') {
//         amount = Order!.total + Order!.gst + 33;
//         codCharge = 33;
//       } else {
//         codCharge = 0;
//         amount = (Order!.total + Order!.gst);
//       }
// ///////////////////////////////////////////////////////////////
//       // for (var data in Order.items) {
//       //   items.add({
//       //     'product_name': data.name,
//       //     'product_qty': data.quantity.toInt(),
//       //     'product_price': data.price * 100 / (100 + data.gst.toInt()),
//       //     'product_tax_per': data.gst.toInt(),
//       //     'product_sku': data.productCode,
//       //     'product_hsn': data.hsnCode,
//       //   });
//       // }
//       String payment_method = '';
//
//       if (Order?.shippingMethod == 'Cash On Delivery') {
//         payment_method = "COD";
//       } else {
//         payment_method = "prepaid";
//       }
//
//       var request = http.Request('POST',
//           Uri.parse('https://ship.xpressbees.com/api/franchise/shipments'));
//       request.body = json.encode({
//         "id": 'THARAE$orderId',
//         "payment_method": payment_method,
//
//         //thara
//         "consigner_name": "Thara Online Store",
//         "consigner_phone": "8589858588",
//         "consigner_pincode": "679322",
//         "consigner_city": "Malappuram",
//         "consigner_state": "Kerala",
//         "consigner_address":
//             "11/321,Thara Appartments,Hospital Road,Perinthalmanna",
//         "consigner_gst_number": "32JDVPS7635J1ZK",
//
//         //customer
//         "consignee_name": Order?.shippingAddress['name'],
//         "consignee_phone": Order?.shippingAddress['mobileNumber'],
//         "consignee_pincode": Order?.shippingAddress['pinCode'],
//         "consignee_city": Order?.shippingAddress['city'],
//         "consignee_state": Order?.shippingAddress['state'],
//         "consignee_address": Order?.shippingAddress['address'],
//         "consignee_gst_number": "",
//
//         //items
//         "products": items,
//
//         //invoiceData
//         "invoice": [
//           {
//             "invoice_number": "",
//             "invoice_date": "",
//             "ebill_number": "",
//             "ebill_expiry_date": ""
//           }
//         ],
//
//         "length": "",
//         "breadth": "",
//         "height": "",
//         "weight": "",
//
//         //courierId air or surface
//         "courier_id": "1025",
//         "pickup_location": "franchise",
//         "shipping_charges": '',
//         "cod_charges": '',
//         "discount": '',
//         "order_amount": Order?.price.toInt(),
//       });
//       request.headers.addAll(header);
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//       } else {
//         print(response.statusCode);
//         print(response.reasonPhrase);
//         print(await response.stream.bytesToString());
//         // showUploadMessage(context, response.reasonPhrase);
//       }
//     }
//   }
//
//   List<dynamic> p = [];
//   var partner;
//   getPartner() {
//     FirebaseFirestore.instance
//         .collection('settings')
//         .doc('order')
//         .get()
//         .then((value) {
//       p = value.data()?['partners'];
//       print('---------');
//       print(p);
//     });
//   }
//
//   getorderspartner() {
//     FirebaseFirestore.instance
//         .collection('orders')
//         .doc(widget.id)
//         .snapshots()
//         .listen((event) {
//       partner=event.data()?['partner'];
//       try {
//         print('========');
//         print(widget.id);
//         partner = event.get('partner');
//         print('========');
//         print(partner);
//         print('========');
//       } catch (e) {
//         print(e.toString());
//       }
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   late int orderstatus;
//   late int invoiceNumber;
//   late double price;
//   late String shiprocket;
//    OrderModel? Order;
//   getOrderDetails() {
//     FirebaseFirestore.instance
//         .collection('orders')
//         .doc(widget.id)
//         .snapshots()
//         .listen((event) async {
//       print('========');
//       print(event.data());
//        Order = OrderModel.fromJson(event.data()??{});
//       print('Order.orderStatus');
//       awbCode.text = Order!.awb_code;
//       trackingUrl.text = Order!.trackingUrl;
//       print(Order?.orderStatus);
//       print(']]]]]]]');
//       statusController.text = (Order?.orderStatus == 0)
//           ? 'Pending'
//           : (Order?.orderStatus == 1)
//               ? 'Accepted'
//               : (Order?.orderStatus == 3)
//                   ? 'Shipped'
//                   : (Order?.orderStatus == 4)
//                       ? 'Delivered'
//                       : 'Cancelled';
//       getOrderItems();
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     getOrderDetails();
//     // TODO: implement initState
//     // awbCode = TextEditingController(text:Order.awb_code??'');
//     // trackingUrl = TextEditingController(text: Order.trackingUrl??'');
//     getPartner();
//     getAddress();
//     getorderspartner();
//     // ExpressBees();
//     super.initState();
//     if (fetchedRiders.isEmpty) {
//       getRiders().then((value) {
//         setState(() {});
//       });
//     }
//   }
//
//   Future getRiders(OrderModel data) async {
//     QuerySnapshot data1 = await FirebaseFirestore.instance
//         .collection("rider")
//         .where('online', isEqualTo: true)
//         .get();
//     for (var doc in data1.docs) {
//       fetchedRiders.add(DropdownMenuItem(
//         child: Text(doc.get('display_name')),
//         value: doc.data(),
//       ));
//       if (data.driverId == doc.get('uid')) {
//         setState(() {
//           selectedRider = doc.data();
//         });
//       }
//     }
//   }
//
//   void colorLists() async {
//     Map colorMaps = Map();
//     DocumentSnapshot<Map<String, dynamic>> colorRef = await FirebaseFirestore
//         .instance
//         .collection('colors')
//         .doc('colors')
//         .get();
//     List colorList = colorRef.data()?['colorList'];
//     for (int i = 0; i < colorList.length; i++) {
//       colorMaps[colorList[i]['code']] = colorList[i]['name'];
//     }
//     setState(() {
//       colorMap = colorMaps;
//     });
//     // getOrderItems();
//   }
//
//   String colorList(String colorName) {
//     print(colorName);
//     if (colorMap[colorName] != null) {
//       return colorMap[colorName];
//     } else {
//       return 'NotFound';
//     }
//   }
//
//   String awbNo = '';
//   String trackingLink = '';
//
//   getTrackingId() async {
//     var list;
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token'
//     };
//
//     var request = http.Request(
//         'GET',
//         Uri.parse(
//             'https://apiv2.shiprocket.in/v1/external/courier/track?order_id=${Order?.shipRocketOrderId}&channel_id=1861189'));
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       List body = json.decode(await response.stream.bytesToString());
//
//       print(await response.stream.bytesToString());
//
//       if (body == null || body.length == 0) {
//         showDialog(
//             context: context,
//             builder: (buildContext) {
//               return AlertDialog(
//                 title: Text('Order Not Shipped'),
//                 content: SelectableText(trackingLink),
//                 actions: [
//                   TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('Ok')),
//                 ],
//               );
//             });
//       } else {
//         list = body[0]['tracking_data'];
//         trackingLink = list['track_url'];
//         List shipment_track = list['shipment_track'];
//         print(shipment_track[0]['awb_code']);
//
//         showDialog(
//             context: context,
//             builder: (buildContext) {
//               return AlertDialog(
//                 title: Text('Tracking Url'),
//                 content: SelectableText(trackingLink),
//                 actions: [
//                   TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('Cancel')),
//                   TextButton(
//                       onPressed: () async {
//                         FirebaseFirestore.instance
//                             .collection('orders')
//                             .doc(widget.id)
//                             .update({
//                           'trackingUrl': trackingLink,
//                           'awb_code': shipment_track[0]['awb_code'],
//                         });
//                         // widget.order.reference.update({
//                         //
//                         // });
//                         Navigator.pop(context);
//                         showUploadMessage(context, 'Tracking Url Updated...');
//                       },
//                       child: Text('Submit')),
//                 ],
//               );
//             });
//       }
//       setState(() {});
//     } else {
//       print(response.reasonPhrase);
//
//       showDialog(
//           context: context,
//           builder: (buildContext) {
//             return AlertDialog(
//               title: Text('Order Not Shipped'),
//               content: SelectableText(trackingLink),
//               actions: [
//                 TextButton(
//                     onPressed: () => Navigator.pop(context), child: Text('Ok')),
//               ],
//             );
//           });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('arunppp');
//     final orderDetailsOrdersRecord = Order;
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Pallete.primaryColor,
//         automaticallyImplyLeading: true,
//         title: Text(
//           statusController.text + ' Order',
//           style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
//         ),
//         actions: [
//           // Order.orderStatus == 2&&Order.invoiceNo!=0
//           //       ?
//           TextButton(
//               onPressed: () async {
//                 bool proceed = await showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('Change Invoice Number'),
//                       content: const Text(
//                           'Do you want to change the invoice number?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop(false);
//                           },
//                           child: const Text('No'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop(true);
//                           },
//                           child: const Text('Yes'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//
//                 if (proceed != null && proceed) {
//                   await FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(widget.id)
//                       .update({
//                     "invoiceNo": 0,
//                   });
//                   showUploadMessage(
//                       context, 'Successfully changed invoice number');
//                 }
//               },
//               child: const Text(
//                 'Invalidate \ninvoice',
//                 style: TextStyle(color: Colors.white),
//               )),
//           // : Container(),
//           Order?.orderStatus != 3
//               ? Container()
//               : IconButton(
//                   iconSize: 27,
//                   onPressed: () {
//                     getTrackingId();
//                   },
//                   icon: const Icon(Icons.report)),
//           Order?.orderStatus == 3
//               ? IconButton(
//                   iconSize: 27,
//                   onPressed: () async {
//                     print(orderItems);
//
//                     Map items = {};
//                     List products =
//                         []; ///////////////////////////////////////////////////////////////
//                     // for (var item in Order.items) {
//                     //   // print(item.name);
//                     //   items = {
//                     //     'productName': item['name'],
//                     //     'price': item['price'],
//                     //     'quantity': item['quantity'].toInt(),
//                     //     'total': item['price'] * item['quantity'],
//                     //     'gst': item['gst'],
//                     //   };
//                     //   products.add(items);
//                     // }
//                     print(items);
//                     print(b2b);
//                     List<InvoiceItem> item = [];
//                     int? amount = int.tryParse(Order!.price.toInt().toString());
//                     print(amount.toString());
//                     String number = NumberToWord().convert('en-in', amount!);
//                     for (var data in products) {
//                       item.add(
//                         InvoiceItem(
//                             gstp: data['gst'],
//                             description: data['productName'],
//                             gst: data['total'] -
//                                 data['quantity'] *
//                                     data['price'] *
//                                     100 /
//                                     (100 + data['gst']),
//                             // gst: items['quantity']*items['price']*100/(100+items['gst'])* items['gst']/100,
//                             price: data['price'].toDouble(),
//                             quantity: data['quantity'],
//                             tax: data['quantity'] *
//                                 data['price'] *
//                                 100 /
//                                 (100 + data['gst']),
//                             total: data['total'].toDouble(),
//                             unitPrice:
//                                 data['price'] * 100 / (100 + data['gst'])),
//                       );
//                     }
//
//                     final invoice = Invoice(
//                       invoiceNo: Order!.invoiceNo,
//                       discount: Order!.discount,
//                       shipRocketId: Order!.shipRocketOrderId,
//                       invoiceNoDate: Order!.invoiceDate,
//                       orderId: widget.id,
//                       shipping: Order!.deliveryCharge,
//                       orderDate: Order!.placedDate,
//                       total: Order!.total,
//                       price: Order!.price,
//                       gst: Order!.gst,
//                       amount: number,
//                       method: Order!.shippingMethod,
//                       b2b: b2b,
//                       shippingAddress: [
//                         ShippingAddress(
//                           gst: Order!.gst.toString(),
//                           name: Order?.shippingAddress['name'],
//                           area: Order?.shippingAddress['area'],
//                           address: Order?.shippingAddress['address'],
//                           mobileNumber: Order?.shippingAddress['mobileNumber'],
//                           pincode: Order?.shippingAddress['pinCode'],
//                           city: Order?.shippingAddress['city'],
//                           state: Order?.shippingAddress['state'],
//                         ),
//                       ],
//                       salesItems: item,
//                     );
//                     ///////////////////////////////////////////////////////////////
//                     // final pdfFile = await B2cPdfInvoiceApi.generate(invoice);
//                     // await PdfApi.openFile(pdfFile);
//                     // await save
//                   },
//                   icon: Icon(Icons.picture_as_pdf))
//               : Container()
//         ],
//         centerTitle: true,
//         elevation: 4,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           bool proceed = await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Cancel Order'),
//                                 content: const Text(
//                                     'Are you sure you want to cancel this order?'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(false);
//                                     },
//                                     child: const Text('No'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(true);
//                                     },
//                                     child: const Text('Yes'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//
//                           if (proceed != null && proceed) {
//                             final orderStatus = 2;
//                             // if (orderDetailsOrdersRecord.orderStatus > 2) {
//                             //   final ordersRecordData = createOrdersRecordData(
//                             //     orderStatus: orderStatus,
//                             //     returnOrder: true,
//                             //     invoiceNo:
//                             //         orderDetailsOrdersRecord.invoiceNo ?? 0,
//                             //     cancelledDate: Timestamp.now(),
//                             //   );
//                             //   await FirebaseFirestore.instance
//                             //       .collection('orders')
//                             //       .doc(widget.id)
//                             //       .update(ordersRecordData);
//                             //   setState(() {
//                             //     statusController.text = 'cancelled';
//                             //   });
//                             // } else {
//                             //   final ordersRecordData = createOrdersRecordData(
//                             //     invoiceNo:
//                             //         orderDetailsOrdersRecord.invoiceNo ?? 0,
//                             //     returnOrder: false,
//                             //     orderStatus: orderStatus,
//                             //     cancelledDate: Timestamp.now(),
//                             //   );
//                             //   await FirebaseFirestore.instance
//                             //       .collection('orders')
//                             //       .doc(widget.id)
//                             //       .update(ordersRecordData);
//                             //   setState(() {
//                             //     statusController.text = 'cancelled';
//                             //   });
//                             // }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Pallete.primaryColor,
//                           minimumSize: const Size(110, 40),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         bool proceed = await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('Confirmation'),
//                               content: const Text(
//                                   'Do you want to accept this order?'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context)
//                                         .pop(false); // Return false if canceled
//                                   },
//                                   child: const Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context)
//                                         .pop(true); // Return true if accepted
//                                   },
//                                   child: const Text('Accept'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                         if (proceed != null && proceed) {
//                           shipRocket();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: Pallete.primaryColor,
//                         minimumSize: const Size(110, 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Accept',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//
//                     // Column(
//                     //   children: [
//                     //     Text('List'),
//                     //     Switch(
//                     //       value: listView,
//                     //       onChanged: (value) {
//                     //         setState(() {
//                     //           listView = value;
//                     //         });
//                     //       },
//                     //     )
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//               //================================================================
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           bool proceed = await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Shipped Order'),
//                                 content: const Text('Is this order shipped?'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(false);
//                                     },
//                                     child: const Text('No'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(true);
//                                     },
//                                     child: const Text('Yes'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//
//                           if (proceed) {
//                             final orderStatus = 3;
//                             DocumentSnapshot invoiceNoDoc =
//                                 await FirebaseFirestore.instance
//                                     .collection('invoiceNo')
//                                     .doc(currentBranchId)
//                                     .get();
//                             FirebaseFirestore.instance
//                                 .collection('invoiceNo')
//                                 .doc(currentBranchId)
//                                 .update({
//                               'sales': FieldValue.increment(1),
//                             });
//                             int sales = invoiceNoDoc.get('sales');
//                             sales++;
//                             ///////////////////////////////////////////////////////////////
//                             // final ordersRecordData = createOrdersRecordData(
//                             //   orderStatus: orderStatus,
//                             //   shippedDate: Timestamp.now(),
//                             //   invoiceNo: sales,
//                             //   invoiceDate: Timestamp.now(),
//                             // );
//                             // await FirebaseFirestore.instance
//                             //     .collection('orders')
//                             //     .doc(widget.id)
//                             //     .update(ordersRecordData);
//                             // FirebaseFirestore.instance
//                             //     .collection('orders')
//                             //     .doc(widget.id)
//                             //     .update({
//                             //   'search': setSearchParam(
//                             //       '${sales.toString()} ${Order.shipRocketOrderId}'),
//                             // });
//                             // setState(() {
//                             //   statusController.text = 'Shipped';
//                             // });
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Pallete.primaryColor,
//                           textStyle: const TextStyle(
//                             fontFamily: 'Poppins',
//                             color: Colors.white,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text('Shipped'),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         List<Map<String, dynamic>> products = [];
//                         // for (var item in Order.items) {
//                         //   // Order.items
//                         //   products.add({
//                         //     'gst': item['gst'],
//                         //     'hsnCode': item['hsnCode'],
//                         //     'id': item['id'],
//                         //     'image': item['image'],
//                         //     'name': item['name'],
//                         //     'price': item['price'],
//                         //     'productCode': item['productCode'],
//                         //     'quantity': item['quantity'],
//                         //     'status': item['status'],
//                         //   });
//                         // }
//                         // bool proceed =
//                         //     await alert(context, 'Is this order delivered?');
//                         // if (proceed) {
//                         //   final orderStatus = 4;
//                         //   final ordersRecordData = createOrdersRecordData(
//                         //     orderStatus: orderStatus,
//                         //     deliveredDate: Timestamp.now(),
//                         //   );
//                         //   if (Order.referralCode != null) {
//                         //     QuerySnapshot rUsers = await FirebaseFirestore
//                         //         .instance
//                         //         .collection('users')
//                         //         .where('referralCode',
//                         //             isEqualTo: Order.referralCode)
//                         //         .get();
//                         //     if (rUsers.docs.length > 0) {
//                         //       DocumentSnapshot rUser = rUsers.docs[0];
//                         //       double? referralCommission = 0;
//                         //       referralCommission = double.tryParse(
//                         //         rUser.get('referralCommission').toString(),
//                         //       );
//                         //       if (referralCommission != 0) {
//                         //         print("commission");
//                         //         FirebaseFirestore.instance
//                         //             .collection('referralCommission')
//                         //             .add({
//                         //           'refferedBy': rUser.id,
//                         //           'referralCode': Order.referralCode,
//                         //           'date': FieldValue.serverTimestamp(),
//                         //           'userId': Order.userId,
//                         //           'items': products,
//                         //           'price': Order.price,
//                         //           'tip': Order.tip,
//                         //           'deliveryCharge': Order.deliveryCharge,
//                         //           'total': Order.total,
//                         //           'gst': Order.gst,
//                         //           'discount': Order.discount,
//                         //           'referralCommission': referralCommission,
//                         //           'amount': (Order.total.toDouble() ??
//                         //                   0 * referralCommission!) /
//                         //               100,
//                         //         }).then((value) {
//                         //           rUser.reference.update({
//                         //             'wallet': FieldValue.increment(
//                         //               Order.total.toDouble() *
//                         //                   referralCommission! /
//                         //                   100,
//                         //             ),
//                         //           });
//                         //         });
//                         //       }
//                         //     }
//                         //     print("finish");
//                         //   }
//                         //   await FirebaseFirestore.instance
//                         //       .collection('orders')
//                         //       .doc(widget.id)
//                         //       .update(ordersRecordData);
//                         //   setState(() {
//                         //     statusController.text = 'Delivered';
//                         //   });
//                         //   await FirebaseFirestore.instance
//                         //       .collection('users')
//                         //       .doc(Order.userId)
//                         //       .update({
//                         //     'currentB2cAmount': FieldValue.increment(
//                         //       double.tryParse(Order.price.toString()) as num,
//                         //     ),
//                         //   });
//                         // }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: Pallete.primaryColor,
//                         onPrimary: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('Delivered'),
//                     )
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2,
//                     child: Text(
//                       widget.name,
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5, right: 15),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Order Id : ',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     SelectableText(
//                       widget.id,
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5, right: 15),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Order Time : ',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     Text(
//                       DateFormat('d-MM-y hh:mm').format(
//                         orderDetailsOrdersRecord!.placedDate.toDate(),
//                       ),
//                       style: const TextStyle(
//                         fontFamily: 'Poppins',
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Order!.orderStatus >= 1
//                   ?
//               Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             border: Border.all(
//                               color: Colors.white,
//                             ),
//                             borderRadius: BorderRadius.circular(12)),
//                         child: DropdownButtonFormField<String>(
//                           value: partner,
//                           decoration: const InputDecoration(
//                             hintText: "Partners",
//                             border: OutlineInputBorder(),
//                           ),
//                           onChanged: (crs) {
//                             partner = crs;
//                             print(partner);
//                             setState(() {});
//                           },
//                           validator: (value) =>
//                               value == null ? 'field required' : null,
//                           items:
//                               p.toList().map<DropdownMenuItem<String>>((value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Order!.orderStatus > 1
//                   ?
//               Padding(
//                       padding: const EdgeInsets.only(left: 10, top: 5),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Invoice No : ',
//                             style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             'TCE-${orderDetailsOrdersRecord.invoiceNo.toString()}',
//                             style: const TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(),
//               Order!.orderStatus >= 1
//                   ?
//               Padding(
//                       padding: const EdgeInsets.only(left: 10, top: 5),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'ShipRocket OrderId : ',
//                             style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             orderDetailsOrdersRecord.shipRocketOrderId,
//                             style: const TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(),
//               Order!.orderStatus >= 1
//                   ?
//               Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(10, 12, 0, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Container(
//                                 width: 200,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color: const Color(0xFFE6E6E6),
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(16, 0, 0, 0),
//                                   child: TextFormField(
//                                     controller: awbCode,
//                                     obscureText: false,
//                                     decoration: const InputDecoration(
//                                       labelText: 'AWD Code',
//                                       labelStyle: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         color: Color(0xFF8B97A2),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       hintText: 'Enter your AWB Code',
//                                       hintStyle: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         color: Color(0xFF8B97A2),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.transparent,
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(4.0),
//                                           topRight: Radius.circular(4.0),
//                                         ),
//                                       ),
//                                       focusedBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.transparent,
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(4.0),
//                                           topRight: Radius.circular(4.0),
//                                         ),
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontFamily: 'Montserrat',
//                                       color: Color(0xFF8B97A2),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   bool pressed = await showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: const Text('Update AWB'),
//                                         content: const Text(
//                                             'Are you sure you want to update AWB?'),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop(false);
//                                             },
//                                             child: const Text('No'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop(true);
//                                             },
//                                             child: const Text('Yes'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//
//                                   if (pressed != null && pressed) {
//                                     FirebaseFirestore.instance
//                                         .collection('orders')
//                                         .doc(widget.id)
//                                         .update({
//                                       'awb_code': awbCode.text,
//                                     });
//                                     showUploadMessage(
//                                         context, 'AWB updated...');
//                                   } else {
//                                     showUploadMessage(
//                                         context, 'AWB not updated.');
//                                   }
//                                 },
//                                 child: Text('Update'),
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Pallete.primaryColor,
//                                   textStyle: const TextStyle(
//                                     fontFamily: 'Lexend Deca',
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(10, 12, 0, 10),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Container(
//                                 width: 350,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color: const Color(0xFFE6E6E6),
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(16, 0, 0, 0),
//                                   child: TextFormField(
//                                     maxLines: 3,
//                                     controller: trackingUrl,
//                                     obscureText: false,
//                                     decoration: const InputDecoration(
//                                       labelText: 'Tracking Url',
//                                       labelStyle: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         color: Color(0xFF8B97A2),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       hintText: 'Enter your AWB Code',
//                                       hintStyle: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         color: Color(0xFF8B97A2),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.transparent,
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(4.0),
//                                           topRight: Radius.circular(4.0),
//                                         ),
//                                       ),
//                                       focusedBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.transparent,
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(4.0),
//                                           topRight: Radius.circular(4.0),
//                                         ),
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       fontFamily: 'Montserrat',
//                                       color: Color(0xFF8B97A2),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () async {
//                                 bool pressed = await showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: const Text('Update Tracking Url'),
//                                       content: const Text(
//                                           'Are you sure you want to update the Tracking Url?'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop(false);
//                                           },
//                                           child: const Text('No'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop(true);
//                                           },
//                                           child: const Text('Yes'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//
//                                 if (pressed != null && pressed) {
//                                   FirebaseFirestore.instance
//                                       .collection('orders')
//                                       .doc(widget.id)
//                                       .update({
//                                     'trackingUrl': trackingUrl.text,
//                                     'partner': partner,
//                                   });
//
//                                   showUploadMessage(
//                                       context, 'Tracking Url updated...');
//                                 } else {
//                                   showUploadMessage(
//                                       context, 'Tracking Url not updated.');
//                                 }
//                               },
//                               child: Text('Update'),
//                               style: ElevatedButton.styleFrom(
//                                 // height: 40,
//                                 primary: Pallete.primaryColor,
//                                 textStyle: const TextStyle(
//                                   fontFamily: 'Lexend Deca',
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 side: const BorderSide(
//                                   color: Colors.transparent,
//                                   width: 1,
//                                 ),
//                                 // borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 if (trackingUrl.text != '') {
//                                   bool pressed = await showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title:
//                                             const Text('Launch Tracking Url'),
//                                         content: const Text(
//                                             'Are you sure you want to launch the Tracking Url?'),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop(false);
//                                             },
//                                             child: const Text('No'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop(true);
//                                             },
//                                             child: const Text('Yes'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//
//                                   if (pressed != null && pressed) {
//                                     _launchURL(trackingUrl.text);
//                                   }
//                                 } else {
//                                   showUploadMessage(
//                                       context, 'Please Enter Tracking Url...');
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 // height: 40,
//                                 primary: Pallete.primaryColor,
//                                 textStyle: const TextStyle(
//                                   fontFamily: 'Lexend Deca',
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 side: const BorderSide(
//                                   color: Colors.transparent,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: const Text('Launch'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   : Container(),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Referred By : ',
//                       style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                     Text(
//                       '${orderDetailsOrdersRecord.referralCode}',
//                       style:
//                           const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'PromoCode : ',
//                       style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                     Text(
//                       '${orderDetailsOrdersRecord.promoCode}',
//                       style:
//                           const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Discount : ',
//                       style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                     Text(
//                       '\₹ ${orderDetailsOrdersRecord.discount.toStringAsFixed(2)}',
//                       style:
//                           const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Delivery Charge : ',
//                       style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                     Text(
//                       '\₹ ${orderDetailsOrdersRecord.deliveryCharge.toStringAsFixed(2)}',
//                       style:
//                           const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Total (excl. GST) : ₹ ${orderDetailsOrdersRecord.total.toStringAsFixed(2)} ',
//                       style:
//                           const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'GST : ',
//                       style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                     Text(
//                       '\₹ ${orderDetailsOrdersRecord.gst.toStringAsFixed(2)}',
//                       style:
//                           const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Order?.shippingMethod == 'Cash On Delivery'
//                   ? const
//               Padding(
//                       padding: EdgeInsets.only(left: 10, top: 5),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             'COD Charge : ',
//                             style:
//                                 TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                           ),
//                           Text(
//                             '\₹ 33.00',
//                             style:
//                                 TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Total Amount : ',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     Text(
//                       '\₹ ${orderDetailsOrdersRecord.price.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       orderDetailsOrdersRecord.shippingMethod,
//                       style: const TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Container(
//                   color: Colors.grey[300],
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             IconButton(
//                                 onPressed: () {
//                                   showDialog(
//                                       context: context,
//                                       barrierDismissible: false,
//                                       builder: (buildContext) {
//                                         return AddressPopUp(
//                                           name: Order?.shippingAddress['name'],
//                                           mobNo: Order
//                                               ?.shippingAddress['mobileNumber'],
//                                           alterMobNo: Order?.shippingAddress[
//                                               'alternativePhone'],
//                                           address:
//                                               Order?.shippingAddress['address'],
//                                           landMark:
//                                               Order?.shippingAddress['landMark'],
//                                           area: Order?.shippingAddress['area'],
//                                           pincode:
//                                               Order?.shippingAddress['pinCode'],
//                                           state: Order?.shippingAddress['state'],
//                                           orderId: widget.id,
//                                           customerId: Order?.userId,
//                                           city: Order?.shippingAddress['city'],
//                                         );
//                                       });
//                                 },
//                                 icon: Icon(Icons.edit)),
//                           ],
//                         ),
//                         Text(
//                           'Name : ' +
//                               orderDetailsOrdersRecord.shippingAddress['name'],
//                           style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Address : ' +
//                                   orderDetailsOrdersRecord
//                                       .shippingAddress['address'] ??
//                               '',
//                           style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Landmark : ' +
//                                   orderDetailsOrdersRecord
//                                       .shippingAddress['landMark'] ??
//                               '',
//                           style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Area :  ${orderDetailsOrdersRecord.shippingAddress['area']}',
//                           style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'State : ${orderDetailsOrdersRecord.shippingAddress['city']},${orderDetailsOrdersRecord.shippingAddress['state']}',
//                           style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Pincode : ' +
//                               orderDetailsOrdersRecord
//                                   .shippingAddress['pinCode'],
//                           style: const TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             const Text(
//                               'Mobile No : ',
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             SelectableText(
//                               orderDetailsOrdersRecord
//                                   .shippingAddress['mobileNumber'],
//                               style: const TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Text(
//                               'Alternative Mobile No : ',
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             SelectableText(
//                               orderDetailsOrdersRecord
//                                   .shippingAddress['alternativePhone'],
//                               style: const TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ]),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: Order?.items?.length,
//                 // itemExtent:!listView?80:30 ,
//                 itemBuilder: (context, itemsIndex) {
//                   final itemsItem = Order?.items?[itemsIndex];
//                   return ListTile(
//                     tileColor: itemsIndex % 2 == 0
//                         ? Colors.blue[200]
//                         : Colors.yellow[200],
//                     leading: CircleAvatar(
//                       radius: 50.0,
//                       backgroundImage: NetworkImage(
//                         itemsItem['image'],
//                       ),
//                     ),
//                     title: Text(
//                       itemsItem['name'],
//                       style: const TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text(
//                       "\₹ ${double.tryParse(itemsItem['price'].toString())}",
//                       style: const TextStyle(
//                           fontSize: 16.0, fontWeight: FontWeight.w500),
//                     ),
//                     trailing: Column(children: [
//                       Text(
//                         'x${itemsItem['quantity'].toString()}',
//                         style: const TextStyle(
//                             fontSize: 18.0, fontWeight: FontWeight.w600),
//                       ),
//                     ]),
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
