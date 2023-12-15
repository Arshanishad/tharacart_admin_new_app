import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharacart_admin_new_app/feature/login/controller/login_controller.dart';
import 'package:tharacart_admin_new_app/modal/adminusermodal.dart';
import '../../home/screen/navbarscreen.dart';
import 'login_screen.dart';

var width;
var height;

String currentUserEmail = '';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  bool login = false;
  Future<void> getValidation() async {
    final localStorage = await SharedPreferences.getInstance();
    bool log = localStorage.containsKey('email');
    if (log) {
      currentUserEmail = localStorage.getString('email')!;
      String? uId = localStorage.getString("uid");
      AdminModel admin=await ref.read(loginControllerProvider.notifier).getUserData(uId!).first;
      ref.read(userProvider.notifier).update((state) => admin);
      login = true;
      print("Login successful. Email: $currentUserEmail, UID: $uId");
    } else {
      print("User not logged in.");
    }
  }
  bool verified = false;




  @override
  void initState() {
    super.initState();
    getValidation();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) {
                return login
                    ? const NavBarScreen()
                    : const LoginScreen();
              }),
              (route) => false);
    });
  }



  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: width * 2.2,
      width: width,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ),
    );
  }
}
