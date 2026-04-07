import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'mock_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// API SERVICES — MODE MOCK (Phase 1 Front-End)
//
// Tous les appels HTTP réels sont remplacés par des Future.delayed.
// Pour passer en production, remplacer chaque méthode par le vrai appel HTTP.
// Le contrat de retour (types) reste identique.
// ─────────────────────────────────────────────────────────────────────────────

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException({required this.message, required this.statusCode});
  @override
  String toString() => message;
}

// ── Simulation d'erreur réseau (pour tester les SnackBars d'erreur) ───────────
class MockNetworkSimulator {
  static bool _forceError = false;
  static bool _slowMode = false;

  static void forceNetworkError(bool enabled) => _forceError = enabled;
  static void enableSlowMode(bool enabled) => _slowMode = enabled;

  static Future<void> simulate({int minMs = 400, int maxMs = 900}) async {
    final delay = _slowMode
        ? 3000
        : minMs + Random().nextInt(maxMs - minMs);
    await Future.delayed(Duration(milliseconds: delay));
    if (_forceError) {
      throw ApiException(
        message: 'Erreur réseau : impossible de contacter le serveur.',
        statusCode: 503,
      );
    }
  }
}

// ─── TOKEN LOCAL ──────────────────────────────────────────────────────────────
class ApiService {
  static String? _token;

  static Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

// ─── AUTH SERVICE ─────────────────────────────────────────────────────────────
class AuthService {
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    await MockNetworkSimulator.simulate();
    if (phone.isEmpty || password.isEmpty) {
      throw ApiException(message: 'Numéro ou mot de passe incorrect.', statusCode: 401);
    }
    if (password.length < 4) {
      throw ApiException(message: 'Mot de passe trop court (4 caractères min).', statusCode: 401);
    }
    const mockToken = 'mock_jwt_token_2025_marketci_abidjan';
    await ApiService.setToken(mockToken);
    return {'token': mockToken, 'user': MockData.currentUser};
  }

  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    String? email,
    bool isSeller = false,
  }) async {
    await MockNetworkSimulator.simulate(minMs: 600, maxMs: 1200);
    const mockToken = 'mock_jwt_token_new_user_2025';
    await ApiService.setToken(mockToken);
    final newUser = AppUser(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      isSeller: isSeller,
      createdAt: DateTime.now(),
    );
    return {'token': mockToken, 'user': newUser};
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await ApiService.clearToken();
  }

  static Future<AppUser> getProfile() async {
    await MockNetworkSimulator.simulate(minMs: 300, maxMs: 600);
    return MockData.currentUser;
  }

  static Future<AppUser> updateProfile(Map<String, dynamic> updates) async {
    await MockNetworkSimulator.simulate();
    final current = MockData.currentUser;
    return AppUser(
      id: current.id,
      firstName: updates['firstName'] ?? current.firstName,
      lastName: updates['lastName'] ?? current.lastName,
      phone: updates['phone'] ?? current.phone,
      email: updates['email'] ?? current.email,
      avatarUrl: updates['avatarUrl'] ?? current.avatarUrl,
      defaultAddress: updates['defaultAddress'] ?? current.defaultAddress,
      defaultZone: updates['defaultZone'] ?? current.defaultZone,
      isSeller: current.isSeller,
      createdAt: current.createdAt,
    );
  }
}

// ─── PRODUCT SERVICE ──────────────────────────────────────────────────────────
class ProductService {
  static Future<List<Product>> getProducts({
    String? category,
    String? search,
    String? shopId,
    int page = 1,
    int limit = 20,
  }) async {
    await MockNetworkSimulator.simulate();
    var results = [...MockData.products];
    if (category != null && category != 'Tous' && category != 'Tout') {
      results = results.where((p) => p.category == category).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase();
      results = results.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.shopName.toLowerCase().contains(q)).toList();
    }
    if (shopId != null) {
      results = results.where((p) => p.shopId == shopId).toList();
    }
    final start = (page - 1) * limit;
    if (start >= results.length) return [];
    return results.skip(start).take(limit).toList();
  }

  static Future<Product> getProduct(String id) async {
    await MockNetworkSimulator.simulate(minMs: 300, maxMs: 700);
    return MockData.products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw ApiException(message: 'Produit introuvable.', statusCode: 404),
    );
  }

  static Future<List<Product>> getFeatured() async {
    await MockNetworkSimulator.simulate();
    return MockData.featuredProducts;
  }

  static Future<List<Product>> getBestSellers() async {
    await MockNetworkSimulator.simulate();
    return MockData.bestSellers;
  }

  static Future<List<Product>> getNewArrivals() async {
    await MockNetworkSimulator.simulate();
    return MockData.newArrivals;
  }

  static Future<List<Product>> searchProducts(String query) async {
    await MockNetworkSimulator.simulate(minMs: 300, maxMs: 600);
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    return MockData.products.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q) ||
        p.shopName.toLowerCase().contains(q)).toList();
  }

  static Future<List<String>> getSearchSuggestions() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return MockData.searchSuggestions;
  }
}

// ─── ORDER SERVICE ────────────────────────────────────────────────────────────
class OrderService {
  static final List<Order> _sessionOrders = [...MockData.orders];

