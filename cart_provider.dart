import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

// ─── CART PROVIDER — avec gestion promos et variantes ────────────────────────
class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // Code promo appliqué
  String? _appliedPromoCode;
  double _promoDiscount = 0.0; // 0.0 à 1.0 (ex: 0.10 = -10%)

  // ── Getters ────────────────────────────────────────────────────────────────
  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    _items.forEach((_, item) => total += item.quantity);
    return total;
  }

  bool get isEmpty => _items.isEmpty;

  /// Sous-total avant livraison et avant promo
  double get subtotal {
    double total = 0.0;
    _items.forEach((_, item) => total += item.price * item.quantity);
    return total;
  }

  /// Montant de la réduction promo (en FCFA)
  double get discountAmount => subtotal * _promoDiscount;

  /// Sous-total après promo, avant livraison
  double get totalAfterDiscount => subtotal - discountAmount;

  /// Montant total final (après promo + frais de livraison passés en paramètre)
  double totalWithDelivery(double deliveryFee) => totalAfterDiscount + deliveryFee;

  String? get appliedPromoCode => _appliedPromoCode;
  double get promoDiscountPercent => _promoDiscount * 100;
  bool get hasPromo => _appliedPromoCode != null && _promoDiscount > 0;

  // ── Ajout au panier ────────────────────────────────────────────────────────
  /// La clé inclut taille+couleur pour distinguer les variantes du même produit.
  void addItem({
    required String productId,
    required String name,
    required String brand,
    required double price,
    required String image,
    String? selectedSize,
    String? selectedColor,
  }) {
    // Clé unique = produit + taille + couleur
    final key = '${productId}_${selectedSize ?? ''}_${selectedColor ?? ''}';

    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existing) => CartItem(
          id: existing.id,
          productId: existing.productId,
          name: existing.name,
          brand: existing.brand,
          price: existing.price,
          image: existing.image,
          quantity: existing.quantity + 1,
          selectedSize: existing.selectedSize,
          selectedColor: existing.selectedColor,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItem(
          id: key,
          productId: productId,
          name: name,
          brand: brand,
          price: price,
          image: image,
          quantity: 1,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
        ),
      );
    }
    notifyListeners();
  }

  // ── Incrément / Décrement ──────────────────────────────────────────────────
  void incrementItem(String itemKey) {
    if (!_items.containsKey(itemKey)) return;
    _items.update(
      itemKey,
      (existing) => CartItem(
        id: existing.id,
        productId: existing.productId,
        name: existing.name,
        brand: existing.brand,
        price: existing.price,
        image: existing.image,
        quantity: existing.quantity + 1,
        selectedSize: existing.selectedSize,
        selectedColor: existing.selectedColor,
      ),
    );
    notifyListeners();
  }

  void decrementItem(String itemKey) {
    if (!_items.containsKey(itemKey)) return;
    if (_items[itemKey]!.quantity > 1) {
      _items.update(
        itemKey,
        (existing) => CartItem(
          id: existing.id,
          productId: existing.productId,
          name: existing.name,
          brand: existing.brand,
          price: existing.price,
          image: existing.image,
          quantity: existing.quantity - 1,
          selectedSize: existing.selectedSize,
          selectedColor: existing.selectedColor,
        ),
      );
    } else {
      _items.remove(itemKey);
    }
    notifyListeners();
  }

  void removeItem(String itemKey) {
    _items.remove(itemKey);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _appliedPromoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
  }

  // ── Gestion des codes promo ────────────────────────────────────────────────
  /// Applique un code promo validé (discount = 0.0 à 1.0).
  void applyPromoCode(String code, double discount) {
    _appliedPromoCode = code.toUpperCase();
    _promoDiscount = discount;
    notifyListeners();
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
  }

  // ── Export pour OrderService ───────────────────────────────────────────────
  /// Convertit le panier en liste d'articles pour l'API OrderService.createOrder()
  List<Map<String, dynamic>> toOrderItems() {
    return _items.values.map((item) => {
      'productId': item.productId,
      'productName': item.name,
      'productImage': item.image,
      'price': item.price,
      'quantity': item.quantity,
      'selectedSize': item.selectedSize,
      'selectedColor': item.selectedColor,
    }).toList();
  }
}
