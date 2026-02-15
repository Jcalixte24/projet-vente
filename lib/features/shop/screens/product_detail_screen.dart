import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSizeIndex = 1;
  final List<String> sizes = ["S", "M", "L", "XL", "XXL"];
  int _selectedColorIndex = 0;
  final List<Color> colors = [const Color(0xFF6200EE), const Color(0xFFC0A080), const Color(0xFF1E3C30)];
  
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // Placeholder images for carousel
    final List<String> images = [
      widget.product['image'],
      "https://images.unsplash.com/photo-1515347619252-60a6bf4fffce?auto=format&fit=crop&q=80&w=400",
      "https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&q=80&w=400",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar Image Carousel
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
               icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.share, color: Colors.black),
              ),
                onPressed: () {},
              ),
               IconButton(
               icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.favorite_border, color: Colors.black),
              ),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry.key
                                ? const Color(0xFF6200EE)
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header
                  Row(
                    children: [
                       CircleAvatar(
                         radius: 12,
                         backgroundColor: const Color(0xFFE0C09C),
                         child: Text(widget.product['brand']?[0] ?? "C", style: const TextStyle(fontSize: 10, color: Colors.white)),
                       ),
                       const SizedBox(width: 8),
                       Text(widget.product['brand'] ?? "MARQUE", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6200EE))),
                       const SizedBox(width: 4),
                       const Icon(Icons.verified, size: 14, color: Color(0xFF6200EE)),
                       const Spacer(),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         decoration: BoxDecoration(
                           color: const Color(0xFFFFF9C4),
                           borderRadius: BorderRadius.circular(4),
                         ),
                         child: const Row(
                           children: [
                             Icon(Icons.star, size: 12, color: Colors.orange),
                             SizedBox(width: 4),
                             Text("4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                           ],
                         ),
                       )
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Title & Price
                  Text(
                    widget.product['name'] + " - Collection Tabaski",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.product['price'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6200EE)),
                      ),
                      const SizedBox(width: 12),
                      if (widget.product.containsKey('oldPrice'))
                      Text(
                        "${widget.product['oldPrice']} FCFA",
                        style: const TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, color: Colors.grey),
                      ),
                       const SizedBox(width: 8),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                         decoration: BoxDecoration(
                           color: Colors.green[50],
                           borderRadius: BorderRadius.circular(4)
                         ),
                         child: Text(widget.product['discount'] ?? "-20%", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
                       )
                    ],
                  ),

                  const Divider(height: 48),

                  // Colors
                  const Text("Couleur", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: colors.asMap().entries.map((entry) {
                      final isSelected = _selectedColorIndex == entry.key;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColorIndex = entry.key),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? const Color(0xFF6200EE) : Colors.transparent, width: 2),
                          ),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: entry.value,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Sizes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Taille", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: (){}, child: const Text("Guide des tailles", style: TextStyle(fontSize: 12, color: Color(0xFF6200EE))))
                    ],
                  ),
                  Row(
                    children: sizes.asMap().entries.map((entry) {
                      final isSelected = _selectedSizeIndex == entry.key;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSizeIndex = entry.key),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6200EE) : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Description
                  ExpansionTile(
                    title: const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    initiallyExpanded: true,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    children: [
                       Text(
                        "Magnifique robe en Bazin riche authentique, confectionnée avec soin. Idéale pour les cérémonies et le port quotidien. Le tissu est doux, respirant et durable.",
                        style: TextStyle(color: Colors.grey[600], height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                           Icon(Icons.circle, size: 6, color: Colors.grey),
                           SizedBox(width: 8),
                           Text("100% Coton Bazin", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                       const Row(
                        children: [
                           Icon(Icons.circle, size: 6, color: Colors.grey),
                           SizedBox(width: 8),
                           Text("Origine: Fabriqué à Abidjan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),

                   const SizedBox(height: 32),
                   
                   // Delivery Info
                   Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       color: const Color(0xFFF3E5F5),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: const Row(
                       children: [
                         Icon(Icons.local_shipping, color: Color(0xFF6200EE)),
                         SizedBox(width: 16),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("Livraison Express", style: TextStyle(fontWeight: FontWeight.bold)),
                             Text("Livré le 24 Octobre à Abidjan (Cocody, Plateau...)", style: TextStyle(fontSize: 10, color: Colors.grey)),
                           ],
                         )
                       ],
                     ),
                   ),

                   const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF00C853),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  Positioned(right:10, top:10, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)))
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    cart.addItem(
                      widget.product['name'],
                      widget.product['name'],
                      widget.product['brand'] ?? "Unknown",
                      double.parse(widget.product['price'].replaceAll(RegExp(r'[^0-9]'), '')),
                      widget.product['image'],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${widget.product['name']} ajouté au panier"),
                        backgroundColor: const Color(0xFF6200EE),
                      )
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text("AJOUTER AU PANIER", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
