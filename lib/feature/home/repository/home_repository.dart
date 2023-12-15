import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/providers/firebase_providers.dart';


final homeRepositoryProvider=Provider((ref) => HomeRepository(firestore: ref.read(firestoreProvider)));

class HomeRepository{
  final FirebaseFirestore _firestore;
  HomeRepository({
    required FirebaseFirestore firestore,
}):_firestore=firestore;
}