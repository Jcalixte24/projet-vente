import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

// ─── BOUTON PRIMAIRE ──────────────────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? color;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.color,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          minimumSize: Size(double.infinity, height),
        ),
        child: isLoading
            ? const SizedBox(width: 22, height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

// ─── CARTE PRODUIT ────────────────────────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final String name, emoji, shopName, category;
  final double price;
  final double? originalPrice;
  final double rating;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.name,
    required this.emoji,
    required this.shopName,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    final discount = hasDiscount
        ? (((originalPrice! - price) / originalPrice!) * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.06),
                blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Emoji
            Stack(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 56)),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('-$discount%',
                          style: const TextStyle(color: Colors.white, fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                          color: AppColors.primary, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(shopName,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
                      Text(' $rating', style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${price.toStringAsFixed(0)} F',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14,
                                  color: AppColors.textPrimary)),
                          if (hasDiscount)
                            Text('${originalPrice!.toStringAsFixed(0)} F',
                                style: const TextStyle(fontSize: 11,
                                    color: AppColors.textLight,
                                    decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BADGE MOYEN DE PAIEMENT ──────────────────────────────────────────────────
class PaymentBadge extends StatelessWidget {
  final String method;
  final bool selected;
  final VoidCallback onTap;

  const PaymentBadge({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  static const _map = {
    'orange': {'label': 'Orange Money', 'icon': '🟠', 'color': 0xFFFF6B00},
    'mtn': {'label': 'MTN MoMo', 'icon': '🟡', 'color': 0xFFFFD700},
    'wave': {'label': 'Wave', 'icon': '🔵', 'color': 0xFF1FAAFF},
    'moov': {'label': 'Moov Money', 'icon': '🟢', 'color': 0xFF00C853},
    'carte': {'label': 'Carte', 'icon': '💳', 'color': 0xFF6C3FC5},
  };

  @override
  Widget build(BuildContext context) {
    final info = _map[method] ?? {'label': method, 'icon': '💳', 'color': 0xFF6C3FC5};
    final color = Color(info['color'] as int);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : AppColors.divider, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(info['icon'] as String, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(info['label'] as String,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12,
                    color: selected ? color : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ─── CHIP DE STATUT ───────────────────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
  );
}

// ─── EMPTY STATE ──────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji, title, subtitle;
  final String? buttonLabel;
  final VoidCallback? onButton;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(title, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
          if (buttonLabel != null && onButton != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onButton,
                child: Text(buttonLabel!),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

// ─── CHAMP DE FORMULAIRE ──────────────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String label, hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.textLight, size: 20) : null,
          suffixIcon: suffixIcon,
        ),
      ),
    ],
  );
}

// ─── BOTTOM SHEET RÉUTILISABLE ────────────────────────────────────────────────
void showAppBottomSheet(BuildContext context, {required Widget child, String? title}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2))),
          if (title != null) ...[
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ],
          child,
        ],
      ),
    ),
  );
}


// ─── EMPTY STATE WIDGET ────────────────────────────────────────────────────────
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  // Constructeurs nommés pour les cas courants
  factory EmptyStateWidget.cart({VoidCallback? onShop}) => EmptyStateWidget(
        icon: Icons.shopping_cart_outlined,
        title: 'Votre panier est vide',
        subtitle: 'Ajoutez des articles pour commencer vos achats.',
        actionLabel: 'Parcourir la boutique',
        onAction: onShop,
      );

  factory EmptyStateWidget.orders({VoidCallback? onShop}) => EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'Aucune commande',
        subtitle: 'Vous n\'avez pas encore passé de commande.',
        actionLabel: 'Commencer mes achats',
        onAction: onShop,
      );

  factory EmptyStateWidget.favorites({VoidCallback? onShop}) => EmptyStateWidget(
        icon: Icons.favorite_border,
        title: 'Aucun favori',
        subtitle: 'Appuyez sur ♡ sur un article pour l\'ajouter à vos favoris.',
        actionLabel: 'Découvrir des articles',
        onAction: onShop,
      );

  factory EmptyStateWidget.search() => const EmptyStateWidget(
        icon: Icons.search_off_outlined,
        title: 'Aucun résultat',
        subtitle: 'Essayez d\'autres mots-clés ou consultez nos catégories.',
      );

  factory EmptyStateWidget.notifications() => const EmptyStateWidget(
        icon: Icons.notifications_none_outlined,
        title: 'Pas de notifications',
        subtitle: 'Vous serez notifié ici du suivi de vos commandes et promos.',
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(actionLabel!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── ERROR STATE WIDGET (erreur réseau) ───────────────────────────────────────
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.message = 'Une erreur est survenue. Vérifiez votre connexion.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.red.shade200),
            const SizedBox(height: 20),
            const Text(
              'Problème de connexion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade500, height: 1.5),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6200EE),
                  side: const BorderSide(color: Color(0xFF6200EE)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── SNACKBAR HELPERS ─────────────────────────────────────────────────────────
class AppSnackBar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor: const Color(0xFF6200EE),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }
}
