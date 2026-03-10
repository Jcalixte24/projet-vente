class AppConstants {
  // API
  static const String baseUrl = 'https://api.marketci.ci/v1';
  static const String apiVersion = 'v1';

  // Zones de livraison CI
  static const List<Map<String, dynamic>> zonesLivraison = [
    {'id': 'abj-centre', 'label': 'Abidjan Centre (Plateau, Cocody)', 'delai': '24h', 'prix': 1500},
    {'id': 'abj-nord', 'label': 'Abidjan Nord (Abobo, Anyama)', 'delai': '24-48h', 'prix': 2000},
    {'id': 'abj-sud', 'label': 'Abidjan Sud (Marcory, Koumassi)', 'delai': '24-48h', 'prix': 2000},
    {'id': 'abj-ouest', 'label': 'Abidjan Ouest (Yopougon)', 'delai': '48h', 'prix': 2500},
    {'id': 'yamoussoukro', 'label': 'Yamoussoukro', 'delai': '2-3 jours', 'prix': 3500},
    {'id': 'bouake', 'label': 'Bouaké', 'delai': '2-3 jours', 'prix': 3500},
    {'id': 'san-pedro', 'label': 'San-Pédro', 'delai': '3-4 jours', 'prix': 4000},
    {'id': 'korhogo', 'label': 'Korhogo', 'delai': '3-4 jours', 'prix': 4500},
    {'id': 'man', 'label': 'Man', 'delai': '3-4 jours', 'prix': 4500},
    {'id': 'daloa', 'label': 'Daloa', 'delai': '2-3 jours', 'prix': 3500},
    {'id': 'autre', 'label': 'Autre ville', 'delai': '4-5 jours', 'prix': 5000},
  ];

  // Moyens de paiement CI
  static const List<Map<String, dynamic>> paymentMethods = [
    {'id': 'orange', 'label': 'Orange Money', 'prefix': '07', 'color': 0xFFFF6B00},
    {'id': 'mtn', 'label': 'MTN MoMo', 'prefix': '05', 'color': 0xFFFFD700},
    {'id': 'wave', 'label': 'Wave', 'prefix': '01', 'color': 0xFF1FAAFF},
    {'id': 'moov', 'label': 'Moov Money', 'prefix': '01', 'color': 0xFF00C853},
    {'id': 'carte', 'label': 'Carte Bancaire', 'prefix': '', 'color': 0xFF6C3FC5},
  ];

  // Catégories
  static const List<String> categories = [
    'Tous', 'Mode', 'Tissus', 'Beauté', 'Bijoux', 'Maroquinerie',
    'Alimentation', 'Électronique', 'Musique', 'Décoration',
  ];
}

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String shopSetup = '/shop-setup';

  // Shop
  static const String home = '/home';
  static const String catalog = '/catalog';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String paymentConfirmation = '/payment-confirmation';
  static const String orderHistory = '/order-history';
  static const String orderTracking = '/order-tracking';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String shopList = '/shop-list';
  static const String notifications = '/notifications';

  // Admin
  static const String sellerDashboard = '/seller-dashboard';
  static const String salesDashboard = '/sales-dashboard';
  static const String orders = '/orders';
  static const String stock = '/stock';
  static const String addProduct = '/add-product';
  static const String shopProfile = '/shop-profile';
}
