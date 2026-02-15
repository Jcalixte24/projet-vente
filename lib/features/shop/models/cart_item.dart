class CartItem {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}
