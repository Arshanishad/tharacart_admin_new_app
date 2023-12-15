




import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  final List<InvoiceItem> salesItems ;
  final List<ShippingAddress> shippingAddress ;
  final int invoiceNo;
  final String orderId;
  final String amount;
  final bool b2b;
  final String method;
  final String shipRocketId;
  final double shipping;
  final double gst;
  final double total;
  final double price;
  final double discount;
  final Timestamp invoiceNoDate;
  final Timestamp orderDate;


  const Invoice({
    required this.salesItems,
    required this.b2b,
    required this.shipRocketId,
    required this.amount,
    required this.shippingAddress,
    required this.method,
    required this.shipping,
    required this.gst,
    required this.invoiceNo,
    required this.total,
    required this.price,
    required this.discount,
    required this.orderId,
    required this.orderDate,
    required this.invoiceNoDate,

  });
}



class ShippingAddress {
  final String name;
  final String address;
  final String area;
  final String gst;
  final String city;
  final String mobileNumber;
  final String state;
  final String pincode;

  const ShippingAddress({
    required this.name,
    required this.address,
    required this.area,
    required this.city,
    required this.gst,
    required this.mobileNumber,
    required this.state,
    required this.pincode,

  });

}

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double tax;
  final double gst;
  final double price;
  final double total;
  final double gstp;

  const InvoiceItem(
      {
        required this.tax,
        required this.description,
        required this.quantity,
        required this.unitPrice,
        required this.gst,
        required this.price,
        required this.total,
        required this.gstp,
      });
}