import 'dart:async';
import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../config/constants.dart';
import '../models/models.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String orderId;
  final String paymentMethod;
  final double amount;
  final String? paymentPhone;

  const PaymentConfirmationScreen({
    super.key,
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    this.paymentPhone,
  });

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with TickerProviderStateMixin {
  // États : 'waiting', 'success', 'failed'
  String _paymentStatus = 'waiting';
  int _countdown = 120; // 2 minutes pour confirmer
  Timer? _timer;
  Timer? _pollTimer;
  late AnimationController _pulseCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCountdown();
    _simulatePaymentCheck(); // Simuler la vérification paiement
  }

  void _setupAnimations() {
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut),
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _onTimeout();
      }
    });
  }

  void _simulatePaymentCheck() {
    // En production : appeler PaymentService.checkPaymentStatus() toutes les 5s
    _pollTimer = Timer(const Duration(seconds: 8), () {
      _onPaymentSuccess();
    });
  }

  void _onPaymentSuccess() {
    _timer?.cancel();
    _pulseCtrl.stop();
    setState(() => _paymentStatus = 'success');
    _successCtrl.forward();
  }

  void _onTimeout() {
    _timer?.cancel();
    _pollTimer?.cancel();
    setState(() => _paymentStatus = 'failed');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pollTimer?.cancel();
    _pulseCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _paymentStatus != 'waiting',
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _paymentStatus == 'waiting'
                ? _buildWaiting()
                : _paymentStatus == 'success'
                    ? _buildSuccess()
                    : _buildFailed(),
          ),
        ),
      ),
    );
  }

  // ── En attente ──────────────────────────────────────────────────────────────
  Widget _buildWaiting() {
    final method = AppConstants.paymentMethods
        .firstWhere((m) => m['id'] == widget.paymentMethod, orElse: () => {'label': widget.paymentMethod, 'color': 0xFF6C3FC5});
    final color = Color(method['color'] as int);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animation pulsation
        ScaleTransition(
          scale: _pulseAnim,
          child: Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 88, height: 88,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(_paymentIcon(widget.paymentMethod),
                      style: const TextStyle(fontSize: 40)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 36),

        Text('Confirmation en attente',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Text(
                '📱 Vérifiez votre téléphone',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                widget.paymentPhone != null
                    ? 'Une demande de paiement a été envoyée au\n${widget.paymentPhone}'
                    : 'Confirmez le paiement sur votre application ${method['label']}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Montant
        Text('Montant à payer',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 4),
        Text('${widget.amount.toStringAsFixed(0)} F CFA',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Commande ${widget.orderId}',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 28),

        // Compte à rebours
        Text(
          '⏱ Expiration dans $_countdownFormatted',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: _countdown < 30 ? AppColors.error : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _countdown / 120,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(
                _countdown < 30 ? AppColors.error : AppColors.primary),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 32),

        OutlinedButton(
          onPressed: () {
            _timer?.cancel();
            _pollTimer?.cancel();
            setState(() => _paymentStatus = 'failed');
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            side: const BorderSide(color: AppColors.error),
            foregroundColor: AppColors.error,
          ),
          child: const Text('Annuler le paiement'),
        ),
      ],
    );
  }

  // ── Succès ──────────────────────────────────────────────────────────────────
  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _successScale,
          child: Container(
            width: 120, height: 120,
            decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
            child: const Center(
              child: Icon(Icons.check_rounded, color: Colors.white, size: 60),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Paiement réussi ! 🎉',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Text(
          'Votre commande ${widget.orderId} a été confirmée.\nVous allez recevoir un SMS de confirmation.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 28),

        // Récap paiement
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _SuccessRow('Commande', widget.orderId),
              _SuccessRow('Montant', '${widget.amount.toStringAsFixed(0)} F CFA'),
              _SuccessRow('Méthode', _methodLabel(widget.paymentMethod)),
              if (widget.paymentPhone != null) _SuccessRow('Numéro', widget.paymentPhone!),
            ],
          ),
        ),
        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.orderTracking, (r) => r.isFirst,
            );
          },
          icon: const Icon(Icons.location_on_outlined, size: 18),
          label: const Text('Suivre ma commande'),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              minimumSize: const Size(double.infinity, 52)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (r) => false),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          child: const Text('Retour à l\'accueil'),
        ),
      ],
    );
  }

  // ── Échec ───────────────────────────────────────────────────────────────────
  Widget _buildFailed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Container(
              width: 88, height: 88,
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 48),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Paiement non reçu',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        const Text(
          'Le délai de confirmation est expiré ou le paiement a été annulé. Vous pouvez réessayer.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () {
            setState(() {
              _paymentStatus = 'waiting';
              _countdown = 120;
            });
            _setupAnimations();
            _startCountdown();
            _simulatePaymentCheck();
          },
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          child: const Text('Réessayer'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.checkout, (r) => false),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          child: const Text('Changer de moyen de paiement'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (r) => false),
          child: const Text('Annuler et retourner à l\'accueil',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  String get _countdownFormatted {
    final m = (_countdown ~/ 60).toString().padLeft(2, '0');
    final s = (_countdown % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _paymentIcon(String method) {
    return {'orange': '🟠', 'mtn': '🟡', 'wave': '🔵', 'moov': '🟢', 'carte': '💳'}[method] ?? '💳';
  }

  String _methodLabel(String method) {
    return {'orange': 'Orange Money', 'mtn': 'MTN MoMo', 'wave': 'Wave',
        'moov': 'Moov Money', 'carte': 'Carte Bancaire'}[method] ?? method;
  }
}

class _SuccessRow extends StatelessWidget {
  final String label, value;
  const _SuccessRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    ),
  );
}
