import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:tharacart_admin_new_app/feature/b2c_orders/screen/pdf_api.dart';
import 'package:tharacart_admin_new_app/modal/ordermodal.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/common/Upload_message.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/theme/pallete.dart';
import '../../../main.dart';
import '../../../modal/invoice model.dart';
import '../../home/screen/home_page_widget.dart';
import '../controller/b2c_orders_controller.dart';
import 'address_popup.dart';
import 'b2c_pdf.dart';

class EditB2cOrders extends ConsumerStatefulWidget {
  final String id;
  const EditB2cOrders({super.key, required this.id});

  @override
  ConsumerState<EditB2cOrders> createState() => _EditOrdersState();
}

class _EditOrdersState extends ConsumerState<EditB2cOrders> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController statusController = TextEditingController();
  TextEditingController awbCode = TextEditingController();
  TextEditingController trackingUrl = TextEditingController();

  bool b2b = false;
  List<DropdownMenuItem> fetchedRiders = [];
  late Map<String, dynamic> selectedRider;
  Map address = {};
  Map billingAddress = {};
  String? partner;

  _launchURL(String urls) async {
    var url = urls;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List orderData = [];
  Future<void> getOrderItems(OrderModel data) async {
    List ordersItems = [];
    for (int i = 0; i < data.items!.length; i++) {
      Map tempOrderData = new Map();
      tempOrderData['quantity'] = data.items?[i].quantity;
      DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore
          .instance
          .collection('products')
          .doc(data.items?[i].id)
          .get();
      tempOrderData['productImage'] = docRef.data()?['imageId'][0];
      tempOrderData['productName'] = docRef.data()?['name'];
      tempOrderData['price'] = data.items?[i].price;
      ordersItems.add(tempOrderData);
    }
    if (mounted) {
      setState(() {
        orderData = ordersItems;
      });
    }
  }

  getOrderDetails(OrderModel data) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.id)
        .snapshots()
        .listen((event) async {
      print('========');
      print(event.data());
      // Order = OrderModel.fromJson(event.data()??{});
      print('Order.orderStatus');
      awbCode.text = data.awb_code;
      trackingUrl.text = data.trackingUrl;
      print(data.orderStatus);
      print(']]]]]]]');
      statusController.text = (data.orderStatus == 0)
          ? 'Pending'
          : (data.orderStatus == 1)
              ? 'Accepted'
              : (data.orderStatus == 3)
                  ? 'Shipped'
                  : (data.orderStatus == 4)
                      ? 'Delivered'
                      : 'Cancelled';
      getOrderItems(data);
      if (mounted) {
        setState(() {});
      }
    });
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

  getAddress(OrderModel data) async {
    address = {};
    billingAddress = {};

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.id)
        .get();

    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .doc(data.userId)
        .get();

    address = doc.get('shippingAddress');
    print('customer place ' + address['state']);

    if (data.orderStatus == 3 && user.get('b2b') == true) {
      data.gst = user.get('gst');
      b2b = user.get('b2b');
    }

    if (b2b == true) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('b2bRequests')
          .doc(data.userId)
          .get();

      List<Map<String, dynamic>> taxpayerInfo = [];

      if (doc.exists) {
        if (doc.get('status') == 1) {
          taxpayerInfo.add(doc.get('taxpayerInfo'));

          billingAddress = {};
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  updateOrder(String orderId, String trackingLink, String awbCode) {
    ref
        .read(b2COrdersControllerProvider)
        .updateOrder(orderId, trackingLink, awbCode);
  }

  String trackingLink = '';
  getTrackingId(OrderModel data) async {
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
      print(await response.stream.bytesToString());
      if (body == null || body.length == 0) {
        showDialog(
            context: context,
            builder: (buildContext) {
              return AlertDialog(
                title: Text('Order Not Shipped'),
                content: SelectableText(trackingLink),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok')),
                ],
              );
            });
      } else {
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
                        // FirebaseFirestore.instance
                        //     .collection('orders')
                        //     .doc(widget.id)
                        //     .update({
                        //   'trackingUrl': trackingLink,
                        //   'awb_code': shipment_track[0]['awb_code'],
                        // });
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

  shipRocket(OrderModel data) {
    ref.read(b2COrdersControllerProvider).shipRocket(data);
  }

  updateOrderStatus(String orderId, OrderModel data) {
    ref
        .read(b2COrdersControllerProvider)
        .updateOrderStatus(orderId: orderId, data: data);
  }

  updateOrderInvoiceNo(String orderId) {
    ref.read(b2COrdersControllerProvider).updateOrderInvoiceNo(orderId);
  }

  updateOrderstatus(String orderId, OrderModel data) {
    ref
        .read(b2COrdersControllerProvider)
        .updateOrderstatus(orderId: orderId, data: data);
  }

  updateAwbCode(String id, String awbCode) {
    ref.read(b2COrdersControllerProvider).updateAwbCode(id, awbCode);
  }

  processOrderAndReferral(
      OrderModel data, List<Map<String, dynamic>> products) {
    ref
        .read(b2COrdersControllerProvider)
        .processOrderAndReferral(data, products);
  }

  updateOrderStatusAndInvoice(
    String currentBranchId,
    OrderModel data,
  ) {
    ref
        .read(b2COrdersControllerProvider)
        .updateOrderStatusAndInvoice(currentBranchId, data);
  }

  cancelOrder(
    OrderModel data,
  ) {
    ref.read(b2COrdersControllerProvider).cancelOrder(data);
  }

  updateInvoiceNo(String OrderId) {
    ref.read(b2COrdersControllerProvider).updateInvoiceNo(OrderId);
  }


  updateTrackingUrl(String partner){
    ref.read(b2COrdersControllerProvider).updateTrackingUrl(trackingUrl.text,partner);
  }




  // List p = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return ref.watch(getOrdersProvider(widget.id)).when(
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
                    data.orderStatus == 2 && data.invoiceNo != 0
                        ? TextButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Change Invoice Number'),
                                    content: const Text(
                                        'Do you want to change the invoice number?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          updateInvoiceNo(data.orderId);
                                          Navigator.pop(context);
                                          showUploadMessage(context,
                                              'Successfully changed invoice number');
                                          // Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Invalidate \ninvoice',
                              style: TextStyle(color: Colors.white),
                            ))
                        : Container(),
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
                              Map items = {};
                              List products = [];
                              for (var item in data.items ?? []) {
                                // print(item.name);
                                items = {
                                  'productName': item['name'],
                                  'price': item['price'],
                                  'quantity': item['quantity'].toInt(),
                                  'total': item['price'] * item['quantity'],
                                  'gst': item['gst'],
                                };
                                products.add(items);
                              }
                              print(items);
                              print(b2b);
                              List<InvoiceItem> item = [];
                              int? amount =
                                  int.tryParse(data.price.toInt().toString());
                              print(amount.toString());
                              String number =
                                  NumberToWord().convert('en-in', amount!);
                              for (var data in products) {
                                item.add(
                                  InvoiceItem(
                                      gstp: data['gst'].toDouble(),
                                      description: data['productName'],
                                      // gst: data['total'] -
                                      //     data['quantity'] *
                                      //         data['price'] *
                                      //         100 /
                                      //         (100 + data['gst']),
                                      gst: items['quantity'] *
                                          items['price'] *
                                          100 /
                                          (100 + items['gst']) *
                                          items['gst'] /
                                          100,
                                      price: data['price'].toDouble(),
                                      quantity: data['quantity'],
                                      tax: data['quantity'] *
                                          data['price'] *
                                          100 /
                                          (100 + data['gst']),
                                      total: data['total'].toDouble(),
                                      unitPrice: data['price'] *
                                          100 /
                                          (100 + data['gst'])),
                                );
                              }

                              final invoice = Invoice(
                                invoiceNo: data.invoiceNo,
                                discount: data.discount,
                                shipRocketId: data.shipRocketOrderId,
                                invoiceNoDate: data.invoiceDate,
                                orderId: widget.id,
                                shipping: data.deliveryCharge,
                                orderDate: data.placedDate,
                                total: data.total,
                                price: data.price,
                                gst: data.gst,
                                amount: number,
                                method: data.shippingMethod,
                                b2b: b2b,
                                shippingAddress: [
                                  ShippingAddress(
                                    gst: data.gst.toString(),
                                    name: data.shippingAddress['name'],
                                    area: data.shippingAddress['area'],
                                    address: data.shippingAddress['address'],
                                    mobileNumber:
                                        data.shippingAddress['mobileNumber'],
                                    pincode: data.shippingAddress['pinCode'],
                                    city: data.shippingAddress['city'],
                                    state: data.shippingAddress['state'],
                                  ),
                                ],
                                salesItems: item,
                              );
                              final pdfFile =
                                  await B2cPdfInvoiceApi.generate(invoice);
                              await PdfApi.openFile(pdfFile);
                            },
                            icon: const Icon(Icons.picture_as_pdf))
                        : Container()
                  ],
                  centerTitle: true,
                  elevation: 4,
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                                setState(() {
                                                  if (data.orderStatus > 2) {
                                                    updateOrderStatus(
                                                        data.orderId, data);
                                                    statusController.text='cancel';
                                                  } else {
                                                    updateOrderstatus(
                                                        data.orderId, data);
                                                    statusController.text='cancel';
                                                  }
                                                });
                                                Navigator.pop(context);
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
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Do you want to accept this order?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Return false if canceled
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              shipRocket(data);
                                              statusController.text = 'Accepted';
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Accept'),
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
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
                                          title: const Text('Shipped Order'),
                                          content: const Text('Is this order shipped?'),
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
                                                updateOrderStatusAndInvoice(
                                                    currentBranchId, data);
                                                statusController.text = 'Shipped';
                                                Navigator.pop(context);
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
                                    textStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Shipped',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
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
                                        title: const Text('Delivered Order'),
                                        content: const Text(
                                            'Is this order delivered?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              processOrderAndReferral(
                                                  data, products);
                                              Navigator.pop(context);
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
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Delivered'),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 15),
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
                          height: 5,
                        ),
                        data.orderStatus >= 1
                            ? Consumer(
                              builder: (context,ref,child) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Consumer(
                                        builder: (context,ref,child) {
                                          var data= ref.watch(getPartnerListProvider);
                                          return data.when(data: (data){
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
                                                partner = crs!;
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
                                          }, error: (error, stackTrace) {
                                            print(error);
                                            return const SizedBox();
                                          }, loading: () {
                                            return const SizedBox();
                                          },);
                                        }
                                      ),
                                    ));
                              }
                            )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        data.orderStatus > 1
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
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Invoice ${data.invoiceNo.toString()}',
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
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Update AWB'),
                                                  content: const Text(
                                                      'Are you sure you want to update AWB?'),
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
                                                        updateAwbCode(
                                                            data.orderId,
                                                            data.awb_code);
                                                        showUploadMessage(
                                                            context,
                                                            'AWB updated...');
                                                        Navigator.of(context)
                                                            .pop(true);
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
                                            textStyle: const TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'Update',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
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
                                                      updateTrackingUrl(
                                                        data.partner   );
                                                      Navigator.pop(context);
                                                      showUploadMessage(context,
                                                          'Tracking Url updated...');
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
                                          textStyle: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          side: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Launch Tracking Url'),
                                                content: const Text(
                                                    'Are you sure you want to launch the Tracking Url?'),
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
                                                      _launchURL(
                                                          trackingUrl.text);
                                                      Navigator.pop(context);
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
                                          textStyle: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          side: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Text(
                                          'Launch',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                'Referral Code: ${data.referralCode}',
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
                                ' ${data.promoCode}',
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
                                '${data.discount}',
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
                                '${data.deliveryCharge}',
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
                                '₹ ${data.gst.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        data.shippingMethod == 'Cash On Delivery'
                            ? const Padding(
                                padding: EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'COD Charge : ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 13),
                                    ),
                                    Text(
                                      '\₹ 33.00',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 13),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (buildContext) {
                                                  return AddressPopUp(
                                                    name: data.shippingAddress[
                                                        'name'],
                                                    mobNo: data.shippingAddress[
                                                        'mobileNumber'],
                                                    alterMobNo:
                                                        data.shippingAddress[
                                                            'alternativePhone'],
                                                    address:
                                                        data.shippingAddress[
                                                            'address'],
                                                    landMark:
                                                        data.shippingAddress[
                                                            'landMark'],
                                                    area: data.shippingAddress[
                                                        'area'],
                                                    pincode:
                                                        data.shippingAddress[
                                                            'pinCode'],
                                                    state: data.shippingAddress[
                                                        'state'],
                                                    orderId: widget.id,
                                                    customerId: data.userId,
                                                    city: data.shippingAddress[
                                                        'city'],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.edit)),
                                    ],
                                  ),
                                  Text(
                                    'Name: ${data.shippingAddress['name']}',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Address : ${data.shippingAddress['address']}',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Landmark : ${data.shippingAddress['landMark']}',
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
                                    'Pincode : ${data.shippingAddress['pinCode']}',
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
                                        '${data.shippingAddress['mobileNumber']}',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Alternative Mobile No : ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SelectableText(
                                        '${data.shippingAddress['alternativePhone']}',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.items?.length,
                          // itemExtent:!listView?80:30 ,
                          itemBuilder: (context, itemsIndex) {
                            final itemsItem = data.items?[itemsIndex];
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
                        )
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
