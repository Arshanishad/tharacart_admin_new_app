
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../modal/deletedusermodal.dart';
import '../repository/deleteduserRepository.dart';

final deletedUserControllerProvider = StateProvider((ref) => DeletedUserController(
    deletedUserRepository: ref.read(deletedUserRepositoryProvider), ref: ref));

final  deletedb2cUsersStreamProvider = StreamProvider(
    (ref) => ref.read(deletedUserControllerProvider).deletedb2cUsers());

final deletedb2cuserStreamProvider = StreamProvider.family(
    (ref, String mobile) =>
        ref.read(deletedUserControllerProvider).deletedb2cuser(mobile));

final  deleteb2buserStreamProvider = StreamProvider(
    (ref) => ref.read(deletedUserControllerProvider).deleteb2buser());
final b2bdeleteuserStreamProvider = StreamProvider.family(
    (ref, String mobile) =>
        ref.read(deletedUserControllerProvider).b2bdeleteusers(mobile));

final b2CcountProvider = StateProvider<int>((ref) {
  return 0;
});

final b2BcountProvider = StateProvider<int>((ref) {
  return 0;
});
final deletedb2cUserSearchProvider=StateProvider<String>((ref) => '');
final deletedb2bUserSearchProvider=StateProvider<String>((ref) => '');
final totalOrderProvider=StateProvider<int>((ref) {
  return 0;
});


class DeletedUserController extends StateNotifier<bool> {
  final DeletedUserRepository _deletedUserRepository;
  final Ref _ref;
  DeletedUserController({
    required DeletedUserRepository deletedUserRepository,
    required Ref ref,
  })  : _deletedUserRepository = deletedUserRepository,
        _ref = ref,
        super(false);

  Future<void> getB2C() async {
    final res = await _deletedUserRepository.getB2C();
    res.fold((l) => " ",
        (r) => _ref.read(b2CcountProvider.notifier).update((state) => r));
  }

  Future<void> getB2B() async {
    final res = await _deletedUserRepository.getB2B();
    res.fold((l) => " ",
        (r) => _ref.read(b2BcountProvider.notifier).update((state) => r));
  }

  Stream<List<DeletedUserModal>> deletedb2cUsers() {
    return _deletedUserRepository.deletedb2cUsers();
  }

  Stream<List<DeletedUserModal>> deletedb2cuser(String mobile) {
    return _deletedUserRepository.deletedb2cuser(mobile);
  }

  Stream<List<DeletedUserModal>> deleteb2buser() {
    return _deletedUserRepository.deleteb2buser();
  }

  Stream<List<DeletedUserModal>> b2bdeleteusers(String mobile) {
    return _deletedUserRepository.b2bdeleteusers(mobile);
  }
  Future<void> getOrders(String userId) async {
    final res=await _deletedUserRepository.getOrders(userId);
    res.fold((l) => " ", (r) =>_ref.read(totalOrderProvider.notifier).update((state) => r));
  }

  Future<void> retrieveUser(DeletedUserModal deletedUsermodal,BuildContext context)async{
   await _deletedUserRepository.retrieveUser(deletedUsermodal);
}

}
