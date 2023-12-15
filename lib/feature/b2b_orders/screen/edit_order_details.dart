import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'package:tharacart_admin_new_app/feature/b2b_orders/controller/b2b_order_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/common/Upload_message.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../../../modal/b2bmodel.dart';
import '../../../modal/invoice model.dart';
import '../../b2c_orders/screen/pdf_api.dart';
import '../../home/screen/home_page_widget.dart';
import 'b2b_image_view.dart';
import 'b2b_pdf.dart';

class B2BOrderDetailsWidget extends ConsumerStatefulWidget {
  B2BOrderDetailsWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  ConsumerState createState() => _B2BOrderDetailsWidgetState();
}

class _B2BOrderDetailsWidgetState extends ConsumerState<B2BOrderDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController statusController = TextEditingController();
  bool listView = false;
  // Map colorMap = new Map();
  // var orderItems;
  String gst = '';
  String? partner;
  Map address = {};
  Map billingAddress = {};
  bool b2b = false;

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

  List orderData = [];
  List<DropdownMenuItem> fetchedRiders = [];
  late Map<String, dynamic> selectedRider;
  List<Map<String, dynamic>> products = [];

  Future<void> getOrderItems(B2bModel data) async {
    List ordersItems = [];
    for (int i = 0; i < data.items.length; i++) {
      Map tempOrderData = new Map();
      tempOrderData['quantity'] = data.items[i].quantity;
      DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore
          .instance
          .collection('products')
          .doc(data.items[i].id)
          .get();
      tempOrderData['productImage'] = docRef.data()?['imageId'][0];
      tempOrderData['productName'] = docRef.data()?['name'];
      tempOrderData['price'] = data.items[i].price;
      ordersItems.add(tempOrderData);
    }
    if (mounted) {
      setState(() {
        orderData = ordersItems;
      });
    }
  }

  _launchURL(String urls) async {
    var url = urls;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // shipRocket(B2bModel data) async {
  //   List items = [];
  //
  //   if (token != null || token != '') {
  //     DocumentSnapshot invoiceNoDoc = await FirebaseFirestore.instance
  //         .collection('invoiceNo')
  //         .doc(currentBranchId)
  //         .get();
  //     FirebaseFirestore.instance
  //         .collection('invoiceNo')
  //         .doc(currentBranchId)
  //         .update({
  //       'orderId': FieldValue.increment(1),
  //     });
  //     int orderId = invoiceNoDoc.get('orderId');
  //     orderId++;
  //
  //     var header = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token'
  //     };
  //     print(token);
  //
  //     double amount = 0;
  //     String method = '';
  //     if (data.shippingMethod == 'Cash On Delivery') {
  //       amount = data.total + data.gst + 33;
  //       method = "COD";
  //     } else {
  //       amount =data.total + data.gst;
  //       method = "Prepaid";
  //     }
  //
  //     for (var data in data.items) {
  //       items.add({
  //         'name': data.name,
  //         'sku': data.productCode,
  //         'units': data.quantity.toInt(),
  //         'selling_price': data.price * 100 / (100 + data.gst.toInt()),
  //         'tax': data.gst.toInt(),
  //         'hsn': data.hashCode,
  //       });
  //     }
  //
  //     var request = http.Request(
  //         'POST',
  //         Uri.parse(
  //             'https://apiv2.shiprocket.in/v1/external/orders/create/adhoc'));
  //     request.body = json.encode({
  //       "order_id": 'THARAE$orderId',
  //       "order_date": DateTime.now().toString().substring(0, 16),
  //       "pickup_location": "THARA CART",
  //       "billing_customer_name": data.shippingAddress['name'],
  //       "billing_last_name": "",
  //       "billing_city": data.shippingAddress['city'],
  //       "billing_pincode": data.shippingAddress['pinCode'],
  //       "billing_state":data.shippingAddress['state'],
  //       "billing_address": data.shippingAddress['address'],
  //       "billing_country": "India",
  //       "billing_email": data.shippingAddress['email'],
  //       "billing_phone": data.shippingAddress['mobileNumber'],
  //       "shipping_is_billing": true,
  //       "shipping_customer_name": data.shippingAddress['name'],
  //       "shipping_address": data.shippingAddress['address'],
  //       "shipping_address_2": data.shippingAddress['area'],
  //       "shipping_city": data.shippingAddress['city'],
  //       "shipping_pincode": data.shippingAddress['pinCode'],
  //       "shipping_country": "India",
  //       "shipping_state": data.shippingAddress['state'],
  //       "shipping_email": data.shippingAddress['email'],
  //       "shipping_phone": data.shippingAddress['mobileNumber'],
  //       "order_items": items,
  //       "payment_method": method,
  //       "shipping_charges": data.deliveryCharge.toInt(),
  //       "sub_total": amount.toInt(),
  //       "length": '10.0',
  //       "breadth": '15.0',
  //       "height": '20.0',
  //       "weight": '2.5'
  //     });
  //     request.headers.addAll(header);
  //
  //     http.StreamedResponse response = await request.send();
  //     print('1');
  //     if (response.statusCode == 200) {
  //       print(await response.stream.bytesToString());
  //       final ordersRecordData = createB2bOrdersRecordData(
  //           orderStatus: 1,
  //           acceptedDate: Timestamp.now(),
  //           shipRocketOrderId: 'THARAE$orderId');
  //       await widget.order.reference.update(ordersRecordData);
  //       showUploadMessage(context, 'New Shipment Created...');
  //
  //       Navigator.pop(context);
  //     } else {
  //       print(response.statusCode);
  //       print(response.reasonPhrase);
  //       print(await response.stream.bytesToString());
  //     }
  //   }
  // }

  TextEditingController awbCode = TextEditingController();
  TextEditingController trackingUrl = TextEditingController();
  List<dynamic> p = [];
  // var partner;Drop
  // getPartner() {
  //   FirebaseFirestore.instance
  //       .collection('settings')
  //       .doc('order')
  //       .get()
  //       .then((value) {
  //     p = value.data()['partners'];
  //     print('---------');
  //     print(p);
  //   });
  // }

  updateOrderStatus(B2bModel data) {
    ref.read(b2bOrderControllerProvider).updateOrderStatus(data);
  }

  updateOrderstatus(B2bModel data) {
    ref.read(b2bOrderControllerProvider).updateOrderstatus(data);
  }

  updateTrackingUrl(String id, String trackingUrl) {
    ref.read(b2bOrderControllerProvider).updateTrackingUrl(id, trackingUrl);
  }

  updateOrderStatusAndInvoice(String currentBranchId, B2bModel data,
      List<Map<String, dynamic>> products) {
    ref
        .read(b2bOrderControllerProvider)
        .updateOrderStatusAndInvoice(currentBranchId, data, products);
  }

  processOrderAndReferral(B2bModel data, List<Map<String, dynamic>> products) {
    ref
        .read(b2bOrderControllerProvider)
        .processOrderAndReferral(data, products);
  }

  updatePartner(String partner) {
    ref
        .read(b2bOrderControllerProvider)
        .updatePartner(trackingUrl.text, partner);
  }

  updateAwbCode(String id, String awbCode) {
    ref.read(b2bOrderControllerProvider).updateAwbCode(id, awbCode);
  }

  shipRocket(B2bModel data) {
    ref.read(b2bOrderControllerProvider).shipRocket(data);
  }

  updateOrder(String orderId, String trackingLink, String awbCode) {
    ref
        .read(b2bOrderControllerProvider)
        .updateOrder(orderId, trackingLink, awbCode);
  }

  var docImage;

  late StreamSubscription user;
  getorderspartner() {
    print('Id |: ' + widget.id);

    user = FirebaseFirestore.instance
        .collection('b2bOrders')
        .doc(widget.id)
        .snapshots()
        .listen((event) {
      print('12490');
      print(event.data());
      // partner=event.data()['partner'];
      try {
        print('========');
        print(widget.id);
        partner = event.get('partner');
        trackingUrl.text = event.get('trackingUrl');
        awbCode.text = event.get('awb_code');
        print(docImage);
      } catch (e) {
        print(e.toString());
      }
      try {
        print('========');
        print(widget.id);
        docImage = event.data()?['docImage'];
        print(docImage);
      } catch (e) {
        print(e.toString());
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // getOrderItems(data);
    // getAddress();
    getorderspartner();
    // getPartner();
    // statusController.text = (widget.order.orderStatus == 0)
    //     ? 'Pending'
    //     : (widget.order.orderStatus == 1)
    //         ? 'Accepted'
    //         : (widget.order.orderStatus == 3)
    //             ? 'Shipped'
    //             : (widget.order.orderStatus == 4)
    //                 ? 'Delivered'
    //                 : 'Cancelled';

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    user.cancel();
    super.dispose();
  }

  String awbNo = '';
  String trackingLink = '';

  getTrackingId(B2bModel data) async {
    var list;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var request = http.Request(
        'GET',
        Uri.parse(
            'https://apiv2.shiprocket.in/v1/external/courier/track?order_id=${data.shipRocketOrderId}&channel_id=1861189'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List body = json.decode(await response.stream.bytesToString());

      // print(response.stream.bytesToString());
      // print(body);

      if (body == null || body.length == 0) {
        print(body);

        showDialog(
            context: context,
            builder: (buildContext) {
              return AlertDialog(
                title: Text('Not Shipped'),
                content: SelectableText(trackingLink),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok')),
                ],
              );
            });
      } else {
        print(body);

        list = body[0]['tracking_data'];
        trackingLink = list['track_url'];
        List shipment_track = list['shipment_track'];
        print(shipment_track[0]['awb_code']);

        showDialog(
            context: context,
            builder: (buildContext) {
              return AlertDialog(
                title: Text('Tracking Url'),
                content: SelectableText(trackingLink),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        // FirebaseFirestore.instance.collection(FirebaseConstants.b2bOrdersCollection).update({
                        //     'trackingUrl': trackingLink,
                        //     'awb_code': shipment_track[0]['awb_code'],
                        //   });
                        updateOrder(data.orderId, trackingLink,
                            shipment_track[0]['awb_code']);
                        Navigator.pop(context);
                        showUploadMessage(context, 'Tracking Url Updated...');
                      },
                      child: Text('Submit')),
                ],
              );
            });
      }
      setState(() {});
    } else {
      print(response.reasonPhrase);

      showDialog(
          context: context,
          builder: (buildContext) {
            return AlertDialog(
              title: Text('Order Not Shipped'),
              content: SelectableText(trackingLink),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('Ok')),
              ],
            );
          });
    }
  }

  getAddress(B2bModel data) async {
    address = {};
    billingAddress = {};

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('b2bOrders')
        .doc(data.orderId)
        .get();

    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .doc(data.userId)
        .get();

    address = doc.get('shippingAddress');
    print('customer place ' + address['state']);

    if (data.orderStatus == 3 && user.get('b2b') == true) {
      gst = user.get('gst');
      b2b = user.get('b2b');
    }

    if (b2b == true) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('b2bRequests')
          .doc(data.userId)
          .get();

      List<Map<String, dynamic>> taxpayerInfo = [];
      if (data.orderStatus == 1) {
        taxpayerInfo.add(doc.get('taxpayerInfo'));

        billingAddress = {};
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return ref.watch(getb2bOrdersProvider(widget.id)).when(
            data: (data) {
              return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  backgroundColor: Pallete.primaryColor,
                  automaticallyImplyLeading: true,
                  title: Text(
                    '${statusController.text} Order',
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.white),
                  ),
                  actions: [
                    data.orderStatus != 3
                        ? Container()
                        : IconButton(
                            iconSize: 27,
                            onPressed: () {
                              getTrackingId(data);
                            },
                            icon: const Icon(Icons.report)),
                    data.orderStatus == 3
                        ? IconButton(
                            iconSize: 27,
                            onPressed: () async {
                              print('11111');
                              Map items = {};
                              List products = [];
                              int? amount =
                                  int.tryParse(data.price.toInt().toString());
                              print(data.price.toString());
                              print(amount.toString());
                              String number =
                                  NumberToWord().convert('en-in', amount!);
                              for (var item in data.items ?? []) {
                                print(item.name);
                                items = {
                                  'productName': item.name,
                                  'price': item.price,
                                  'quantity': item.quantity.toInt(),
                                  'total': item.price * item.quantity,
                                  'gst': item.gst,
                                };
                                products.add(items);
                              }
                              print(items);
                              List<InvoiceItem> item = [];
                              for (var data in products) {
                                item.add(
                                  InvoiceItem(
                                    description: data['productName'],
                                    gst: data['total'] -
                                        data['quantity'] *
                                            data['price'] *
                                            100 /
                                            (100 + data['gst']),
                                    // gst: items['quantity']*items['price']*100/(100+items['gst'])* items['gst']/100,
                                    price: data['price'],
                                    quantity: data['quantity'],
                                    tax: data['quantity'] *
                                        data['price'] *
                                        100 /
                                        (100 + data['gst']),
                                    total: data['total'],
                                    unitPrice: data['price'] *
                                        100 /
                                        (100 + data['gst']),
                                    gstp: data['gst'].toDouble(),
                                  ),
                                );
                              }
                              final invoice = Invoice(
                                discount: data.discount,
                                shipRocketId: data.shipRocketOrderId,
                                invoiceNo: data.invoiceNo,
                                invoiceNoDate: data.invoiceDate,
                                shipping: data.deliveryCharge,
                                orderId: data.orderId,
                                orderDate: data.placedDate,
                                method: data.shippingMethod,
                                amount: number,
                                gst: data.gst,
                                price: data.price,
                                total: data.price,
                                b2b: true,
                                shippingAddress: [
                                  ShippingAddress(
                                    gst: gst ?? '',
                                    name: address['name'],
                                    area: address['area'],
                                    address: address['address'],
                                    mobileNumber: address['mobileNumber'],
                                    pincode: address['pinCode'],
                                    state: address['state'],
                                    city: address['city'],
                                  ),
                                ],
                                salesItems: item,
                              );
                              final pdfFile =
                                  await B2bPdfInvoiceApi.generate(invoice);
                              await PdfApi.openFile(pdfFile);
                            },
                            icon: const Icon(Icons.picture_as_pdf))
                        : Container()
                  ],
                  centerTitle: true,
                  elevation: 4,
                ),
                body: SafeArea(
                  minimum: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Cancel Order'),
                                          content: const Text(
                                              'Are you sure you want to cancel this order?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (data.orderStatus < 2) {
                                                  updateOrderStatus(data);
                                                  statusController.text =
                                                      'cancelled';
                                                } else {
                                                  updateOrderstatus(data);
                                                  statusController.text =
                                                      'cancelled';
                                                }
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Pallete.primaryColor,
                                    minimumSize: const Size(110, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Container(
                                      width: 100,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  bool proceed = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Do you want to accept this order?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              shipRocket(data);
                                              Navigator.pop(context);
                                              // Navigator.of(context).pop(true);
                                            },
                                            child: const Text('Accept'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // if (proceed != null && proceed) {
                                  //   shipRocket(data);
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Pallete.primaryColor,
                                  minimumSize: const Size(110, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                     await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirmation'),
                                            content: const Text(
                                                'Is this order shipped?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  updateOrderStatusAndInvoice(
                                                      currentBranchId,
                                                      data,
                                                      products);
                                                  statusController.text =
                                                      'Shipped';
                                                  Navigator.pop(context);
                                                  // Navigator.of(context).pop(true);
                                                },
                                                child: const Text('Shipped'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Pallete.primaryColor,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Shipped',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                              ElevatedButton(
                                onPressed: () async {
                                  List<Map<String, dynamic>> products = [];
                                  for (var item in data.items ?? []) {
                                    products.add({
                                      'gst': item['gst'],
                                      'hsnCode': item['hsnCode'],
                                      'id': item['id'],
                                      'image': item['image'],
                                      'name': item['name'],
                                      'price': item['price'],
                                      'productCode': item['productCode'],
                                      'quantity': item['quantity'],
                                      'status': item['status'],
                                    });
                                  }
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Is this order delivered?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              processOrderAndReferral(
                                                  data, products);
                                              statusController.text =
                                                  'Delivered';
                                              Navigator.pop(context);
                                              // Navigator.of(context).pop(true);
                                            },
                                            child: Container(
                                              height:100,
                                                width:40,
                                                child: const Text('Delivered')),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // if (proceed != null && proceed) {
                                  //   final orderStatus = 4;
                                  //
                                  //   // final ordersRecordData = createB2bOrdersRecordData(
                                  //   //   orderStatus: orderStatus,
                                  //   //   deliveredDate: Timestamp.now(),
                                  //   // );
                                  //
                                  //   if (data.referralCode != null) {
                                  //     QuerySnapshot rUsers = await FirebaseFirestore.instance
                                  //         .collection('users')
                                  //         .where('referralCode', isEqualTo:data.referralCode)
                                  //         .get();
                                  //     if (rUsers.docs.length > 0) {
                                  //       DocumentSnapshot rUser = rUsers.docs[0];
                                  //       double? referralCommission = 0;
                                  //       referralCommission = double.tryParse(rUser.get('referralCommission').toString());
                                  //
                                  //       if (referralCommission != 0) {
                                  //         print("commission");
                                  //         FirebaseFirestore.instance.collection('referralCommission').add({
                                  //           'refferedBy': rUser.id,
                                  //           'referralCode': data.referralCode,
                                  //           'date': FieldValue.serverTimestamp(),
                                  //           'userId': data.userId,
                                  //           'items': products,
                                  //           'price': data.price,
                                  //           'tip': data.tip,
                                  //           'deliveryCharge': data.deliveryCharge,
                                  //           'total': data.total,
                                  //           'gst': data.gst,
                                  //           'discount': data.discount,
                                  //           'referralCommission': referralCommission,
                                  //           'amount': data.total * referralCommission! / 100,
                                  //         }).then((value) {
                                  //           rUser.reference.update({
                                  //             'wallet': FieldValue.increment(data.total * referralCommission / 100),
                                  //           });
                                  //         });
                                  //       }
                                  //     }
                                  //     print("finish");
                                  //   }
                                  //
                                  //   await orderDetailsOrdersRecord.reference.update(ordersRecordData);
                                  //   setState(() {
                                  //     statusController.text = 'Delivered';
                                  //   });
                                  //   await FirebaseFirestore.instance
                                  //       .collection('users')
                                  //       .doc(widget.data.userId)
                                  //       .update({
                                  //     'currentB2bAmount': FieldValue.increment(double.tryParse(data.price.toString()) as num),
                                  //   });
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Pallete.primaryColor,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Container(
                                  width: 110,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Delivered',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // Row(
                        //     children:[
                        //       Container(
                        //         width: 250,
                        //         // height: 70,
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.circular(8),
                        //           border: Border.all(
                        //             color: Color(0xFFE6E6E6),
                        //           ),
                        //         ),
                        //         child:SearchableDropdown.single(
                        //       items: fetchedRiders,
                        //       value: selectedRider,
                        //       hint:selectedRider==null? "Assign Rider":selectedRider['display_name'],
                        //       searchHint: "Select Rider",
                        //       onChanged: (value) {
                        //         setState(() {
                        //
                        //           selectedRider = value;
                        //
                        //         });
                        //
                        //       },
                        //       isExpanded: true,
                        //     ),),
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: FFButtonWidget(
                        //           onPressed: () async {
                        //             bool proceed = await alert(
                        //                 context, 'You want this rider Assigned?');
                        //
                        //             if (proceed) {
                        //              String driverId=selectedRider==null?"":selectedRider['uid'];
                        //              String driverName=selectedRider==null?"":selectedRider['display_name'];
                        //
                        //
                        //               final ordersRecordData = createOrdersRecordData(
                        //                driverId:driverId,
                        //                 driverName: driverName,
                        //
                        //               );
                        //
                        //               await orderDetailsOrdersRecord.reference
                        //                   .update(ordersRecordData);
                        //               setState(() {
                        //                 statusController.text = 'Driver Assigned';
                        //               });
                        //             }
                        //           },
                        //           text: 'Assign',
                        //           options: FFButtonOptions(
                        //             width: 110,
                        //             height: 40,
                        //             color: FlutterFlowTheme.primaryColor,
                        //             textStyle: FlutterFlowTheme.subtitle2.override(
                        //               fontFamily: 'Poppins',
                        //               color: Colors.white,
                        //             ),
                        //             borderSide: BorderSide(
                        //               color: Colors.transparent,
                        //               width: 1,
                        //             ),
                        //             borderRadius: 12,
                        //           ),
                        //         ),
                        //       ),
                        //     ]
                        //   ),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   'Customer name : ',
                            //   style: FlutterFlowTheme.bodyText1.override(
                            //     fontFamily: 'Poppins',
                            //   ),
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                'Name: ${data.shippingAddress['name']}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Id : ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SelectableText(
                                data.orderId,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Time : ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'd-MM-y hh:mm',
                                ).format(data.placedDate.toDate()),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        data.orderStatus >= 1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Consumer(builder: (context, ref, child) {
                                    var data =
                                        ref.watch(getPartnerListProvider);
                                    return data.when(
                                      data: (data) {
                                        print("dataaa");
                                        print(data);
                                        print("dataaa");
                                        return DropdownButtonFormField<String>(
                                          value: partner,
                                          decoration: const InputDecoration(
                                            hintText: "Partners",
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (crs) {
                                            partner = crs;
                                            print(partner);
                                            setState(() {});
                                          },
                                          validator: (value) => value == null
                                              ? 'field required'
                                              : null,
                                          items: data
                                              .toList()
                                              .map<DropdownMenuItem<String>>(
                                                  (value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        print(error);
                                        return SizedBox();
                                      },
                                      loading: () {
                                        return SizedBox();
                                      },
                                    );
                                  }),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Update Tracking Url'),
                                                content: const Text(
                                                    'Are you sure you want to update the Tracking Url?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      updatePartner(
                                                          data.partner);
                                                      Navigator.pop(context);
                                                      showUploadMessage(context,
                                                          'Tracking Url updated...');
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text('update'))
                                ],
                              )
                            : const SizedBox(),
                        data.orderStatus == 3
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Invoice No : ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'TCE-${data.invoiceNo.toString()}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        data.orderStatus >= 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'ShipRocket OrderId : ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data.shipRocketOrderId,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        data.orderStatus >= 1
                            ? Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 12, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFFE6E6E6),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 0, 0),
                                            child: TextFormField(
                                              controller: awbCode,
                                              obscureText: false,
                                              decoration: const InputDecoration(
                                                labelText: 'AWD Code',
                                                labelStyle: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                hintText: 'Enter your AWB Code',
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Color(0xFF8B97A2),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // bool pressed =
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Update AWB'),
                                                  content: TextField(
                                                    controller: awbCode,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Enter AWB Code'),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        updateAwbCode(
                                                            data.orderId,
                                                            data.awb_code);
                                                        // Navigator.of(context).pop(true);
                                                        Navigator.pop(context);
                                                        showUploadMessage(
                                                            context,
                                                            'AWB updated...');
                                                      },
                                                      child:
                                                          const Text('Update'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // if (pressed != null && pressed) {
                                            //   FirebaseFirestore.instance
                                            //       .collection('b2bOrders')
                                            //       .doc(widget.id)
                                            //       .update({
                                            //     'awb_code': awbCode.text,
                                            //   });
                                            //   showUploadMessage(context, 'AWB updated...');
                                            // }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Pallete.primaryColor,
                                            onPrimary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Update',
                                              style: TextStyle(
                                                fontFamily: 'Lexend Deca',
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 12, 0, 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 350,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFFE6E6E6),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 0, 0),
                                            child: TextFormField(
                                              maxLines: 3,
                                              controller: trackingUrl,
                                              obscureText: false,
                                              decoration: const InputDecoration(
                                                labelText: 'Tracking Url',
                                                labelStyle: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                hintText: 'Enter your AWB Code',
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Color(0xFF8B97A2),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool pressed = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Update Tracking Url'),
                                                content: TextField(
                                                  controller: trackingUrl,
                                                  decoration: const InputDecoration(
                                                      labelText:
                                                          'Enter Tracking Url'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      updateTrackingUrl(
                                                          data.orderId,
                                                          trackingUrl.text);
                                                      showUploadMessage(context,
                                                          'Tracking Url updated...');
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text('Update'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          // if (pressed != null && pressed) {
                                          //   orderDetailsOrdersRecord.reference.update({
                                          //     'trackingUrl': trackingUrl.text,
                                          //   });
                                          //   showUploadMessage(context, 'Tracking Url updated...');
                                          // }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Pallete.primaryColor,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Container(
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Update',
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (trackingUrl.text.isNotEmpty) {
                                            bool pressed = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Launch Tracking Url'),
                                                  content: const Text(
                                                      'Do you want to launch the Tracking Url?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child:
                                                          const Text('Launch'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (pressed != null && pressed) {
                                              _launchURL(trackingUrl.text);
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'Please Enter Tracking Url'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Pallete.primaryColor,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Container(
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Launch',
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        data.orderStatus >= 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'AWB Code : ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SelectableText(
                                      data.awb_code,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Referred By : ',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                              Text(
                                data.referralCode,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'PromoCode : ',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                              Text(
                                data.promoCode,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Discount : ',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                              Text(
                                '\₹ ${data.discount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Delivery Charge : ',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                              Text(
                                '\₹ ${data.deliveryCharge.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Total (excl. GST) : ₹ ${data.total.toStringAsFixed(2)} ',
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'GST : ',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                              Text(
                                '\₹ ${data.gst.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount : ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                '\₹ ${data.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data.shippingMethod,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            color: Colors.grey[300],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name : ' + data.shippingAddress['name'],
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Address : ' +
                                            data.shippingAddress['address'] ??
                                        '',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Landmark : ' +
                                            data.shippingAddress['landMark'] ??
                                        '',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Area :  ${data.shippingAddress['area']}',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'State : ${data.shippingAddress['city']},${data.shippingAddress['state']}',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Pincode : ' +
                                        data.shippingAddress['pinCode'],
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Mobile No : ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SelectableText(
                                        data.shippingAddress['mobileNumber'],
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Imageview(
                                          image: data.docImage,
                                        )));
                          },
                          child: Container(
                              height: 300,
                              width: 300,
                              child: data.docImage == ''
                                  ? Container()
                                  : Image.network(data.docImage)
                              // Image.network('https://firebasestorage.googleapis.com/v0/b/tharacartonlinestore.appspot.com/o/users%2FvRN5P8h5pDYMmSeb9BKQarrx9rJ2%2Fuploads%2F1681730026543455.jpg?alt=media&token=967724a9-1691-43f7-9dad-e91652e6bb67')
                              // CachedNetworkImage(
                              //   imageUrl: docImage,
                              // ),
                              ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: data.items.length,
                          // itemExtent:!listView?80:30 ,
                          itemBuilder: (context, itemsIndex) {
                            final itemsItem = data.items[itemsIndex];
                            return ListTile(
                              tileColor: itemsIndex % 2 == 0
                                  ? Colors.blue[200]
                                  : Colors.yellow[200],
                              leading: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(
                                  itemsItem['image'],
                                ),
                              ),
                              title: Text(
                                itemsItem['name'],
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                "\₹ ${double.tryParse(itemsItem['price'].toString())}",
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Column(children: [
                                Text(
                                  'x${itemsItem['quantity'].toString()}',
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    });
  }
}
