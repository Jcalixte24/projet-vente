import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = "Ce mois";
  final List<String> _periods = ["Aujourd'hui", "Cette semaine", "Ce mois", "Cette année"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Added "Livré" -> 4 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filtrer par période:",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                  isDense: true,
                  items: _periods.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPeriod = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF6200EE),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF6200EE),
            isScrollable: true,
             tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: "Toutes"),
              Tab(text: "En attente"),
              Tab(text: "En préparation"),
              Tab(text: "Livrées"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(),
              _buildOrderList(filter: "En attente"),
              _buildOrderList(filter: "En préparation"),
              _buildOrderList(filter: "Livré"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList({String? filter}) {
    // Mock data
    final orders = [
      {
        "id": "8842",
        "time": "14:20",
        "customer": "Jean Koffi",
        "items": "Chemise Slim Fit + 2 articles",
        "details": "Taille: L, Couleur: Blanc",
        "price": "45.500 FCFA",
        "status": "En attente",
        "image": "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&q=80&w=300"
      },
      {
        "id": "8840",
        "time": "12:45",
        "customer": "Marie Kouassi",
        "items": "Baskets BobSport Air",
        "details": "Taille: 42, Couleur: Rouge",
        "price": "62.000 FCFA",
        "status": "En préparation",
        "image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=300"
      },
       {
        "id": "8835",
        "time": "HIER",
        "customer": "Ibrahim Touré",
        "items": "Ensemble jogging Luxe",
        "details": "1 article • Paiement reçu",
        "price": "35.000 FCFA",
        "status": "Livré",
        "image": "https://images.unsplash.com/photo-1515347619252-60a6bf4fffce?auto=format&fit=crop&q=80&w=300"
      },
    ];

    final filteredOrders = filter == null 
        ? orders 
        : orders.where((o) => o['status'] == filter || (filter == "Toutes")).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "CMD #${order['id']} - ${order['time']}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(order['status']!),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      order['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          order['customer']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order['items']!,
                          style: const TextStyle(fontSize: 14),
                           overflow: TextOverflow.ellipsis,
                        ),
                         Text(
                          order['details']!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                   const SizedBox(width: 8),
                   Text(
                    order['price']!,
                    style: const TextStyle(
                      color: Color(0xFF007AFF), 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (order['status'] == "En attente")
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Confirmer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                            onPressed: (){}, 
                            icon: const Icon(Icons.more_horiz)
                        )
                    )
                  ],
                )
             else if (order['status'] == "En préparation")
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: const Text("Prêt pour expédition"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    )
             else 
                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text("Détails de la livraison"),
                      ),
                  )
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    
    switch (status) {
      case "En attente":
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFFFA000);
        break;
      case "En préparation":
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case "Livré":
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF388E3C);
        break;
      default:
        bgColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
