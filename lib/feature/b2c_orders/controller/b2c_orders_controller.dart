import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../modal/ordermodal.dart';
import '../repository/b2c_orders_repository.dart';

final b2COrdersControllerProvider = Provider((ref) => B2COrdersController(
    b2cOrdersRepository: ref.read(b2cordersRepositoryProvider)));

final datePickerProvider = StreamProvider.family((ref, String data) =>
    ref.read(b2COrdersControllerProvider).b2cOrders(data: data));

final datePicked1Provider = StateProvider<Timestamp?>((ref) => null);
final startDateProvider = StateProvider<DateTime?>((ref) => null);
final endDateProvider = StateProvider<DateTime?>((ref) => null);
final selectedIndexProvider = StateProvider<int>((ref) => 0);
final partnerProvider = StateProvider<List>((ref) => []);
final getOrdersProvider = StreamProvider.family((ref, String id) {
  final b2ccontroller = ref.watch(b2COrdersControllerProvider);
  return b2ccontroller.getOrders(id);
});

final getPartnerListProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  return ref.watch(b2COrdersControllerProvider).getPartner();
});

class B2COrdersController {
  final B2COrdersRepository _b2cOrdersRepository;
  B2COrdersController({
    required B2COrdersRepository b2cOrdersRepository,
  }) : _b2cOrdersRepository = b2cOrdersRepository;

  Stream<List<OrderModel>> b2cOrders({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _b2cOrdersRepository.b2cOrders(data);
  }

  Stream<OrderModel> getOrders(String uid) {
    return _b2cOrdersRepository.getOrders(uid);
  }

  Future<void> updateOrderInvoiceNo(String orderId) {
    return _b2cOrdersRepository.updateOrderInvoiceNo(orderId);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderModel data,
  }) async {
    return _b2cOrdersRepository.updateOrderStatus(orderId: orderId, data: data);
  }

  Future<void> updateOrderstatus({
    required String orderId,
    required OrderModel data,
  }) {
    return _b2cOrdersRepository.updateOrderstatus(orderId: orderId, data: data);
  }

  Future<void> updateAwbCode(String id, String awbCode) {
    return _b2cOrdersRepository.updateAwbCode(id, awbCode);
  }

  Future<void> processOrderAndReferral(
      OrderModel data, List<Map<String, dynamic>> products) {
    return _b2cOrdersRepository.processOrderAndReferral(data, products);
  }

  Future<void> cancelOrder(
    OrderModel data,
  ) {
    return _b2cOrdersRepository.cancelOrder(data);
  }

  Future<void> updateInvoiceNo(String OrderId) {
    return _b2cOrdersRepository.updateInvoiceNo(OrderId);
  }

  Future<void> updateOrderStatusAndInvoice(
    String currentBranchId,
    OrderModel data,
  ) {
    return _b2cOrdersRepository.updateOrderStatusAndInvoice(
        currentBranchId, data);
  }

  Future<void> shipRocket(OrderModel data) {
    return _b2cOrdersRepository.shipRocket(data);
  }

  void updateOrder(String orderId, String trackingLink, String awbCode) {
    return _b2cOrdersRepository.updateOrder(orderId, trackingLink, awbCode);
  }

  Future<List<String>> getPartner() {
    return _b2cOrdersRepository.getPartner();
  }

  getRiders(OrderModel data) {
    return _b2cOrdersRepository.getRiders(data);
  }

  updateTrackingUrl(String trackingUrl, String partner) {
    return _b2cOrdersRepository.updateTrackingUrl(trackingUrl, partner);
  }

  void updateOrderDocument({
    required String orderId,
    required String name,
    required String address,
    required String area,
    required String city,
    required String landMark,
    required String pincode,
    required String state,
    required String mobileNumber,
    required String alterMobileNumber,
  }) {
    return _b2cOrdersRepository.updateOrderDocument(
        orderId: orderId,
        name: name,
        address: address,
        area: area,
        city: city,
        landMark: landMark,
        pincode: pincode,
        state: state,
        mobileNumber: mobileNumber,
        alterMobileNumber: alterMobileNumber);
  }
}
