import 'platform_channel_service.dart';

enum OrderStatus {
  confirmed('Order Confirmed', '✅'),
  preparing('Preparing Item', '🍳'),
  outForDelivery('Out for Delivery', '🚴'),
  arrivingSoon('Arriving Soon', '📍'),
  delivered('Delivered', '🎉');

  const OrderStatus(this.label, this.icon);
  final String label;
  final String icon;
}

class OrderTrackingService {
  static const String dummyOrderId = '12345';

  bool _isActive = false;
  bool get isActive => _isActive;

  bool _isSimulating = false;
  bool get isSimulating => _isSimulating;

  OrderStatus _currentStatus = OrderStatus.confirmed;
  OrderStatus get currentStatus => _currentStatus;

  int _eta = 30;
  int get eta => _eta;

  Future<bool> startTracking() async {
    _currentStatus = OrderStatus.confirmed;
    _eta = 30;
    final success = await PlatformChannelService.startLiveActivity(
      orderId: dummyOrderId,
      status: _currentStatus.label,
      eta: _eta,
    );
    _isActive = success;
    return success;
  }

  Future<bool> advanceStatus() async {
    if (!_isActive) return false;

    final statuses = OrderStatus.values;
    final nextIndex = statuses.indexOf(_currentStatus) + 1;
    if (nextIndex >= statuses.length) return false;

    _currentStatus = statuses[nextIndex];
    _eta = switch (_currentStatus) {
      OrderStatus.confirmed => 28,
      OrderStatus.preparing => 20,
      OrderStatus.outForDelivery => 12,
      OrderStatus.arrivingSoon => 3,
      OrderStatus.delivered => 0,
    };

    final success = await PlatformChannelService.updateLiveActivity(
      status: _currentStatus.label,
      eta: _eta,
    );
    return success;
  }

  Future<bool> endTracking() async {
    await stopSimulation();
    final success = await PlatformChannelService.endLiveActivity();
    _isActive = false;
    _currentStatus = OrderStatus.confirmed;
    return success;
  }

  Future<bool> startSimulation() async {
    if (!_isActive) return false;
    final success = await PlatformChannelService.simulateBackgroundUpdates();
    _isSimulating = success;
    return success;
  }

  Future<bool> stopSimulation() async {
    if (!_isSimulating) return true;
    final success = await PlatformChannelService.stopSimulation();
    _isSimulating = false;
    return success;
  }

  bool get canAdvance =>
      _isActive && _currentStatus != OrderStatus.delivered;
}
