import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../config/constants.dart';
import '../models/models.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données simulées
  final List<Order> _orders = _mockOrders();

  static List<Order> _mockOrders() {
    final now = DateTime.now();
    return [
      Order(
        id: 'CMD-2025-0042',
        userId: 'u1',
        items: [
          const OrderItem(productId: 'p1', productName: 'Tissu Wax Premium',
              productImage: '🧵', price: 8500, quantity: 2),
          const OrderItem(productId: 'p2', productName: 'Huile de Karité',
              productImage: '🫙', price: 4500, quantity: 1),
        ],
        status: OrderStatus.delivered,
        subtotal: 21500,
        deliveryFee: 1500,
        total: 23000,
        deliveryZone: 'Abidjan Centre',
        deliveryAddress: 'Cocody, Riviera 3, Rue des Jardins',
        paymentMethod: 'Orange Money',
        paymentPhone: '+225 07 11 22 33 44',
        transactionId: 'OM-2025-ABC123',
        createdAt: now.subtract(const Duration(days: 5)),
        estimatedDelivery: now.subtract(const Duration(days: 3)),
        statusHistory: [
          OrderStatusUpdate(status: OrderStatus.pending, timestamp: now.subtract(const Duration(days: 5))),
          OrderStatusUpdate(status: OrderStatus.preparing, timestamp: now.subtract(const Duration(days: 4, hours: 20))),
          OrderStatusUpdate(status: OrderStatus.shipped, timestamp: now.subtract(const Duration(days: 4))),
          OrderStatusUpdate(status: OrderStatus.delivered, timestamp: now.subtract(const Duration(days: 3))),
        ],
      ),
      Order(
        id: 'CMD-2025-0038',
        userId: 'u1',
        items: [
          const OrderItem(productId: 'p3', productName: 'Caftan Brodé',
              productImage: '👗', price: 35000, quantity: 1),
        ],
        status: OrderStatus.shipped,
        subtotal: 35000,
        deliveryFee: 3500,
        total: 38500,
        deliveryZone: 'Yamoussoukro',
        deliveryAddress: 'Quartier Millionnaire',
        paymentMethod: 'Wave',
        paymentPhone: '+225 01 55 66 77 88',
        transactionId: 'WV-2025-DEF456',
        createdAt: now.subtract(const Duration(days: 2)),
        estimatedDelivery: now.add(const Duration(days: 1)),
        statusHistory: [
          OrderStatusUpdate(status: OrderStatus.pending, timestamp: now.subtract(const Duration(days: 2))),
          OrderStatusUpdate(status: OrderStatus.preparing, timestamp: now.subtract(const Duration(days: 1, hours: 12))),
          OrderStatusUpdate(status: OrderStatus.shipped, timestamp: now.subtract(const Duration(hours: 10))),
        ],
      ),
      Order(
        id: 'CMD-2025-0031',
        userId: 'u1',
        items: [
          const OrderItem(productId: 'p4', productName: 'Bijoux Perles',
              productImage: '📿', price: 9800, quantity: 1),
          const OrderItem(productId: 'p5', productName: 'Sac Raphia',
              productImage: '👜', price: 15000, quantity: 1),
        ],
        status: OrderStatus.preparing,
        subtotal: 24800,
        deliveryFee: 2000,
        total: 26800,
        deliveryZone: 'Abidjan Nord',
        deliveryAddress: 'Abobo, Derrière Rails',
        paymentMethod: 'MTN MoMo',
        paymentPhone: '+225 05 99 88 77 66',
        transactionId: 'MTN-2025-GHI789',
        createdAt: now.subtract(const Duration(hours: 5)),
        estimatedDelivery: now.add(const Duration(days: 2)),
        statusHistory: [
          OrderStatusUpdate(status: OrderStatus.pending, timestamp: now.subtract(const Duration(hours: 5))),
          OrderStatusUpdate(status: OrderStatus.preparing, timestamp: now.subtract(const Duration(hours: 3))),
        ],
      ),
    ];
  }

  List<Order> _getByStatus(String filter) {
    if (filter == 'Tous') return _orders;
    if (filter == 'En cours') {
      return _orders.where((o) =>
          o.status == OrderStatus.pending ||
          o.status == OrderStatus.preparing ||
          o.status == OrderStatus.shipped).toList();
    }
    if (filter == 'Livrés') return _orders.where((o) => o.status == OrderStatus.delivered).toList();
    if (filter == 'Annulés') return _orders.where((o) => o.status == OrderStatus.cancelled).toList();
    return _orders;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Commandes'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'Tous'),
            Tab(text: 'En cours'),
            Tab(text: 'Livrés'),
            Tab(text: 'Annulés'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: ['Tous', 'En cours', 'Livrés', 'Annulés'].map((filter) {
          final orders = _getByStatus(filter);
          if (orders.isEmpty) return _buildEmpty(filter);
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _OrderCard(
              order: orders[i],
              onTrack: () => Navigator.pushNamed(context, AppRoutes.orderTracking,
                  arguments: orders[i]),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📦', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('Aucune commande $filter'.toLowerCase(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Vos commandes apparaîtront ici',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 46)),
            child: const Text('Découvrir la boutique'),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTrack;

  const _OrderCard({required this.order, required this.onTrack});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.pending: return AppColors.statusPending;
      case OrderStatus.preparing: return AppColors.statusPreparing;
      case OrderStatus.shipped: return AppColors.statusShipping;
      case OrderStatus.delivered: return AppColors.statusDelivered;
      case OrderStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.06),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.id,
                          style: const TextStyle(fontWeight: FontWeight.w800,
                              fontSize: 14, color: AppColors.primary)),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(order.createdAt),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: _statusColor),
                  ),
                ),
              ],
            ),
          ),

          // Produits
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: order.items.take(2).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                      child: Text(item.productName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Text('×${item.quantity}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              )).toList(),
            ),
          ),

          if (order.items.length > 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('+${order.items.length - 2} autre(s) article(s)',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ),

          const Divider(height: 20, color: AppColors.divider),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total payé',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(
                      '${order.total.toStringAsFixed(0)} F CFA',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const Spacer(),
                if (isActive)
                  ElevatedButton.icon(
                    onPressed: onTrack,
                    icon: const Icon(Icons.location_on_outlined, size: 16),
                    label: const Text('Suivre'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(110, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  )
                else if (order.status == OrderStatus.delivered)
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(minimumSize: const Size(120, 38)),
                    child: const Text('⭐ Évaluer'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin',
        'juil', 'août', 'sep', 'oct', 'nov', 'déc'];
    return '${date.day} ${months[date.month - 1]}. ${date.year}';
  }
}
