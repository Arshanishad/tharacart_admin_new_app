import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/feature/users/repository/users_repository.dart';
import '../../../modal/usersmodal.dart';

final usersControllerProvider = Provider((ref) => UsersController(
    usersRepository: ref.read(usersRepositoryProvider), ref: ref));

final b2cUsersStreamProvider =
    StreamProvider((ref) => ref.read(usersControllerProvider).b2cUsers());

final b2cUserStreamProvider = StreamProvider.family(
    (ref, String mobile) => ref.read(usersControllerProvider).b2cUser(mobile));

final b2bUsersStreamProvider =
    StreamProvider((ref) => ref.read(usersControllerProvider).b2bUsers());

final b2bUserStreamProvider = StreamProvider.family(
    (ref, String mobile) => ref.read(usersControllerProvider).b2bUser(mobile));

final b2cUsersSearchProvider = StateProvider<String>((ref) => '');

final b2bUsersSearchProvider = StateProvider<String>((ref) => '');

final totalOrdersProvider = StateProvider<int>((ref) {
  return 0;
});

final b2cCountProvider = StateProvider<int>((ref) {
  return 0;
});

final userIdProvider=StateProvider((ref) {
  return 0;
});

final b2bCountProvider = StateProvider<int>((ref) {
  return 0;
});

class UsersController extends StateNotifier<bool> {
  final UsersRepository _usersRepository;
  final Ref _ref;
  UsersController({
    required UsersRepository usersRepository,
    required Ref ref,
  })  : _usersRepository = usersRepository,
        _ref = ref,
        super(false);

  getB2CCount() async {
    final res = await _usersRepository.getB2CCount();
    res.fold((l) => " ",
        (r) => _ref.read(b2cCountProvider.notifier).update((state) => r));
  }

  getB2BCount() async {
    final res = await _usersRepository.getB2BCount();
    res.fold((l) => " ",
        (r) => _ref.read(b2bCountProvider.notifier).update((state) => r));
  }

  final usersSearchProvider = StateProvider((ref) {
    return '';
  });

  Stream<List<UserModal>> b2cUsers() {
    return _usersRepository.b2cUsers();
  }

  Stream<List<UserModal>> b2cUser(String mobile) {
    return _usersRepository.b2cUser(mobile);
  }

  Stream<List<UserModal>> b2bUsers() {
    return _usersRepository.b2bUsers();
  }

  Stream b2bUser(String mobile) {
    return _usersRepository.b2bUser(mobile);
  }

  getOrders(String userId) async {
    final res = await _usersRepository.getOrders(userId);
    res.fold((l) => " ",
        (r) => _ref.read(totalOrdersProvider.notifier).update((state) => r));
  }

  deleteUser(UserModal usermodal, BuildContext context) {
    _usersRepository.deleteUser(usermodal);

  }

  void editProfile(
    String userId,
    String email,
    String pincode,
    String phone,
    String state,
  ) {
    print("===========");
    _usersRepository.editProfile(userId, email, pincode, phone, state);
  }
}
