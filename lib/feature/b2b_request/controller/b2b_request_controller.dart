import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/feature/b2b_request/repository/b2b_request_repository.dart';

import '../../../modal/b2brequest_model.dart';

final b2bRequestControllerProvider = Provider((ref) => B2bRequestController(
    b2bRequestRepository: ref.read(b2bRequestRepositoryProvider)));

final getPendingB2BRequestsStreamProvider = StreamProvider(
    (ref) => ref.read(b2bRequestControllerProvider).getPendingB2BRequests());
final getPendingB2BRequestsByNumberStreamProvider = StreamProvider.family(
    (ref, String number) => ref
        .read(b2bRequestControllerProvider)
        .getPendingB2BRequestsByNumber(number));

final getApprovedB2BRequestsStreamProvider = StreamProvider(
    (ref) => ref.read(b2bRequestControllerProvider).getApprovedB2BRequests());

final getApprovedRequestsByNumberStreamProvider = StreamProvider.family((ref,
        String number) =>
    ref.read(b2bRequestControllerProvider).getApprovedRequestsByNumber(number));
final getPendingSearchProvider = StateProvider<String>((ref) => '');
final approvedB2bRequestsSearchProvider = StateProvider<String>((ref) => '');

final getB2bRequestStreamProvider = StreamProvider.family((ref, String id) =>
    ref.read(b2bRequestControllerProvider).getB2bRequest(id));

final getZoneListProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  return ref.watch(b2bRequestControllerProvider).getZone();
});
final safeZoneProvider = StateProvider<String?>((ref) {
  return '';
});

final getZone1ListProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  return ref.watch(b2bRequestControllerProvider).getZone1();
});

class B2bRequestController {
  final B2bRequestRepository _b2bRequestRepository;
  B2bRequestController({
    required B2bRequestRepository b2bRequestRepository,
  }) : _b2bRequestRepository = b2bRequestRepository;

  Stream<List<B2BRequestModel>> getPendingB2BRequests() {
    return _b2bRequestRepository.getPendingB2BRequests();
  }

  Stream<List<B2BRequestModel>> getPendingB2BRequestsByNumber(String number) {
    return _b2bRequestRepository.getPendingB2BRequestsByNumber(number);
  }

  Stream<List<B2BRequestModel>> getApprovedB2BRequests() {
    return _b2bRequestRepository.getApprovedB2BRequests();
  }

  Stream<List<B2BRequestModel>> getApprovedRequestsByNumber(String number) {
    return _b2bRequestRepository.getApprovedRequestsByNumber(number);
  }

  Stream<B2BRequestModel> getB2bRequest(String id) {
    return _b2bRequestRepository.getB2bRequest(id);
  }

  Future<List<String>> getZone() async {
    return _b2bRequestRepository.getZone();
  }

  Future<List<String>> getZone1() async {
    return _b2bRequestRepository.getZone1();
  }

  Future<void> updateStatus(String id) async {
    return _b2bRequestRepository.updateStatus(id);
  }

  Future<void> updateB2BRequest(
      {required String safeMcc,
      required String ebmcc,
      required String safeExtension,
      required String ebextension,
      required String safeZone,
      required String ebZone}) {
    return _b2bRequestRepository.updateB2BRequest(
        safeMcc: safeMcc,
        ebmcc: ebmcc,
        safeExtension: safeExtension,
        ebextension: ebextension,
        safeZone: safeZone,
        ebZone: ebZone);
  }
}
