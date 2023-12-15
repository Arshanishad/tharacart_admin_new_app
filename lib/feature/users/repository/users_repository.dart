import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tharacart_admin_new_app/core/constants/firebase_constants.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';
import 'package:tharacart_admin_new_app/core/providers/type_def.dart';
import 'package:tharacart_admin_new_app/modal/usersmodal.dart';
import '../../../core/providers/failure.dart';

final usersRepositoryProvider =
    Provider((ref) => UsersRepository(firestore: ref.read(firestoreProvider)));

class UsersRepository {
  final FirebaseFirestore _firestore;

  UsersRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;


  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _orders =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _b2bOrders =>
      _firestore
          .collection(FirebaseConstants.b2bOrdersCollection);

  CollectionReference get _deletedUsers =>
  _firestore
      .collection(FirebaseConstants.deletedUsersCollection);
  CollectionReference get _pincodeGroups =>
  _firestore
      .collection(FirebaseConstants.pincodeGroupsCollection);
  var b2cCount = 0;
  FutureEither<int> getB2CCount() async {
    try {
      var b2corders = _users
          .where('b2b', isEqualTo: false);
      AggregateQuerySnapshot query = await b2corders.count().get();
      b2cCount = query.count;
      return right(b2cCount);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  var b2bCount = 0;
  FutureEither<int> getB2BCount() async {
    try {
      var b2corders = _users
          .where('b2b', isEqualTo: true);
      AggregateQuerySnapshot query = await b2corders.count().get();
      b2bCount = query.count;
      return right(b2bCount);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<UserModal>> b2cUsers() {
    print('reach');
    return _users
        .where('b2b', isEqualTo: false)
        .snapshots()
        .map((event) =>
        event.docs.map((e) {
          print('1');
          // print(e
          //     .data()
          //     ?.length);
          print(e.data());
          return UserModal.fromJson(e.data() as Map<String,dynamic>);
        }).toList());
  }

  Stream<List<UserModal>> b2cUser(String mobile) {
    print(mobile);
    print("///////");
    if (mobile != '') {
      print(mobile);
      return _users
          .where('b2b', isEqualTo: false)
          .where('mobileNumber', isEqualTo: mobile.toUpperCase())
          .snapshots()
          .map((event) =>
          event.docs.map((e) => UserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    } else {
      return _users
          .where('b2b', isEqualTo: false)
          .snapshots()
          .map((event) =>
          event.docs.map((e) => UserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    }
  }

  Stream<List<UserModal>> b2bUsers() {
    return _users
        .where('b2b', isEqualTo: true)
        .snapshots()
        .map((event) =>
        event.docs.map((e) => UserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
  }

  Stream<List<UserModal>> b2bUser(String mobile) {
    if (mobile != '') {
      print(mobile);
      print("(((object)))");
      return _users
          .where('b2b', isEqualTo: true)
          .where('mobileNumber', isEqualTo: mobile.toUpperCase())
          .snapshots()
          .map((event) =>
          event.docs.map((e) => UserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    } else {
      return _users
          .where('b2b', isEqualTo: true)
          .snapshots()
          .map((event) =>
          event.docs.map((e) => UserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    }
  }

  int totalOrders = 0;
  FutureEither<int> getOrders(String userId) async {
    try {
      var order = _orders
          .where('orderStatus', isEqualTo: 4)
          .where('userId', isEqualTo: userId);
      AggregateQuerySnapshot query = await order.count().get();
      totalOrders = query.count;
      var order1 = _b2bOrders
          .where('orderStatus', isEqualTo: 4)
          .where('userId', isEqualTo: userId);
      AggregateQuerySnapshot snap = await order.count().get();
      totalOrders += snap.count;
      return right(totalOrders);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> deleteUser(UserModal usermodal) async {
    print("[[[[object]]]]");
    try {
      await _deletedUsers
          .doc(usermodal.userId)
          .set(usermodal.toJson());
      await _users
          .doc(usermodal.userId)
          .delete();
      print("///////////////////");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  String groupName = '';
  Future<void> editProfile(String userId, String email, String pincode,
      String phone, String state) async {
    print('pincode    ${pincode}');
    print(phone);
    print(phone);
    print("[[[[[[[0]]]]]]]");
    try {
      QuerySnapshot snap = await _pincodeGroups
          .where('pincodes', arrayContains: pincode)
          .get();

      print(snap.docs);
      if (snap.docs.isNotEmpty) {
        groupName = snap.docs[0].id;
      }
      await _users
          .doc(userId)
          .update({
        'email': email,
        'pinCode': pincode,
        'mobileNumber': phone,
        'state': state,
        'group': groupName,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
