import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WidgetService.initialize();
  runApp(const RentNearApp());
}

class RentNearApp extends StatelessWidget {
  const RentNearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentNear',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/order-tracking': (_) => const OrderTrackingScreen(),
      },
    );
  }
}
