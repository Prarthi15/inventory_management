import 'package:intl/intl.dart';

class Order {
  final Customer? customer;
  final String source;
  final String id;
  final String orderId;
  final DateTime? date;
  final String paymentMode;
  final String currencyCode;
  final List<Item> items;
  final String skuTrackingId;
  final double totalWeight;
  final double totalAmount;
  final int coin;
  final double codAmount;
  final double prepaidAmount;
  final String discountScheme;
  final int discountPercent;
  final double discountAmount;
  final int taxPercent;
  final String shippingAddress;
  final String courierName;
  final bool replacement;
  final int orderStatus;
  final List<OrderStatusMap> orderStatusMap;
  final String agent;
  final String filter;
  final FreightCharge? freightCharge;
  final String notes;
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
    required this.discountScheme,
    required this.discountPercent,
    required this.discountAmount,
    required this.taxPercent,
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

  // Null-safe date parsing
  static DateTime? parseDate(String? dateString) {
    if (dateString == null) return null;

    // Remove the portion of the string starting from ' (' if present
    dateString = dateString.split(' (')[0];

    try {
      // Try to parse as ISO 8601 first
      return DateTime.parse(dateString);
    } catch (e) {
      // If ISO fails, attempt custom format parsing
      try {
        DateFormat dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss Z');
        return dateFormat.parse(dateString);
      } catch (e) {
        print("Error parsing date: $e");
        return null;
      }
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      source: json['source'] ?? '', // Default to empty string if null
      id: json['_id'] ?? '', // Default to empty string if null
      orderId: json['order_id'] ?? '', // Default to empty string if null
      date: parseDate(json['date']),
      paymentMode:
          json['payment_mode'] ?? '', // Default to empty string if null
      currencyCode:
          json['currency_code'] ?? '', // Default to empty string if null
      items: (json['items'] as List?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
      skuTrackingId:
          json['sku_tracking_id'] ?? '', // Default to empty string if null
      totalWeight: (json['total_weight'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      totalAmount: (json['total_amt'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      coin: json['coin'] ?? 0, // Default to 0 if null
      codAmount: (json['cod_amount'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      prepaidAmount: (json['prepaid_amount'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      discountScheme:
          json['discount_scheme'] ?? '', // Default to empty string if null
      discountPercent: json['discount_percent'] ?? 0, // Default to 0 if null
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      taxPercent: json['tax_percent'] ?? 0, // Default to 0 if null
      shippingAddress:
          json['shipping_addr'] ?? '', // Default to empty string if null
      courierName:
          json['courier_name'] ?? '', // Default to empty string if null
      replacement: json['replacement'] ?? false, // Default to false if null
      orderStatus: json['order_status'] ?? 0, // Default to 0 if null
      orderStatusMap: (json['order_status_map'] as List?)
              ?.map((status) => OrderStatusMap.fromJson(status))
              .toList() ??
          [],
      agent: json['agent'] ?? '', // Default to empty string if null
      filter: json['filter'] ?? '', // Default to empty string if null
      freightCharge: json['freight_charge'] != null
          ? FreightCharge.fromJson(json['freight_charge'])
          : null,
      notes: json['notes'] ?? '', // Default to empty string if null
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
}

// Customer class (with null safety improvements)
class Customer {
  final String customerId;
  final String name;
  final String phone;
  final String billingAddress;
  final String customerGstin;

  Customer({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.billingAddress,
    required this.customerGstin,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'] ?? '', // Default to empty string if null
      name: json['name'] ?? '', // Default to empty string if null
      phone: json['phone'] ?? '', // Default to empty string if null
      billingAddress:
          json['billing_addr'] ?? '', // Default to empty string if null
      customerGstin:
          json['customer_gstin'] ?? '', // Default to empty string if null
    );
  }
}

class Item {
  final int qty;
  final Product? product;
  final double amount;
  final String id;

  Item({
    required this.qty,
    this.product,
    required this.amount,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      qty: json['qty'] ?? 0, // Default to 0 if null
      product: json['product_id'] != null
          ? Product.fromJson(json['product_id'])
          : null, // Handle null product
      amount:
          (json['amount'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      id: json['_id'] ?? '', // Default to empty string if null
    );
  }
}

class Product {
  final Dimensions? dimensions;
  final String id;
  final String displayName;
  final String parentSku;
  final String sku;
  final String ean;
  final String description;
  final String category;
  final String technicalName;
  final String label;
  final String color;
  final String taxRule;
  final String weight;
  final String boxSize;
  final double mrp;
  final double cost;
  final bool active;
  final List<String> images;
  final String grade;
  final String shopifyImage;

  Product({
    required this.dimensions,
    required this.id,
    required this.displayName,
    required this.parentSku,
    required this.sku,
    required this.ean,
    required this.description,
    required this.category,
    required this.technicalName,
    required this.label,
    required this.color,
    required this.taxRule,
    required this.weight,
    required this.boxSize,
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
          : null, // Handle null dimensions
      id: json['_id'] ?? '', // Default to empty string if null
      displayName: json['displayName'] ?? '', // Default to empty string if null
      parentSku: json['parentSku'] ?? '', // Default to empty string if null
      sku: json['sku'] ?? '', // Default to empty string if null
      ean: json['ean'] ?? '', // Default to empty string if null
      description: json['description'] ?? '', // Default to empty string if null
      category: json['category'] ?? '', // Default to empty string if null
      technicalName:
          json['technicalName'] ?? '', // Default to empty string if null
      label: json['label'] ?? '', // Default to empty string if null
      color: json['color'] ?? '', // Default to empty string if null
      taxRule: json['tax_rule'] ?? '', // Default to empty string if null
      weight: json['weight'] ?? '', // Default to empty string if null
      boxSize: json['boxSize'] ?? '', // Default to empty string if null
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      active: json['active'] ?? false, // Default to false if null
      images: List<String>.from(
          json['images'] ?? []), // Default to an empty list if null
      grade: json['grade'] ?? '', // Default to empty string if null
      shopifyImage:
          json['shopifyImage'] ?? '', // Default to empty string if null
    );
  }
}

class Dimensions {
  final int length;
  final String breadth;
  final int height;

  Dimensions({
    required this.length,
    required this.breadth,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: json['length'] ?? 0, // Default to 0 if null
      breadth: json['breadth'] ?? '', // Default to empty string if null
      height: json['height'] ?? 0, // Default to 0 if null
    );
  }
}

class FreightCharge {
  final double delhivery;
  final double shiprocket;

  FreightCharge({
    required this.delhivery,
    required this.shiprocket,
  });

  factory FreightCharge.fromJson(Map<String, dynamic> json) {
    return FreightCharge(
      delhivery: (json['delhivery'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      shiprocket: (json['shiprocket'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
    );
  }
}

class OrderStatusMap {
  final String id;
  final int statusId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderStatusMap({
    required this.id,
    required this.statusId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Safe date parsing similar to Order class
  static DateTime? parseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  factory OrderStatusMap.fromJson(Map<String, dynamic> json) {
    return OrderStatusMap(
      id: json['_id'] ?? '', // Default to empty string if null
      statusId: json['status_id'] ?? 0, // Default to 0 if null
      status: json['status'] ?? '', // Default to empty string if null
      createdAt: parseDate(json['createdAt']), // Null-safe date parsing
      updatedAt: parseDate(json['updatedAt']), // Null-safe date parsing
    );
  }
}
