import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../config/constants.dart';

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

  // Recherches récentes (à sauvegarder en SharedPrefs)
  List<String> _recentSearches = ['Tissu wax', 'Robe bogolan', 'Bijoux perles', 'Shea butter'];

  // Suggestions populaires
  final List<String> _trending = [
    '🔥 Tissu wax', '✨ Boubou cérémonie', '💄 Karité bio',
    '👜 Sac raphia', '📿 Bijoux or', '🥁 Djembé',
  ];

  // Résultats simulés
  final List<Map<String, dynamic>> _mockResults = [
    {'name': 'Tissu Wax Premium', 'price': 8500, 'shop': 'Kôkô Boutique', 'emoji': '🧵', 'cat': 'Tissus'},
    {'name': 'Wax Hollandais', 'price': 15000, 'shop': 'Africa Style', 'emoji': '🎨', 'cat': 'Tissus'},
    {'name': 'Pagne Kente', 'price': 12000, 'shop': 'Kôkô Boutique', 'emoji': '🪡', 'cat': 'Tissus'},
    {'name': 'Caftan Brodé', 'price': 35000, 'shop': 'Mode Abidjan', 'emoji': '👗', 'cat': 'Mode'},
    {'name': 'Boubou Homme', 'price': 28000, 'shop': 'Mode Abidjan', 'emoji': '👘', 'cat': 'Mode'},
    {'name': 'Huile de Karité', 'price': 4500, 'shop': 'Nature CI', 'emoji': '🫙', 'cat': 'Beauté'},
  ];

  List<Map<String, dynamic>> get _filteredResults {
    if (_query.isEmpty) return [];
    return _mockResults.where((p) =>
      p['name'].toString().toLowerCase().contains(_query.toLowerCase()) ||
      p['cat'].toString().toLowerCase().contains(_query.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _query = query;
      _isSearching = query.isNotEmpty;
    });
  }

  void _selectSearch(String term) {
    _searchCtrl.text = term;
    _onSearch(term);
    if (!_recentSearches.contains(term)) {
      setState(() => _recentSearches.insert(0, term));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Bouton retour
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
              const SizedBox(width: 12),
              // Barre de recherche
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    focusNode: _focusNode,
                    onChanged: _onSearch,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _selectSearch,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un produit...',
                      hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textLight, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchCtrl.clear();
                                _onSearch('');
                              },
                              child: const Icon(Icons.close_rounded,
                                  color: AppColors.textLight, size: 18),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: false,
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
          // Filtres catégories
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = AppConstants.categories[i];
                final active = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active ? AppColors.primary : AppColors.divider),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: _query.isEmpty ? _buildEmptyState() : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tendances
          const Text('🔥 Tendances',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trending.map((t) => GestureDetector(
              onTap: () => _selectSearch(t.replaceAll(RegExp(r'[^\w\s]'), '').trim()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text(t,
                    style: const TextStyle(fontSize: 13, color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 28),

          // Recherches récentes
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🕐 Récents',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                TextButton(
                  onPressed: () => setState(() => _recentSearches.clear()),
                  child: const Text('Effacer', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...(_recentSearches.take(5).map((search) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.history_rounded, size: 18, color: AppColors.textSecondary),
              ),
              title: Text(search,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
              trailing: const Icon(Icons.north_west_rounded, size: 16,
                  color: AppColors.textLight),
              onTap: () => _selectSearch(search),
            ))),
          ],
        ],
      ),
    );
  }

  Widget _buildResults() {
    final results = _filteredResults;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('Aucun résultat pour "$_query"',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Essayez avec d\'autres mots-clés',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text('${results.length} résultat${results.length > 1 ? 's' : ''}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final p = results[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.05),
                          blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Image produit
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(p['emoji'], style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'],
                                style: const TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: 14, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(p['shop'],
                                style: const TextStyle(fontSize: 12,
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(p['cat'],
                                      style: const TextStyle(fontSize: 10,
                                          color: AppColors.secondary, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${(p['price'] as int).toStringAsFixed(0)} F',
                              style: const TextStyle(fontWeight: FontWeight.w800,
                                  fontSize: 15, color: AppColors.primary)),
                          const SizedBox(height: 6),
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
