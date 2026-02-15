import 'package:flutter/material.dart';
// Note: Tu devras créer home_screen.dart et admin_dashboard.dart ensuite !
// import 'home_screen.dart'; 
// import 'admin_dashboard.dart'; 

class LoginScreen extends StatefulWidget {
  final bool isSeller; // La variable qui manquait

  const LoginScreen({super.key, required this.isSeller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isSeller ? "Espace VENDEUR" : "Espace CLIENT",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("Formulaire de connexion ici..."),
          ],
        ),
      ),
    );
  }
}