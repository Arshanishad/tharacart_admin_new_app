import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';
import 'package:tharacart_admin_new_app/modal/deletedusermodal.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/type_def.dart';


final deletedUserRepositoryProvider=Provider((ref) => DeletedUserRepository(firestore: ref.read(firestoreProvider)));

class DeletedUserRepository{
  final FirebaseFirestore _firestore;
  DeletedUserRepository({
    required FirebaseFirestore firestore,
}):_firestore=firestore;
  CollectionReference get _deletedUsers =>
      _firestore
          .collection(FirebaseConstants.deletedUsersCollection);

  CollectionReference get _orders =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _b2bOrders =>
      _firestore
          .collection(FirebaseConstants.b2bOrdersCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  var b2CCount = 0;
  FutureEither<int> getB2C() async {
    try{
      var b2corders= _deletedUsers
          .where('b2b', isEqualTo: false);
      AggregateQuerySnapshot query = await b2corders.count().get();
      b2CCount = query.count;
      return right(b2CCount);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }



  var b2BCount=0;
  FutureEither<int> getB2B() async {
    try{
      var b2borders= _deletedUsers
          .where('b2b', isEqualTo: true);
      AggregateQuerySnapshot query = await b2borders.count().get();
      b2BCount = query.count;
      return right(b2BCount);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<DeletedUserModal>> deletedb2cUsers(){
    return _deletedUsers .where('b2b', isEqualTo: false)
        .snapshots().map((event) => event.docs.map((e) => DeletedUserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
  }

  Stream<List<DeletedUserModal>> deletedb2cuser(String mobile){
    if(mobile!=''){
      return _deletedUsers
          .where('b2b', isEqualTo: false)
          .where('mobileNumber',
          isEqualTo: mobile.toUpperCase())
          .snapshots().map((event) => event.docs.map((e) => DeletedUserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    }
    else{
      return  _deletedUsers
          .where('b2b', isEqualTo: false)
          .snapshots().map((event) => event.docs.map((e) => DeletedUserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    }

}



Stream<List<DeletedUserModal>> deleteb2buser(){
   return _deletedUsers
        .where('b2b', isEqualTo: true)
        .snapshots().map((event) => event.docs.map((e) => DeletedUserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
}

Stream<List<DeletedUserModal>> b2bdeleteusers(String mobile){
    if(mobile!=''){
      return    _deletedUsers
          .where('b2b', isEqualTo: true)
          .where('mobileNumber',
          isEqualTo: mobile.toUpperCase())
          .snapshots().map((event) => event.docs.map((e) => DeletedUserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    }
    else{
      return   _deletedUsers
          .where('b2b', isEqualTo: true)
          .snapshots().map((event) => event.docs.map((e) => DeletedUserModal.fromJson(e.data() as Map<String,dynamic>)).toList());
    }
}


  int totalOrders=0;
  FutureEither<int>getOrders(String userId)async{
    try{
      var  order= _orders
          .where('orderStatus',isEqualTo: 4)
          .where('userId',isEqualTo:userId);
      AggregateQuerySnapshot query = await order.count().get();
      totalOrders=query.count;
      var order1= _firestore.collection(FirebaseConstants.b2bOrdersCollection)
          .where('orderStatus',isEqualTo: 4)
          .where('userId',isEqualTo:userId);
      AggregateQuerySnapshot snap = await order.count().get();
      totalOrders += snap.count;
      return right(totalOrders);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  Future<void> retrieveUser(DeletedUserModal deletedUsermodal) async {
    print("[[[[object]]]]");
    try {
      await _users
          .doc(deletedUsermodal.userId)
          .set(deletedUsermodal.toJson());
      await _deletedUsers
          .doc(deletedUsermodal.userId)
          .delete();
      print("User retrieved successfully!");
    } catch (error) {
      print("Error retrieving user: $error");
    }
    print("///////////////////");
  }
}

