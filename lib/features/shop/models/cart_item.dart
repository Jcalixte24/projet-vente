class CartItem {
  final String id;          // clé unique = productId_size_color
  final String productId;   // ID du produit source
  final String name;
  final String brand;
  final double price;
  final String image;
  int quantity;
  final String? selectedSize;
  final String? selectedColor;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get subtotal => price * quantity;
}
