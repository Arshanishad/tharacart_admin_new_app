import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/feature/users/controller/users_controller.dart';
import '../../../core/common/upload_message.dart';
import '../../../core/providers/utils.dart';
import '../../login/screen/splash_screen.dart';

class EditProfileWidget extends ConsumerStatefulWidget {
  final String email;
  final String phone;
  final String pincode;
  final String state;
  final String id;
  EditProfileWidget({
    Key? key,
    required this.email,
    required this.phone,
    required this.pincode,
    required this.state,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends ConsumerState<EditProfileWidget> {
  late TextEditingController email;
  late TextEditingController pincode;
  late TextEditingController state;
  late TextEditingController phone;
  final scaffoldKey = GlobalKey<ScaffoldState>();



  // void editProfile() {
  //   // Map data ={
  //   //   'id':widget.userdata.userId,
  //   // }
  //   ref.read(usersControllerProvider).editProfile(
  //   widget.userdata.userId,
  //   email.text,
  //   pincode.text,
  //     phone.text,
  //       state.text,
  //       );
  // }

  @override
  void initState() {
    super.initState();
    email = TextEditingController(text: widget.email);
    pincode = TextEditingController(text: widget.pincode);
    state = TextEditingController(text: widget.state);
    phone = TextEditingController(text: widget.phone);
  }

  void editProfile() {
    if (pincode.text != '' &&
        email.text != '' &&
        phone.text != '' &&
        state.text != '') {
      ref.read(usersControllerProvider).editProfile(
            widget.id,
            email.text,
            pincode.text,
            phone.text,
            state.text,
          );
      showSnackBar(context, "Edited successfully");
      Navigator.pop(context);
    } else {
      phone.text == ''
          ? showUploadMessage(context, 'Please Enter Phone No')
          : email.text == ''
              ? showUploadMessage(context, 'Please Enter Email Address')
              : state.text == ''
                  ? showUploadMessage(context, 'Please Enter State')
                  : showUploadMessage(context, 'Please Enter Pincode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 16),
              child: TextFormField(
                controller: phone,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Phone No',
                  hintText: 'Please Enter Phone No',
                  labelStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                ),
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF090F13),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
              child: TextFormField(
                controller: email,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Please Enter Email Address',
                  labelStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                ),
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF090F13),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
              child: TextFormField(
                controller: state,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'State',
                  hintText: 'Please Enter State',
                  labelStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                ),
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF090F13),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
              child: TextFormField(
                controller: pincode,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  hintText: 'Please Enter Pincode',
                  labelStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                ),
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF090F13),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.05),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    editProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        const Color(0xFF4B39EF), // Set the background color
                    textStyle: const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    width: width * 0.5,
                    height: height * 0.07,
                    alignment: Alignment.center,
                    child: const Text('Save Changes'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
