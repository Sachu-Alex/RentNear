import 'package:flutter/material.dart';
import '../services/order_tracking_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final _service = OrderTrackingService();
  bool _loading = false;

  Future<void> _run(Future<bool> Function() action) async {
    setState(() => _loading = true);
    final success = await action();
    setState(() => _loading = false);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Live Activities require iOS 16.1+ with Dynamic Island'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _service.currentStatus;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Live Order Tracking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dynamic Island preview card
            _DynamicIslandPreview(
              status: status,
              eta: _service.eta,
              orderId: OrderTrackingService.dummyOrderId,
              isActive: _service.isActive,
            ),
            const SizedBox(height: 28),

            // Order details card
            _OrderDetailsCard(
              orderId: OrderTrackingService.dummyOrderId,
              status: status,
              eta: _service.eta,
              isActive: _service.isActive,
            ),
            const SizedBox(height: 28),

            // Status progress
            if (_service.isActive) ...[
              _StatusProgress(current: status),
              const SizedBox(height: 28),
            ],

            // Simulation running indicator
            if (_service.isSimulating) ...[
              _SimulationBanner(),
              const SizedBox(height: 16),
            ],

            // Action buttons
            if (!_service.isActive)
              _ActionButton(
                label: 'Start Order Tracking',
                icon: Icons.play_circle_fill,
                color: const Color(0xFF00C896),
                loading: _loading,
                onPressed: () => _run(_service.startTracking),
              )
            else ...[
              _ActionButton(
                label: 'Update Order Status',
                icon: Icons.update,
                color: const Color(0xFF4A90D9),
                loading: _loading,
                enabled: _service.canAdvance && !_service.isSimulating,
                onPressed: () => _run(_service.advanceStatus),
              ),
              const SizedBox(height: 12),
              if (!_service.isSimulating)
                _ActionButton(
                  label: 'Simulate Background Updates',
                  icon: Icons.fast_forward,
                  color: const Color(0xFF9B59B6),
                  loading: _loading,
                  enabled: _service.canAdvance,
                  onPressed: () => _run(_service.startSimulation),
                )
              else
                _ActionButton(
                  label: 'Stop Simulation',
                  icon: Icons.stop,
                  color: const Color(0xFFE67E22),
                  loading: _loading,
                  onPressed: () => _run(_service.stopSimulation),
                ),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'End Order Tracking',
                icon: Icons.stop_circle,
                color: const Color(0xFFE05252),
                loading: _loading,
                onPressed: () => _run(_service.endTracking),
              ),
            ],

            const SizedBox(height: 28),
            _InfoBanner(),
          ],
        ),
      ),
    );
  }
}

// ─── Dynamic Island Preview ───────────────────────────────────────────────────

class _DynamicIslandPreview extends StatelessWidget {
  const _DynamicIslandPreview({
    required this.status,
    required this.eta,
    required this.orderId,
    required this.isActive,
  });

  final OrderStatus status;
  final int eta;
  final String orderId;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_iphone, color: Color(0xFF888888), size: 16),
              const SizedBox(width: 6),
              const Text(
                'Dynamic Island Preview',
                style: TextStyle(color: Color(0xFF888888), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Phone notch mockup
          Center(
            child: Container(
              width: 260,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF333333), width: 1.5),
              ),
              child: isActive
                  ? _ExpandedIslandContent(status: status, eta: eta)
                  : Center(
                      child: Container(
                        width: 100,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Expanded view mockup
          if (isActive) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        status.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              eta > 0 ? 'ETA: $eta minutes' : 'Delivered!',
                              style: const TextStyle(
                                color: Color(0xFF00C896),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#$orderId',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '↑ Expanded  •  Lock Screen view',
              style: TextStyle(color: Color(0xFF555555), fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpandedIslandContent extends StatelessWidget {
  const _ExpandedIslandContent({required this.status, required this.eta});
  final OrderStatus status;
  final int eta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Text(status.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              status.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            eta > 0 ? '${eta}m' : '✓',
            style: const TextStyle(
              color: Color(0xFF00C896),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order Details Card ───────────────────────────────────────────────────────

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard({
    required this.orderId,
    required this.status,
    required this.eta,
    required this.isActive,
  });

  final String orderId;
  final OrderStatus status;
  final int eta;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF00C896).withValues(alpha: 0.15)
                      : const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'LIVE' : 'INACTIVE',
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF00C896)
                        : const Color(0xFF666666),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Order ID', value: '#$orderId'),
          const SizedBox(height: 8),
          _DetailRow(label: 'Status', value: '${status.icon}  ${status.label}'),
          const SizedBox(height: 8),
          _DetailRow(
            label: 'ETA',
            value: eta > 0 ? '$eta minutes' : 'Delivered',
            valueColor:
                isActive ? const Color(0xFF00C896) : const Color(0xFFAAAAAA),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFFDDDDDD),
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: valueColor, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ─── Status Progress ──────────────────────────────────────────────────────────

class _StatusProgress extends StatelessWidget {
  const _StatusProgress({required this.current});
  final OrderStatus current;

  @override
  Widget build(BuildContext context) {
    final statuses = OrderStatus.values;
    final currentIndex = statuses.indexOf(current);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...statuses.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final isDone = i < currentIndex;
            final isCurrent = i == currentIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFF00C896)
                          : isCurrent
                              ? const Color(0xFF4A90D9)
                              : const Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        isDone ? '✓' : s.icon,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    s.label,
                    style: TextStyle(
                      color: isDone || isCurrent
                          ? Colors.white
                          : const Color(0xFF555555),
                      fontSize: 14,
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NOW',
                        style: TextStyle(
                          color: Color(0xFF4A90D9),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !loading;

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Icon(icon, size: 20),
          label: Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            disabledBackgroundColor: color,
            disabledForegroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}

// ─── Simulation Banner ────────────────────────────────────────────────────────

class _SimulationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF9B59B6).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9B59B6).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF9B59B6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Background simulation running • Updates every 8 seconds',
              style: TextStyle(
                color: Color(0xFF9B59B6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Banner ──────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A00),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A00)),
      ),
      padding: const EdgeInsets.all(14),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚠️', style: TextStyle(fontSize: 16)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Live Activities & Dynamic Island require iOS 16.1+ on iPhone 14 Pro or later. '
              'On simulators or unsupported devices, the app still runs but Live Activities won\'t appear.',
              style: TextStyle(color: Color(0xFFAAAA88), fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
