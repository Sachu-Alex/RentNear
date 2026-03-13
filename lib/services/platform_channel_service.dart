import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:flutter/services.dart';

class PlatformChannelService {
  static const MethodChannel _channel =
      MethodChannel('com.example.rentProducts/liveActivity');

  static Future<bool> startLiveActivity({
    required String orderId,
    required String status,
    required int eta,
  }) async {
    if (!_isIOS()) return false;
    try {
      final result = await _channel.invokeMethod<bool>('startLiveActivity', {
        'orderId': orderId,
        'status': status,
        'eta': eta,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('startLiveActivity error: ${e.message}');
      return false;
    }
  }

  static Future<bool> updateLiveActivity({
    required String status,
    required int eta,
  }) async {
    if (!_isIOS()) return false;
    try {
      final result = await _channel.invokeMethod<bool>('updateLiveActivity', {
        'status': status,
        'eta': eta,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('updateLiveActivity error: ${e.message}');
      return false;
    }
  }

  static Future<bool> endLiveActivity() async {
    if (!_isIOS()) return false;
    try {
      final result = await _channel.invokeMethod<bool>('endLiveActivity');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('endLiveActivity error: ${e.message}');
      return false;
    }
  }

  static bool _isIOS() => defaultTargetPlatform == TargetPlatform.iOS;
}
