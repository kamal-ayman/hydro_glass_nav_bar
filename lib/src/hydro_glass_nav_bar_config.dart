part of '../hydro_glass_nav_bar.dart';

/// Configuration for an item in [HydroGlassNavBar].
///
/// Each navigation item displays an icon and a label. You can optionally
/// provide:
/// - A different icon for the selected state via [selectedIcon]
/// - A custom glow color via [glowColor]
///
/// ## Example
///
/// ```dart
/// HydroGlassNavItem(
///   label: 'Home',
///   icon: Icons.home_outlined,
///   selectedIcon: Icons.home,
///   glowColor: Colors.blue,
/// )
/// ```
final class HydroGlassNavItem {
  /// Creates a navigation item configuration.
  ///
  /// The [label] and [icon] are required.
  const HydroGlassNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.glowColor,
  });

  /// The text label displayed below the icon.
  final String label;

  /// The icon displayed when this item is not selected.
  final IconData icon;

  /// The icon displayed when this item is selected.
  ///
  /// If `null`, [icon] will be used for both states.
  final IconData? selectedIcon;

  /// The glow color for this item when selected.
  ///
  /// If `null`, the default theme color will be used.
  final Color? glowColor;
}

/// Configuration for the floating action button in [HydroGlassNavBar].
///
/// The FAB appears when items are selected (controlled by
/// [HydroGlassNavBar.selectedItemsCount]). When tapped, it expands to
/// show a menu of [actions].
///
/// ## Example
///
/// ```dart
/// HydroGlassNavBarFABConfig(
///   icon: Icons.more_vert,
///   semanticLabel: 'Actions menu',
///   actions: [
///     HydroGlassNavBarAction(
///       icon: Icons.share,
///       label: 'Share',
///       onTap: () => handleShare(),
///     ),
///     HydroGlassNavBarAction(
///       icon: Icons.delete,
///       label: 'Delete',
///       onTap: () => handleDelete(),
///       isDanger: true,
///     ),
///   ],
/// )
/// ```
final class HydroGlassNavBarFABConfig {
  /// Creates a FAB configuration.
  ///
  /// The [icon] and [actions] are required.
  const HydroGlassNavBarFABConfig({
    required this.icon,
    required this.actions,
    this.semanticLabel,
    this.size = 56,
  });

  /// The icon displayed on the FAB.
  final IconData icon;

  /// The list of actions shown when the FAB is expanded.
  final List<HydroGlassNavBarAction> actions;

  /// Semantic label for accessibility.
  ///
  /// If `null`, defaults to "Action button".
  final String? semanticLabel;

  /// The size of the FAB.
  ///
  /// Defaults to `56`.
  final double size;
}

/// An action in the [HydroGlassNavBarFABConfig] menu.
///
/// Each action displays an icon and label, and triggers [onTap] when pressed.
/// Set [isDanger] to `true` for destructive actions (displayed in error color).
///
/// ## Example
///
/// ```dart
/// HydroGlassNavBarAction(
///   icon: Icons.delete,
///   label: 'Delete',
///   onTap: () => showDeleteConfirmation(),
///   isDanger: true,
/// )
/// ```
final class HydroGlassNavBarAction {
  /// Creates an action configuration.
  ///
  /// The [icon], [label], and [onTap] are required.
  const HydroGlassNavBarAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  /// The icon for this action.
  final IconData icon;

  /// The text label for this action.
  final String label;

  /// The callback invoked when this action is tapped.
  final VoidCallback onTap;

  /// Whether this is a destructive action.
  ///
  /// When `true`, the action will be displayed in the theme's error color.
  /// Defaults to `false`.
  final bool isDanger;
}
