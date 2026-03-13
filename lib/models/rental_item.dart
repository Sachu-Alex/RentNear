import 'package:flutter/material.dart';

class RentalItem {
  final String id;
  final String name;
  final String category;
  final double pricePerHour;
  final double pricePerDay;
  final double rating;
  final int reviewCount;
  final IconData iconData;
  final String imageUrl;

  const RentalItem({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.rating,
    this.reviewCount = 0,
    this.iconData = Icons.build,
    required this.imageUrl,
  });

  static List<RentalItem> get sampleItems => const [
    RentalItem(
      id: '1',
      name: 'Digital Weighing Scale',
      category: 'Weighing Machines',
      pricePerHour: 150,
      pricePerDay: 800,
      rating: 4.8,
      reviewCount: 124,
      iconData: Icons.monitor_weight_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1585751119414-ef2636f8aede?w=400&h=400&fit=crop',
    ),
    RentalItem(
      id: '2',
      name: 'Power Drill Set',
      category: 'Tools',
      pricePerHour: 120,
      pricePerDay: 650,
      rating: 4.6,
      reviewCount: 89,
      iconData: Icons.hardware,
      imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=400&h=400&fit=crop',
    ),
    RentalItem(
      id: '3',
      name: 'Industrial Scale',
      category: 'Weighing Machines',
      pricePerHour: 400,
      pricePerDay: 2500,
      rating: 4.9,
      reviewCount: 203,
      iconData: Icons.scale,
      imageUrl: 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=400&h=400&fit=crop',
    ),
    RentalItem(
      id: '4',
      name: 'Angle Grinder',
      category: 'Tools',
      pricePerHour: 100,
      pricePerDay: 500,
      rating: 4.5,
      reviewCount: 67,
      iconData: Icons.content_cut,
      imageUrl: 'https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=400&h=400&fit=crop',
    ),
    RentalItem(
      id: '5',
      name: 'Portable Generator',
      category: 'Electronics',
      pricePerHour: 350,
      pricePerDay: 2000,
      rating: 4.7,
      reviewCount: 156,
      iconData: Icons.bolt,
      imageUrl: 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?w=400&h=400&fit=crop',
    ),
    RentalItem(
      id: '6',
      name: 'Pressure Washer',
      category: 'Tools',
      pricePerHour: 200,
      pricePerDay: 1200,
      rating: 4.4,
      reviewCount: 92,
      iconData: Icons.water_drop,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400&h=400&fit=crop',
    ),
  ];

  static List<RentalItem> get featuredItems =>
      sampleItems.where((item) => item.rating >= 4.7).toList();
}

class RentalCategory {
  final String name;
  final IconData icon;

  const RentalCategory({required this.name, required this.icon});

  static const List<RentalCategory> categories = [
    RentalCategory(name: 'Tools', icon: Icons.build_circle_outlined),
    RentalCategory(name: 'Weighing', icon: Icons.monitor_weight_outlined),
    RentalCategory(name: 'Electronics', icon: Icons.electrical_services),
    RentalCategory(name: 'Others', icon: Icons.category_outlined),
  ];
}
