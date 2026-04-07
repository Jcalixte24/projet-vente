import 'dart:async';
import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../config/constants.dart';
import '../models/models.dart';
import '../services/api_services.dart';
import '../../shared/widgets/app_widgets.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  String _query = '';
  String _selectedCategory = 'Tous';
  bool _isSearching = false;
  String? _error;

  List<Product> _results = [];
  Timer? _debounce;

  // Recherches récentes
  List<String> _recentSearches = [
    'Robe bazin', 'Sneakers', 'Wax femme', 'Sandales cuir'
  ];

  // Suggestions tendances
  final List<String> _trending = [
    '🔥 Robe bazin', '✨ Costume slim', '💄 Wax ankara',
    '👜 Sac cuir', '📿 Bijoux', '👟 Sneakers',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Recherche avec debounce 400ms ───────────────────────────────────────────
  void _onSearchChanged(String query) {
    setState(() { _query = query; _error = null; });
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() { _results = []; _isSearching = false; });
      return;
    }
    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _doSearch(query));
  }

  Future<void> _doSearch(String query) async {
    try {
      // Filtre catégorie + texte
      final results = await ProductService.getProducts(
        search: query,
        category: _selectedCategory == 'Tous' ? null : _selectedCategory,
      );
      if (mounted) setState(() { _results = results; _isSearching = false; });
    } on ApiException catch (e) {
      if (mounted) setState(() { _error = e.message; _isSearching = false; });
    } catch (_) {
      if (mounted) setState(() { _error = 'Erreur réseau.'; _isSearching = false; });
    }
  }

  void _selectSearch(String term) {
    // Enlever les emojis du terme
    final clean = term.replaceAll(RegExp(r'[^\w\s\u00C0-\u024F]'), '').trim();
    _searchCtrl.text = clean;
    _onSearchChanged(clean);
    if (!_recentSearches.contains(clean) && clean.isNotEmpty) {
      setState(() => _recentSearches.insert(0, clean));
    }
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    if (_query.isNotEmpty) _doSearch(_query);
  }

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
            'originalPrice': product.originalPrice?.toStringAsFixed(0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    focusNode: _focusNode,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _selectSearch,
                    decoration: InputDecoration(
                      hintText: 'Robe, sneakers, wax...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: Colors.grey.shade400, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchCtrl.clear();
                                _onSearchChanged('');
                              },
                              child: Icon(Icons.close_rounded,
                                  color: Colors.grey.shade400, size: 18),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filtres catégories ─────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = AppConstants.categories[i];
                  final active = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => _onCategoryChanged(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: active
                                ? AppColors.primary
                                : Colors.grey.shade300),
                      ),
                      child: Text(cat,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : Colors.grey.shade600)),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Corps ──────────────────────────────────────────────────────
          Expanded(
            child: _query.isEmpty
                ? _buildEmptyState()
                : _isSearching
                    ? _buildLoadingState()
                    : _error != null
                        ? ErrorStateWidget(
                            message: _error!,
                            onRetry: () => _doSearch(_query))
                        : _buildResults(),
          ),
        ],
      ),
    );
  }

  // ── État vide (tendances + récents) ────────────────────────────────────────
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tendances
          const Text('🔥 Tendances',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trending
                .map((t) => GestureDetector(
                      onTap: () => _selectSearch(t),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),

          // Recherches récentes
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🕐 Récents',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                TextButton(
                  onPressed: () =>
                      setState(() => _recentSearches.clear()),
                  child: const Text('Effacer',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ..._recentSearches.take(5).map((s) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.history_rounded,
                        size: 18, color: AppColors.textSecondary),
                  ),
                  title: Text(s,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.north_west_rounded,
                      size: 16, color: AppColors.textLight),
                  onTap: () => _selectSearch(s),
                )),
          ],
        ],
      ),
    );
  }

  // ── Skeleton de chargement ─────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 88,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12))),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 12,
                      width: 140,
                      color: Colors.grey.shade200),
                  const SizedBox(height: 8),
                  Container(
                      height: 10,
                      width: 90,
                      color: Colors.grey.shade200),
                  const SizedBox(height: 8),
                  Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey.shade200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Résultats réels ────────────────────────────────────────────────────────
  Widget _buildResults() {
    if (_results.isEmpty) {
      return EmptyStateWidget.search();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Text(
            '${_results.length} résultat${_results.length > 1 ? 's' : ''} pour "$_query"',
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final p = _results[i];
              return GestureDetector(
                onTap: () => _goToDetail(p),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Photo produit
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              p.images.isNotEmpty ? p.images.first : '',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.image_not_supported,
                                    color: AppColors.textLight),
                              ),
                            ),
                          ),
                          if (!p.isAvailable)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Text('Épuisé',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                          if (p.hasDiscount)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(8)),
                                ),
                                child: Text('-${p.discountPercent}%',
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
                            Text(p.shopName.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.textPrimary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(p.category,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star,
                                    size: 11, color: Colors.amber),
                                Text(' ${p.rating}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Prix + chevron
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${p.price.toStringAsFixed(0)} F',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: AppColors.primary)),
                          if (p.hasDiscount)
                            Text(
                                '${p.originalPrice!.toStringAsFixed(0)} F',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade400,
                                    fontSize: 11)),
                          const SizedBox(height: 4),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textLight, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
