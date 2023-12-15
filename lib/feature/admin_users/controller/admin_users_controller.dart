import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/feature/admin_users/repository/admin_users_repository.dart';
import 'package:tharacart_admin_new_app/modal/adminusermodal.dart';

final adminUsersControllerProvider = Provider((ref) => AdminUsersController(
    adminUsersRepository: ref.read(adminUsersRepositoryProvider)));

final pendingAdminUsersStreamProvider = StreamProvider(
    (ref) => ref.read(adminUsersControllerProvider).pendingAdminUsers());

final approvedAdminUsersStreamProvider = StreamProvider.autoDispose(
    (ref) => ref.read(adminUsersControllerProvider).approvedAdminUsers());

final deletedAdminUsersStreamProvider=StreamProvider((ref) => ref.read(adminUsersControllerProvider).deletedAdminUsers());

final unverifiedAdminUsersStreamProvider=StreamProvider((ref) => ref.read(adminUsersControllerProvider).unverifiedAdminUsers());

class AdminUsersController {
  final AdminUsersRepository _adminUsersRepository;
  AdminUsersController({
    required AdminUsersRepository adminUsersRepository,
  }) : _adminUsersRepository = adminUsersRepository;

  Stream<List<AdminModel>> approvedAdminUsers(){
    return _adminUsersRepository.approvedAdminUsers();
  }

  Stream<List<AdminModel>> pendingAdminUsers(){
    return _adminUsersRepository.pendingAdminUsers();
  }

  Stream<List<AdminModel>> unverifiedAdminUsers(){
    return _adminUsersRepository.unverifiedAdminUsers();
  }

  Future<void>  deleteUser(String uid) async{
    await _adminUsersRepository.deleteUser(uid);
  }

 Future<void> removeAdminUserAndBranch(String adminEmail)async{
    await _adminUsersRepository.removeAdminUserAndBranch(adminEmail);
  }

  Stream<List<AdminModel>> deletedAdminUsers(){
    return _adminUsersRepository.deletedAdminUsers();
  }

  Future<void>addAdminUsers(String uid)async{
    await _adminUsersRepository.addAdminUsers(uid);
  }
}
