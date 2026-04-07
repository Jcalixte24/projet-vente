import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../config/constants.dart';
import '../models/models.dart';
import '../services/api_services.dart';
import '../../shared/widgets/app_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final notifs = await NotificationService.getNotifications();
    if (mounted) setState(() { _notifications = notifs; _isLoading = false; });
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> _markAllRead() async {
    await NotificationService.markAllRead();
    final notifs = await NotificationService.getNotifications();
    if (mounted) setState(() => _notifications = notifs);
  }

  Future<void> _markRead(String id) async {
    await NotificationService.markRead(id);
    final notifs = await NotificationService.getNotifications();
    if (mounted) setState(() => _notifications = notifs);
  }

  void _delete(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6200EE))),
      );
    }
    final recent = _notifications.where((n) =>
        n.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 1)))).toList();
    final older = _notifications.where((n) =>
        n.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 1)))).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$_unreadCount',
                    style: const TextStyle(color: Colors.white, fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Tout lire', style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmpty()
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (recent.isNotEmpty) ...[
                  _SectionLabel(label: "Aujourd'hui"),
                  ...recent.map((n) => _NotifTile(
                    notif: n,
                    onTap: () {
                      _markRead(n.id);
                      if (n.orderId != null) {
                        Navigator.pushNamed(context, AppRoutes.orderTracking);
                      }
                    },
                    onDismiss: () => _delete(n.id),
                  )),
                ],
                if (older.isNotEmpty) ...[
                  _SectionLabel(label: 'Plus tôt'),
                  ...older.map((n) => _NotifTile(
                    notif: n,
                    onTap: () {
                      _markRead(n.id);
                      if (n.orderId != null) {
                        Navigator.pushNamed(context, AppRoutes.orderTracking);
                      }
                    },
                    onDismiss: () => _delete(n.id),
                  )),
                ],
              ],
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text('Aucune notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Vous serez notifié de vos commandes ici',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
    child: Text(label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
            color: AppColors.textSecondary, letterSpacing: 0.5)),
  );
}

class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  const _NotifTile({required this.notif, required this.onTap, required this.onDismiss});

  Color get _typeColor {
    switch (notif.type) {
      case 'order': return AppColors.primary;
      case 'payment': return AppColors.secondary;
      case 'promo': return AppColors.accent;
      default: return AppColors.textSecondary;
    }
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(notif.createdAt);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inDays}j';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error.withOpacity(0.1),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notif.isRead ? AppColors.surface : _typeColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notif.isRead ? AppColors.divider : _typeColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône type
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: _typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    {'order': '📦', 'payment': '💳', 'promo': '🎁', 'system': '⭐'}[notif.type] ?? '🔔',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(notif.title,
                              style: TextStyle(
                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                                fontSize: 13, color: AppColors.textPrimary,
                              )),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: _typeColor, shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(notif.body,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary,
                            height: 1.4),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(_timeAgo,
                        style: const TextStyle(fontSize: 11, color: AppColors.textLight,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
