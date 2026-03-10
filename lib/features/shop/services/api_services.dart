import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../../../config/constants.dart';

// ─── API SERVICE (base) ───────────────────────────────────────────────────────
class ApiService {
  static const String _baseUrl = AppConstants.baseUrl;
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

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      message: body['message'] ?? 'Une erreur est survenue',
      statusCode: response.statusCode,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException({required this.message, required this.statusCode});
  @override
  String toString() => message;
}

// ─── AUTH SERVICE ─────────────────────────────────────────────────────────────
class AuthService {
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final data = await ApiService.post('/auth/login', {
      'phone': phone,
      'password': password,
    });
    await ApiService.setToken(data['token']);
    return data;
  }

  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    String? email,
    bool isSeller = false,
  }) async {
    final data = await ApiService.post('/auth/signup', {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'password': password,
      if (email != null) 'email': email,
      'isSeller': isSeller,
    });
    await ApiService.setToken(data['token']);
    return data;
  }

  static Future<void> logout() async {
    await ApiService.clearToken();
  }

  static Future<AppUser> getProfile() async {
    final data = await ApiService.get('/auth/me');
    return AppUser.fromJson(data['user']);
  }

  static Future<AppUser> updateProfile(Map<String, dynamic> updates) async {
    final data = await ApiService.put('/auth/profile', updates);
    return AppUser.fromJson(data['user']);
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
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null && category != 'Tous') 'category': category,
      if (search != null) 'search': search,
      if (shopId != null) 'shopId': shopId,
    };
    final query = Uri(queryParameters: params).query;
    final data = await ApiService.get('/products?$query');
    return (data['products'] as List).map((p) => Product.fromJson(p)).toList();
  }

  static Future<Product> getProduct(String id) async {
    final data = await ApiService.get('/products/$id');
    return Product.fromJson(data['product']);
  }

  static Future<List<Product>> getFeatured() async {
    final data = await ApiService.get('/products/featured');
    return (data['products'] as List).map((p) => Product.fromJson(p)).toList();
  }

  static Future<List<Product>> searchProducts(String query) async {
    final data = await ApiService.get('/products/search?q=${Uri.encodeComponent(query)}');
    return (data['products'] as List).map((p) => Product.fromJson(p)).toList();
  }
}

// ─── ORDER SERVICE ────────────────────────────────────────────────────────────
class OrderService {
  static Future<Order> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryZone,
    required String deliveryAddress,
    required String paymentMethod,
    String? paymentPhone,
    String? promoCode,
  }) async {
    final data = await ApiService.post('/orders', {
      'items': items,
      'deliveryZone': deliveryZone,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      if (paymentPhone != null) 'paymentPhone': paymentPhone,
      if (promoCode != null) 'promoCode': promoCode,
    });
    return Order.fromJson(data['order']);
  }

  static Future<List<Order>> getMyOrders() async {
    final data = await ApiService.get('/orders/my');
    return (data['orders'] as List).map((o) => Order.fromJson(o)).toList();
  }

  static Future<Order> getOrder(String id) async {
    final data = await ApiService.get('/orders/$id');
    return Order.fromJson(data['order']);
  }

  static Future<Order> cancelOrder(String id) async {
    final data = await ApiService.put('/orders/$id/cancel', {});
    return Order.fromJson(data['order']);
  }
}

// ─── PAYMENT SERVICE ──────────────────────────────────────────────────────────
class PaymentService {
  /// Initie un paiement Mobile Money (Orange, MTN, Wave, Moov)
  static Future<Map<String, dynamic>> initMobilePay({
    required String orderId,
    required String method, // 'orange', 'mtn', 'wave', 'moov'
    required String phone,
    required double amount,
  }) async {
    return await ApiService.post('/payments/mobile/init', {
      'orderId': orderId,
      'method': method,
      'phone': phone,
      'amount': amount,
    });
    // Retourne { transactionId, status, message }
    // Le client reçoit une notification USSD pour confirmer
  }

  /// Vérifie le statut d'un paiement
  static Future<Map<String, dynamic>> checkPaymentStatus(String transactionId) async {
    return await ApiService.get('/payments/$transactionId/status');
    // Retourne { status: 'pending'|'success'|'failed', transactionId }
  }

  /// Initie un paiement par carte bancaire (Stripe / CinetPay)
  static Future<Map<String, dynamic>> initCardPay({
    required String orderId,
    required double amount,
  }) async {
    return await ApiService.post('/payments/card/init', {
      'orderId': orderId,
      'amount': amount,
    });
    // Retourne { paymentUrl } → rediriger vers CinetPay
  }
}

// ─── NOTIFICATION SERVICE ─────────────────────────────────────────────────────
class NotificationService {
  static Future<List<AppNotification>> getNotifications() async {
    final data = await ApiService.get('/notifications');
    return (data['notifications'] as List)
        .map((n) => AppNotification.fromJson(n))
        .toList();
  }

  static Future<void> markAllRead() async {
    await ApiService.put('/notifications/read-all', {});
  }

  static Future<void> markRead(String id) async {
    await ApiService.put('/notifications/$id/read', {});
  }
}
