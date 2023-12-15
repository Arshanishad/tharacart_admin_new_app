import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';
import 'package:tharacart_admin_new_app/modal/b2brequest_model.dart';
import '../../../core/constants/firebase_constants.dart';

final b2bRequestRepositoryProvider = Provider(
    (ref) => B2bRequestRepository(firestore: ref.read(firestoreProvider)));

class B2bRequestRepository {
  final FirebaseFirestore _firestore;
  B2bRequestRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
  CollectionReference get _b2bRequests =>
      _firestore.collection(FirebaseConstants.b2bRequestsCollection);
  CollectionReference get users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _safeExpress =>
      _firestore.collection(FirebaseConstants.safeExpressCollection);
  CollectionReference get _expressB =>
      _firestore.collection(FirebaseConstants.expressBCollection);

  Stream<List<B2BRequestModel>> getPendingB2BRequests() {
    return _b2bRequests
        .where('status', isEqualTo: 0)
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                B2BRequestModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<B2BRequestModel>> getPendingB2BRequestsByNumber(String number) {
    if (number != '') {
      print(number);
      print("(((object)))");
      return _b2bRequests
          .where('status', isEqualTo: 0)
          .where('officialNo', isEqualTo: number)
          .orderBy('time', descending: true)
          .snapshots()
          .map((event) {
        print("///////");
        print(event.docs.length);
        print("Query result count: ${event.docs.length}");
        return event.docs
            .map((e) =>
                B2BRequestModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      });
    } else {
      return _b2bRequests
          .orderBy('time', descending: true)
          .snapshots()
          .map((event) {
        print("Query result count: ${event.docs.length}");
        return event.docs
            .map((e) =>
                B2BRequestModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Stream<List<B2BRequestModel>> getApprovedB2BRequests() {
    return _b2bRequests
        .where('status', isEqualTo: 1)
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                B2BRequestModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<B2BRequestModel>> getApprovedRequestsByNumber(String number) {
    if (number != '') {
      return _b2bRequests
          .where('status', isEqualTo: 1)
          .where('officialNo', isEqualTo: number)
          .orderBy('time', descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((e) =>
                  B2BRequestModel.fromJson(e.data() as Map<String, dynamic>))
              .toList());
    } else {
      return _b2bRequests.orderBy('time', descending: true).snapshots().map(
          (event) => event.docs
              .map((e) =>
                  B2BRequestModel.fromJson(e.data() as Map<String, dynamic>))
              .toList());
    }
  }

  Stream<B2BRequestModel> getB2bRequest(String id) {
    return _b2bRequests.doc(id).snapshots().map((event) =>
        B2BRequestModel.fromJson(event.data() as Map<String, dynamic>));
  }

  String? safeZone;
  String? ebZone;
  List<String> zones = ['Select Zone'];
  List<String> zones1 = ['Select Zone'];

  Future<List<String>> getZone() async {
    try {
      return await _safeExpress.doc('safeExpress').get().then((value) {
        zones = [];
        safeZone = "A";
        for (var abc in value.get('zonePrice')) {
          zones.add(abc['name']);
        }
        return zones;
      });
    } catch (e) {
      print("Error getting zones: $e");
      return [];
    }
  }
  // if(mounted){
  //   setState(() {
  //     safeZone='Select Zone';
  // });

  Future<List<String>> getZone1() async {
    try {
      return await _expressB.doc('expressB').get().then((value) {
        zones = [];
        ebZone = "A";
        for (var abc in value.get('zonePrice')) {
          zones1.add(abc['name']);
        }
        return zones1;
      });

      // if(mounted){
      //   setState(() {
      ebZone = 'Select Zone';
      // });
    } catch (e) {
      print("Error getting zones: $e");
      return [];
    }
  }

  Future<void> updateStatus(String id) async {
    _b2bRequests.doc(id).update({
      'status': 2,
    });
  }

  Future<void> updateB2BRequest(
      {required String safeMcc,
      required String ebmcc,
      required String safeExtension,
      required String ebextension,
      required String safeZone,
      required String ebZone}) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.b2bRequestsCollection)
          .doc()
          .update({
        'status': 1,
        'mcc': safeMcc,
        'ebMcc': ebmcc,
        'extension': safeExtension,
        'ebExtension': ebextension,
        'zone': safeZone,
        'ebZone': ebZone,
      });
      print('Document updated successfully');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  void updateUserDocument(String userId, String safeZone, String ebZone,
      String safeExtension, String ebextension, String safeMcc, String ebmcc,B2BRequestModel data) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'b2b': true,
      'zone': safeZone,
      'ebZone': ebZone,
      'officialNo': data.officialNo,
      'ext': safeExtension,
      'ebExtension': ebextension,
      'gst': data.taxpayerInfo?['gstin'],
      'mcc': safeMcc,
      'ebMcc': ebmcc,
    });
  }
}
