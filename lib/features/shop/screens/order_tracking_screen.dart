import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../models/models.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order? order;
  const OrderTrackingScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    // Commande passée en arguments ou démo
    final o = order ?? _demoOrder();
    final currentStep = o.status.step;

    final steps = [
      _TrackStep(
        status: OrderStatus.pending,
        icon: '✅',
        title: 'Commande confirmée',
        subtitle: 'Paiement reçu avec succès',
        time: o.statusHistory.isNotEmpty ? o.statusHistory[0].timestamp : null,
      ),
      _TrackStep(
        status: OrderStatus.preparing,
        icon: '📦',
        title: 'En préparation',
        subtitle: 'Le vendeur prépare votre colis',
        time: o.statusHistory.length > 1 ? o.statusHistory[1].timestamp : null,
      ),
      _TrackStep(
        status: OrderStatus.shipped,
        icon: '🚚',
        title: 'En transit',
        subtitle: 'Votre colis est en route',
        time: o.statusHistory.length > 2 ? o.statusHistory[2].timestamp : null,
      ),
      _TrackStep(
        status: OrderStatus.delivered,
        icon: '🏠',
        title: 'Livré',
        subtitle: 'Colis remis à l\'adresse indiquée',
        time: o.statusHistory.length > 3 ? o.statusHistory[3].timestamp : null,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(o.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
            tooltip: 'Partager le suivi',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte statut principal
            _StatusBanner(order: o),
            const SizedBox(height: 20),

            // Tracker visuel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.07),
                      blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Suivi de livraison',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 20),
                  ...List.generate(steps.length, (i) {
                    final step = steps[i];
                    final isDone = currentStep > i;
                    final isActive = currentStep == i;
                    final isLast = i == steps.length - 1;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colonne gauche : cercle + ligne
                        Column(
                          children: [
                            _StepCircle(isDone: isDone, isActive: isActive, icon: step.icon),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 48,
                                color: isDone
                                    ? AppColors.secondary
                                    : AppColors.divider,
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        // Contenu
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDone || isActive
                                        ? AppColors.textPrimary
                                        : AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  step.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDone || isActive
                                        ? AppColors.textSecondary
                                        : AppColors.textLight,
                                  ),
                                ),
                                if (step.time != null && (isDone || isActive)) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDateTime(step.time!),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Détails livraison
            _InfoCard(
              title: '📍 Détails de livraison',
              children: [
                _InfoRow('Zone', o.deliveryZone),
                _InfoRow('Adresse', o.deliveryAddress),
                if (o.estimatedDelivery != null)
                  _InfoRow('Livraison estimée', _formatDate(o.estimatedDelivery!)),
              ],
            ),
            const SizedBox(height: 16),

            // Paiement
            _InfoCard(
              title: '💳 Paiement',
              children: [
                _InfoRow('Méthode', o.paymentMethod),
                if (o.paymentPhone != null) _InfoRow('Numéro', o.paymentPhone!),
                if (o.transactionId != null) _InfoRow('Transaction', o.transactionId!),
                _InfoRow('Total payé', '${o.total.toStringAsFixed(0)} F CFA'),
              ],
            ),
            const SizedBox(height: 16),

            // Articles
            _InfoCard(
              title: '🛍 Articles (${o.items.length})',
              children: o.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(item.productImage, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('Qté: ${item.quantity}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text('${(item.price * item.quantity).toStringAsFixed(0)} F',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // Bouton contacter vendeur
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: const Text('Contacter le vendeur'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin',
        'juil', 'août', 'sep', 'oct', 'nov', 'déc'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} à $h:$m';
  }

  String _formatDate(DateTime dt) {
    final months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin',
        'juil', 'août', 'sep', 'oct', 'nov', 'déc'];
    return '${dt.day} ${months[dt.month - 1]}. ${dt.year}';
  }

  static Order _demoOrder() {
    final now = DateTime.now();
    return Order(
      id: 'CMD-2025-0038',
      userId: 'u1',
      items: [
        const OrderItem(productId: 'p1', productName: 'Caftan Brodé',
            productImage: '👗', price: 35000, quantity: 1),
        const OrderItem(productId: 'p2', productName: 'Tissu Wax',
            productImage: '🧵', price: 8500, quantity: 2),
      ],
      status: OrderStatus.shipped,
      subtotal: 52000,
      deliveryFee: 3500,
      total: 55500,
      deliveryZone: 'Yamoussoukro',
      deliveryAddress: 'Quartier Millionnaire, près de la Fondation',
      paymentMethod: 'Wave',
      paymentPhone: '+225 01 55 66 77 88',
      transactionId: 'WV-2025-DEF456',
      createdAt: now.subtract(const Duration(days: 2)),
      estimatedDelivery: now.add(const Duration(days: 1)),
      statusHistory: [
        OrderStatusUpdate(status: OrderStatus.pending,
            timestamp: now.subtract(const Duration(days: 2))),
        OrderStatusUpdate(status: OrderStatus.preparing,
            timestamp: now.subtract(const Duration(days: 1, hours: 12))),
        OrderStatusUpdate(status: OrderStatus.shipped,
            timestamp: now.subtract(const Duration(hours: 10))),
      ],
    );
  }
}

// ── Widgets internes ────────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final Order order;
  const _StatusBanner({required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = {
      OrderStatus.pending: [const Color(0xFFFFF8E1), AppColors.statusPending],
      OrderStatus.preparing: [const Color(0xFFE3F2FD), AppColors.statusPreparing],
      OrderStatus.shipped: [const Color(0xFFEDE7F6), AppColors.statusShipping],
      OrderStatus.delivered: [const Color(0xFFE8F5E9), AppColors.statusDelivered],
      OrderStatus.cancelled: [const Color(0xFFFFEBEE), AppColors.statusCancelled],
    };
    final bg = colors[order.status]![0];
    final color = colors[order.status]![1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Center(
              child: Text(
                { OrderStatus.pending: '⏳', OrderStatus.preparing: '📦',
                  OrderStatus.shipped: '🚚', OrderStatus.delivered: '✅',
                  OrderStatus.cancelled: '❌' }[order.status]!,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.status.label,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color)),
                const SizedBox(height: 2),
                if (order.estimatedDelivery != null &&
                    order.status != OrderStatus.delivered &&
                    order.status != OrderStatus.cancelled)
                  Text(
                    'Livraison estimée le ${_fmt(order.estimatedDelivery!)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    final months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin',
        'juil', 'août', 'sep', 'oct', 'nov', 'déc'];
    return '${dt.day} ${months[dt.month - 1]}.';
  }
}

class _StepCircle extends StatelessWidget {
  final bool isDone, isActive;
  final String icon;
  const _StepCircle({required this.isDone, required this.isActive, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.secondary
            : isActive
                ? AppColors.primary
                : AppColors.divider,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
            : Text(icon, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.05),
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class _TrackStep {
  final OrderStatus status;
  final String icon, title, subtitle;
  final DateTime? time;
  const _TrackStep({required this.status, required this.icon,
      required this.title, required this.subtitle, this.time});
}
