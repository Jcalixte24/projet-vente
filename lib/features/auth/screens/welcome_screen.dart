import 'package:flutter/material.dart';
import 'login_screen.dart'; 

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isBuyerSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ... (Je garde la partie visuelle courte pour aller droit au but)
              const SizedBox(height: 40),
              const Text("Bienvenue sur IvoireMode", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              // CHOIX
              _buildRoleCard("Je suis un Acheteur", Icons.shopping_bag_outlined, isBuyerSelected, () => setState(() => isBuyerSelected = true)),
              const SizedBox(height: 16),
              _buildRoleCard("Je suis un Vendeur", Icons.storefront_outlined, !isBuyerSelected, () => setState(() => isBuyerSelected = false)),

              const Spacer(),

              // LE FIX EST ICI : Pas de 'const' devant LoginScreen !
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // RETRAIT DU 'const' car isBuyerSelected est une variable
                      builder: (context) => LoginScreen(isSeller: !isBuyerSelected),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
                child: const Text("Continuer", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFFF6B00) : Colors.transparent, width: 2),
        ),
        child: Row(children: [Icon(icon, color: const Color(0xFFFF6B00)), const SizedBox(width: 16), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ),
    );
  }
}