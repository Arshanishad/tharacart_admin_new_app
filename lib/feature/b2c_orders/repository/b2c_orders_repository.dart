import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/constants/firebase_constants.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';
import '../../../main.dart';
import '../../../modal/ordermodal.dart';
import '../../home/screen/home_page_widget.dart';
import 'package:http/http.dart' as http;


final b2cordersRepositoryProvider = Provider(
    (ref) => B2COrdersRepository(firestore: ref.read(firestoreProvider)));

class B2COrdersRepository {
  final FirebaseFirestore _firestore;

  B2COrdersRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get orders =>
      _firestore.collection(FirebaseConstants.ordersCollection);
  CollectionReference get users=>_firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _referralCommission=>_firestore.collection(FirebaseConstants.referralCommissionCollection);
  CollectionReference get invoiceNo=>_firestore.collection(FirebaseConstants.invoiceNoCollection);

  int limit = 150;
  Stream<List<OrderModel>> b2corders1(int index,) {
    return orders
        .where('orderStatus', isEqualTo: index)
        .orderBy('placedDate', descending: true)
        .limit(limit)
        .snapshots()
        .map((event) =>
        event.docs.map((e) =>
            OrderModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }



// Stream<List<OrderModel>>b2corders(data){
//   print(data);
//   print("====================================");
//   Map<String,dynamic> map=jsonDecode(data);
//   var datas;
//   print("====================================");
//   print(data);
//   if(map['DatePicker1']!=null&&map['DatePicker2']!=null){
//     print("//////");
//     print(datas);
//     print("[[[[[[object]]]]]]");
//     DateTime date1=DateTime.parse(map["DatePicker1"]);
//     DateTime date2=DateTime.parse(map["DatePicker2"]);
//     print(date1);
//     print(date2);
//     print("[[[---====");
//      datas= orders
//         .where('orderStatus',
//         isEqualTo: map['index'])
//         .where('placedDate',
//         isGreaterThanOrEqualTo:
//         date1 )
//         .where('placedDate',
//         isLessThanOrEqualTo:
//         date2  )
//         .orderBy('placedDate',
//         descending: true)
//         .snapshots().map((event) => event.docs.map((e) => OrderModel.fromJson(e.data()as Map<String,dynamic>)).toList());
//      print(datas);
//      print("============================");
//   }
//   else{
// print('else');
//     datas=orders
//         .where('orderStatus', isEqualTo: map['index'])
//         .orderBy('placedDate', descending: true)
//         .limit(limit)
//         .snapshots()
//         .map((event) =>
//         event.docs.map((e) =>
//             OrderModel.fromJson(e.data() as Map<String, dynamic>)).toList());
//
//     print(datas);
//     print('end');
//   }
//   return datas;
// }
  Stream<List<OrderModel>> b2cOrders(data) {
    print(data);
    print("====================================");
    Map<String, dynamic> map = jsonDecode(data);
    var datas;
    print("====================================");
    print(data);
    if (map['DatePicker1'] != null && map['DatePicker2'] != null) {
      print("//////");
      print(datas);
      print("[[[[[[object]]]]]]");
      DateTime date1 = DateTime.parse(map["DatePicker1"]);
      DateTime date2 = DateTime.parse(map["DatePicker2"]);
      print("Date1: $date1");
      print("Date2: $date2");
      print("[[[---====");

      datas = orders
          .where('orderStatus', isEqualTo: map['index'])
          .where('placedDate', isGreaterThanOrEqualTo: date1)
          .where('placedDate', isLessThanOrEqualTo: date2)
          .orderBy('placedDate', descending: true)
          .snapshots()
          .map((event) => event.docs
          .map((e) => OrderModel.fromJson(e.data() as Map<String, dynamic>))
          .toList());
      print("Datas: $datas");
      print("============================");
    } else {
      print('else');
      datas = orders
          .where('orderStatus', isEqualTo: map['index'])
          .orderBy('placedDate', descending: true)
          .limit(limit)
          .snapshots()
          .map((event) => event.docs
          .map((e) => OrderModel.fromJson(e.data() as Map<String, dynamic>))
          .toList());

      print("Datas: $datas");
      print('end');
    }
    return datas;
  }




  Stream<OrderModel> getOrders(String id) {
    return
     orders.doc(id).snapshots().map(
              (event) => OrderModel.fromJson(event.data() as Map<String, dynamic>));
  }


  Future<void> updateOrderInvoiceNo(String orderId) async {
    try {
      await orders
          .doc(orderId)
          .update({
        "invoiceNo": 0,
      });
      print("InvoiceNo updated successfully!");
    } catch (error) {
      print("Error updating invoiceNo: $error");
    }
  }


  Future<void> updateOrderStatus({
    required String orderId,
    required OrderModel data,
  }) async {
    try {
     orders.doc(orderId).update({
        'orderStatus': data.orderStatus,
        'returnOrder': true,
        'invoiceNo': data.invoiceNo ?? 0,
        'cancelledDate': Timestamp.now(),
      });
      print('Order status updated successfully.');
    } catch (error) {
      print('Error updating order status: $error');
    }
  }


  Future<void> updateOrderstatus({
    required String orderId,
    required OrderModel data,
  }) async {
    try {
      await orders.doc(orderId).update({
        'returnOrder': false,
        'orderStatus': data.orderStatus,
        'cancelledDate': Timestamp.now(),
      });
      print('Order updated successfully!');
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  Future<void> updateAwbCode(String id, String awbCode) async {
    try {
      await orders.doc(id).update({
        'awb_code': awbCode,
      });
      print('Awb Code updated successfully.');
    } catch (e) {
      print('Error updating Awb Code: $e');
    }
  }



  Future<void> processOrderAndReferral(OrderModel data, List<Map<String, dynamic>> products)async {
    if (data.referralCode != null) {
      QuerySnapshot rUsers = await users
          .where('referralCode',
          isEqualTo: data.referralCode)
          .get();
      if (rUsers.docs.length > 0) {
        DocumentSnapshot rUser = rUsers.docs[0];
        double? referralCommission = 0;
        referralCommission = double.tryParse(
          rUser.get('referralCommission').toString(),
        );
        if (referralCommission != 0) {
          print("commission");
          _referralCommission
              .add({
            'refferedBy': rUser.id,
            'referralCode': data.referralCode,
            'date': FieldValue.serverTimestamp(),
            'userId':data.userId,
            'items': products,
            'price': data.price,
            'tip': data.tip,
            'deliveryCharge':data.deliveryCharge,
            'total': data.total,
            'gst': data.gst,
            'discount': data.total,
            'referralCommission': referralCommission,
            'amount': (data.total.toDouble() ??
                0 * referralCommission!) /
                100,
          }).then((value) {
            rUser.reference.update({
              'wallet': FieldValue.increment(
                data.total.toDouble() *
                    referralCommission! /
                    100,
              ),
            });
          });
        }
      }
      print("finish");
    }
    await orders
        .doc(data.orderId)
        .update({
      "orderStatus": data.orderStatus,
      "deliveredDate": Timestamp.now(),
    });
    await users
        .doc(data.userId)
        .update({
      'currentB2cAmount': FieldValue.increment(
        double.tryParse(data.price.toString()) as num,
      ),
    });
  }



  Future<void> cancelOrder(OrderModel data,)async {
    if (data.orderStatus > 2) {
      await orders
          .doc(data.orderId)
          .update({
        'orderStatus': data.orderStatus,
        'returnOrder': true,
        'invoiceNo': data.invoiceNo ?? 0,
        'cancelledDate': Timestamp.now(),
      });
    } else {
      await orders
          .doc(data.orderId)
          .update({
        'returnOrder': false,
        'orderStatus': data.orderStatus,
        'cancelledDate': Timestamp.now(),
      });
    }
  }


  Future<void> updateInvoiceNo(String OrderId) async {
    try {
      await orders
          .doc(OrderId)
          .update({
        "invoiceNo": 0,
      });
      print("InvoiceNo updated successfully");
    } catch (e) {
      print("Error updating invoiceNo: $e");
    }
  }


  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    List<String> nameSplits = caseNumber.split(" ");
    for (int i = 0; i < nameSplits.length; i++) {
      String name = "";
      for (int k = i; k < nameSplits.length; k++) {
        name = name + nameSplits[k] + " ";
      }
      temp = "";
      for (int j = 0; j < name.length; j++) {
        temp = temp + name[j];
        caseSearchList.add(temp.toUpperCase());
      }
    }
    return caseSearchList;
  }

  Future<void> updateOrderStatusAndInvoice(
      String currentBranchId,
      OrderModel data,
      ) async {
    DocumentSnapshot invoiceNoDoc =
    await invoiceNo
        .doc(currentBranchId)
        .get();
  invoiceNo
        .doc(currentBranchId)
        .update({
      'sales': FieldValue.increment(1),
    });
    int sales = invoiceNoDoc.get('sales');
    sales++;
    await orders
        .doc(data.orderId)
        .update({
      'orderStatus':data.orderStatus,
      'shippedDate': Timestamp.now(),
      'invoiceNo': sales,
      'invoiceDate': Timestamp.now(),
    });
  orders
        .doc(data.orderId)
        .update({
      'search': setSearchParam(
          '${sales.toString()} ${data.shipRocketOrderId}'),
    });
  }

  Future<void> shipRocket(OrderModel data) async {
    List items = [];
    if (token != null || token != '') {
      print('1');
      DocumentSnapshot invoiceNoDoc = await invoiceNo
          .doc(currentBranchId)
          .get();
       invoiceNo
          .doc(currentBranchId)
          .update({
        'orderId': FieldValue.increment(1),
      });
      int orderId = invoiceNoDoc.get('orderId');
      orderId++;
      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      print('2');
      print(token);
      print('pppp');
      double amount = 0;
      String method = '';
      if (data.shippingMethod == 'Cash On Delivery') {
        amount = data.total + data.gst + 33;
        method = "COD";
      } else {
        amount = (data.total + data.gst);
        method = "Prepaid";
      }
      for (var data in data.items??[]) {
        items.add({
          'name': data['name'],
          'sku': data['productCode'],
          'units': data['quantity'].toInt(),
          'selling_price': data['price'],
          'tax': data['gst'].toInt(),
          'hsn': data['hsnCode'],
        });
      }
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://apiv2.shiprocket.in/v1/external/orders/create/adhoc'));
      request.body = json.encode({
        "order_id": 'THARAE$orderId',
        "order_date": DateTime.now().toString().substring(0, 16),
        "pickup_location": "THARA CART",
        "billing_customer_name": data.shippingAddress['name'],
        "billing_last_name": "",
        "billing_city": data.shippingAddress['city'],
        "billing_pincode": data.shippingAddress['pinCode'],
        "billing_state": data.shippingAddress['state'],
        "billing_address": data.shippingAddress['address'],
        "billing_country": "India",
        "billing_email": data.shippingAddress['email'],
        "billing_phone": data.shippingAddress['mobileNumber'],
        "shipping_is_billing": true,
        "shipping_customer_name": data.shippingAddress['name'],
        "shipping_address": data.shippingAddress['address'],
        "shipping_address_2": data.shippingAddress['area'],
        "shipping_city": data.shippingAddress['city'],
        "shipping_pincode": data.shippingAddress['pinCode'],
        "shipping_country": "India",
        "shipping_state": data.shippingAddress['state'],
        "shipping_email": data.shippingAddress['email'],
        "shipping_phone": data.shippingAddress['mobileNumber'],
        "order_items": items,
        "payment_method": method,
        "shipping_charges": data.deliveryCharge.toInt(),
        "total_discount": data.discount.toInt(),
        "sub_total": amount.toInt(),
        "length": '10.0',
        "breadth": '15.0',
        "height": '20.0',
        "weight": '2.5'
      });
      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();
      print('-----');
      if (response.statusCode == 200) {
        print('1');
        print(await response.stream.bytesToString());
        await orders
            .doc(data.orderId)
            .update({
          'orderStatus': 1,
          'acceptedDate': Timestamp.now(),
          'shipRocketOrderId': 'THARAE$orderId'
        });
        // showUploadMessage(context, 'Order Accepted...');
        // Navigator.pop(context);
      } else {
        print(response.statusCode);
        print(response.reasonPhrase);
        print(await response.stream.bytesToString());
        // showUploadMessage(context, response.reasonPhrase);
      }
    }
  }


  void updateOrder(String orderId, String trackingLink, String awbCode) async {
    try {
      await orders
          .doc(orderId)
          .update({
        'trackingUrl': trackingLink,
        'awb_code': awbCode,
      });
      print('Order updated successfully');
    } catch (error) {
      print('Error updating order: $error');
    }
  }

  List  p = [];
 Future<List<String>> getPartner() async{
   List<String> partners=[];
    try{
   return await  _firestore
          .collection(FirebaseConstants.settingsCollection)
          .doc('order')
          .get()
          .then((value) {
            partners=[];
            for(var a in value.data()?['partners']??[]){
              partners.add(a.toString());
            }
            return partners;
        // p = value.data()?['partners'];
        print('---------');
        print(p);
      });
    }
    catch (e) {
      print("Error getting partner: $e");
      return [];
    }
  }

  List<DropdownMenuItem> fetchedRiders = [];
  late Map<String, dynamic> selectedRider;
  Future<void> getRiders(OrderModel data) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data1 = await FirebaseFirestore.instance
          .collection("rider")
          .where('online', isEqualTo: true)
          .get();

      for (var doc in data1.docs) {
        fetchedRiders.add(DropdownMenuItem(
          value: doc.data(),
          child: Text(doc.get('display_name')),
        ));

        if (data.driverId == doc.get('uid')) {
            selectedRider = doc.data();
        }
      }
    } catch (e) {
      print('Error fetching riders: $e');
    }
  }
updateTrackingUrl(String trackingUrl,String partner){
orders
      .doc()
      .update({
    'trackingUrl': trackingUrl,
    'partner': partner,
  });
}



  void updateOrderDocument({
    required String orderId,
    required String name,
    required String address,
    required String area,
    required String city,
    required String landMark,
    required String pincode,
    required String state,
    required String mobileNumber,
    required String alterMobileNumber,
  }) {
 _firestore.collection(FirebaseConstants.ordersCollection)
        .doc(orderId)
        .update({
      'shippingAddress.name': name,
      'shippingAddress.address': address,
      'shippingAddress.area': area,
      'shippingAddress.city': city,
      'shippingAddress.landMark': landMark,
      'shippingAddress.pinCode': pincode,
      'shippingAddress.state': state,
      'shippingAddress.mobileNumber': mobileNumber,
      'shippingAddress.alternativePhone': alterMobileNumber,
    })
        .then((_) {
      print('Document updated successfully');
    })
        .catchError((error) {
      print('Error updating document: $error');
    });
  }




}


