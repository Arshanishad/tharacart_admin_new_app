import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'package:tharacart_admin_new_app/feature/b2b_orders/controller/b2b_order_controller.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../login/controller/login_controller.dart';
import 'edit_order_details.dart';

class B2b_Order extends ConsumerStatefulWidget {
  B2b_Order({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _B2b_OrderState();
}

class _B2b_OrderState extends ConsumerState<B2b_Order>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Map<String, dynamic> userName = {};
  // Map<String, dynamic> userPhoto = {};
  // Map<String, dynamic> userEmail = {};


  late TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    DateTime time = DateTime.now();
    datePicked1 =
        Timestamp.fromDate(DateTime(time.year, time.month, time.day, 0, 0, 0));
    datePicked2 = Timestamp.fromDate(
        DateTime(time.year, time.month, time.day, 23, 59, 59));
    super.initState();


    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
      setState(() {
        index = _controller.index;
      });
      print("Selected Index: " + index.toString());
    });
  }

  int index = 0;
  late Timestamp datePicked1;
  late Timestamp datePicked2;
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
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
              // FirebaseFirestore.instance.collection(FirebaseConstants.b2bOrdersCollection).get().then((value) {
              //   dynamic data;
              //   for(var a in value.docs){
              //     // data=a.data();
              //     FirebaseFirestore.instance.collection(FirebaseConstants.b2bOrdersCollection).doc(a.id).update({
              //       'orderId':a.id
              //     });
              //     print(a.id);
              //   }
              // });
      
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditB2BOrders()));
            },
            child: const Text(
              'B2B Orders',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 4,
        ),
        body:
            // userName.isEmpty
            //     ? const Center(
            //   child: CircularProgressIndicator(),
            // )
            //     :
            SafeArea(
          child: DefaultTabController(
            length: 5,
            initialIndex: 0,
            child: Column(
              children: [
                TabBar(
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
                  tabAlignment: TabAlignment.start,
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
                    : Padding(
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
                                      if (value != null) {
                                        DateTime time = DateTime.now();
                                        print(DateFormat("yyy-MM-dd")
                                            .format(value));
                                        DateFormat("yyy-MM-dd").format(value);
                                        datePicked1 = Timestamp.fromDate(value);
                                        print(datePicked1
                                            .toDate()
                                            .toString()
                                            .substring(0, 10));
                                        print('000000000000000');
                                        selectedDate1 = value;
                                        ref
                                            .watch(startDateProvider.notifier)
                                            .update((state) => selectedDate1);
                                        print('pppppppppppppppppppppppppp');
                                        print(ref.watch(startDateProvider));
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
                      ),
                Expanded(
                  child: TabBarView(controller: _controller, children: [
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
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
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
                                                    B2BOrderDetailsWidget(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                                  MainAxisSize
                                                                      .max,
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
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: data
                                                                                .photoUrl ==
                                                                            ''
                                                                        ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                        : data
                                                                            .photoUrl,
                                                                  ),
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
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                            error:
                                                                error.toString(),
                                                          ),
                                                          loading: () =>
                                                              const Loader(),
                                                        );
                                                  }),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
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
                                                          textAlign:
                                                              TextAlign.end,
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
                        child: Consumer(
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
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder: (context, listViewIndex) {
                                          return Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: const Color(0xFFF5F5F5),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        B2BOrderDetailsWidget(
                                                          id:data[index].orderId
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 20, 5, 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                                    MainAxisSize
                                                                        .max,
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
                                                                        imageUrl: data.photoUrl ==
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
                                                            error: (error,
                                                                    stackTrace) =>
                                                                ErrorText(
                                                              error: error
                                                                  .toString(),
                                                            ),
                                                            loading: () =>
                                                                const Loader(),
                                                          );
                                                    }),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          data[listViewIndex]
                                                              .shipRocketOrderId,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                        ),
                                                        Text(
                                                          'Invoice : TCE-' +
                                                              data[listViewIndex]
                                                                  .invoiceNo
                                                                  .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                        ),
                                                        const Text(
                                                          'Accepted',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                          child: Text(
                                                            data[listViewIndex]
                                                                .price
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.end,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
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
                            child: Consumer(
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
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: data.length,
                                            itemBuilder:
                                                (context, listViewIndex) {
                                              return Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color: const Color(0xFFF5F5F5),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    print('[]]][[[]]]');
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            B2BOrderDetailsWidget(
                                                              id:data[index].orderId,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            10, 20, 5, 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Consumer(builder:
                                                            (context, ref,
                                                                child) {
                                                          return ref
                                                              .watch(getUsersProvider(
                                                                  data[listViewIndex]
                                                                      .userId))
                                                              .when(
                                                                data: (data) {
                                                                  return Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                                .size
                                                                                .width *
                                                                            .5,
                                                                        height:
                                                                            60,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                        ),
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: data.photoUrl == ''
                                                                                ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                                : data.photoUrl),
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
                                                                error: (error,
                                                                        stackTrace) =>
                                                                    ErrorText(
                                                                  error: error
                                                                      .toString(),
                                                                ),
                                                                loading: () =>
                                                                    const Loader(),
                                                              );
                                                        }),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              data[listViewIndex]
                                                                  .shipRocketOrderId,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            Text(
                                                              'Invoice : TCE-' +
                                                                  data[listViewIndex]
                                                                      .invoiceNo
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                'd-MM-y hh:mm',
                                                              ).format(data[
                                                                      listViewIndex]
                                                                  .placedDate
                                                                  .toDate()),
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            const Text(
                                                              'Cancelled',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            Text(
                                                              data[listViewIndex]
                                                                  .shippingMethod,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .4,
                                                              child: Text(
                                                                data[listViewIndex]
                                                                    .price
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign.end,
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
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
                                child: Consumer(builder: (context, ref, child) {
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
                                            scrollDirection: Axis.vertical,
                                            itemCount: data.length,
                                            itemBuilder:
                                                (context, listViewIndex) {
                                              return Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color: const Color(0xFFF5F5F5),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            B2BOrderDetailsWidget(
                                                              id:data[index].orderId,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            1, 20, 5, 30),
                                                    child: Row(
                                                      // mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Consumer(builder:
                                                            (context, ref,
                                                                child) {
                                                          return ref
                                                              .watch(getUsersProvider(
                                                                  data[listViewIndex]
                                                                      .userId))
                                                              .when(
                                                                data: (data) {
                                                                  return Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                                .size
                                                                                .width *
                                                                            .5,
                                                                        height:
                                                                            60,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                        ),
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: data.photoUrl == ''
                                                                                ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                                : data.photoUrl),
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
                                                                error: (error,
                                                                        stackTrace) =>
                                                                    ErrorText(
                                                                  error: error
                                                                      .toString(),
                                                                ),
                                                                loading: () =>
                                                                    const Loader(),
                                                              );
                                                        }),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              data[listViewIndex]
                                                                  .shipRocketOrderId,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            Text(
                                                              'Invoice : TCE-' +
                                                                  data[listViewIndex]
                                                                      .invoiceNo
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                'd-MM-y hh:mm',
                                                              ).format(data[
                                                                      listViewIndex]
                                                                  .placedDate
                                                                  .toDate()),
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            const Text(
                                                              'Shiprocket',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                            Text(
                                                              data[listViewIndex]
                                                                  .shippingMethod,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .4,
                                                              child: Text(
                                                                data[listViewIndex]
                                                                    .price
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign.end,
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
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
                                }, child: Consumer(
                                  builder: (context, ref, child) {
                                    return ref
                                        .watch(datePickerProvider(jsonEncode({
                                          "DatePicker1": null,
                                          "DatePicker2": null,
                                          "index":
                                              ref.watch(selectedIndexProvider),
                                        })))
                                        .when(
                                          data: (data) {
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemCount: data.length,
                                              itemBuilder:
                                                  (context, listViewIndex) {
                                                return Card(
                                                  clipBehavior:
                                                      Clip.antiAliasWithSaveLayer,
                                                  color: const Color(0xFFF5F5F5),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              B2BOrderDetailsWidget(
                                                                id:data[index].orderId,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(1, 20, 5, 30),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Consumer(builder:
                                                              (context, ref,
                                                                  child) {
                                                            return ref
                                                                .watch(getUsersProvider(
                                                                    data[listViewIndex]
                                                                        .userId))
                                                                .when(
                                                                  data: (data) {
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width *
                                                                              .5,
                                                                          height:
                                                                              60,
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child: CachedNetworkImage(
                                                                              imageUrl: data.photoUrl == ''
                                                                                  ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                                  : data.photoUrl),
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
                                                                  error: (error,
                                                                          stackTrace) =>
                                                                      ErrorText(
                                                                    error: error
                                                                        .toString(),
                                                                  ),
                                                                  loading: () =>
                                                                      const Loader(),
                                                                );
                                                          }),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize.max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                data[listViewIndex]
                                                                    .shipRocketOrderId,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                              ),
                                                              Text(
                                                                'Invoice : TCE-' +
                                                                    data[listViewIndex]
                                                                        .invoiceNo
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                  'd-MM-y hh:mm',
                                                                ).format(data[
                                                                        listViewIndex]
                                                                    .placedDate
                                                                    .toDate()),
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                              ),
                                                              const Text(
                                                                'Delivered',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: true,
                                                              ),
                                                              Text(
                                                                data[listViewIndex]
                                                                    .shippingMethod,
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .4,
                                                                child: Text(
                                                                  data[listViewIndex]
                                                                      .price
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
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
                                )))))
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
