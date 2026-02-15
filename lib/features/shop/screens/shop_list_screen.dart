import 'package:flutter/material.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  String _selectedCategory = "Tous";
  final List<String> _categories = ["Tous", "Mode Homme", "Sport", "Luxe", "Chaussures"];

  final List<Map<String, dynamic>> _shops = [
    {
      "name": "Casa Bismark",
      "description": "Mode urbaine et chic...",
      "rating": "4.9",
      "location": "Cocody, Abidjan",
      "image": "https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=400",
      "logo": "https://ui-avatars.com/api/?name=Casa+Bismark&background=E0C09C&color=fff",
      "isFollowed": false,
      "color": 0xFF8D2CE2
    },
    {
      "name": "BobSport",
      "description": "Équipements et vêtements...",
      "rating": "4.7",
      "location": "Marcory, Abidjan",
      "image": "https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&q=80&w=400",
      "logo": "https://ui-avatars.com/api/?name=Bob+Sport&background=1E3C30&color=fff",
      "isFollowed": false,
      "tags": ["Sport", "Fitness"],
       "color": 0xFF6200EE
    },
    {
      "name": "Abidjan Couture",
      "description": "Tenues traditionnelles et...",
      "rating": "5.0",
      "location": "Plateau, Abidjan",
      "image": "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&q=80&w=400",
      "logo": "https://ui-avatars.com/api/?name=Abidjan+Couture&background=E0C09C&color=fff",
      "isFollowed": true,
      "tags": ["Traditionnel", "Sur mesure"],
       "color": 0xFFE0C09C
    },
    {
      "name": "Naya Shoes",
      "description": "Chaussures italiennes de lu...",
      "rating": "4.8",
      "location": "Riviera, Abidjan",
      "image": "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=400",
      "logo": "https://ui-avatars.com/api/?name=Naya+Shoes&background=FFCCBC&color=fff",
      "isFollowed": false,
      "tags": ["Femme", "Accessoires"],
       "color": 0xFF6200EE
    },
     {
      "name": "Urban Vibe",
      "description": "Streetwear local et importé.",
      "rating": "4.5",
      "location": "Yopougon, Abidjan",
      "image": "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&q=80&w=400",
      "logo": "https://ui-avatars.com/api/?name=Urban+Vibe&background=33691E&color=fff",
      "isFollowed": false,
      "tags": ["Streetwear"],
       "color": 0xFF6200EE
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Boutiques", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text("Découvrez nos partenaires", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Categories
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _selectedCategory = cat),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF6200EE),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                 // Featured Shop
                _buildFeaturedShop(),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tous les vendeurs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                     TextButton(onPressed: (){}, child: const Text("Voir tout"))
                  ],
                ),
                
                const SizedBox(height: 8),
                
                ..._shops.map((shop) => _buildShopCard(shop)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedShop() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)
          )
        ]
      ),
      child: Stack(
        children: [
           ClipRRect(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
               child: Image.network(
                   "https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=600",
                   height: 120,
                   width: double.infinity,
                   fit: BoxFit.cover,
                   errorBuilder: (_,__,___) => Container(color: Colors.grey[200]),
               ),
           ),
           Positioned(
               top: 12, left: 12,
               child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(color: const Color(0xFF8B2CF5), borderRadius: BorderRadius.circular(20)),
                   child: const Text("VEDETTE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
               ),
           ),
           Positioned(
             top: 90,
             left: 16,
             child: Container(
               width: 60, height: 60,
               decoration: BoxDecoration(
                 color: const Color(0xFFF3E5F5), // Beige/Pink
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.white, width: 2),
                 image: const DecorationImage(
                   image: NetworkImage("https://ui-avatars.com/api/?name=Casa+Bismark&background=E0C09C&color=fff"),
                 )
               ),
             ),
           ),
           Positioned(
             top: 130,
             right: 16,
             child: ElevatedButton(
               onPressed: (){},
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF8B2CF5),
                 foregroundColor: Colors.white,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 padding: const EdgeInsets.symmetric(horizontal: 24)
               ),
               child: const Text("Suivre"),
             ),
           ),
           Positioned(
             bottom: 16,
             left: 16,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text("Casa Bismark", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                 Text("Mode urbaine et chic...", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
               ],
             ),
           ),
           Positioned(
               bottom: 16,
               left: 150,
               child: Row(
                   children: [
                       const Icon(Icons.star, size: 14, color: Colors.amber),
                       const SizedBox(width: 4),
                       Text("4.9", style: TextStyle(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.bold)),
                       Text(" • Cocody, Abidjan", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                   ],
               ),
           )
        ],
      ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(shop['logo']),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[200],
            child: shop['logo'] == null ? const Icon(Icons.store) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                 Text(shop['description'], style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                 const SizedBox(height: 8),
                 if (shop['tags'] != null)
                 Row(
                   children: (shop['tags'] as List).map<Widget>((tag) => 
                     Container(
                       margin: const EdgeInsets.only(right: 8),
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                       child: Text(tag, style: TextStyle(fontSize: 10, color: Colors.grey[800])),
                     )
                   ).toList(),
                 )
              ],
            ),
          ),
          ElevatedButton(
               onPressed: (){},
               style: ElevatedButton.styleFrom(
                 backgroundColor: shop['isFollowed'] ? Colors.grey[200] : Colors.white,
                 foregroundColor: shop['isFollowed'] ? Colors.black : const Color(0xFF6200EE),
                 side: BorderSide(color: shop['isFollowed'] ? Colors.transparent : const Color(0xFF6200EE)),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 elevation: 0,
                 padding: const EdgeInsets.symmetric(horizontal: 16)
               ),
               child: Text(shop['isFollowed'] ? "Suivi" : "Suivre"),
             ),
        ],
      ),
    );
  }
}
