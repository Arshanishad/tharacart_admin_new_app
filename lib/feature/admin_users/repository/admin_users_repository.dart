import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/constants/firebase_constants.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';
import 'package:tharacart_admin_new_app/main.dart';
import 'package:tharacart_admin_new_app/modal/adminusermodal.dart';

final adminUsersRepositoryProvider = Provider(
    (ref) => AdminUsersRepository(firestore: ref.read(firestoreProvider)));

class AdminUsersRepository {
  final FirebaseFirestore _firestore;
  AdminUsersRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get admin_users =>
      _firestore.collection(FirebaseConstants.admin_userCollection);

  CollectionReference get _branches =>
      _firestore.collection(FirebaseConstants.branchesCollection);

  Stream<List<AdminModel>>  approvedAdminUsers() {
    return admin_users
        .where('verified', isEqualTo: true)
        .orderBy('created_time', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => AdminModel.fromJson(e.data()as Map<String,dynamic>)).toList());
  }

  Stream<List<AdminModel>> pendingAdminUsers() {
    return admin_users
        .where('verified', isNotEqualTo: true)
        .where('delete', isEqualTo: false)
        .orderBy('verified', descending: true)
        .orderBy('created_time', descending: true)
        .snapshots()
        .map((querySnapshot) =>
        querySnapshot.docs.map((doc) => AdminModel.fromJson(doc.data() as Map<String,dynamic>)).toList());
  }


  Stream<List<AdminModel>> unverifiedAdminUsers() {
    return admin_users
        .where('verified', isNotEqualTo: true)
        .where('delete', isEqualTo: false)
        .orderBy('verified', descending: true)
        .orderBy('created_time', descending: true)
        .snapshots()
        .map((event) =>
        event.docs.map((e) => AdminModel.fromJson(e.data() as Map<String,dynamic>)).toList());
  }


  Future<void> deleteUser(String uid) async {
    try {
      await admin_users
          .doc(uid)
          .update({
        'delete': true,
        'verified': false,
      });
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }


  Future<void> removeAdminUserAndBranch(String adminEmail) async {
    try {
      await _branches.doc(currentBranchId).update({
        'admins': FieldValue.arrayRemove([adminEmail]),
      });
    } catch (e) {
      print('Error removing admin user and branch: $e');
      rethrow;
    }
  }


   Stream<List<AdminModel>> deletedAdminUsers(){
   return admin_users
     .where('delete', isEqualTo: true).snapshots().map((event) =>
        event.docs.map((e) => AdminModel.fromJson(e.data() as Map<String,dynamic>)).toList());
   }

  Future<void> addAdminUsers(String uid) async {
    try {
      await admin_users
          .doc(uid).update({
        'delete': false
      });
    } catch (e) {
      print('Error updating admin user: $e');
      rethrow;
    }
  }
}
