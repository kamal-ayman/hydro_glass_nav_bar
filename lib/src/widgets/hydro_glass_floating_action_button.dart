part of '../../hydro_glass_nav_bar.dart';

/// Glass FAB with expandable action menu.
///
/// This is an internal widget used by [HydroGlassNavBar].
class _HydroGlassFloatingActionButton extends StatefulWidget {
  const _HydroGlassFloatingActionButton({
    required this.config,
    required this.colorScheme,
    required this.selectedCount,
    required this.useLiquidGlass,
  });

  final HydroGlassNavBarFABConfig config;
  final ColorScheme colorScheme;
  final int selectedCount;
  final bool useLiquidGlass;

  @override
  State<_HydroGlassFloatingActionButton> createState() =>
      _HydroGlassFloatingActionButtonState();
}

class _HydroGlassFloatingActionButtonState
    extends State<_HydroGlassFloatingActionButton> {
  bool _isExpanded = false;

  void _toggleOptions() {
    if (mounted) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  void didUpdateWidget(_HydroGlassFloatingActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCount == 0 && _isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate height to include options menu for touch events
    final optionsHeight = widget.config.actions.length * 44.0 +
        (widget.config.actions.length - 1) * 8.0;
    final totalHeight = _isExpanded
        ? widget.config.size + 8 + optionsHeight
        : widget.config.size;

    return SizedBox(
      width: widget.config.size,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          // Expanded options menu positioned above FAB
          Positioned(
            bottom: widget.config.size + 8,
            right: 0,
            child: SingleMotionBuilder(
              motion: const Motion.bouncySpring(),
              value: _isExpanded ? 1.0 : 0.0,
              builder: (context, value, child) {
                final clampedValue = value.clamp(0.0, 1.0);
                return Transform.scale(
                  scale: clampedValue,
                  alignment: Alignment.bottomRight,
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
              child: _FABOptionsMenu(
                actions: widget.config.actions,
                colorScheme: widget.colorScheme,
                useLiquidGlass: widget.useLiquidGlass,
                isExpanded: _isExpanded,
                onActionTap: (action) {
                  _toggleOptions();
                  action.onTap();
                },
              ),
            ),
          ),

          // Main FAB button
          Positioned(
            bottom: 0,
            right: 0,
            child: _GlassFABButton(
              config: widget.config,
              colorScheme: widget.colorScheme,
              selectedCount: widget.selectedCount,
              isExpanded: _isExpanded,
              useLiquidGlass: widget.useLiquidGlass,
              onTap: () {
                HapticFeedback.selectionClick();
                _toggleOptions();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The main FAB button.
class _GlassFABButton extends StatelessWidget {
  const _GlassFABButton({
    required this.config,
    required this.colorScheme,
    required this.selectedCount,
    required this.isExpanded,
    required this.useLiquidGlass,
    required this.onTap,
  });

  final HydroGlassNavBarFABConfig config;
  final ColorScheme colorScheme;
  final int selectedCount;
  final bool isExpanded;
  final bool useLiquidGlass;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget fabContent = Container(
      width: config.size,
      height: config.size,
      alignment: Alignment.center,
      decoration: !useLiquidGlass
          ? BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.95),
                  colorScheme.surface.withValues(alpha: 0.85),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 300),
        turns: isExpanded ? 0.125 : 0.0,
        child: Icon(config.icon, size: 28, color: colorScheme.onSurface),
      ),
    );

    if (useLiquidGlass) {
      fabContent = LiquidStretch(
        child: GlassGlow(
          child:
              LiquidGlass.grouped(shape: const LiquidOval(), child: fabContent),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: config.semanticLabel ?? 'Action button',
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            fabContent,
            // Badge with count
            if (selectedCount > 0 && !isExpanded)
              Positioned(
                top: -4,
                right: -4,
                child: _CountBadge(
                  count: selectedCount,
                  colorScheme: colorScheme,
                  useLiquidGlass: useLiquidGlass,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Count badge for the FAB.
class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.count,
    required this.colorScheme,
    required this.useLiquidGlass,
  });

  final int count;
  final ColorScheme colorScheme;
  final bool useLiquidGlass;

  @override
  Widget build(BuildContext context) {
    final Widget badge = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.error,
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.surface, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.error.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            count > 99 ? '99+' : '$count',
            key: ValueKey<int>(count),
            style: TextStyle(
              color: colorScheme.onError,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    if (useLiquidGlass) {
      return LiquidGlass.grouped(shape: const LiquidOval(), child: badge);
    }

    return badge;
  }
}

/// Options menu for the FAB.
class _FABOptionsMenu extends StatelessWidget {
  const _FABOptionsMenu({
    required this.actions,
    required this.colorScheme,
    required this.useLiquidGlass,
    required this.isExpanded,
    required this.onActionTap,
  });

  final List<HydroGlassNavBarAction> actions;
  final ColorScheme colorScheme;
  final bool useLiquidGlass;
  final bool isExpanded;
  final ValueChanged<HydroGlassNavBarAction> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          _FABOptionItem(
            action: actions[i],
            colorScheme: colorScheme,
            useLiquidGlass: useLiquidGlass,
            onTap: () => onActionTap(actions[i]),
          ),
          if (i < actions.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

/// Individual option item in the menu.
class _FABOptionItem extends StatelessWidget {
  const _FABOptionItem({
    required this.action,
    required this.colorScheme,
    required this.useLiquidGlass,
    required this.onTap,
  });

  final HydroGlassNavBarAction action;
  final ColorScheme colorScheme;
  final bool useLiquidGlass;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final itemColor =
        action.isDanger ? colorScheme.error : colorScheme.onSurface;

    final Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: !useLiquidGlass
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.95),
                  colorScheme.surface.withValues(alpha: 0.85),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, size: 20, color: itemColor),
          const SizedBox(width: 12),
          Text(
            action.label,
            style: TextStyle(
              color: itemColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    Widget wrappedContent = content;
    if (useLiquidGlass) {
      wrappedContent = LiquidStretch(
        child: GlassGlow(
          child: LiquidGlass.grouped(
            shape: const LiquidRoundedSuperellipse(borderRadius: 16),
            child: content,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child:
          Semantics(button: true, label: action.label, child: wrappedContent),
    );
  }
}
