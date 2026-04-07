import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/cart_provider.dart';
import '../services/api_services.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../../config/constants.dart';

import 'shop_list_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // ── Données chargées depuis le mock ────────────────────────────────────────
  List<Product> _newArrivals = [];
  List<Product> _bestSellers = [];
  bool _isLoading = true;
  String? _error;

  // Catégorie sélectionnée dans le filtre
  String _selectedCategory = 'Tout';
  final List<String> _categories = ['Tout', 'Femmes', 'Hommes', 'Enfants', 'Accessoires'];

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final results = await Future.wait([
        ProductService.getNewArrivals(),
        ProductService.getBestSellers(),
      ]);
      if (mounted) {
        setState(() {
          _newArrivals = results[0];
          _bestSellers = results[1];
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() { _error = e.message; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = 'Erreur réseau. Vérifiez votre connexion.'; _isLoading = false; });
    }
  }

  List<Product> get _filteredBestSellers {
    if (_selectedCategory == 'Tout') return _bestSellers;
    return _bestSellers.where((p) => p.category == _selectedCategory).toList();
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const ShopListScreen(),
          const FavoritesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Accueil', 0),
              _buildNavItem(Icons.store, 'Boutiques', 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.favorite_border, 'Favoris', 2),
              _buildNavItem(Icons.person_outline, 'Compte', 3),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? Consumer<CartProvider>(
              builder: (_, cart, __) => FloatingActionButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen())),
                backgroundColor: const Color(0xFF6200EE),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.white),
                    if (cart.totalQuantity > 0)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Text('${cart.totalQuantity}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // ── Tab Accueil ─────────────────────────────────────────────────────────────
  Widget _buildHomeTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF6200EE), size: 18),
            const SizedBox(width: 4),
            const Text('Abidjan, CI',
                style: TextStyle(
                    color: Color(0xFF6200EE),
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down,
                color: Colors.grey[600], size: 18),
          ],
        ),
        actions: [
          // Cloche notifications
          IconButton(
            icon: Stack(children: [
              const Icon(Icons.notifications_none, color: Colors.black87),
              Positioned(
                right: 0, top: 0,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ]),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        color: const Color(0xFF6200EE),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── Barre de recherche (tap → SearchScreen) ────────────────
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade400),
                      const SizedBox(width: 10),
                      Text('Robe bazin, sneakers, wax...',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Bannière promo ─────────────────────────────────────────
              _buildPromoBanner(),

              const SizedBox(height: 24),

              // ── Catégories ─────────────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _buildCategoryChip(_categories[i]),
                ),
              ),

              const SizedBox(height: 24),

              // ── Nouveautés ─────────────────────────────────────────────
              _buildSectionHeader('Nouveautés',
                  onSeeAll: () => _onItemTapped(1)),
              const SizedBox(height: 14),
              _isLoading
                  ? _buildHorizontalSkeleton()
                  : _error != null
                      ? ErrorStateWidget(
                          message: _error!, onRetry: _loadHomeData)
                      : _newArrivals.isEmpty
                          ? _buildEmptySection('Aucune nouveauté pour le moment.')
                          : SizedBox(
                              height: 265,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _newArrivals.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 14),
                                itemBuilder: (_, i) =>
                                    _buildProductCard(_newArrivals[i]),
                              ),
                            ),

              const SizedBox(height: 28),

              // ── Les plus vendus ────────────────────────────────────────
              _buildSectionHeader('Les plus vendus',
                  onSeeAll: () => _onItemTapped(1)),
              const SizedBox(height: 14),
              _isLoading
                  ? Column(children: List.generate(
                      2, (_) => _buildHorizontalCardSkeleton()))
                  : _filteredBestSellers.isEmpty
                      ? _buildEmptySection('Aucun article dans cette catégorie.')
                      : Column(
                          children: _filteredBestSellers
                              .take(5)
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildHorizontalProductCard(p),
                                  ))
                              .toList(),
                        ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bannière promo ──────────────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B2CF5), Color(0xFF6200EE)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, bottom: -20,
            child: Opacity(
              opacity: 0.15,
              child: const Icon(Icons.shopping_bag, size: 180, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('OFFRE SPÉCIALE',
                      style: TextStyle(
                          color: Color(0xFF6200EE),
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
                const SizedBox(height: 10),
                const Text('Soldes\n-50%',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.1)),
                const SizedBox(height: 4),
                const Text('Sur toute la boutique Casa Bismark',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    AppSnackBar.showInfo(context, 'Code BIENVENUE10 copié ! (-10% sur votre commande)');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('Voir les offres',
                        style: TextStyle(
                            color: Color(0xFF6200EE),
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Carte produit verticale ─────────────────────────────────────────────────
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _goToDetail(product),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4)),
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
                    product.images.isNotEmpty ? product.images.first : '',
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        height: 165,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: const Center(
                        child: Text('ÉPUISÉ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      ),
                    ),
                  ),
                if (product.hasDiscount)
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text('-${product.discountPercent}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
                    ),
                  ),
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border,
                        size: 15, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.shopName.toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF6200EE),
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${product.price.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF0D47A1))),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 5),
                        Text('${product.originalPrice!.toStringAsFixed(0)}',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade400,
                                fontSize: 10)),
                      ]
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

  // ── Carte produit horizontale (best sellers) ────────────────────────────────
  Widget _buildHorizontalProductCard(Product product) {
    return GestureDetector(
      onTap: () => _goToDetail(product),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.images.isNotEmpty ? product.images.first : '',
                    width: 90, height: 90, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 90, height: 90,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 0, left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Text('-${product.discountPercent}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.shopName.toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF6200EE),
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text('${product.rating} (${product.reviewCount})',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('${product.price.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF0D47A1))),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text('${product.originalPrice!.toStringAsFixed(0)} FCFA',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade400,
                                fontSize: 11)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Stock
            if (!product.isAvailable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6)),
                child: Text('Épuisé',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  // ── Navigation vers ProductDetailScreen ────────────────────────────────────
  void _goToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: {
            'id': product.id,
            'image': product.images.isNotEmpty ? product.images.first : '',
            'brand': product.shopName,
            'name': product.name,
            'price': '${product.price.toStringAsFixed(0)} FCFA',
            'originalPrice': product.originalPrice != null
                ? product.originalPrice!.toStringAsFixed(0)
                : null,
            'discount': product.hasDiscount ? '-${product.discountPercent}%' : null,
            'isNew': product.createdAt.isAfter(
                DateTime.now().subtract(const Duration(days: 7))),
            'description': product.description,
            'sizes': product.sizes,
            'colors': product.colors,
            'rating': product.rating,
            'reviewCount': product.reviewCount,
            'stock': product.stock,
            'isAvailable': product.isAvailable,
          },
        ),
      ),
    );
  }

  // ── Skeletons de chargement ─────────────────────────────────────────────────
  Widget _buildHorizontalSkeleton() {
    return SizedBox(
      height: 265,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => Container(
          width: 160,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16))),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 8, width: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 6),
                      Container(height: 10, width: 120, color: Colors.grey.shade300),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 8, width: 60, color: Colors.grey.shade200),
                const SizedBox(height: 6),
                Container(height: 12, width: 140, color: Colors.grey.shade200),
                const SizedBox(height: 10),
                Container(height: 10, width: 100, color: Colors.grey.shade200),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySection(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(msg,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
      ),
    );
  }

  // ── Nav + Section header + Category chip ───────────────────────────────────
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isSelected ? const Color(0xFF6200EE) : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: isSelected ? const Color(0xFF6200EE) : Colors.grey,
                  fontSize: 10,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text('Voir tout',
              style: TextStyle(
                  color: Color(0xFF6200EE),
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6200EE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}
