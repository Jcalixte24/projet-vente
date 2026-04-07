import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_services.dart';
import '../../shared/widgets/app_widgets.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool _isValidatingPromo = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyPromoCode(CartProvider cart) async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isValidatingPromo = true);
    try {
      final discount = await PromoCodeService.validateCode(code);
      cart.applyPromoCode(code, discount);
      if (mounted) {
        AppSnackBar.showSuccess(
          context,
          'Code "$code" appliqué ! -${(discount * 100).toInt()}% sur votre commande.',
        );
        _promoController.clear();
      }
    } on ApiException catch (e) {
      if (mounted) AppSnackBar.showError(context, e.message);
    } catch (_) {
      if (mounted) AppSnackBar.showError(context, 'Erreur réseau. Réessayez.');
    } finally {
      if (mounted) setState(() => _isValidatingPromo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          cart.isEmpty
              ? 'Mon Panier'
              : 'Mon Panier (${cart.totalQuantity} article${cart.totalQuantity > 1 ? 's' : ''})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          if (!cart.isEmpty)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Vider le panier ?'),
                    content: const Text('Tous les articles seront supprimés.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler')),
                      TextButton(
                        onPressed: () {
                          cart.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Vider', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Vider'),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyStateWidget.cart(
              onShop: () => Navigator.pop(context),
            )
          : Column(
              children: [
                // ── Liste des articles ────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.values.length,
                    itemBuilder: (context, index) {
                      final item = cart.items.values.elementAt(index);
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          cart.removeItem(item.id);
                          AppSnackBar.showInfo(context, '${item.name} retiré du panier.');
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Suppr.', style: TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Photo
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Infos
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => cart.removeItem(item.id),
                                          child: Icon(Icons.close,
                                              size: 18, color: Colors.grey.shade400),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Variantes (taille + couleur)
                                    Wrap(
                                      spacing: 6,
                                      children: [
                                        if (item.selectedSize != null)
                                          _VariantChip(label: 'Taille: ${item.selectedSize}'),
                                        if (item.selectedColor != null)
                                          _VariantChip(label: item.selectedColor!),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${item.price.toStringAsFixed(0)} FCFA',
                                          style: const TextStyle(
                                              color: Color(0xFF6200EE),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        // Compteur +/-
                                        Row(
                                          children: [
                                            _CounterBtn(
                                              icon: Icons.remove,
                                              onTap: () => cart.decrementItem(item.id),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 14),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                            ),
                                            _CounterBtn(
                                              icon: Icons.add,
                                              filled: true,
                                              onTap: () => cart.incrementItem(item.id),
                                            ),
                                          ],
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
                    },
                  ),
                ),

                // ── Bottom : Promo + Résumé + CTA ────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4))
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Code promo
                        if (cart.hasPromo)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_offer,
                                    color: Colors.green, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Code "${cart.appliedPromoCode}" • -${cart.promoDiscountPercent.toInt()}%',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => cart.removePromoCode(),
                                  child: Icon(Icons.cancel_outlined,
                                      color: Colors.green.shade400, size: 20),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          const Text('Code Promo',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: _promoController,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      hintText: 'Ex : BIENVENUE10',
                                      border: InputBorder.none,
                                      icon: Icon(Icons.local_offer_outlined,
                                          color: Colors.grey, size: 18),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isValidatingPromo
                                      ? null
                                      : () => _applyPromoCode(cart),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE3F2FD),
                                    foregroundColor: const Color(0xFF1976D2),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: _isValidatingPromo
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2))
                                      : const Text('Appliquer',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Sécurité
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_user_outlined,
                                  size: 15, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Paiements sécurisés · Retours gratuits',
                                  style:
                                      TextStyle(color: Colors.green, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Récapitulatif des montants
                        _PriceRow(label: 'Sous-total', value: cart.subtotal),
                        if (cart.hasPromo) ...[
                          const SizedBox(height: 4),
                          _PriceRow(
                            label:
                                'Réduction (${cart.promoDiscountPercent.toInt()}%)',
                            value: -cart.discountAmount,
                            valueColor: Colors.green,
                          ),
                        ],
                        const SizedBox(height: 4),
                        const _PriceRowText(
                          label: 'Livraison estimée',
                          value: 'Calculée à l\'étape suivante',
                          valueColor: Colors.grey,
                        ),
                        const Divider(height: 20),
                        _PriceRow(
                          label: 'Total estimé',
                          value: cart.totalAfterDiscount,
                          labelStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          valueStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1)),
                        ),
                        const SizedBox(height: 14),

                        // Bouton CTA
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CheckoutScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Passer à la caisse',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Widgets utilitaires locaux ─────────────────────────────────────────────────
class _VariantChip extends StatelessWidget {
  final String label;
  const _VariantChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      );
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _CounterBtn(
      {required this.icon, required this.onTap, this.filled = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: filled ? const Color(0xFF0D47A1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: filled ? Colors.white : Colors.black),
        ),
      );
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  const _PriceRow(
      {required this.label,
      required this.value,
      this.valueColor,
      this.labelStyle,
      this.valueStyle});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  labelStyle ?? TextStyle(color: Colors.grey.shade600)),
          Text(
            '${value >= 0 ? '' : '-'}${value.abs().toStringAsFixed(0)} FCFA',
            style: valueStyle ??
                TextStyle(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black),
          ),
        ],
      );
}

class _PriceRowText extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _PriceRowText(
      {required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: valueColor ?? Colors.black54,
                  fontSize: 12)),
        ],
      );
}
