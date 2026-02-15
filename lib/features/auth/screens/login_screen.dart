import 'package:flutter/material.dart';

import 'shop_setup_screen.dart';
import '../../shop/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isSeller; // C'est cette variable qui décide quel design afficher

  const LoginScreen({super.key, required this.isSeller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Contrôleurs
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoginSelected = true;

  // --- COULEURS DYNAMIQUES ---
  // Si Vendeur : Orange (#FF6B00)
  // Si Acheteur : Ton Rouge original (#FF3B30)
  Color get mainColor =>
      widget.isSeller ? const Color(0xFFFF6B00) : const Color(0xFFFF3B30);

  // --- IMAGES DYNAMIQUES ---
  String get backgroundImage => widget.isSeller
      ? 'https://images.unsplash.com/photo-1556740758-90de374c12ad?q=80&w=1000&auto=format&fit=crop' // Image Business pour Vendeur
      : 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000&auto=format&fit=crop'; // Image Mode pour Acheteur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 1. IMAGE DE FOND (Change selon le rôle)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: constraints.maxHeight * 0.45,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(backgroundImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bouton Retour
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        // BADGE (Change texte et couleur)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.isSeller
                                ? mainColor
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.isSeller
                                ? "ESPACE VENDEUR"
                                : "MODE & TENDANCE",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // TITRE (Change texte)
                        Text(
                          widget.isSeller
                              ? "Gérez votre boutique\nen toute simplicité."
                              : "La mode ivoirienne\nvous attend.",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. LE FORMULAIRE
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: constraints.maxHeight * 0.65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Onglets Connexion / Inscription
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTabButton("Se connecter", true),
                              ),
                              Expanded(
                                child: _buildTabButton("S'inscrire", false),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Affiche le bon formulaire selon l'onglet
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          crossFadeState: _isLoginSelected
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: _buildLoginForm(),
                          secondChild: _buildSignupForm(),
                        ),

                        const SizedBox(height: 24),

                        // Séparateur
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[200])),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                "Ou continuer avec",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[200])),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Boutons Sociaux
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                "Google",
                                Icons.g_mobiledata,
                                Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSocialButton(
                                "Facebook",
                                Icons.facebook,
                                const Color(0xFF1877F2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- FORMULAIRES ---

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildPhoneField(),
        const SizedBox(height: 16),
        _buildPasswordField(
          _passwordController,
          "Mot de passe",
          _isPasswordVisible,
          () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Mot de passe oublié ?",
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          widget.isSeller ? "Accéder à ma boutique" : "Se connecter",
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        // C'EST ICI LA DIFFÉRENCE CLÉ :
        // Acheteur -> "Nom complet"
        // Vendeur -> "Nom de la boutique"
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: widget.isSeller
                  ? "Nom de la boutique"
                  : "Nom complet (ex: Jean Kouassi)",
              prefixIcon: Icon(
                widget.isSeller ? Icons.store : Icons.person_outline,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildPhoneField(),
        const SizedBox(height: 16),
        _buildPasswordField(
          _passwordController,
          "Mot de passe",
          _isPasswordVisible,
          () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          _confirmPasswordController,
          "Confirmer le mot de passe",
          _isConfirmPasswordVisible,
          () => setState(
            () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
          ),
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          widget.isSeller ? "Ouvrir ma boutique" : "Créer mon compte",
        ),
      ],
    );
  }

  // --- WIDGETS ---

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              children: [
                Text("🇨🇮", style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(
                  "+225",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "01 02 03 04 05",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool isVisible,
    VoidCallback onToggle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // LOGIQUE DE NAVIGATION
          if (widget.isSeller) {
            print("Connexion Vendeur -> Vers ShopSetupScreen / Dashboard");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShopSetupScreen(),
              ), // On passe par la config d'abord pour la démo
            );
          } else {
            print("Connexion Acheteur -> Vers HomeScreen");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false, // Retire les écrans précédents de la pile
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor, // Couleur dynamique (Orange ou Rouge)
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isLoginTab) {
    bool isSelected = _isLoginSelected == isLoginTab;
    return GestureDetector(
      onTap: () => setState(() => _isLoginSelected = isLoginTab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? mainColor : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color color) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
