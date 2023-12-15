import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/constants/constants.dart';
import 'package:tharacart_admin_new_app/feature/login/screen/splash_screen.dart';
import '../controller/login_controller.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context,WidgetRef ref){
    ref.read(loginControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
     height= MediaQuery.of(context).size.height;
     width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  signInWithGoogle(context,ref);
                },
                child: Container(
                  height: height * 0.052,
                  width: width * 0.62,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          offset: const Offset(1, 2),
                          spreadRadius: 1,
                          blurRadius: 2),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        SizedBox(width: width*0.02,),
                        const Image(image: AssetImage(Constants.googlePath)),
                        SizedBox(width: width*0.015,),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
