// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import '../../../core/theme/pallete.dart';
//
//
// class EditUsersList extends StatefulWidget {
//   @override
//   _EditUsersListState createState() => _EditUsersListState();
// }
//
// class _EditUsersListState extends State<EditUsersList> {
//   late List myList;
//   ScrollController _scrollController = ScrollController();
//   int _currentMax = 100;
//   StreamController<List<DocumentSnapshot>> _streamController =
//   StreamController<List<DocumentSnapshot>>();
//   List<DocumentSnapshot> _data = [];
//
//   @override
//   void initState() {
//     super.initState();
//     myList = List.generate(10, (i) => "Item : ${i + 1}");
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _getMoreData();
//       }
//     });
//     _getData();
//     getB2C();
//     getB2B();
//   }
//
//   _getData() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('b2b', isEqualTo: false)
//         .limit(_currentMax)
//         .get();
//     _data = querySnapshot.docs;
//     _streamController.add(_data);
//   }
//
//   _getMoreData() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('b2b', isEqualTo: false)
//         .startAfterDocument(_data[_data.length - 1])
//         .limit(100)
//         .get();
//     _data.addAll(querySnapshot.docs);
//     _streamController.add(_data);
//   }
//   TextEditingController mobile = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     _streamController.close();
//   }
//   int b2c=0;
//   int b2b=0;
//
//   getB2C()async{
//     FirebaseFirestore.instance.collection('users').where('b2b',isEqualTo: false).snapshots().listen((event) {
//       b2c=event.docs.length;
//       if(mounted){
//         setState(() {
//         });
//       }
//     });
//   }
//
//   getB2B()async{
//     FirebaseFirestore.instance.collection('users').where('b2b',isEqualTo: true).snapshots().listen((event) {
//       b2b=event.docs.length;
//       if(mounted){
//         setState(() {
//
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const InkWell(child: Text("Lazy Loading")),
//         actions: [
//           IconButton(onPressed: (){
//             // Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleLazyPage()));
//           }, icon: const Icon(Icons.add)),
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: DefaultTabController(
//           length: 2,
//           initialIndex: 0,
//           child: Column(
//             children: [
//               const TabBar(
//                 labelColor: Pallete.primaryColor,
//                 indicatorColor: Pallete.secondaryColor,
//                 tabs: [
//                   Tab(
//                     text: 'B2C',
//                   ),
//                   Tab(
//                     text: 'B2B',
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: TabBarView(
//                     children:[
//                       Column(
//                         children: [
//                           StreamBuilder<List<DocumentSnapshot>>(
//                               stream: _streamController.stream,
//                               builder: (context, snapshot) {
//                                 if (!snapshot.hasData) {
//                                   return const Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 }
//                                 var data = snapshot.data;
//                                 print(data?.length);
//                                 return ListView.builder(
//                                   controller: _scrollController,
//                                   itemExtent: 80,
//                                   itemCount: data!.length + 1,
//                                   itemBuilder: (context, i) {
//                                     if (i == data.length) {
//                                       return const CupertinoActivityIndicator();
//                                     }
//                                     String photoUrl = '';
//                                     String fullName = '';
//                                     String email = '';
//                                     try {
//                                       email = data[i]['email'];
//                                       photoUrl = data[i]['photoUrl'];
//                                       fullName = data[i]['fullName'];
//                                     } catch (e) {
//                                       photoUrl = '';
//                                       fullName = '';
//                                       email = '';
//                                       print(data[i].id);
//                                     }
//                                     return Padding(
//                                       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
//                                       child: InkWell(
//                                         onTap: () {
//                                           // Navigator.push(
//                                           //     context,
//                                           //     MaterialPageRoute(
//                                           //         builder: (context) => UsersViewWidget(
//                                           //           id: data[i].id,
//                                           //         )));
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.white,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 blurRadius: 0,
//                                                 color: Color(0xFFE0E3E7),
//                                                 offset: Offset(0, 1),
//                                               )
//                                             ],
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.max,
//                                               children: [
//                                                 Text((i + 1).toString()),
//                                                 ClipRRect(
//                                                   borderRadius: BorderRadius.circular(40),
//                                                   child: CachedNetworkImage(
//                                                     imageUrl: photoUrl == ''
//                                                         ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
//                                                         : photoUrl,
//                                                     width: 60,
//                                                     height: 60,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Column(
//                                                     mainAxisSize: MainAxisSize.max,
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Padding(
//                                                         padding: const EdgeInsetsDirectional.fromSTEB(
//                                                             12, 0, 0, 0),
//                                                         child: Text(
//                                                           fullName,
//                                                           style:
//                                                          const TextStyle(
//                                                             fontFamily: 'Poppins',
//                                                             color: Color(0xFF1D2429),
//                                                             fontSize: 14,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsetsDirectional.fromSTEB(
//                                                             12, 4, 0, 0),
//                                                         child: Row(
//                                                           mainAxisSize: MainAxisSize.max,
//                                                           children: [
//                                                             Padding(
//                                                               padding:
//                                                               const EdgeInsetsDirectional.fromSTEB(
//                                                                   4, 0, 0, 0),
//                                                               child: Text(
//                                                                 email ?? '',
//                                                                 style: const TextStyle(
//                                                                   fontFamily: 'Poppins',
//                                                                   color: Color(0xFF57636C),
//                                                                   fontSize: 11,
//                                                                   fontWeight: FontWeight.normal,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsetsDirectional.fromSTEB(
//                                                             12, 4, 0, 0),
//                                                         child: Row(
//                                                           mainAxisSize: MainAxisSize.max,
//                                                           children: [
//                                                             Padding(
//                                                               padding:
//                                                               const EdgeInsetsDirectional.fromSTEB(
//                                                                   4, 0, 0, 0),
//                                                               child: Text(
//                                                                 data[i]['mobileNumber'] ?? '',
//                                                                 style: const TextStyle(
//                                                                   fontFamily: 'Poppins',
//                                                                   color: Color(0xFF57636C),
//                                                                   fontSize: 11,
//                                                                   fontWeight: FontWeight.bold,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Card(
//                                                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                                                   color: const Color(0xFFF1F4F8),
//                                                   elevation: 1,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(40),
//                                                   ),
//                                                   child: const Padding(
//                                                     padding:
//                                                     EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
//                                                     child: Icon(
//                                                       Icons.keyboard_arrow_right_rounded,
//                                                       color: Color(0xFF57636C),
//                                                       size: 24,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               }),
//                         ],
//                       ),
//                       Column(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                             const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
//                             child: TextFormField(
//                               controller: mobile,
//                               obscureText: false,
//                               onFieldSubmitted: (text){
//                                 setState(() {
//
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 labelText: 'Search',
//                                 labelStyle: const TextStyle(
//                                   fontFamily: 'Poppins',
//                                   color: Color(0xFF57636C),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                                 hintText: 'Search Users',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: Color(0x00000000),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: Color(0x00000000),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFF1F4F8),
//                                 prefixIcon: const Icon(
//                                   Icons.search_outlined,
//                                   color: Color(0xFF57636C),
//                                 ),
//                               ),
//                               style: const TextStyle(
//                                 fontFamily: 'Poppins',
//                                 color: Color(0xFF1D2429),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     16, 12, 0, 0),
//                                 child: Text(
//                                   'Total Users : ',
//                                   style: TextStyle(
//                                     fontFamily: 'Poppins',
//                                     color: Color(0xFF57636C),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     4, 12, 16, 0),
//                                 child: Text(
//                                   b2b.toString(),
//                                   style:const TextStyle(
//                                     fontFamily: 'Poppins',
//                                     color: Color(0xFF4B39EF),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           mobile.text==''?
//                           StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance.collection('users').where('b2b',isEqualTo: true).snapshots(),
//                               builder: (context, snapshot) {
//                                 if(!snapshot.hasData){
//                                   return const Center(child: CircularProgressIndicator(),);
//                                 }
//                                 var data=snapshot.data?.docs;
//                                 return Expanded(
//                                   child: Padding(
//                                     padding:
//                                     const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
//                                     child: ListView.builder(
//                                       padding: EdgeInsets.zero,
//                                       scrollDirection: Axis.vertical,
//                                       physics: const BouncingScrollPhysics(),
//                                       itemCount: data?.length,
//                                       shrinkWrap: true,
//                                       itemBuilder: (buildContext,int index){
//                                         return Padding(
//                                           padding: const EdgeInsetsDirectional.fromSTEB(
//                                               0, 0, 0, 1),
//                                           child: InkWell(
//                                             onTap: (){
//                                               // Navigator.push(context, MaterialPageRoute(builder: (context)=>UsersViewWidget(
//                                               //   id:data?[index],
//                                               // )));
//                                             },
//                                             child: Container(
//                                               width: 100,
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.white,
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     blurRadius: 0,
//                                                     color: Color(0xFFE0E3E7),
//                                                     offset: Offset(0, 1),
//                                                   )
//                                                 ],
//                                               ),
//                                               child: Padding(
//                                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                                     8, 8, 8, 8),
//                                                 child: Row(
//                                                   mainAxisSize: MainAxisSize.max,
//                                                   children: [
//                                                     ClipRRect(
//                                                       borderRadius:
//                                                       BorderRadius.circular(40),
//                                                       child: CachedNetworkImage(
//                                                         imageUrl: data?[index]['photoUrl']==''?'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png':data?[index]['photoUrl'],
//                                                         width: 60,
//                                                         height: 60,
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Column(
//                                                         mainAxisSize: MainAxisSize.max,
//                                                         crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 12, 0, 0, 0),
//                                                             child: Text(
//                                                               data?[index]['fullName'],
//                                                               style:const TextStyle(
//                                                                 fontFamily:
//                                                                 'Poppins',
//                                                                 color: Color(
//                                                                     0xFF1D2429),
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.bold,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 12, 4, 0, 0),
//                                                             child: Row(
//                                                               mainAxisSize:
//                                                               MainAxisSize.max,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding:
//                                                                   const EdgeInsetsDirectional
//                                                                       .fromSTEB(4,
//                                                                       0, 0, 0),
//                                                                   child: Text(
//                                                                     data?[index]['email']??'',
//                                                                     style: const TextStyle(
//                                                                       fontFamily:
//                                                                       'Poppins',
//                                                                       color: Color(
//                                                                           0xFF57636C),
//                                                                       fontSize: 11,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .normal,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 12, 4, 0, 0),
//                                                             child: Row(
//                                                               mainAxisSize:
//                                                               MainAxisSize.max,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding:
//                                                                   const EdgeInsetsDirectional
//                                                                       .fromSTEB(4,
//                                                                       0, 0, 0),
//                                                                   child: Text(
//                                                                     data?[index]['mobileNumber']??'',
//                                                                     style: const TextStyle(
//                                                                       fontFamily:
//                                                                       'Poppins',
//                                                                       color: Color(
//                                                                           0xFF57636C),
//                                                                       fontSize: 11,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     Card(
//                                                       clipBehavior:
//                                                       Clip.antiAliasWithSaveLayer,
//                                                       color: const Color(0xFFF1F4F8),
//                                                       elevation: 1,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                         BorderRadius.circular(40),
//                                                       ),
//                                                       child: const Padding(
//                                                         padding: EdgeInsetsDirectional
//                                                             .fromSTEB(4, 4, 4, 4),
//                                                         child: Icon(
//                                                           Icons
//                                                               .keyboard_arrow_right_rounded,
//                                                           color: Color(0xFF57636C),
//                                                           size: 24,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//
//                                     ),
//                                   ),
//                                 );
//                               }
//                           ):
//                           StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance.collection('users').where('b2b',isEqualTo: true)
//                                   .where('mobileNumber',isEqualTo: mobile.text.toUpperCase())
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if(!snapshot.hasData){
//                                   return const Center(child: CircularProgressIndicator(),);
//                                 }
//                                 var data=snapshot.data?.docs;
//                                 return Expanded(
//                                   child: Padding(
//                                     padding:
//                                     const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
//                                     child: ListView.builder(
//                                       padding: EdgeInsets.zero,
//                                       scrollDirection: Axis.vertical,
//                                       physics: const BouncingScrollPhysics(),
//                                       itemCount: data?.length,
//                                       shrinkWrap: true,
//                                       itemBuilder: (buildContext,int index){
//                                         return Padding(
//                                           padding: const EdgeInsetsDirectional.fromSTEB(
//                                               0, 0, 0, 1),
//                                           child: InkWell(
//                                             onTap: (){
//                                               // Navigator.push(context, MaterialPageRoute(builder: (context)=>UsersViewWidget(
//                                               //   id:data?[index].id,
//                                               // )));
//                                             },
//                                             child: Container(
//                                               width: 100,
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.white,
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     blurRadius: 0,
//                                                     color: Color(0xFFE0E3E7),
//                                                     offset: Offset(0, 1),
//                                                   )
//                                                 ],
//                                               ),
//                                               child: Padding(
//                                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                                     8, 8, 8, 8),
//                                                 child: Row(
//                                                   mainAxisSize: MainAxisSize.max,
//                                                   children: [
//                                                     ClipRRect(
//                                                       borderRadius:
//                                                       BorderRadius.circular(40),
//                                                       child: CachedNetworkImage(
//                                                         imageUrl: data?[index]['photoUrl']==''?'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png':data?[index]['photoUrl'],
//                                                         width: 60,
//                                                         height: 60,
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Column(
//                                                         mainAxisSize: MainAxisSize.max,
//                                                         crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 12, 0, 0, 0),
//                                                             child: Text(
//                                                               data?[index]['fullName'],
//                                                               style: const TextStyle(
//                                                                 fontFamily:
//                                                                 'Poppins',
//                                                                 color: Color(
//                                                                     0xFF1D2429),
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                 FontWeight.bold,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 12, 4, 0, 0),
//                                                             child: Row(
//                                                               mainAxisSize:
//                                                               MainAxisSize.max,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding:
//                                                                   const EdgeInsetsDirectional
//                                                                       .fromSTEB(4,
//                                                                       0, 0, 0),
//                                                                   child: Text(
//                                                                     data?[index]['email']??'',
//                                                                     style: const TextStyle(
//                                                                       fontFamily:
//                                                                       'Poppins',
//                                                                       color: Color(
//                                                                           0xFF57636C),
//                                                                       fontSize: 11,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .normal,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                                 12, 4, 0, 0),
//                                                             child: Row(
//                                                               mainAxisSize:
//                                                               MainAxisSize.max,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding:
//                                                                   const EdgeInsetsDirectional
//                                                                       .fromSTEB(4,
//                                                                       0, 0, 0),
//                                                                   child: Text(
//                                                                     data?[index]['mobileNumber']??'',
//                                                                     style: const TextStyle(
//                                                                       fontFamily:
//                                                                       'Poppins',
//                                                                       color: Color(
//                                                                           0xFF57636C),
//                                                                       fontSize: 11,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     Card(
//                                                       clipBehavior:
//                                                       Clip.antiAliasWithSaveLayer,
//                                                       color: const Color(0xFFF1F4F8),
//                                                       elevation: 1,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                         BorderRadius.circular(40),
//                                                       ),
//                                                       child: const Padding(
//                                                         padding: EdgeInsetsDirectional
//                                                             .fromSTEB(4, 4, 4, 4),
//                                                         child: Icon(
//                                                           Icons
//                                                               .keyboard_arrow_right_rounded,
//                                                           color: Color(0xFF57636C),
//                                                           size: 24,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//
//                                     ),
//                                   ),
//                                 );
//                               }
//                           ),
//                         ],
//                       ),
//                     ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }