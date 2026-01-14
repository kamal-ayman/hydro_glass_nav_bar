part of '../hydro_glass_nav_bar.dart';

/// Apple-style hydro glass floating navigation bar with advanced animations.
///
/// A premium navigation bar widget featuring:
/// - Hydro glass morphism effect with refraction and blur
/// - Draggable indicator with iOS-style physics
/// - Smooth spring animations using the Motor package
/// - Optional expandable FAB with action menu
/// - Selection mode support with badge counter
///
/// ## Example
///
/// ```dart
/// HydroGlassNavBar(
///   controller: _tabController,
///   items: [
///     HydroGlassNavItem(label: 'Home', icon: Icons.home),
///     HydroGlassNavItem(label: 'Search', icon: Icons.search),
///     HydroGlassNavItem(label: 'Profile', icon: Icons.person),
///   ],
///   fabConfig: HydroGlassNavBarFABConfig(
///     icon: Icons.add,
///     actions: [
///       HydroGlassNavBarAction(
///         icon: Icons.share,
///         label: 'Share',
///         onTap: () => print('Share tapped'),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// The navigation bar requires between 2 and 5 items. An assertion will fail
/// if you provide fewer than 2 or more than 5 items.
///
/// {@category Widgets}
final class HydroGlassNavBar extends StatefulWidget {
  /// Creates a hydro glass navigation bar.
  ///
  /// The [controller] and [items] parameters are required.
  /// The number of items must be between 2 and 5 (inclusive).
  const HydroGlassNavBar({
    required this.controller,
    required this.items,
    this.fabConfig,
    this.showIndicator = true,
    this.indicatorColor,
    this.selectedItemsCount,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.useLiquidGlass = true,
    super.key,
  }) : assert(items.length >= 2 && items.length <= 5, 'Items must be 2-5');

  /// The controller that manages the current item selection.
  ///
  /// The controller's length should match the number of [items].
  /// You can use a [TabController] to synchronize with a [TabBarView].
  final TabController controller;

  /// The list of navigation items to display in the bar.
  ///
  /// Must contain between 2 and 5 items.
  final List<HydroGlassNavItem> items;

  /// Optional configuration for the floating action button.
  ///
  /// When provided, an expandable FAB will appear next to the nav bar
  /// when items are selected (controlled by [selectedItemsCount]).
  final HydroGlassNavBarFABConfig? fabConfig;

  /// Whether to show the sliding indicator.
  ///
  /// Defaults to `true`.
  final bool showIndicator;

  /// The color of the indicator.
  ///
  /// If `null`, the color will be derived from the theme.
  final Color? indicatorColor;

  /// A [ValueNotifier] that tracks the number of selected items.
  ///
  /// When the value is greater than 0, the FAB (if configured) will appear
  /// with a badge showing the count.
  final ValueNotifier<int>? selectedItemsCount;

  /// The padding around the navigation bar.
  ///
  /// Defaults to `EdgeInsets.fromLTRB(20, 20, 20, 20)`.
  final EdgeInsets padding;

  /// Whether to use the liquid glass effect.
  ///
  /// When `false`, a simpler gradient background with shadows is used.
  /// This can be useful for performance optimization or when the liquid
  /// glass effect is not desired.
  ///
  /// Defaults to `true`.
  final bool useLiquidGlass;

  @override
  State<HydroGlassNavBar> createState() => _HydroGlassNavBarState();
}

class _HydroGlassNavBarState extends State<HydroGlassNavBar> {
  bool _hasSelection = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onIndexChanged);
    widget.selectedItemsCount?.addListener(_onSelectionChanged);
    _hasSelection = (widget.selectedItemsCount?.value ?? 0) > 0;
  }

  @override
  void didUpdateWidget(HydroGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItemsCount != widget.selectedItemsCount) {
      oldWidget.selectedItemsCount?.removeListener(_onSelectionChanged);
      widget.selectedItemsCount?.addListener(_onSelectionChanged);
      _onSelectionChanged();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onIndexChanged);
    widget.selectedItemsCount?.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onIndexChanged() {
    if (mounted) setState(() {});
  }

  void _onSelectionChanged() {
    if (mounted) {
      setState(() {
        _hasSelection = (widget.selectedItemsCount?.value ?? 0) > 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final Widget content = SafeArea(
      top: false,
      child: Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Main nav bar with draggable indicator
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: _HydroGlassNavIndicator(
                  visible: widget.showIndicator,
                  currentIndex: widget.controller.index,
                  itemCount: widget.items.length,
                  indicatorColor: widget.indicatorColor,
                  useLiquidGlass: widget.useLiquidGlass,
                  onIndexChanged: (index) {
                    HapticFeedback.selectionClick();
                    widget.controller.animateTo(index);
                  },
                  child: Row(
                    children: [
                      for (var i = 0; i < widget.items.length; i++)
                        Expanded(
                          child: RepaintBoundary(
                            child: _HydroGlassNavItemWidget(
                              config: widget.items[i],
                              selected: widget.controller.index == i,
                              colorScheme: colorScheme,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.controller.animateTo(i);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated spacing for FAB
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: _hasSelection ? 8 : 0,
            ),

            // FAB button - animated visibility
            if (widget.fabConfig != null) _buildFAB(colorScheme),
          ],
        ),
      ),
    );

    if (!widget.useLiquidGlass) {
      return Positioned(left: 0, right: 0, bottom: 0, child: content);
    }

    final glassSettings = LiquidGlassSettings(
      refractiveIndex: 1.21,
      thickness: 30,
      blur: 8,
      saturation: 1.5,
      lightIntensity: isDark ? .7 : 1,
      ambientStrength: isDark ? .2 : .5,
      lightAngle: 3.14159 / 4,
      glassColor: colorScheme.surface.withValues(alpha: 0.6),
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        ignoring: false,
        child: LiquidGlassLayer(
          settings: glassSettings,
          child: LiquidGlassBlendGroup(
            blend: 15.0,
            child: ClipRect(child: content),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      width: _hasSelection ? null : 0,
      child: SingleMotionBuilder(
        motion: const Motion.bouncySpring(),
        value: _hasSelection ? 1.0 : 0.0,
        builder: (context, value, child) {
          final clampedValue = value.clamp(0.0, 1.0);
          return Transform.scale(
            scale: clampedValue,
            alignment: Alignment.centerRight,
            child: Opacity(
              opacity: clampedValue,
              child: IgnorePointer(
                ignoring: clampedValue < 0.1,
                child: Visibility(
                  visible: clampedValue > 0.01,
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  child: child!,
                ),
              ),
            ),
          );
        },
        child: RepaintBoundary(
          child: Align(
            alignment: Alignment.bottomRight,
            child: _HydroGlassFloatingActionButton(
              config: widget.fabConfig!,
              colorScheme: colorScheme,
              selectedCount: widget.selectedItemsCount?.value ?? 0,
              useLiquidGlass: widget.useLiquidGlass,
            ),
          ),
        ),
      ),
    );
  }
}
