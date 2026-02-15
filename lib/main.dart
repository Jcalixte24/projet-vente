import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Note bien le chemin : features/auth/screens/
import 'features/auth/screens/splash_screen.dart'; 
import 'features/shop/providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'IvoireMode',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7F13EC)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}