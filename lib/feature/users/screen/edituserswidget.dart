
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tharacart_admin_new_app/modal/usersmodal.dart';
// import '../../../core/common/upload_message.dart';
// class EditProfileWidget extends StatefulWidget {
//   // final String number;
//   // final String pincode;
//   // final String state;
//   // final String id;
//   // final String email;
//   UserModal? data;
//    EditProfileWidget({Key? key,required this.data }) : super(key: key);
//   @override
//   _EditProfileWidgetState createState() => _EditProfileWidgetState();
// }
// class _EditProfileWidgetState extends State<EditProfileWidget> {
//   late TextEditingController email;
//   late TextEditingController pincode;
//   late TextEditingController state;
//   late TextEditingController phone;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   String groupName='';
//   getGroups(int pinCode)async{
//     QuerySnapshot snap =await FirebaseFirestore.instance.collection('pincodeGroups')
//         .where('pincodes',arrayContains: pinCode)
//         .get();
//     if(snap.docs.isNotEmpty){
//       groupName=snap.docs[0].id;
//     }
//     FirebaseFirestore.instance.collection('users').doc(widget.data?.userId).update({
//       'email':email.text,
//       'pinCode':pincode.text,
//       'mobileNumber':phone.text,
//       'state':state.text,
//       'group':groupName,
//     });
//     print(groupName);
//     showUploadMessage(context, 'User Details Updated...');
//     Navigator.pop(context);
//     if(mounted){
//       setState(() {
//       });
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     email = TextEditingController(text: widget.data?.email);
//     pincode = TextEditingController(text: widget.data?.pinCode);
//     state = TextEditingController(text: widget.data?.state);
//     phone = TextEditingController(text: widget.data?.mobileNumber);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         automaticallyImplyLeading: true,
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(
//               fontFamily: 'Poppins',
//               color: Colors.black,
//               fontSize: 18,
//               fontWeight: FontWeight.bold
//           ),
//         ),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 16),
//               child: TextFormField(
//                 controller: phone,
//                 obscureText: false,
//                 decoration: InputDecoration(
//                   labelText: 'Phone No',
//                   hintText: 'Please Enter Phone No',
//                   labelStyle:const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   hintStyle:const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
//                 ),
//                 style: const TextStyle(
//                   fontFamily: 'Lexend Deca',
//                   color: Color(0xFF090F13),
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
//               child: TextFormField(
//                 controller: email,
//                 obscureText: false,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   hintText: 'Please Enter Email Address',
//                   labelStyle: const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   hintStyle: const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
//                 ),
//                 style: const TextStyle(
//                   fontFamily: 'Lexend Deca',
//                   color: Color(0xFF090F13),
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
//               child: TextFormField(
//                 controller: state,
//                 obscureText: false,
//                 decoration: InputDecoration(
//                   labelText: 'State',
//                   hintText: 'Please Enter State',
//                   labelStyle: const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   hintStyle:const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
//                 ),
//                 style:const TextStyle(
//                   fontFamily: 'Lexend Deca',
//                   color: Color(0xFF090F13),
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
//               child: TextFormField(
//                 controller: pincode,
//                 obscureText: false,
//                 decoration: InputDecoration(
//                   labelText: 'Pincode',
//                   hintText: 'Please Enter Pincode',
//                   labelStyle:const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   hintStyle: const TextStyle(
//                     fontFamily: 'Lexend Deca',
//                     color: Color(0xFF95A1AC),
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFF1F4F8),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
//                 ),
//                 style: const TextStyle(
//                   fontFamily: 'Lexend Deca',
//                   color: Color(0xFF090F13),
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: const AlignmentDirectional(0, 0.05),
//               child: Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
//                 child: FFButtonWidget(
//                   onPressed: () {
//                     if(pincode.text!=''&&email.text!=''&&phone.text!=''&&state.text!=''){
//                       getGroups(int.tryParse(pincode.text));
//                     }else{
//                       phone.text==''?showUploadMessage(context, 'Please Enter Phone No'):
//                       email.text==''?showUploadMessage(context, 'Please Enter Email Address'):
//                       state.text==''?showUploadMessage(context, 'Please Enter State'):
//                       showUploadMessage(context, 'Please Enter Pincode');
//                     }
//                   },
//                   text: 'Save Changes',
//                   options: FFButtonOptions(
//                     width: 340,
//                     height: 60,
//                     color: Color(0xFF4B39EF),
//                     textStyle:const TextStyle(
//                       fontFamily: 'Lexend Deca',
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     elevation: 2,
//                     borderSide: const BorderSide(
//                       color: Colors.transparent,
//                       width: 1,
//                     ),
//                     borderRadius: 8,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
