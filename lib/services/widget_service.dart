import 'dart:convert';
import 'package:home_widget/home_widget.dart';

class NearbyRental {
  final String name;
  final String distance;
  final String icon;

  const NearbyRental({
    required this.name,
    required this.distance,
    this.icon = 'build',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'distance': distance,
        'icon': icon,
      };

  factory NearbyRental.fromJson(Map<String, dynamic> json) => NearbyRental(
        name: json['name'] as String,
        distance: json['distance'] as String,
        icon: json['icon'] as String? ?? 'build',
      );
}

class WidgetService {
  static const String _appGroupId = 'group.com.example.rentProducts';
  static const String _androidWidgetName = 'NearbyItemsWidgetProvider';
  static const String _iOSWidgetName = 'NearbyItemsWidget';

  static const List<NearbyRental> dummyNearbyRentals = [
    NearbyRental(name: 'Weight Machine', distance: '2 km', icon: 'fitness'),
    NearbyRental(name: 'DSLR Camera', distance: '1.5 km', icon: 'camera'),
    NearbyRental(name: 'Ladder', distance: '800 m', icon: 'construction'),
    NearbyRental(name: 'Drill Machine', distance: '1.2 km', icon: 'build'),
  ];

  /// Initialize home_widget with app group ID
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Save nearby rental data and trigger widget update
  static Future<bool> updateNearbyRentals([
    List<NearbyRental>? rentals,
  ]) async {
    final items = rentals ?? dummyNearbyRentals;

    try {
      // Save the list as JSON string
      final jsonList = items.map((r) => r.toJson()).toList();
      await HomeWidget.saveWidgetData<String>(
        'nearby_rentals',
        jsonEncode(jsonList),
      );

      // Save item count as string to avoid int/long type issues on Android
      await HomeWidget.saveWidgetData<String>(
          'item_count', items.length.toString());

      // Save each item's data individually for simple native parsing
      for (var i = 0; i < items.length; i++) {
        await HomeWidget.saveWidgetData<String>(
            'item_${i}_name', items[i].name);
        await HomeWidget.saveWidgetData<String>(
            'item_${i}_distance', items[i].distance);
        await HomeWidget.saveWidgetData<String>('item_${i}_icon', items[i].icon);
      }

      // Build a single display string as fallback for simple widgets
      final displayLines = items
          .map((item) => '${item.name}  •  ${item.distance}')
          .join('\n');
      await HomeWidget.saveWidgetData<String>('display_text', displayLines);

      await HomeWidget.saveWidgetData<String>(
        'last_updated',
        DateTime.now().toIso8601String(),
      );

      // Trigger widget update on both platforms
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
