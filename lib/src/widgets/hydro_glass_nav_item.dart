part of '../../hydro_glass_nav_bar.dart';

/// Individual navigation item in the floating nav bar.
///
/// This is an internal widget used by [HydroGlassNavBar].
class _HydroGlassNavItemWidget extends StatelessWidget {
  const _HydroGlassNavItemWidget({
    required this.config,
    required this.selected,
    required this.colorScheme,
    required this.onTap,
  });

  final HydroGlassNavItem config;
  final bool selected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        label: config.label,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with glow effect
              ExcludeSemantics(
                child: AnimatedScale(
                  scale: selected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    selected
                        ? (config.selectedIcon ?? config.icon)
                        : config.icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                config.label,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
