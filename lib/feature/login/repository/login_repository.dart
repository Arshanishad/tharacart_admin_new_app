import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharacart_admin_new_app/core/constants/firebase_constants.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';
import 'package:tharacart_admin_new_app/modal/adminusermodal.dart';
import 'package:tharacart_admin_new_app/modal/usersmodal.dart';
import '../../../core/providers/failure.dart';

final userProvider=StateProvider<AdminModel?>((ref) =>null);


final loginRepositoryProvider = Provider((ref) => LoginRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class LoginRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  LoginRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get admin_users =>
      _firestore.collection(FirebaseConstants.admin_userCollection);

  Stream<User?> get loginStateChange => _auth.authStateChanges();


  Future<Either<dynamic, AdminModel>> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final Credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(Credential);
      print(userCredential.user?.email);
      AdminModel adminModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('email', userCredential.user!.email ?? '');
        localStorage.setString("uid", userCredential.user!.uid ?? '');
         adminModel = AdminModel(
          verified: false,
          created_time: DateTime.now(),
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          delete: false,
          photo_url: userCredential.user!.photoURL ?? '',
          display_name: userCredential.user!.displayName ?? 'No name',
        );
        await admin_users
            .doc(userCredential.user!.uid)
            .set(adminModel.toJson());
      } else {
       adminModel=await getUserData(userCredential.user!.uid).first;
        SharedPreferences localStorage = await SharedPreferences.getInstance();
       localStorage.setString('email', userCredential.user!.email ?? '');
       localStorage.setString("uid", userCredential.user!.uid ?? '');
       localStorage.setString("uid",adminModel.uid);
      }
      return right(adminModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<AdminModel> getUserData(String uid) {
    return admin_users.doc(uid).snapshots().map(
        (event) => AdminModel.fromJson(event.data() as Map<String, dynamic>));
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('email');
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  Future<AdminModel> getAdmin({required String id}) async {
    var a=await _firestore.collection(FirebaseConstants.admin_userCollection).doc(id).get();
    return AdminModel.fromJson(a.data()  as Map<String,dynamic>);
}


  Stream<UserModal> getUsers(String uid) {
    return
      _firestore.collection(FirebaseConstants.usersCollection).doc(uid).snapshots().map(
            (event) => UserModal.fromJson(event.data() as Map<String, dynamic>));
  }



}
