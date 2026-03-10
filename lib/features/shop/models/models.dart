// ─── PRODUCT MODEL ───────────────────────────────────────────────────────────
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String category;
  final String shopId;
  final String shopName;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> sizes;
  final List<String> colors;
  final bool isAvailable;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.category,
    required this.shopId,
    required this.shopName,
    this.rating = 0,
    this.reviewCount = 0,
    required this.stock,
    this.sizes = const [],
    this.colors = const [],
    this.isAvailable = true,
    required this.createdAt,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  int get discountPercent =>
      hasDiscount ? (((originalPrice! - price) / originalPrice!) * 100).round() : 0;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        originalPrice: json['originalPrice'] != null
            ? (json['originalPrice'] as num).toDouble()
            : null,
        images: List<String>.from(json['images'] ?? []),
        category: json['category'],
        shopId: json['shopId'],
        shopName: json['shopName'],
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['reviewCount'] ?? 0,
        stock: json['stock'] ?? 0,
        sizes: List<String>.from(json['sizes'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
        isAvailable: json['isAvailable'] ?? true,
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'images': images,
        'category': category,
        'shopId': shopId,
        'shopName': shopName,
        'rating': rating,
        'reviewCount': reviewCount,
        'stock': stock,
        'sizes': sizes,
        'colors': colors,
        'isAvailable': isAvailable,
        'createdAt': createdAt.toIso8601String(),
      };
}

// ─── ORDER MODEL ─────────────────────────────────────────────────────────────
enum OrderStatus { pending, preparing, shipped, delivered, cancelled }

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending: return 'En attente';
      case OrderStatus.preparing: return 'En préparation';
      case OrderStatus.shipped: return 'En transit';
      case OrderStatus.delivered: return 'Livré';
      case OrderStatus.cancelled: return 'Annulé';
    }
  }
  int get step {
    switch (this) {
      case OrderStatus.pending: return 0;
      case OrderStatus.preparing: return 1;
      case OrderStatus.shipped: return 2;
      case OrderStatus.delivered: return 3;
      case OrderStatus.cancelled: return -1;
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['productId'],
        productName: json['productName'],
        productImage: json['productImage'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
        selectedSize: json['selectedSize'],
        selectedColor: json['selectedColor'],
      );
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryZone;
  final String deliveryAddress;
  final String paymentMethod;
  final String? paymentPhone;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final List<OrderStatusUpdate> statusHistory;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryZone,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.paymentPhone,
    this.transactionId,
    required this.createdAt,
    this.estimatedDelivery,
    this.statusHistory = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        userId: json['userId'],
        items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
        status: OrderStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => OrderStatus.pending,
        ),
        subtotal: (json['subtotal'] as num).toDouble(),
        deliveryFee: (json['deliveryFee'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        deliveryZone: json['deliveryZone'],
        deliveryAddress: json['deliveryAddress'],
        paymentMethod: json['paymentMethod'],
        paymentPhone: json['paymentPhone'],
        transactionId: json['transactionId'],
        createdAt: DateTime.parse(json['createdAt']),
        estimatedDelivery: json['estimatedDelivery'] != null
            ? DateTime.parse(json['estimatedDelivery'])
            : null,
        statusHistory: (json['statusHistory'] as List? ?? [])
            .map((s) => OrderStatusUpdate.fromJson(s))
            .toList(),
      );
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String? note;

  const OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.note,
  });

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) => OrderStatusUpdate(
        status: OrderStatus.values.firstWhere((s) => s.name == json['status']),
        timestamp: DateTime.parse(json['timestamp']),
        note: json['note'],
      );
}

// ─── USER MODEL ──────────────────────────────────────────────────────────────
class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String? defaultAddress;
  final String? defaultZone;
  final bool isSeller;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.defaultAddress,
    this.defaultZone,
    this.isSeller = false,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        email: json['email'],
        avatarUrl: json['avatarUrl'],
        defaultAddress: json['defaultAddress'],
        defaultZone: json['defaultZone'],
        isSeller: json['isSeller'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );
}

// ─── NOTIFICATION MODEL ───────────────────────────────────────────────────────
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'order', 'payment', 'promo', 'system'
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.orderId,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        type: json['type'],
        orderId: json['orderId'],
        isRead: json['isRead'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );
}
