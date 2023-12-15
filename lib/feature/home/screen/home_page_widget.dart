import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import '../../../main.dart';
import '../../admin_users/screen/admin _users.dart';
import '../../b2b_orders/screen/b2b_order_screen.dart';
import '../../b2b_request/screen/b2b_request.dart';
import '../../b2c_orders/screen/b2c_order_screen.dart';
import '../../login/controller/login_controller.dart';
import '../../login/screen/login_screen.dart';
import '../../login/screen/splash_screen.dart';
import '../../users/screen/userslist.dart';


Map<String, dynamic> usersMap = {};
var token;
var expreesBeetoken;


class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
 ConsumerState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget> {
  
 

  googleSignOut(BuildContext context){
    ref.read(loginControllerProvider.notifier).signOutWithGoogle(context);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getT();
    getBranches();
    getGroup();
    getToke();
    getB2cOrders();
    getB2bOrders();
    getB2bRequest();
    getPayout();
    getReturn();
    getAdmins();
    getReferal();
    getquoteCount();
    // updateProducts();
    // updateProduct();
    super.initState();
  }

  updateProduct() {
    FirebaseFirestore.instance.collection('brands').get().then((value) {
      for (DocumentSnapshot snap in value.docs) {
        snap.reference.update({
          'delete': false,
        });
      }
    });
  }

  getGroup() {
    FirebaseFirestore.instance
        .collection('pincodeGroups')
        .snapshots()
        .listen((event) {
      var groupNames = [];
      for (DocumentSnapshot doc in event.docs) {
        groupNames.add(doc.id);
      }
      print(groupNames);
      if (mounted) {
        setState(() {});
      }
    });
  }

  getToke() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://apiv2.shiprocket.in/v1/external/auth/login'));
    request.body = json.encode(
        {"email": "akkuashkar158@gmail.com", "password": "firstlogic123"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(await response.stream.bytesToString());
      print(body['token']);
      token = body['token'];
    } else {
      print(response.reasonPhrase);
    }
  }

  getT() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 61b053f3ec2c0d4e2997db59a3d3251a0f938749'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://track.delhivery.com/api/v1/packages/json/?waybill=20774710055930'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(await response.stream.bytesToString());
      print('hera ddd');
      print(body['ShipmentData'][0]['Shipment']['Status']['Status']);
    } else {
      print(response.reasonPhrase);
    }
  }

  getLoginToken() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://ship.xpressbees.com/api/users/franchise_login'));
    request.body =
        json.encode({"email": "sanjidthara@gmail.com", "password": "xb@1234"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(await response.stream.bytesToString());
      print('ExpressBees Login');
      print(body['data']);
      expreesBeetoken = body['data'];
      getCourierId();
    } else {
      // print('Error : ' + response.reasonPhrase);
    }
  }

  getCourierId() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $expreesBeetoken'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://ship.xpressbees.com/api/franchise/shipments/courier'));
    // request.body = json.encode({
    //   "email": "sanjidthara@gmail.com",
    //   "password": "xb@1234"
    // });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          json.decode(await response.stream.bytesToString());
      print('ID');
      print(body);
      // expreesBeetoken=body['data'];
    } else {
       // print('Error : ' + response.reasonPhrase);
    }
  }

  loadAsset() async {
    var myData = await rootBundle.loadString("assets/Pincodes.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    List places = [];
    List pinCode = [];
    for (int i = 0; i < csvTable.length; i++) {
      Map place = Map();
      place['Pincode'] = csvTable[i][0];
      place['City'] = csvTable[i][1];
      place['State'] = csvTable[i][2];
      place['COD Delivery'] = csvTable[i][3];
      place['Prepaid Delivery'] = csvTable[i][4];
      place['PickUp'] = csvTable[i][5];
      place['Zone'] = csvTable[i][6];
      places.add(place);
      pinCode.add(csvTable[i][0].toString());
    }
    FirebaseFirestore.instance
        .collection('safeExpress')
        .doc('safeExpress')
        .update({
      'pinCode': pinCode,
    });
    setState(() {});
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

  final googleSignIn = GoogleSignIn();

  updateProducts() {
    FirebaseFirestore.instance
        .collection('b2cFailedOrders')
        .get()
        .then((value) {
      for (DocumentSnapshot snap in value.docs) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(snap['userId'])
            .get()
            .then((value) {
          snap.reference.update({
            'search': setSearchParam(value['mobileNumber']),
          });
        });
      }
    });
  }

  getBranches() async {
    if (currentBranchId == null) {
      branches = await FirebaseFirestore.instance
          .collection('branches')
          .where('admins', arrayContains: currentUserEmail)
          .get();
      print(branches?.docs[0]);
      if (branches?.docs.length == 1) {
        setState(() {
          currentBranchId = branches?.docs[0].get('branchId');
          currentBranchName = branches?.docs[0].get('name');
        });
      } else {
        setState(() {
          branches = branches;
        });
      }
    }
  }

  int newB2cOrders = 0;
  int failedB2c = 0;
  int failedB2b = 0;
  int guoteCount = 0;
  getB2cOrders() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      usersMap = {};
      for (DocumentSnapshot doc in event.docs) {
        usersMap[doc.id] = doc.data();
      }
      if (mounted) {
        setState(() {});
      }
    });

    FirebaseFirestore.instance
        .collection('pendingPayments')
        .where('paymentReceived', isEqualTo: false)
        .snapshots()
        .listen((event) {
      failedB2c = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
    FirebaseFirestore.instance
        .collection('pendingB2BPayments')
        .where('paymentReceived', isEqualTo: false)
        .snapshots()
        .listen((event) {
      guoteCount = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });

    FirebaseFirestore.instance
        .collection('orders')
        .where('orderStatus', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      newB2cOrders = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }

  int newB2bOrders = 0;
  getB2bOrders() {
    FirebaseFirestore.instance
        .collection('b2bOrders')
        .where('orderStatus', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      newB2bOrders = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }

  getquoteCount() {
    FirebaseFirestore.instance
        .collection('quotation')
        .where('quotationStatus', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      guoteCount = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }

  int newB2bRequest = 0;
  getB2bRequest() {
    FirebaseFirestore.instance
        .collection('b2bRequests')
        .where('status', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      newB2bRequest = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }

  int newPayout = 0;
  getPayout() {
    FirebaseFirestore.instance
        .collection('payouts')
        .where('status', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      newPayout = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }

  int newReturn = 0;
  getReturn() {
    newReturn = 0;
    FirebaseFirestore.instance
        .collection('cancellationRequests')
        .where('cancellationStatus', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      newReturn = event.docs.length;
      print('Returns : ' + newReturn.toString());
      if (mounted) {
        setState(() {});
      }
    });
  }

  int newAdmins = 0;
  getAdmins() {
    FirebaseFirestore.instance
        .collection('admin_users')
        .where('verified', isEqualTo: false)
        .where('delete', isEqualTo: false)
        .snapshots()
        .listen((event) {
      newAdmins = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }

  int newReferal = 0;
  getReferal() {
    FirebaseFirestore.instance
        .collection('referralRequests')
        .where('approved', isEqualTo: 0)
        .snapshots()
        .listen((event) {
      newReferal = event.docs.length;
      if (mounted) {
        setState(() {});
      }
    });
  }
  @override
  Widget build(BuildContext context) {
     bool?verified=ref.watch(userProvider)!.verified;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor:Pallete.primaryColor,
        automaticallyImplyLeading: true,
        title: const Text(
          'Thara Cart Admin',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          googleSignOut(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body:
        verified?
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child:
          // branches == null
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : branches?.docs.length == 0
          //         ? Center(
          //             child: Text('No branches found for you'),
          //           )
          //         : currentBranchId == null
          //             ? ListView.builder(
          //                 padding: EdgeInsets.zero,
          //                 scrollDirection: Axis.vertical,
          //                 itemCount: branches?.docs.length,
          //                 itemBuilder: (context, listViewIndex) {
          //                   final branch = branches?.docs[listViewIndex];
          //                   return Card(
          //                     clipBehavior: Clip.antiAliasWithSaveLayer,
          //                     color: const Color(0xFFF5F5F5),
          //                     child: Stack(
          //                       children: [
          //                         InkWell(
          //                           onTap: () async {
          //                             setState(() {
          //                               currentBranchId =
          //                                   branch?.get('branchId');
          //                               currentBranchName = branch?.get('name');
          //                             });
          //                           },
          //                           child: Container(
          //                             height: 100,
          //                             child: Column(
          //                               mainAxisSize: MainAxisSize.max,
          //                               children: [
          //                                 Align(
          //                                   alignment: Alignment(0, -0.11),
          //                                   child: Text(
          //                                     branch?.get('name'),
          //                                     style: FlutterFlowTheme.title2
          //                                         .override(
          //                                       fontFamily: 'Poppins',
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   );
          //                 },
          //               )
          //             :
                       SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            newPayout.toString(),
                                            style:const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) =>
                                            // B2b_Order(),
                                            const B2cOrders(),
                                            ),
                                            );
                                          },
                                            icon: const Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.black,
                                              size: 60,
                                            ),
                                            iconSize: 60,
                                          ),
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'B2C Orders',
                                            style:TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            newPayout.toString(),
                                            style:const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) =>
                                            B2b_Order(),
                                            ),
                                            );
                                          },
                                            icon: const Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.black,
                                              size: 60,
                                            ),
                                            iconSize: 60,
                                          ),
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'B2B Orders',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                          badges.Badge(
                                            badgeContent: Text(
                                              newPayout.toString(),
                                              style:const TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: IconButton(
                                             onPressed: () async {
                                               await Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                   builder: (context) =>
                                                       AdminUsersWidget(),
                                                 ),
                                               );
                                             },
                                             icon: const FaIcon(
                                               FontAwesomeIcons.userCheck,
                                               color: Colors.black,
                                               size: 60,
                                             ),
                                             iconSize: 60,
                                            ),
                                          ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Admin Users',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Align(
                                          alignment: const Alignment(0, 0),
                                          child: IconButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const UsersListWidget(),
                                                ),
                                              );
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.userCheck,
                                              color: Colors.black,
                                              size: 60,
                                            ),
                                            iconSize: 60,
                                          ),
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Users',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // await Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ExpressBWidget(),
                                            //   ),
                                            // );
                                          },
                                          icon: const Icon(
                                            Icons.account_circle,
                                            color: Colors.black,
                                            size: 60,
                                          ),
                                          iconSize: 60,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Express B',
                                            style:TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // await Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         SafeExpressWidget(),
                                            //   ),
                                            // );
                                          },
                                          icon: const Icon(
                                            Icons.account_circle,
                                            color: Colors.black,
                                            size: 60,
                                          ),
                                          iconSize: 60,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Safe Express ',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // await Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ReportPageWidget(),
                                            //   ),
                                            // );
                                          },
                                          icon: const Icon(
                                            Icons.report,
                                            color: Colors.black,
                                            size: 60,
                                          ),
                                          iconSize: 60,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Reports',
                                            style:TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            newB2bRequest.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const B2BRequestWidget(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.person_add_sharp,
                                              color: Colors.black,
                                              size: 60,
                                            ),
                                            iconSize: 60,
                                          ),
                                          // showBadge: true,
                                          // shape: BadgeShape.circle,
                                          // badgeColor: Colors.red,
                                          // elevation: 4,
                                          // padding: const EdgeInsetsDirectional
                                          //     .fromSTEB(8, 8, 8, 8),
                                          // position: BadgePosition.topEnd(),
                                          // // animationType: BadgeAnimationType.scale,
                                          // toAnimate: true,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'B2B Requests',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            newReferal.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         ReferWidget(),
                                              //   ),
                                              // );
                                            },
                                            icon: const Icon(
                                              Icons.person_add_sharp,
                                              color: Colors.black,
                                              size: 60,
                                            ),
                                            iconSize: 60,
                                          ),
                                          // showBadge: true,
                                          // shape: BadgeShape.circle,
                                          // badgeColor: Colors.red,
                                          // elevation: 4,
                                          // padding: const EdgeInsetsDirectional
                                          //     .fromSTEB(8, 8, 8, 8),
                                          // position: BadgePosition.topEnd(),
                                          // // animationType: BadgeAnimationType.scale,
                                          // toAnimate: true,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Referral Request',
                                            style:TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            newPayout.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         PayoutsWidget(),
                                              //   ),
                                              // );
                                            },
                                            icon: const Icon(
                                              Icons.payments,
                                              color: Colors.black,
                                              size: 60,
                                            ),
                                            iconSize: 60,
                                          ),
                                          // showBadge: true,
                                          // shape: BadgeShape.circle,
                                          // badgeColor: Colors.red,
                                          // elevation: 4,
                                          // padding: const EdgeInsetsDirectional
                                          //     .fromSTEB(8, 8, 8, 8),
                                          // position: BadgePosition.topEnd(),
                                          // // animationType: BadgeAnimationType.scale,
                                          // toAnimate: true,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Payouts',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            newReturn.toString(),
                                            style:const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          showBadge: true,
                                          child: IconButton(
                                            onPressed: () async {
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         ReturnOrders(),
                                              //   ),
                                              // );
                                            },
                                            icon: const Icon(
                                              Icons.keyboard_return,
                                              size: 70,
                                            ),
                                            iconSize: 60,
                                          ),
                                          // shape: BadgeShape.circle,
                                          // badgeColor: Colors.red,
                                          // elevation: 4,
                                          // padding: const EdgeInsetsDirectional
                                          //     .fromSTEB(8, 8, 8, 8),
                                          // position: BadgePosition.topEnd(),
                                          // // animationType: BadgeAnimationType.scale,
                                          // toAnimate: true,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Return Requests',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Align(
                                          alignment: const Alignment(0, 0),
                                          child: IconButton(
                                            onPressed: () async {
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         ShipmentPage(),
                                              //   ),
                                              // );
                                            },
                                            icon: const Icon(
                                              Icons.local_shipping,
                                              size: 70,
                                            ),
                                            iconSize: 60,
                                          ),
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Shipment',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // await Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => Deals(),
                                            //   ),
                                            // );
                                          },
                                          icon: const Icon(
                                            Icons.account_circle,
                                            color: Colors.black,
                                            size: 60,
                                          ),
                                          iconSize: 60,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Deals',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // await Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         Documents(),
                                            //   ),
                                            // );
                                          },
                                          icon: const Icon(
                                            Icons.file_copy,
                                            color: Colors.black,
                                            size: 60,
                                          ),
                                          iconSize: 60,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Documents',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            (failedB2c + failedB2b).toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          showBadge: true,
                                          child: IconButton(
                                            onPressed: () async {
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         FailedOrders(),
                                              //   ),
                                              // );
                                            },
                                            icon: const Icon(
                                              Icons.error_outline_sharp,
                                              size: 70,
                                            ),
                                            iconSize: 60,
                                          ),
                                          // shape: BadgeShape.circle,
                                          // badgeColor: Colors.red,
                                          // elevation: 4,
                                          // padding: const EdgeInsetsDirectional
                                          //     .fromSTEB(8, 8, 8, 8),
                                          // position: BadgePosition.topEnd(),
                                          // // animationType: BadgeAnimationType.scale,
                                          // toAnimate: true,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Failed Orders',
                                            style:TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text(
                                            guoteCount.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          ),
                                          showBadge: true,
                                          child: IconButton(
                                            onPressed: () async {
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         GouteList(),
                                              //   ),
                                              // );
                                            },
                                            icon: const Icon(
                                              Icons.quora,
                                              size: 70,
                                            ),
                                            iconSize: 60,
                                          ),
                                          // shape: BadgeShape.circle,
                                          // badgeColor: Colors.red,
                                          // elevation: 4,
                                          // padding: const EdgeInsetsDirectional
                                          //     .fromSTEB(8, 8, 8, 8),
                                          // position: BadgePosition.topEnd(),
                                          // // animationType: BadgeAnimationType.scale,
                                          // toAnimate: true,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Get a Quote',
                                            style:TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // await Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         MissingOrdersList(),
                                            //   ),
                                            // );
                                          },
                                          icon: const Icon(
                                            Icons.add_box_rounded,
                                            color: Colors.black,
                                            size: 60,
                                          ),
                                          iconSize: 60,
                                        ),
                                        const Align(
                                          alignment: Alignment(0, 0),
                                          child: Text(
                                            'Missing Orders',
                                            style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
        ),
      )
              :const Center(child: Text('Not Verified'),),
    );
  }
}
