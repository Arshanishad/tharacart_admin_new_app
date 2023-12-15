import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/modal/adminusermodal.dart';
import 'package:tharacart_admin_new_app/modal/usersmodal.dart';
import '../../../core/common/upload_message.dart';
import '../../../core/providers/utils.dart';
import '../../home/screen/navbarscreen.dart';
import '../repository/login_repository.dart';
import '../screen/login_screen.dart';

final userProvider = StateProvider<AdminModel?>((ref) => null);

final loginControllerProvider = StateNotifierProvider<LoginController, bool>(
    (ref) => LoginController(
        loginRepository: ref.read(loginRepositoryProvider), ref: ref));

final loginStateChangeProvider = StreamProvider((ref) {
  final loginController = ref.watch(loginControllerProvider.notifier);
  return loginController.loginStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final loginController = ref.watch(loginControllerProvider.notifier);
  return loginController.getUserData(uid);
});

final getUsersProvider = StreamProvider.family((ref, String uid) {
  final loginController = ref.watch(loginControllerProvider.notifier);
  return loginController.getUsers(uid);
});

class LoginController extends StateNotifier<bool> {
  final LoginRepository _loginRepository;
  final Ref _ref;
  LoginController({
    required LoginRepository loginRepository,
    required Ref ref,
  })  : _loginRepository = loginRepository,
        _ref = ref,
        super(false);

  Stream<User?> get loginStateChange => _loginRepository.loginStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _loginRepository.signInWithGoogle();
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => r);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const NavBarScreen(),
        ),
        (route) => false,
      );
    });
  }

  signOutWithGoogle(BuildContext context) async {
    final user2 = await _loginRepository.signOut();
    user2.fold(
        (l) => showUploadMessage(
              context,
              l.toString(),
            ),
        (r) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            ));
  }

  Stream<AdminModel> getUserData(String uid) {
    return _loginRepository.getUserData(uid);
  }

  Stream<UserModal> getUsers(String uid) {
    return _loginRepository.getUsers(uid);
  }
}
