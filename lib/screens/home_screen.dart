import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/rental_item.dart';
import '../widgets/animations.dart';
import '../widgets/category_chip.dart';
import '../widgets/item_card.dart';
import '../widgets/featured_carousel.dart';
import 'item_detail_screen.dart';
import 'order_tracking_screen.dart';
import 'widget_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedNavIndex = 0;
  int _selectedCategoryIndex = 0;
  int _selectedBookingTab = 0; // 0=Active, 1=Past

  void _openDetail(RentalItem item) {
    Navigator.push(context, FadePageRoute(page: ItemDetailScreen(item: item)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            _buildHomeContent(),
            _buildCategoriesTab(),
            _buildBookingsTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          border: Border(
            top: BorderSide(color: AppTheme.dividerColor.withValues(alpha: 0.6), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (index) => setState(() => _selectedNavIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.home_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.home_rounded)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.grid_view_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.grid_view_rounded)),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.receipt_long_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.receipt_long_rounded)),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.person_outline_rounded)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.person_rounded)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ─── HOME TAB ─────────────────────────────────────────────────────────────

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          FadeSlideIn(
            index: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('S', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning', style: TextStyle(fontSize: 13, color: AppTheme.textTertiary, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 2),
                        const Text('Find & Rent', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.6, height: 1.1)),
                      ],
                    ),
                  ),
                  TapScale(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WidgetSettingsScreen())),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.dividerColor, width: 1.2)),
                      child: const Icon(Icons.widgets_outlined, size: 22, color: AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TapScale(
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.dividerColor, width: 1.2)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.notifications_none_rounded, size: 22, color: AppTheme.textPrimary),
                          Positioned(
                            top: 10, right: 12,
                            child: Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(color: const Color(0xFFEF4444), shape: BoxShape.circle, border: Border.all(color: AppTheme.cardColor, width: 1.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Search bar
          FadeSlideIn(
            index: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TapScale(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppTheme.dividerColor, width: 1.2),
                    boxShadow: [BoxShadow(color: AppTheme.cardShadow, blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Search equipment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                            const SizedBox(height: 2),
                            Text('Tools, machines, electronics...', style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 28, color: AppTheme.dividerColor),
                      const SizedBox(width: 14),
                      Icon(Icons.tune_rounded, color: AppTheme.textSecondary, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Categories section
          FadeSlideIn(
            index: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.3)),
                  Text('${RentalCategory.categories.length} types', style: TextStyle(fontSize: 13, color: AppTheme.textTertiary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FadeSlideIn(
            index: 3,
            child: SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: RentalCategory.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = RentalCategory.categories[index];
                  return CategoryChip(
                    label: category.name,
                    icon: category.icon,
                    isSelected: _selectedCategoryIndex == index,
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Featured
          FadeSlideIn(
            index: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Featured', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.3)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.starColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department_rounded, size: 14, color: AppTheme.starColor),
                        const SizedBox(width: 4),
                        Text('Hot', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.starColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FadeSlideIn(
            index: 5,
            child: FeaturedCarousel(items: RentalItem.featuredItems, onItemTap: _openDetail),
          ),
          const SizedBox(height: 32),

          // Popular items
          FadeSlideIn(
            index: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.3)),
                  TapScale(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Text('See all', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.primaryColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.68,
              ),
              itemCount: RentalItem.sampleItems.length,
              itemBuilder: (context, index) {
                return FadeSlideIn(
                  index: 7 + index,
                  baseDelay: const Duration(milliseconds: 80),
                  child: ItemCard(item: RentalItem.sampleItems[index], onTap: () => _openDetail(RentalItem.sampleItems[index])),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── CATEGORIES TAB ───────────────────────────────────────────────────────

  Widget _buildCategoriesTab() {
    final categoryData = [
      _CategoryData('Tools', Icons.build_circle_outlined, '12 items', const Color(0xFF0B6E6B), const Color(0xFFDBF0EF)),
      _CategoryData('Weighing', Icons.monitor_weight_outlined, '8 items', const Color(0xFF7C3AED), const Color(0xFFEDE9FE)),
      _CategoryData('Electronics', Icons.electrical_services, '15 items', const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
      _CategoryData('Vehicles', Icons.directions_car_outlined, '6 items', const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
      _CategoryData('Furniture', Icons.chair_outlined, '10 items', const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
      _CategoryData('Sports', Icons.sports_soccer_outlined, '9 items', const Color(0xFF10B981), const Color(0xFFD1FAE5)),
      _CategoryData('Photography', Icons.camera_alt_outlined, '7 items', const Color(0xFF8B5CF6), const Color(0xFFEDE9FE)),
      _CategoryData('Others', Icons.category_outlined, '20 items', const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Browse', style: TextStyle(fontSize: 13, color: AppTheme.textTertiary, fontWeight: FontWeight.w400)),
                const SizedBox(height: 2),
                const Text('Categories', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.6)),
                const SizedBox(height: 20),
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.dividerColor, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: AppTheme.textTertiary, size: 20),
                      const SizedBox(width: 12),
                      Text('Search categories...', style: TextStyle(fontSize: 14, color: AppTheme.textTertiary)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text('All Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.2)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cat = categoryData[index];
                return FadeSlideIn(
                  index: index,
                  baseDelay: const Duration(milliseconds: 60),
                  child: TapScale(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.dividerColor, width: 1),
                        boxShadow: [BoxShadow(color: AppTheme.cardShadow, blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: cat.bgColor, borderRadius: BorderRadius.circular(14)),
                            child: Icon(cat.icon, color: cat.color, size: 22),
                          ),
                          const Spacer(),
                          Text(cat.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.2)),
                          const SizedBox(height: 3),
                          Text(cat.count, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: categoryData.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // Popular in each category
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: const Text('Trending Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.2)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.68,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => FadeSlideIn(
                index: 8 + index,
                baseDelay: const Duration(milliseconds: 80),
                child: ItemCard(item: RentalItem.sampleItems[index], onTap: () => _openDetail(RentalItem.sampleItems[index])),
              ),
              childCount: RentalItem.sampleItems.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // ─── BOOKINGS TAB ─────────────────────────────────────────────────────────

  Widget _buildBookingsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Bookings', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.6)),
                const SizedBox(height: 2),
                Text('Manage your rentals', style: TextStyle(fontSize: 14, color: AppTheme.textTertiary)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tab selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  _bookingTabItem('Active', 0),
                  _bookingTabItem('Past', 1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          if (_selectedBookingTab == 0) ...[
            // Live tracking CTA card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TapScale(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderTrackingScreen())),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF073A39), Color(0xFF0B6E6B)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0xFF0B6E6B).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Live Tracking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF2DD4BF), shape: BoxShape.circle)),
                                      const SizedBox(width: 4),
                                      const Text('LIVE', style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Dynamic Island & Lock Screen', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withValues(alpha: 0.7), size: 14),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Active bookings empty state
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(22)),
                      child: const Icon(Icons.inventory_2_outlined, size: 32, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 16),
                    const Text('No active rentals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    Text('Browse items and start your first rental', style: TextStyle(fontSize: 13, color: AppTheme.textTertiary), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    TapScale(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                        child: const Text('Browse Items', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Past bookings — sample history
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildPastBookingCard(
                    name: 'Power Drill Set',
                    date: 'Mar 10, 2026',
                    duration: '2 days',
                    amount: '₹1,300',
                    icon: Icons.hardware,
                    statusColor: const Color(0xFF10B981),
                    status: 'Returned',
                  ),
                  const SizedBox(height: 14),
                  _buildPastBookingCard(
                    name: 'Digital Weighing Scale',
                    date: 'Feb 24, 2026',
                    duration: '4 hours',
                    amount: '₹600',
                    icon: Icons.monitor_weight_outlined,
                    statusColor: const Color(0xFF10B981),
                    status: 'Returned',
                  ),
                  const SizedBox(height: 14),
                  _buildPastBookingCard(
                    name: 'Portable Generator',
                    date: 'Feb 12, 2026',
                    duration: '1 day',
                    amount: '₹2,000',
                    icon: Icons.bolt,
                    statusColor: const Color(0xFF10B981),
                    status: 'Returned',
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _bookingTabItem(String label, int index) {
    final isSelected = _selectedBookingTab == index;
    return Expanded(
      child: TapScale(
        onTap: () => setState(() => _selectedBookingTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [BoxShadow(color: AppTheme.cardShadow, blurRadius: 6, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPastBookingCard({
    required String name, required String date, required String duration,
    required String amount, required IconData icon, required Color statusColor, required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [BoxShadow(color: AppTheme.cardShadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: AppTheme.primaryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text('$date  •  $duration', style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── PROFILE TAB ──────────────────────────────────────────────────────────

  Widget _buildProfileTab() {
    final menuSections = [
      [
        _MenuItem(Icons.list_alt_rounded, 'My Listings', 'Items you rent out', const Color(0xFF0B6E6B), const Color(0xFFDBF0EF)),
        _MenuItem(Icons.favorite_rounded, 'Saved Items', '3 saved', const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
      ],
      [
        _MenuItem(Icons.credit_card_rounded, 'Payment Methods', 'Add & manage cards', const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
        _MenuItem(Icons.location_on_outlined, 'Saved Addresses', '2 addresses', const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
      ],
      [
        _MenuItem(Icons.notifications_outlined, 'Notifications', 'Manage alerts', const Color(0xFF8B5CF6), const Color(0xFFEDE9FE)),
        _MenuItem(Icons.security_outlined, 'Privacy & Security', 'Account settings', const Color(0xFF10B981), const Color(0xFFD1FAE5)),
      ],
      [
        _MenuItem(Icons.help_outline_rounded, 'Help & Support', 'FAQ, contact us', const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
        _MenuItem(Icons.info_outline_rounded, 'About RentNear', 'Version 1.0.0', const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
      ],
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
              boxShadow: [BoxShadow(color: AppTheme.cardShadow, blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0B6E6B), Color(0xFF2DD4BF)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: const Color(0xFF0B6E6B).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: const Center(
                        child: Text('S', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(color: AppTheme.cardColor, shape: BoxShape.circle, border: Border.all(color: AppTheme.dividerColor, width: 1.5)),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Sachu Alex', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.4)),
                const SizedBox(height: 4),
                Text('sachu@example.com', style: TextStyle(fontSize: 13, color: AppTheme.textTertiary)),
                const SizedBox(height: 20),

                // Stats row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      _profileStat('8', 'Rentals'),
                      _profileStatDivider(),
                      _profileStat('3', 'Saved'),
                      _profileStatDivider(),
                      _profileStat('4.9', 'Rating'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu sections
          ...menuSections.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Column(
                  children: entry.value.asMap().entries.map((itemEntry) {
                    final item = itemEntry.value;
                    final isLast = itemEntry.key == entry.value.length - 1;
                    return Column(
                      children: [
                        TapScale(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(color: item.bgColor, borderRadius: BorderRadius.circular(12)),
                                  child: Icon(item.icon, color: item.color, size: 18),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                                      Text(item.subtitle, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textTertiary),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: Divider(color: AppTheme.dividerColor, height: 1),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }),

          // Sign out
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 32),
            child: TapScale(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFCA5A5).withValues(alpha: 0.5)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 18, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text('Sign Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.4)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
        ],
      ),
    );
  }

  Widget _profileStatDivider() {
    return Container(width: 1, height: 32, color: AppTheme.dividerColor);
  }
}

// ─── Data classes ─────────────────────────────────────────────────────────────

class _CategoryData {
  final String name;
  final IconData icon;
  final String count;
  final Color color;
  final Color bgColor;
  const _CategoryData(this.name, this.icon, this.count, this.color, this.bgColor);
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  const _MenuItem(this.icon, this.title, this.subtitle, this.color, this.bgColor);
}
