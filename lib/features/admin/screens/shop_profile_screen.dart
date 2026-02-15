import '../../shop/screens/shop_list_screen.dart';
import '../../auth/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class ShopProfileScreen extends StatelessWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
            Center(
                child: Column(
                    children: [
                         Stack(
                             alignment: Alignment.bottomRight,
                             children: [
                                 Container(
                                     width: 100,
                                     height: 100,
                                     decoration: const BoxDecoration(
                                          color: Color(0xFF1E463F), // Dark green branding
                                          shape: BoxShape.circle,
                                     ),
                                     child: const Center(
                                         child: Icon(Icons.store, color: Colors.white, size: 40,),
                                     ),
                                 ),
                                 Container(
                                     padding: const EdgeInsets.all(6),
                                     decoration: const BoxDecoration(
                                          color: Color(0xFF007AFF),
                                          shape: BoxShape.circle
                                     ),
                                     child: const Icon(Icons.camera_alt, color: Colors.white, size: 16,),
                                 )
                             ],
                         ),
                         const SizedBox(height: 16),
                         const Text("BobSport", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                         const SizedBox(height: 8),
                         const Text(
                             "Spécialiste de la mode streetwear et\nsneakers authentiques à Abidjan.",
                             textAlign: TextAlign.center,
                             style: TextStyle(color: Colors.grey),
                         )
                    ],
                ),
            ),
            const SizedBox(height: 24),
            Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    _buildStatCard("VENTES TOTALES", "1.250.000", "FCFA"),
                    _buildStatCard("NOTE CLIENTS", "4.8", "★ (124)"),
                ],
            ),
             const SizedBox(height: 24),

            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: (){}, 
                    icon: const Icon(Icons.visibility_outlined, size: 18), 
                    label: const Text("Voir ma boutique en ligne"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE3F2FD),
                        foregroundColor: const Color(0xFF007AFF),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(Icons.contact_mail_outlined, "Informations de contact"),
            const SizedBox(height: 12),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("TÉLÉPHONE", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("+225 07 01 02 03 04", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                         Text("WHATSAPP BUSINESS", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                 Text("05 88 99 00 11", style: TextStyle(fontSize: 16)),
                                 Icon(Icons.chat_bubble_outline, color: Colors.green)
                             ],
                        )
                    ],
                ),
            ),

            const SizedBox(height: 24),
             _buildSectionHeader(Icons.access_time, "Horaires d'ouverture"),
             const SizedBox(height: 12),
             Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                    children: [
                        _buildTimeRow("Lundi - Vendredi", "09:00", "19:00"),
                        const SizedBox(height: 12),
                        Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                const Text("Samedi - Dimanche"),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                                    child: const Text("Fermé", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                                ),
                                const Icon(Icons.edit, size: 16, color: Colors.blue)
                            ],
                        )
                    ],
                ),
             ),

             const SizedBox(height: 24),
             _buildSectionHeader(Icons.local_shipping_outlined, "Zones de livraison"),
             const SizedBox(height: 12),
             Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                          image: NetworkImage("https://www.google.com/maps/d/thumbnail?mid=1QJ7s6Yf1Z2Z2u6X9X9X9X9X9X9&hl=en"),
                           fit: BoxFit.cover
                      )
                  ),
                  child: Center(
                      child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                           child: const Text("Modifier la zone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                  ),
             ),


             const SizedBox(height: 40),
             
             SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                     // TODO: Implement actual logout logic (clear tokens, etc.)
                     Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                          (route) => false,
                     );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Se déconnecter"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
             ),

             const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit) {
      return Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                      children: [
                          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Text(unit, style: TextStyle(fontSize: 12, color: title.contains("NOTE") ? Colors.orange : Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                  )
              ],
          ),
      );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
      return Row(
          children: [
              Icon(icon, size: 20, color: const Color(0xFF007AFF)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
          ],
      );
  }

  Widget _buildTimeRow(String day, String start, String end) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Text(day),
              Row(
                  children: [
                      _buildTimeChip(start),
                      const SizedBox(width: 8),
                      const Text("-", style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      _buildTimeChip(end),
                  ],
              )
          ],
      );
  }

  Widget _buildTimeChip(String time) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
          child: Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      );
  }
}