  static Future<Order> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryZone,
    required String deliveryAddress,
    required String paymentMethod,
    String? paymentPhone,
    String? promoCode,
  }) async {
    await MockNetworkSimulator.simulate(minMs: 800, maxMs: 1500);
    double subtotal = 0;
    final orderItems = items.map((item) {
      final price = (item['price'] as num).toDouble();
      final qty = item['quantity'] as int;
      subtotal += price * qty;
      return OrderItem(
        productId: item['productId'],
        productName: item['productName'],
        productImage: item['productImage'] ?? '',
        price: price,
        quantity: qty,
        selectedSize: item['selectedSize'],
        selectedColor: item['selectedColor'],
      );
    }).toList();
    final deliveryFee = _deliveryFeeForZone(deliveryZone).toDouble();
    double discount = 0;
    if (promoCode != null && MockData.promoCodes.containsKey(promoCode.toUpperCase())) {
      discount = subtotal * MockData.promoCodes[promoCode.toUpperCase()]!;
    }
    final total = subtotal - discount + deliveryFee;
    final newOrder = Order(
      id: 'CMD-2025-${(1000 + Random().nextInt(8999))}',
      userId: MockData.currentUser.id,
      items: orderItems,
      status: OrderStatus.pending,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      deliveryZone: deliveryZone,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      paymentPhone: paymentPhone,
      transactionId: paymentMethod != 'cash'
          ? '${paymentMethod.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}'
          : null,
      createdAt: DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(hours: 24)),
      statusHistory: [
        OrderStatusUpdate(
          status: OrderStatus.pending,
          timestamp: DateTime.now(),
          note: 'Commande reçue, en attente de confirmation.',
        ),
      ],
    );
    _sessionOrders.insert(0, newOrder);
    return newOrder;
  }

  static Future<List<Order>> getMyOrders() async {
    await MockNetworkSimulator.simulate();
    return _sessionOrders;
  }

  static Future<Order> getOrder(String id) async {
    await MockNetworkSimulator.simulate(minMs: 300, maxMs: 500);
    return _sessionOrders.firstWhere(
      (o) => o.id == id,
      orElse: () => throw ApiException(message: 'Commande introuvable.', statusCode: 404),
    );
  }

  static Future<Order> cancelOrder(String id) async {
    await MockNetworkSimulator.simulate();
    final idx = _sessionOrders.indexWhere((o) => o.id == id);
    if (idx == -1) throw ApiException(message: 'Commande introuvable.', statusCode: 404);
    final order = _sessionOrders[idx];
    if (order.status != OrderStatus.pending) {
      throw ApiException(
          message: 'Impossible d\'annuler : la commande est déjà en cours.',
          statusCode: 400);
    }
    final cancelled = Order(
      id: order.id, userId: order.userId, items: order.items,
      status: OrderStatus.cancelled, subtotal: order.subtotal,
      deliveryFee: order.deliveryFee, total: order.total,
      deliveryZone: order.deliveryZone, deliveryAddress: order.deliveryAddress,
      paymentMethod: order.paymentMethod, paymentPhone: order.paymentPhone,
      transactionId: order.transactionId, createdAt: order.createdAt,
      statusHistory: [...order.statusHistory,
        OrderStatusUpdate(status: OrderStatus.cancelled, timestamp: DateTime.now(), note: 'Annulée par le client.'),
      ],
    );
    _sessionOrders[idx] = cancelled;
    return cancelled;
  }

  static int _deliveryFeeForZone(String zoneId) {
    const fees = {
      'abj-centre': 1500, 'abj-nord': 2000, 'abj-sud': 2000,
      'abj-ouest': 2500, 'yamoussoukro': 3500, 'bouake': 3500,
      'san-pedro': 4000, 'korhogo': 4500, 'man': 4500, 'daloa': 3500, 'autre': 5000,
    };
    return fees[zoneId] ?? 2000;
  }
}

// ─── PROMO CODE SERVICE ───────────────────────────────────────────────────────
class PromoCodeService {
  static Future<double> validateCode(String code) async {
    await MockNetworkSimulator.simulate(minMs: 500, maxMs: 900);
    final upperCode = code.trim().toUpperCase();
    if (MockData.promoCodes.containsKey(upperCode)) {
      return MockData.promoCodes[upperCode]!;
    }
    throw ApiException(message: 'Code promo "$code" invalide ou expiré.', statusCode: 400);
  }
}

// ─── PAYMENT SERVICE ──────────────────────────────────────────────────────────
class PaymentService {
  static Future<Map<String, dynamic>> initMobilePay({
    required String orderId,
    required String method,
    required String phone,
    required double amount,
  }) async {
    await MockNetworkSimulator.simulate(minMs: 1000, maxMs: 2000);
    return {
      'transactionId': '${method.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'pending',
      'message': 'Demande USSD envoyée au $phone. Confirmez le paiement de ${amount.toInt()} FCFA.',
    };
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(String transactionId) async {
    await MockNetworkSimulator.simulate(minMs: 600, maxMs: 1200);
    return {'transactionId': transactionId, 'status': 'success'};
  }

  static Future<Map<String, dynamic>> initCardPay({
    required String orderId,
    required double amount,
  }) async {
    await MockNetworkSimulator.simulate(minMs: 800, maxMs: 1500);
    return {'paymentUrl': 'https://cinetpay.com/payment/mock_session_12345'};
  }
}

// ─── NOTIFICATION SERVICE ─────────────────────────────────────────────────────
class NotificationService {
  static final List<AppNotification> _notifications = [...MockData.notifications];

  static Future<List<AppNotification>> getNotifications() async {
    await MockNetworkSimulator.simulate(minMs: 300, maxMs: 600);
    return _notifications;
  }

  static Future<void> markAllRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _notifications.length; i++) {
      final n = _notifications[i];
      _notifications[i] = AppNotification(
        id: n.id, title: n.title, body: n.body, type: n.type,
        orderId: n.orderId, isRead: true, createdAt: n.createdAt,
      );
    }
  }

  static Future<void> markRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final n = _notifications[idx];
      _notifications[idx] = AppNotification(
        id: n.id, title: n.title, body: n.body, type: n.type,
        orderId: n.orderId, isRead: true, createdAt: n.createdAt,
      );
    }
  }

  static int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
