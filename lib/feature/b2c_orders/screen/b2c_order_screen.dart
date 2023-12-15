import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tharacart_admin_new_app/feature/login/controller/login_controller.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/theme/pallete.dart';
import '../../home/screen/home_page_widget.dart';
import '../controller/b2c_orders_controller.dart';
import 'edit_b2c_orders.dart';

class B2cOrders extends ConsumerStatefulWidget {
  const B2cOrders({super.key});

  @override
  ConsumerState createState() => _B2cOrdersState();
}

class _B2cOrdersState extends ConsumerState<B2cOrders>
    with TickerProviderStateMixin {
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  TabController? _controller;
  Timestamp? datePicked1;
  Timestamp? datePicked2;
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  int statusCode = 0;

  getTrackingStatus(String awb, String type) async {
    if (type == 'Shiprocket') {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://apiv2.shiprocket.in/v1/external/courier/track/awb/$awb'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Map<String, dynamic> body =
            json.decode(await response.stream.bytesToString());
        var list = body['tracking_data'];
        List shipment_track = list['shipment_track'];
        String status = shipment_track[0]['current_status'];
        statusCode = list['shipment_status'];
        print(shipment_track[0]['current_status']);
        return status;
      } else {
        print(response.reasonPhrase);
        return "Error";
      }
    } else if (type == 'Delhivery') {
      print('Delhivery');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 61b053f3ec2c0d4e2997db59a3d3251a0f938749'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://track.delhivery.com/api/v1/packages/json/?waybill=$awb'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> body =
            json.decode(await response.stream.bytesToString());
        print('hera ddd');
        print('hera ddd');
        String status = body['ShipmentData'][0]['Shipment']['Status']['Status'];
        print(status);
        return status;
      } else {
        print(response.reasonPhrase);
      }
    } else {
      return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime time = DateTime.now();
    datePicked1 =
        Timestamp.fromDate(DateTime(time.year, time.month, time.day, 0, 0, 0));
    datePicked2 = Timestamp.fromDate(
        DateTime(time.year, time.month, time.day, 23, 59, 59));
    _controller = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Pallete.primaryColor,
          automaticallyImplyLeading: true,
          title: InkWell(
            onTap: () {
              // FirebaseFirestore.instance.collection(FirebaseConstants.ordersCollection).where('orderStatus',isEqualTo: 0).get().then((value) {
              //   dynamic data;
              //   for(var a in value.docs){
              //     data=a.data();
              //     FirebaseFirestore.instance.collection(FirebaseConstants.ordersCollection).doc(a.id).update({
              //       'shippingAddress':data['shippingAddress']==[]?{}:data['shippingAddress'],
              //     });
              //     print(a.id);
              //   }
              // });
            },
            child: const Text(
              'B2C Orders',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 4,
        ),
        body: DefaultTabController(
          length: 5,
          initialIndex: index,
          child: Column(
            children: [
              TabBar(
                padding: const EdgeInsets.all(10),
                tabAlignment: TabAlignment.start,
                physics: const ClampingScrollPhysics(),
                onTap: (text) {
                  ref
                      .watch(selectedIndexProvider.notifier)
                      .update((state) => text);
                  index = text;
                },
                controller: _controller,
                labelColor: Pallete.primaryColor,
                indicatorColor: Pallete.secondaryColor,
                isScrollable: true,
                tabs: const [
                  Tab(
                    text: 'Pending ',
                  ),
                  Tab(
                    text: 'Accepted ',
                  ),
                  Tab(
                    text: 'Cancelled ',
                  ),
                  Tab(
                    text: 'Shipped',
                  ),
                  Tab(
                    text: 'Delivered',
                  ),
                ],
              ),
              ref.watch(selectedIndexProvider) == 0
                  ? Container()
                  : Consumer(
                    builder: (context,ref,child) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: selectedDate1,
                                          firstDate: DateTime(1901, 1),
                                          lastDate: DateTime(2100, 1))
                                          .then((value) {
                                        print(value);
                                        print('[[[object]]]');
                                        if (value != null) {
                                          DateTime time = DateTime.now();
                                          print(DateFormat("yyy-MM-dd")
                                              .format(value));
                                          DateFormat("yyy-MM-dd").format(value);
                                          datePicked1 = Timestamp.fromDate(value);
                                          print(datePicked1!
                                              .toDate()
                                              .toString()
                                              .substring(0, 10));
                                          print('000000000000000');
                                          selectedDate1 = value;
                                          print(selectedDate1);
                                          ref
                                              .watch(startDateProvider.notifier)
                                              .update((state) => selectedDate1);
                                          print('pppppppppppppppppppppppppp');
                                          print(ref.watch(startDateProvider));
                                        }
                                      });
                                      ref
                                          .watch(startDateProvider.notifier)
                                          .update((state) => selectedDate1);
                                    },
                                    child: Text(
                                      datePicked1 == null
                                          ? 'Choose Starting Date'
                                          : datePicked1!
                                          .toDate()
                                          .toString()
                                          .substring(0, 10),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),

                                const Text(
                                  'To',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: selectedDate2,
                                              firstDate: DateTime(1901, 1),
                                              lastDate: DateTime(2100, 1))
                                          .then((value) {
                                        if (value != null) {
                                          DateFormat("yyyy-MM-dd").format(value);
                                          datePicked2 = Timestamp.fromDate(
                                              value.add(const Duration(
                                                  hours: 23,
                                                  minutes: 59,
                                                  seconds: 59)));
                                          selectedDate2 = value;
                                          ref
                                              .watch(endDateProvider.notifier)
                                              .update((state) => selectedDate2);
                                          return ref
                                              .watch(datePickerProvider(jsonEncode({
                                            "DatePicker1": ref
                                                .watch(startDateProvider)
                                                ?.toIso8601String(),
                                            "DatePicker2": ref
                                                .watch(endDateProvider)
                                                ?.toIso8601String(),
                                            "index":
                                                ref.watch(selectedIndexProvider),
                                          })));
                                        }
                                      });
                                      ref
                                          .watch(endDateProvider.notifier)
                                          .update((state) => selectedDate2);
                                    },
                                    child: Text(
                                      datePicked2 == null
                                          ? 'Choose Ending Date'
                                          : datePicked2!
                                              .toDate()
                                              .toString()
                                              .substring(0, 10),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                    }
                  ),
              Expanded(
                child: TabBarView(controller: _controller, children: [
                  Consumer(builder: (context, ref, child) {
                    return ref
                        .watch(datePickerProvider(jsonEncode({
                          "DatePicker1": ref.watch(startDateProvider),
                          "DatePicker2": ref.watch(endDateProvider),
                          "index": ref.watch(selectedIndexProvider),
                        })))
                        .when(
                          data: (data) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, listViewIndex) {
                                return Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: const Color(0xFFF5F5F5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditB2cOrders(
                                                id:data[listViewIndex].orderId,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 20, 5, 30),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Consumer(
                                                builder: (context, ref, child) {
                                              return ref
                                                  .watch(getUsersProvider(
                                                      data[listViewIndex].userId))
                                                  .when(
                                                    data: (data) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .5,
                                                            height: 60,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: CachedNetworkImage(
                                                                imageUrl: data
                                                                    .photoUrl ==
                                                                        ''
                                                                    ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                    : data
                                                                        .photoUrl),
                                                          ),
                                                          Text(
                                                            data.fullName,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                    error:
                                                        (error, stackTrace) =>
                                                            ErrorText(
                                                      error: error.toString(),
                                                    ),
                                                    loading: () =>
                                                        const Loader(),
                                                  );
                                            }),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat(
                                                    'd-MM-y hh:mm',
                                                  ).format(data[listViewIndex]
                                                      .placedDate
                                                      .toDate()),
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                Text(
                                                  data[listViewIndex]
                                                      .shippingMethod,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                  child: Text(
                                                    data[listViewIndex]
                                                        .price
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        );
                  }),
                  Consumer(builder: (context, ref, child) {
                    return ref
                        .watch(datePickerProvider(jsonEncode({
                          "DatePicker1": null,
                          "DatePicker2": null,
                      "index": ref.watch(selectedIndexProvider),
                        })))
                        .when(
                          data: (data) {
                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: data.length,
                                itemBuilder: (context, listViewIndex) {
                                  return Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: const Color(0xFFF5F5F5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        print(data[listViewIndex].orderId);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditB2cOrders(
                                                  id: data[listViewIndex].orderId,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 20, 5, 30),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Consumer(builder:
                                                  (context, ref, child) {
                                                return ref
                                                    .watch(getUsersProvider(
                                                        data[listViewIndex]
                                                            .userId))
                                                    .when(
                                                      data: (data) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .5,
                                                              height: 60,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: CachedNetworkImage(
                                                                  imageUrl: data
                                                                              .photoUrl ==
                                                                          ''
                                                                      ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                      : data
                                                                          .photoUrl),
                                                            ),
                                                            Text(
                                                              data.fullName,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      error:
                                                          (error, stackTrace) =>
                                                              ErrorText(
                                                        error: error.toString(),
                                                      ),
                                                      loading: () =>
                                                          const Loader(),
                                                    );
                                              }),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    data[listViewIndex]
                                                        .shipRocketOrderId,
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                      'd-MM-y hh:mm',
                                                    ).format(data[listViewIndex]
                                                        .placedDate
                                                        .toDate()),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    data[listViewIndex]
                                                        .shippingMethod,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .4,
                                                    child: Text(
                                                      data[listViewIndex]
                                                          .price
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        );
                  }),
                  Consumer(
                    builder: (context, ref, child) {
                      return ref
                          .watch(datePickerProvider(jsonEncode({
                            "DatePicker1": null,
                            "DatePicker2": null,
                        "index": ref.watch(selectedIndexProvider),
                          })))
                          .when(
                            data: (data) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: data.length,
                                itemBuilder: (context, listViewIndex) {
                                  DateTime invoiceDate;
                                  int invoiceNo;
                                  String shipRocketOrderId;
                                  try {
                                    invoiceDate = data[listViewIndex]
                                        .invoiceDate
                                        .toDate();
                                    invoiceNo = data[listViewIndex].invoiceNo;
                                    shipRocketOrderId =
                                        data[listViewIndex].shipRocketOrderId;
                                  } catch (e) {
                                    invoiceDate = DateTime.now();
                                    invoiceNo = 0;
                                    shipRocketOrderId = '';
                                  }
                                  return Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: const Color(0xFFF5F5F5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        print(data[index].orderId);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditB2cOrders(
                                                  id: data[listViewIndex].orderId,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 20, 5, 30),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Consumer(builder:
                                                  (context, ref, child) {
                                                return ref
                                                    .watch(getUsersProvider(
                                                        data[listViewIndex]
                                                            .userId))
                                                    .when(
                                                      data: (data) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .5,
                                                              height: 60,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: CachedNetworkImage(
                                                                  imageUrl: data
                                                                              .photoUrl ==
                                                                          ''
                                                                      ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                      : data
                                                                          .photoUrl),
                                                            ),
                                                            Text(
                                                              data.fullName,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      error:
                                                          (error, stackTrace) =>
                                                              ErrorText(
                                                        error: error.toString(),
                                                      ),
                                                      loading: () =>
                                                          const Loader(),
                                                    );
                                              }),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Invoice : TCE-' +
                                                        invoiceNo.toString(),
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  const Text(
                                                    'Cancelled',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                      'd-MM-y hh:mm',
                                                    ).format(data[listViewIndex]
                                                        .cancelledDate!
                                                        .toDate()),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    shipRocketOrderId,
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    data[listViewIndex]
                                                        .shippingMethod,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                      'd-MM-y hh:mm',
                                                    ).format(data[listViewIndex]
                                                        .placedDate
                                                        .toDate()),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .4,
                                                    child: Text(
                                                      data[listViewIndex]
                                                          .price
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .4,
                                                    child: Text(
                                                      data[listViewIndex]
                                                          .userId
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                            ),
                            loading: () => const Loader(),
                          );
                    },
                  ),
                  Consumer(builder: (context, ref, child) {
                    return ref
                        .watch(datePickerProvider(jsonEncode({
                          "DatePicker1": null,
                          "DatePicker2": null,
                      "index": ref.watch(selectedIndexProvider),
                        })))
                        .when(
                          data: (data) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, listViewIndex) {
                                DateTime invoiceDate;
                                int invoiceNo;
                                String shipRocketOrderId;
                                String? awbNumber;
                                String? partner;
                                try {
                                  partner =
                                      data[listViewIndex].partner.toString();
                                } catch (e) {
                                  print(e);
                                }
                                try {
                                  invoiceDate =
                                      data[listViewIndex].invoiceDate.toDate();
                                  invoiceNo = data[listViewIndex].invoiceNo;
                                  shipRocketOrderId =
                                      data[listViewIndex].shipRocketOrderId;
                                  awbNumber = data[listViewIndex].awb_code;
                                } catch (e) {
                                  invoiceDate = DateTime.now();
                                  invoiceNo = 0;
                                  shipRocketOrderId = '';
                                }
                                return Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: const Color(0xFFF5F5F5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditB2cOrders(
                                                // id:data[listViewIndex].id,
                                                // order: listViewOrdersRecord,
                                                id: data[listViewIndex].orderId,
                                                // name: userName[
                                                // data[listViewIndex]['userId']],
                                                // name: data[listViewIndex].userId,
                                                // email: userEmail[
                                                // data[listViewIndex]['userId']],
                                                // email: data[listViewIndex].userId,
                                                // orderUser
                                              ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 20, 5, 30),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Consumer(
                                                builder: (context, ref, child) {
                                              return ref
                                                  .watch(getUsersProvider(
                                                      data[listViewIndex]
                                                          .userId))
                                                  .when(
                                                    data: (data) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .5,
                                                            height: 60,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: CachedNetworkImage(
                                                                imageUrl: data
                                                                            .photoUrl ==
                                                                        ''
                                                                    ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                    : data
                                                                        .photoUrl),
                                                          ),
                                                          Text(
                                                            data.fullName,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                    error:
                                                        (error, stackTrace) =>
                                                            ErrorText(
                                                      error: error.toString(),
                                                    ),
                                                    loading: () =>
                                                        const Loader(),
                                                  );
                                            }),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Invoice : TCE-' +
                                                      invoiceNo.toString(),
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 50),
                                                  child: FutureBuilder(
                                                      future: getTrackingStatus(
                                                          awbNumber ?? '',
                                                          partner ?? ''),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return const Text(
                                                              ' ');
                                                        }
                                                        return Text(
                                                            snapshot.data
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .green));
                                                      }),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Date:',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                        'd-MM-y hh:mm',
                                                      ).format(
                                                          data[listViewIndex]
                                                              .placedDate
                                                              .toDate()),
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  shipRocketOrderId,
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                Text(
                                                  DateFormat(
                                                    'd-MM-y hh:mm',
                                                  ).format(data[listViewIndex]
                                                      .placedDate
                                                      .toDate()),
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                Text(
                                                  data[listViewIndex]
                                                      .shippingMethod,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                  child: Text(
                                                    data[listViewIndex]
                                                        .price
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        );
                  }),
                  Consumer(
                    builder: (context, ref, child) {
                      return ref
                          .watch(datePickerProvider(jsonEncode({
                            "DatePicker1": null,
                            "DatePicker2": null,
                        "index": ref.watch(selectedIndexProvider),
                          })))
                          .when(
                            data: (data) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: data.length,
                                itemBuilder: (context, listViewIndex) {
                                  DateTime invoiceDate;
                                  int invoiceNo;
                                  String shipRocketOrderId;
                                  try {
                                    invoiceDate = data[listViewIndex]
                                        .invoiceDate
                                        .toDate();
                                    invoiceNo = data[listViewIndex].invoiceNo;
                                    shipRocketOrderId =
                                        data[listViewIndex].shipRocketOrderId;
                                  } catch (e) {
                                    invoiceDate = DateTime.now();
                                    invoiceNo = 0;
                                    shipRocketOrderId = '';
                                  }
                                  return Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: const Color(0xFFF5F5F5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditB2cOrders(
                                                  // id:data[listViewIndex].id,
                                                  id: data[listViewIndex].orderId,
                                                  // order: listViewOrdersRecord,
                                                  // name: userName[
                                                  // data[listViewIndex]['userId']],
                                                  // name: data[listViewIndex].userId,
                                                  // email: userEmail[
                                                  // data[listViewIndex]['userId']],
                                                  // email: data[listViewIndex].userId,
                                                  // orderUser
                                                ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 20, 5, 30),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Consumer(builder:
                                                  (context, ref, child) {
                                                return ref
                                                    .watch(getUsersProvider(
                                                        data[listViewIndex]
                                                            .userId))
                                                    .when(
                                                      data: (data) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .5,
                                                              height: 60,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: CachedNetworkImage(
                                                                  imageUrl: data
                                                                              .photoUrl ==
                                                                          ''
                                                                      ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                      : data
                                                                          .photoUrl),
                                                            ),
                                                            Text(
                                                              data.fullName,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      error:
                                                          (error, stackTrace) =>
                                                              ErrorText(
                                                        error: error.toString(),
                                                      ),
                                                      loading: () =>
                                                          const Loader(),
                                                    );
                                              }),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Invoice : TCE-' +
                                                        invoiceNo.toString(),
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  const Text(
                                                    'Delivered',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    'Date : ' +
                                                        DateFormat(
                                                                'd-MM-y hh:mm')
                                                            .format(
                                                                invoiceDate),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    shipRocketOrderId,
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                      'd-MM-y hh:mm',
                                                    ).format(data[listViewIndex]
                                                        .placedDate
                                                        .toDate()),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    data[listViewIndex]
                                                        .shippingMethod,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .4,
                                                    child: Text(
                                                      data[listViewIndex]
                                                          .price
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                            ),
                            loading: () => const Loader(),
                          );
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
