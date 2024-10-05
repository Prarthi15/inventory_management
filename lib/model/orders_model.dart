import 'package:intl/intl.dart';

class Order {
  final Customer? customer;
  final String? source;
  final String? id;
  final String? orderId;
  final DateTime? date;
  final String? paymentMode;
  final String? currencyCode;
  final List<Item> items;
  final String? skuTrackingId;
  final double? totalWeight;
  final double? totalAmount;
  final int? coin;
  final double? codAmount;
  final double? prepaidAmount;
  final String? discountCode;
  final String? discountScheme;
  final int? discountPercent;
  final double? discountAmount;
  final int? taxPercent;
  final Address? billingAddress;
  final Address? shippingAddress;
  final String? courierName;
  final bool? replacement;
  int orderStatus;
  final List<OrderStatusMap>? orderStatusMap;
  final String? agent;
  final String? filter;
  final FreightCharge? freightCharge;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isSelected;

  Order({
    required this.customer,
    required this.source,
    required this.id,
    required this.orderId,
    required this.date,
    required this.paymentMode,
    required this.currencyCode,
    required this.items,
    required this.skuTrackingId,
    required this.totalWeight,
    required this.totalAmount,
    required this.coin,
    required this.codAmount,
    required this.prepaidAmount,
    required this.discountCode,
    required this.discountScheme,
    required this.discountPercent,
    required this.discountAmount,
    required this.taxPercent,
    required this.billingAddress,
    required this.shippingAddress,
    required this.courierName,
    required this.replacement,
    required this.orderStatus,
    required this.orderStatusMap,
    required this.agent,
    required this.filter,
    required this.freightCharge,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isSelected = false,
  });

