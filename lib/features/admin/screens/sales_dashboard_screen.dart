import 'package:flutter/material.dart';

class SalesDashboardScreen extends StatelessWidget {
  const SalesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Header Stats for Sales will go here
             Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF69F0AE)], // Green for verified revenue
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00C853).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.insights,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "+12%",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Revenu Total",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "2.450.000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          "FCFA",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 8),
                   const Text(
                    "Mise à jour il y a 5 min",
                    style: TextStyle(color: Colors.white60, fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Sales Chart Placeholder
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                const Text("Tendance des Ventes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                        children: [
                                            Text("7 jours", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                        ],
                                    ),
                                )
                            ],
                        ),
                        const SizedBox(height: 24),
                        // Simple Bar Chart Visualization using Containers
                        SizedBox(
                            height: 150,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    _buildChartBar("LUN", 0.3),
                                    _buildChartBar("MAR", 0.5),
                                    _buildChartBar("MER", 0.8),
                                    _buildChartBar("JEU", 0.6),
                                    _buildChartBar("VEN", 1.0, isSelected: true),
                                    _buildChartBar("SAM", 0.9),
                                    _buildChartBar("DIM", 0.7),
                                ],
                            ),
                        )
                    ],
                ),
            ),

             const SizedBox(height: 24),

            // Top Products
             const Text(
              "Top Produits",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
             _buildTopProductItem("Bazin Riche Premium", "850k", "124 unités", Colors.blue),
             _buildTopProductItem("Chaussures Sport Pro", "420k", "89 unités", Colors.orange),
             _buildTopProductItem("Ensemble Sport Chic", "210k", "62 unités", Colors.purple),
             
             const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double heightPct, {bool isSelected = false}) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              Container(
                  width: 8,
                  height: 100 * heightPct,
                  decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00C853) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                  ),
              ),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFF00C853) : Colors.grey)),
          ],
      );
  }

  Widget _buildTopProductItem(String name, String revenue, String sales, Color color) {
      return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
              children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.shopping_bag_outlined, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("$sales vendues", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                      ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                           Text(revenue, style: const TextStyle(fontWeight: FontWeight.bold)),
                           const Text("FCFA", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                  )
              ],
          ),
      );
  }
}
