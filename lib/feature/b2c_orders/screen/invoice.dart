
import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  final List<InvoiceItem>? salesItems ;
  final List<ShippingAddress>? shippingAddress ;
  final int ?invoiceNo;
  final String? orderId;
  final String? amount;
  final bool ?b2b;
  final String? method;
  final String ?shipRocketId;
  final double ?shipping;
  final double ?gst;
  final double ?total;
  final double ?price;
  final double ?discount;
  final Timestamp? invoiceNoDate;
  final Timestamp ?orderDate;


  const Invoice({
    this.salesItems,
    this.b2b,
    this.shipRocketId,
    this.amount,
    this.shippingAddress,
    this.method,
    this.shipping,
    this.gst,
    this.invoiceNo,
    this.total,
    this.price,
    this.discount,
    this.orderId,
    this.orderDate,
    this.invoiceNoDate,

  });
}



class ShippingAddress {
  final String? name;
  final String ?address;
  final String ?area;
  final String ?gst;
  final String ?city;
  final String ?mobileNumber;
  final String ?state;
  final String ?pincode;

  const ShippingAddress({
    this.name,
    this.address,
    this.area,
    this.city,
    this.gst,
    this.mobileNumber,
    this.state,
    this.pincode,

  });

}

class InvoiceItem {
  final String? description;
  final int? quantity;
  final double? unitPrice;
  final double? tax;
  final double? gst;
  final double? price;
  final double? total;
  final double? gstp;

  const InvoiceItem(
      {
        this.tax,
        this.description,
        this.quantity,
        this.unitPrice,
        this.gst,
        this.price,
        this.total,this.gstp,
      });
}