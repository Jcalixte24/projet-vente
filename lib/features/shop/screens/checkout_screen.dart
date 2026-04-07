import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_services.dart';
import '../../shared/widgets/app_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  String _selectedPaymentMethod = 'Wave';
  String? _selectedCommune;
  bool _isSubmitting = false;

  // Mapping commune → zone ID
  static const Map<String, String> _communeToZone = {
    'Cocody': 'abj-centre', 'Plateau': 'abj-centre',
    'Yopougon': 'abj-ouest', 'Abobo': 'abj-nord', 'Anyama': 'abj-nord',
    'Marcory': 'abj-sud', 'Koumassi': 'abj-sud', 'Treichville': 'abj-sud',
    'Adjamé': 'abj-centre', 'Port-Bouët': 'abj-sud',
    'Songon': 'abj-ouest', 'Bingerville': 'abj-centre',
  };

  static const Map<String, int> _communeFees = {
    'Cocody': 1500, 'Plateau': 1500, 'Adjamé': 1500, 'Bingerville': 1500,
    'Marcory': 2000, 'Koumassi': 2000, 'Treichville': 2000, 'Port-Bouët': 2000,
    'Abobo': 2000, 'Anyama': 2000,
    'Yopougon': 2500, 'Songon': 2500,
  };

  // Form controllers
  final _phoneController = TextEditingController(text: "+225 ");
  final _precisionController = TextEditingController();

  final List<String> _communes = [
    "Cocody", "Marcory", "Yopougon", "Abobo", "Koumassi", "Treichville", "Adjamé", "Port-Bouët", "Songon", "Bingerville"
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _precisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          _currentStep == 0 ? "Validation" : "Paiement Sécurisé",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (_currentStep == 1)
             const Padding(
               padding: EdgeInsets.only(right: 16),
               child: Icon(Icons.verified_user, color: Colors.green),
             )
        ],
      ),
      body: Column(
        children: [
          // Custom Progress Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Container(height: 4, color: const Color(0xFF6200EE))),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 4, color: _currentStep == 1 ? const Color(0xFF6200EE) : Colors.grey[200])),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _currentStep == 0 ? _buildDeliveryStep() : _buildPaymentStep(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
          ]
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentStep == 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total à payer", style: TextStyle(fontSize: 16)),
                        Text(
                        '${Provider.of<CartProvider>(context).totalWithDelivery((_communeFees[_selectedCommune] ?? 2000).toDouble()).toStringAsFixed(0)} FCFA',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6200EE)),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentStep == 0 ? _goToPayment : _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0
                  ),
                  child: Text(
                    _currentStep == 0 ? "Passer au paiement" : "Confirmer et Payer",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.local_shipping_outlined, "Livraison"),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("COMMUNE", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCommune,
                  decoration: _inputDecoration("Sélectionnez votre commune"),
                  items: _communes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedCommune = v),
                  validator: (v) => v == null ? "Veuillez sélectionner une commune" : null,
                ),
                const SizedBox(height: 20),
                const Text("CONTACT", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration("Numéro de téléphone"),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.length < 10 ? "Numéro invalide" : null,
                ),
                const SizedBox(height: 20),
                const Text("PRÉCISIONS (LIEU-DIT)", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _precisionController,
                  decoration: _inputDecoration("Ex: Derrière la pharmacie..."),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    final cart = Provider.of<CartProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recap
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("RÉCAPITULATIF DE LA COMMANDE", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
               ...cart.items.values.map((item) => Padding(
                 padding: const EdgeInsets.only(bottom: 12),
                 child: Row(
                   children: [
                     ClipRRect(
                       borderRadius: BorderRadius.circular(8),
                       child: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color:Colors.grey[200], width:50, height:50)),
                     ),
                     const SizedBox(width: 12),
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                           Text("${item.brand} • Taille: M", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                         ],
                       ),
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Text("${item.price.toStringAsFixed(0)} FCFA", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6200EE))),
                         Text("x${item.quantity}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                       ],
                     ),
                   ],
                 ),
               )).toList(),
               const Divider(height: 24),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const Text("Sous-total", style: TextStyle(color: Colors.grey)),
                   Text("${cart.subtotal.toStringAsFixed(0)} FCFA", style: const TextStyle(fontWeight: FontWeight.bold)),
                 ],
               ),
               const SizedBox(height: 8),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Livraison ($_selectedCommune)", style: const TextStyle(color: Colors.grey)),
                   const Text("1 500 FCFA", style: TextStyle(fontWeight: FontWeight.bold)),
                 ],
               ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text("CODE PROMO", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: const TextField(
                  decoration: InputDecoration(hintText: "Entrez votre code", border: InputBorder.none)
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0F2F1),
                foregroundColor: Colors.teal,
                elevation: 0
              ),
              child: const Text("Valider"),
            )
          ],
        ),

        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text("MOYENS DE PAIEMENT", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
             Text("SÉCURISÉ SSL", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        _buildPaymentOption("Wave", Icons.waves, Colors.blue), // Using icon instead of asset for ease
        const SizedBox(height: 8),
        _buildPaymentOption("Orange Money", Icons.monetization_on, Colors.orange),
        const SizedBox(height: 8),
        _buildPaymentOption("MTN MoMo", Icons.currency_exchange, Colors.yellow[700]!),
        const SizedBox(height: 8),
        _buildPaymentOption("Paiement à la livraison", Icons.local_shipping, Colors.grey),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              const Icon(Icons.shield, color: Colors.green, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text("Vos données sont cryptées de bout en bout. Nous ne stockons aucune information bancaire.", style: TextStyle(color: Colors.green[800], fontSize: 12))),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPaymentOption(String name, IconData icon, Color color) {
    bool isSelected = _selectedPaymentMethod == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = name),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF00C853) : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (isSelected)
                  const Text("Paiement sécurisé", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? const Color(0xFF00C853) : Colors.grey[300]!, width: isSelected ? 6 : 2),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF6200EE), size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF6200EE))),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _goToPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() => _currentStep = 1);
    }
  }

  Future<void> _confirmOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    setState(() => _isSubmitting = true);

    try {
      final order = await OrderService.createOrder(
        items: cart.toOrderItems(),
        deliveryZone: _communeToZone[_selectedCommune] ?? 'abj-centre',
        deliveryAddress:
            '$_selectedCommune • ${_precisionController.text.trim()}',
        paymentMethod: _selectedPaymentMethod.toLowerCase(),
        paymentPhone: _phoneController.text.trim(),
        promoCode: cart.appliedPromoCode,
      );

      if (!mounted) return;
      cart.clear();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.green[50], shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.green, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('Commande Confirmée !',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('N° ${order.id}',
                  style: const TextStyle(
                      color: Color(0xFF6200EE), fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                'Votre commande de ${order.total.toStringAsFixed(0)} FCFA a été enregistrée.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Retourner à l'accueil"),
                ),
              ),
            ],
          ),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) AppSnackBar.showError(context, e.message);
    } catch (_) {
      if (mounted) {
        AppSnackBar.showError(
            context, 'Erreur réseau. Vérifiez votre connexion et réessayez.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
