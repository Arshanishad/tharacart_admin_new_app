import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/feature/b2b_orders/repository/b2b_order_repository.dart';
import '../../../modal/b2bmodel.dart';


final b2bOrderControllerProvider = Provider((ref) => B2bOrderController(b2bOrderRepository: ref.read(b2bRepositoryProvider)));
final getPartnerListProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  return ref.watch(b2bOrderControllerProvider).getPartner();
});

final pendingB2bOrdersStreamProvider=StreamProvider((ref) => ref.read(b2bOrderControllerProvider).pendingB2bOrders());
final acceptedB2bOrdersStreamProvider=StreamProvider((ref) => ref.read(b2bOrderControllerProvider).acceptedB2bOrders());
final cancelledB2bOrdersStreamProvider=StreamProvider((ref) => ref.read(b2bOrderControllerProvider).cancelledB2bOrders());
final shippedB2bOrdersStreamProvider=StreamProvider((ref) => ref.read(b2bOrderControllerProvider).shippedB2bOrders());
final deliveredB2bOrdersStreamProvider=StreamProvider((ref) => ref.read(b2bOrderControllerProvider).deliveredB2bOrders());

final selectedIndexProvider = StateProvider<int>((ref) => 0);

final datePickerProvider=StreamProvider.family((ref,String data) => ref.read(b2bOrderControllerProvider).b2cOrders(data: data));

final datePicked1Provider = StateProvider<Timestamp?>((ref) => null);
final startDateProvider = StateProvider<DateTime?>((ref) => null);
final endDateProvider = StateProvider<DateTime?>((ref) => null);

final getb2bOrdersProvider = StreamProvider.family((ref, String id) {
  final b2ccontroller = ref.watch(b2bOrderControllerProvider);
  return b2ccontroller.getb2bOrders(id);
});
final partnerProvider = StateProvider<List>((ref) => []);



class B2bOrderController{
  final B2bOrderRepository _b2bOrderRepository;
  B2bOrderController({
    required B2bOrderRepository b2bOrderRepository,
}):_b2bOrderRepository=b2bOrderRepository;



  Future<List<String>> getPartner() {
    return _b2bOrderRepository.getPartner();
  }

  Stream<List<B2bModel>> pendingB2bOrders(){
    return _b2bOrderRepository.pendingB2bOrders();
  }
  Stream<List<B2bModel>> acceptedB2bOrders(){
    return _b2bOrderRepository.acceptedB2bOrders();
  }

  Stream<List<B2bModel>> cancelledB2bOrders() {
    return _b2bOrderRepository.cancelledB2bOrders();
  }

  Stream<List<B2bModel>> shippedB2bOrders(){
    return _b2bOrderRepository.shippedB2bOrders();
  }

  Stream<List<B2bModel>> deliveredB2bOrders(){
    return _b2bOrderRepository.deliveredB2bOrders();
  }
  Stream<List<B2bModel>> b2cOrders({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _b2bOrderRepository.b2borders(data);
  }

  Stream<B2bModel> getb2bOrders(String id) {
    return _b2bOrderRepository.getb2bOrders(id);
  }


  Future<void> updateOrderStatus(B2bModel data){
    return _b2bOrderRepository.updateOrderStatus(data);
  }

  Future<void> updateOrderstatus(B2bModel data){
    return _b2bOrderRepository.updateOrderstatus(data: data);
  }

  Future<void> updateOrderStatusAndInvoice(
      String currentBranchId,
      B2bModel data,
      List<Map<String, dynamic>> products
      ){
    return _b2bOrderRepository.updateOrderStatusAndInvoice(data: data,currentBranchId:currentBranchId, products: products);
  }

  Future<void> processOrderAndReferral(B2bModel data, List<Map<String, dynamic>> products)async {
    return _b2bOrderRepository.processOrderAndReferral(data, products);
  }

  updatePartner(String trackingUrl,String partner){
    return _b2bOrderRepository.updatePartner(trackingUrl,partner);
  }


  Future<void> updateAwbCode(String id, String awbCode){
    return _b2bOrderRepository.updateAwbCode(id, awbCode);
  }

  Future<void> updateTrackingUrl(String id,String trackingUrl){
    return _b2bOrderRepository.updateTrackingUrl(id, trackingUrl);
  }

  Future<void> shipRocket(B2bModel data) {
    return _b2bOrderRepository.shipRocket(data);
  }
  void updateOrder(String orderId, String trackingLink, String awbCode) {
    return _b2bOrderRepository.updateOrder(orderId, trackingLink, awbCode);
  }

}