  // Null-safe date parsing with error handling
  static DateTime? parseDate(String? dateString) {
    if (dateString == null) return null;

    try {
      // Attempt to parse the date string as ISO 8601 format
      return DateTime.parse(dateString);
    } catch (_) {
      // If parsing fails, try custom date format
      try {
        final dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss Z');
        return dateFormat.parse(dateString);
      } catch (e) {
        print("Error parsing date: $e");
        return null; // Return null if all attempts fail
      }
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      source:
          json['source']?.toString() ?? '', // Handle null and non-string data
      id: json['_id']?.toString() ?? '', // Handle null and non-string data
      orderId:
          json['order_id']?.toString() ?? '', // Handle null and non-string data
      date: parseDate(json['date']), // Handle null and invalid dates
      paymentMode: json['payment_mode']?.toString() ??
          '', // Handle null and non-string data
      currencyCode: json['currency_code']?.toString() ??
          '', // Handle null and non-string data
      items: (json['items'] as List?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [], // Handle null and empty list
      skuTrackingId: json['sku_tracking_id']?.toString() ??
          '', // Handle null and non-string data
      totalWeight: (json['total_weight'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      totalAmount: (json['total_amt'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      coin: json['coin']?.toInt() ?? 0, // Handle null and non-integer data
      codAmount: (json['cod_amount'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      prepaidAmount: (json['prepaid_amount'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      discountCode: json['discount_code']?.toString() ??
          '', // Handle null and non-string data
      discountScheme: json['discount_scheme']?.toString() ??
          '', // Handle null and non-string data
      discountPercent: json['discount_percent']?.toInt() ??
          0, // Handle null and non-integer data
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      taxPercent:
          json['tax_percent']?.toInt() ?? 0, // Handle null and non-integer data
      billingAddress: json['billing_addr'] is Map<String, dynamic>
          ? Address.fromJson(json['billing_addr'])
          : Address(
              address1: json['billing_addr']
                  ?.toString()), // Handle both string and object address
      shippingAddress: json['shipping_addr'] is Map<String, dynamic>
          ? Address.fromJson(json['shipping_addr'])
          : Address(
              address1: json['shipping_addr']
                  ?.toString()), // Handle both string and object address
      courierName: json['courier_name']?.toString() ??
          '', // Handle null and non-string data
      replacement: json['replacement'] is bool
          ? json['replacement']
          : false, // Default to false if not a bool
      orderStatus: json['order_status']?.toInt() ??
          0, // Handle null and non-integer data
      orderStatusMap: (json['order_status_map'] as List?)
              ?.map((status) => OrderStatusMap.fromJson(status))
              .toList() ??
          [],
      agent: json['agent']?.toString() ?? '', // Handle null and non-string data
      filter:
          json['filter']?.toString() ?? '', // Handle null and non-string data
      freightCharge: json['freight_charge'] != null
          ? FreightCharge.fromJson(json['freight_charge'])
          : null,
      notes: json['notes']?.toString() ?? '', // Handle null and non-string data
      createdAt: parseDate(json['createdAt']), // Handle null and invalid dates
      updatedAt: parseDate(json['updatedAt']), // Handle null and invalid dates
    );
  }
}

class Customer {
  final String? customerId;
  final String? firstName;
  final String? lastName;
  final int? phone;
  final String? email;
  final String? billingAddress;
  final String? customerGstin;

  Customer({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.billingAddress,
    required this.customerGstin,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id']?.toString() ??
          '', // Handle null and non-string data
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone'] is int
          ? json['phone']
          : null, // Handle non-integer data
      billingAddress: json['billing_addr']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      customerGstin: json['customer_gstin']?.toString() ?? '',
    );
  }
}

class Item {
  final int? qty;
  final Product? product;
  final double? amount;
  final String? sku;
  final String? id;

  Item({
    required this.qty,
    this.product,
    required this.amount,
    required this.sku,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      qty: json['qty']?.toInt() ?? 0, // Handle null and non-integer data
      product: json['product_id'] != null
          ? Product.fromJson(json['product_id'])
          : null,
      amount: (json['amount'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      sku: json['sku']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }
}

class Product {
  final Dimensions? dimensions;
  final String? id;
  final String displayName;
  final String? parentSku;
  final String? sku;
  final String? ean;
  final String? description;
  final String? brand;
  final String? category;
  final String? technicalName;
  final String? label;
  final String? color;
  final String? taxRule;
  final String? boxSize;
  final double? netWeight;
  final double? grossWeight;
  final double? mrp;
  final double? cost;
  final bool? active;
  final List<String>? images;
  final String? grade;
  final String? shopifyImage;

  Product({
    required this.dimensions,
    required this.id,
    required this.displayName,
    required this.parentSku,
    required this.sku,
    required this.ean,
    required this.description,
    required this.brand,
    required this.category,
    required this.technicalName,
    required this.label,
    required this.color,
    required this.taxRule,
    required this.boxSize,
    required this.netWeight,
    required this.grossWeight,
    required this.mrp,
    required this.cost,
    required this.active,
    required this.images,
    required this.grade,
    required this.shopifyImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'])
          : null,
      id: json['_id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      parentSku: json['parentSku']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      ean: json['ean']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      technicalName: json['technicalName']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      taxRule: json['tax_rule']?.toString() ?? '',
      boxSize: json['boxSize']?.toString() ?? '',
      netWeight: (json['netWeight'] as num?)?.toDouble() ?? 0.0,
      grossWeight: (json['grossWeight'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      active: json['active'] ?? true, // Default to true if not present
      images:
          (json['images'] as List?)?.map((img) => img.toString()).toList() ??
              [],
      grade: json['grade']?.toString() ?? '',
      shopifyImage: json['shopifyImage']?.toString() ?? '',
    );
  }
}

class Dimensions {
  final double? length;
  final double? width;
  final double? height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: (json['length'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Address {
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? address2;
  final int? phone;
  final String? city;
  final int? pincode;
  final String? state;
  final String? country;
  final String? countryCode;
  final String? email;

  Address({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.phone,
    this.city,
    this.pincode,
    this.state,
    this.country,
    this.countryCode,
    this.email,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: json['first_name']?.toString() ?? '', // Handle null values
      lastName: json['last_name']?.toString() ?? '',
      address1: json['address1']?.toString() ?? '',
      address2: json['address2']?.toString() ?? '',
      phone: (json['phone'] as num?)?.toInt(), // Handle numeric conversion
      city: json['city']?.toString() ?? '',
      pincode: (json['pincode'] as num?)?.toInt(), // Handle numeric conversion
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

// Updated OrderStatusMap class with status_id
class OrderStatusMap {
  final String? status;
  final int? statusId; // New field for status_id
  final DateTime? date;

  OrderStatusMap({
    required this.status,
    required this.statusId,
    required this.date,
  });

  factory OrderStatusMap.fromJson(Map<String, dynamic> json) {
    return OrderStatusMap(
      status: json['status']?.toString() ??
          '', // Convert to String or default to empty
      statusId: (json['status_id'] as num?)?.toInt() ??
          0, // Convert to int or default to 0
      date: Order.parseDate(
          json['createdAt']), // Use the Order class date parsing method
    );
  }
}

class FreightCharge {
  final double? delhivery;
  final double? shiprocket;
  final double? standardShipping;

  FreightCharge({
    required this.delhivery,
    required this.shiprocket,
    required this.standardShipping,
  });

  factory FreightCharge.fromJson(Map<String, dynamic> json) {
    return FreightCharge(
      delhivery: (json['dehlivary'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      shiprocket: (json['shiprocket'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      standardShipping: (json['standard_shipping'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
    );
  }
}
