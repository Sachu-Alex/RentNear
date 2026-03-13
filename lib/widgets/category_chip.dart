import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animations.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color accentColor;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
    this.accentColor = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final accentLight = Color.lerp(accentColor, Colors.white, 0.86)!;
    final gradientEnd = Color.lerp(accentColor, Colors.white, 0.38)!;

    return TapScale(
      onTap: onTap,
      // Outer container holds shadow — must NOT clip (shadows are outside bounds)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: 80,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.44),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTheme.cardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        // Inner clip — keeps gradient, circles, and content within rounded bounds
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Color.lerp(accentColor, Colors.black, 0.14)!,
                        accentColor,
                        gradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : AppTheme.cardColor,
              border: isSelected
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.20),
                      width: 1,
                    )
                  : Border.all(color: AppTheme.dividerColor, width: 1.2),
            ),
            child: Stack(
              children: [
                // Shine blob — top right
                Positioned(
                  top: -18,
                  right: -14,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 280),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                ),
                // Accent blob — bottom left
                Positioned(
                  bottom: -20,
                  left: -12,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 280),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                ),
                // Content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon box — animated colors only, fixed size
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.22)
                              : accentLight,
                          borderRadius: BorderRadius.circular(13),
                          border: isSelected
                              ? Border.all(
                                  color: Colors.white.withValues(alpha: 0.28),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Icon(
                          icon,
                          size: 20,
                          color: isSelected ? Colors.white : accentColor,
                        ),
                      ),
                      const SizedBox(height: 9),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                          letterSpacing: 0.1,
                        ),
                        child: Text(label),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
