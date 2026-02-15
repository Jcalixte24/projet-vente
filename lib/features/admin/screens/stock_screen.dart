import 'package:flutter/material.dart';
import '../../shop/screens/product_detail_screen.dart'; // Ensure reuse if needed or placeholder

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Robe d'été Fleurie",
      "price": 12500,
      "stock": 14,
      "image": "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400",
      "status": "En stock",
      "isNew": true
    },
    {
      "id": 2,
      "name": "Baskets Run Max",
      "price": 45000,
      "stock": 0,
      "image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
      "status": "Épuisé",
      "isNew": false
    },
    {
      "id": 3,
      "name": "Veste Denim Classic",
      "price": 22000,
      "stock": 8,
      "image": "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400",
      "status": "En stock",
      "isNew": false
    },
    {
      "id": 4,
      "name": "Montre Smart Luxe",
      "price": 85000,
      "stock": 2,
      "image": "https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=400",
      "status": "Low Stock",
      "isNew": false
    },
     {
      "id": 5,
      "name": "Chemise Printemps",
      "price": 15000,
      "stock": 0,
      "image": "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400",
      "status": "Archivé",
      "isNew": false
    },
     {
      "id": 6,
      "name": "T-shirt Basic Noir",
      "price": 5000,
      "stock": 120,
      "image": "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=400",
      "status": "En stock",
      "isNew": true
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          // Header & Search
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "Rechercher un produit...",
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                      child: const Icon(Icons.tune, color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color(0xFF00C853),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF00C853),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    _buildTab("Tous (${_products.length})"),
                    _buildTab("En stock (${_products.where((p) => p['stock'] > 0).length})"),
                    _buildTab("Rupture (${_products.where((p) => p['stock'] == 0 && p['status'] != 'Archivé').length})"),
                    _buildTab("Archivés (${_products.where((p) => p['status'] == 'Archivé').length})"),
                  ],
                )
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid(_products), // All
                _buildProductGrid(_products.where((p) => p['stock'] > 0).toList()), // In Stock
                _buildProductGrid(_products.where((p) => p['stock'] == 0 && p['status'] != 'Archivé').toList()), // Out of Stock
                 _buildProductGrid(_products.where((p) => p['status'] == 'Archivé').toList()), // Archived
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product
        },
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text));
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        bool isActive = product['status'] != 'Archivé';
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product['image'],
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                       errorBuilder: (_,__,___) => Container(color:Colors.grey[200], height:140),
                    ),
                  ),
                  if (product['isNew'] == true)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF00C853), borderRadius: BorderRadius.circular(4)),
                        child: const Text("NOUVEAU", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                   if (product['stock'] <= 5 && product['stock'] > 0)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                        child: const Text("LOW STOCK", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text("${product['price']} FCFA", style: const TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("STOCK", style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                                Text(
                                  isActive ? "${product['stock']} unités" : "Désactivé",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: product['stock'] == 0 ? Colors.red : Colors.black,
                                    fontStyle: isActive ? FontStyle.normal : FontStyle.italic
                                  )
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isActive,
                            activeColor: const Color(0xFF00C853),
                            onChanged: (val) {
                              // Toggle status logic placeholder
                              setState(() {
                                product['status'] = val ? "En stock" : "Archivé";
                              });
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )
                        ],
                      ),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: product['stock'] > 0 ? Colors.green[50] : Colors.red[50], // Light green or light red
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              product['stock'] > 0 ? Icons.check_circle : Icons.error,
                              size: 12,
                              color: product['stock'] > 0 ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product['stock'] > 0 ? "En stock" : (product['status'] == 'Archivé' ? "Masqué" : "Épuisé"),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: product['stock'] > 0 ? Colors.green : (product['status'] == 'Archivé' ? Colors.grey : Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
