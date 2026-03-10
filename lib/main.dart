import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'config/constants.dart';

// Auth
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/auth/screens/shop_setup_screen.dart';

// Shop
import 'features/shop/screens/home_screen.dart';
import 'features/shop/screens/catalog_screen.dart';
import 'features/shop/screens/product_detail_screen.dart';
import 'features/shop/screens/cart_screen.dart';
import 'features/shop/screens/checkout_screen.dart';
import 'features/shop/screens/payment_confirmation_screen.dart';
import 'features/shop/screens/order_history_screen.dart';
import 'features/shop/screens/order_tracking_screen.dart';
import 'features/shop/screens/favorites_screen.dart';
import 'features/shop/screens/search_screen.dart';
import 'features/shop/screens/profile_screen.dart';
import 'features/shop/screens/shop_list_screen.dart';
import 'features/shop/screens/notifications_screen.dart';

// Admin
import 'features/admin/screens/seller_dashboard_screen.dart';
import 'features/admin/screens/sales_dashboard_screen.dart';
import 'features/admin/screens/orders_screen.dart';
import 'features/admin/screens/stock_screen.dart';
import 'features/admin/screens/add_product_screen.dart';
import 'features/admin/screens/product_success_screen.dart';
import 'features/admin/screens/shop_profile_screen.dart';

// Providers
import 'features/shop/providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MarketCIApp(),
    ),
  );
}

class MarketCIApp extends StatelessWidget {
  const MarketCIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarketCI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        // Auth
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.shopSetup: (_) => const ShopSetupScreen(),

        // Shop
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.catalog: (_) => const CatalogScreen(),
        AppRoutes.productDetail: (_) => const ProductDetailScreen(),
        AppRoutes.cart: (_) => const CartScreen(),
        AppRoutes.checkout: (_) => const CheckoutScreen(),
        AppRoutes.favorites: (_) => const FavoritesScreen(),
        AppRoutes.search: (_) => const SearchScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.shopList: (_) => const ShopListScreen(),
        AppRoutes.orderHistory: (_) => const OrderHistoryScreen(),
        AppRoutes.orderTracking: (_) => const OrderTrackingScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),

        // Admin
        AppRoutes.sellerDashboard: (_) => const SellerDashboardScreen(),
        AppRoutes.salesDashboard: (_) => const SalesDashboardScreen(),
        AppRoutes.orders: (_) => const OrdersScreen(),
        AppRoutes.stock: (_) => const StockScreen(),
        AppRoutes.addProduct: (_) => const AddProductScreen(),
        AppRoutes.shopProfile: (_) => const ShopProfileScreen(),
      },
      onGenerateRoute: (settings) {
        // Routes avec arguments
        if (settings.name == AppRoutes.paymentConfirmation) {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) => PaymentConfirmationScreen(
              orderId: args['orderId'] ?? '',
              paymentMethod: args['paymentMethod'] ?? 'orange',
              amount: (args['amount'] as num?)?.toDouble() ?? 0,
              paymentPhone: args['paymentPhone'],
            ),
          );
        }
        if (settings.name == AppRoutes.orderTracking) {
          return MaterialPageRoute(
            builder: (_) => OrderTrackingScreen(
              order: settings.arguments as dynamic,
            ),
          );
        }
        return null;
      },
    );
  }
}