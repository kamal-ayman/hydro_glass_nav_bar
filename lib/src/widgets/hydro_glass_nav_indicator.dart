part of '../../hydro_glass_nav_bar.dart';

/// Draggable navigation indicator with hydro glass effect and physics.
///
/// This is an internal widget used by [HydroGlassNavBar].
class _HydroGlassNavIndicator extends StatefulWidget {
  const _HydroGlassNavIndicator({
    required this.child,
    required this.currentIndex,
    required this.itemCount,
    required this.onIndexChanged,
    required this.visible,
    required this.useLiquidGlass,
    this.indicatorColor,
  });

  final Widget child;
  final int currentIndex;
  final int itemCount;
  final ValueChanged<int> onIndexChanged;
  final bool visible;
  final bool useLiquidGlass;
  final Color? indicatorColor;

  @override
  State<_HydroGlassNavIndicator> createState() =>
      _HydroGlassNavIndicatorState();
}

class _HydroGlassNavIndicatorState extends State<_HydroGlassNavIndicator> {
  static const _barBorderRadius = 32.0;
  static const _barShape = LiquidRoundedSuperellipse(
    borderRadius: _barBorderRadius,
  );

  bool _isDown = false;
  bool _isDragging = false;
  late double _xAlign = HydroGlassNavBarPhysics.computeAlignment(
    widget.currentIndex,
    widget.itemCount,
  );

  @override
  void didUpdateWidget(covariant _HydroGlassNavIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex ||
        oldWidget.itemCount != widget.itemCount) {
      setState(() {
        _xAlign = HydroGlassNavBarPhysics.computeAlignment(
          widget.currentIndex,
          widget.itemCount,
        );
      });
    }
  }

  double _getAlignmentFromGlobalPosition(Offset globalPosition) {
    final box = context.findRenderObject()! as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);

    final indicatorWidth = 1.0 / widget.itemCount;
    final draggableRange = 1.0 - indicatorWidth;
    final padding = indicatorWidth / 2;

    final rawRelativeX = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final normalizedX = (rawRelativeX - padding) / draggableRange;

    final adjustedRelativeX =
        HydroGlassNavBarPhysics.applyRubberBandResistance(normalizedX);
    return (adjustedRelativeX * 2) - 1;
  }

  void _onDragDown(DragDownDetails details) {
    setState(() {
      _isDown = true;
      _xAlign = _getAlignmentFromGlobalPosition(details.globalPosition);
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      _xAlign = _getAlignmentFromGlobalPosition(details.globalPosition);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _isDown = false;
    });

    final box = context.findRenderObject()! as RenderBox;
    final currentRelativeX = (_xAlign + 1) / 2;
    final itemWidth = 1.0 / widget.itemCount;

    final indicatorWidth = 1.0 / widget.itemCount;
    final draggableRange = 1.0 - indicatorWidth;
    final velocityX =
        (details.velocity.pixelsPerSecond.dx / box.size.width) / draggableRange;

    final targetIndex = HydroGlassNavBarPhysics.computeTargetIndex(
      currentRelativeX: currentRelativeX,
      velocityX: velocityX,
      itemWidth: itemWidth,
      itemCount: widget.itemCount,
    );

    _xAlign = HydroGlassNavBarPhysics.computeAlignment(
      targetIndex,
      widget.itemCount,
    );

    if (targetIndex != widget.currentIndex) {
      widget.onIndexChanged(targetIndex);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isDragging) return;

    final box = context.findRenderObject()! as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final tappedRelativeX = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final itemWidth = 1.0 / widget.itemCount;
    final tappedIndex = (tappedRelativeX / itemWidth).floor().clamp(
          0,
          widget.itemCount - 1,
        );

    if (tappedIndex != widget.currentIndex) {
      widget.onIndexChanged(tappedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final indicatorColor =
        widget.indicatorColor ?? colorScheme.onSurface.withValues(alpha: .1);

    final targetAlignment = HydroGlassNavBarPhysics.computeAlignment(
      widget.currentIndex,
      widget.itemCount,
    );

    return GestureDetector(
      onTapUp: _onTapUp,
      onHorizontalDragDown: _onDragDown,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onHorizontalDragCancel: () => setState(() {
        _isDragging = false;
        _isDown = false;
      }),
      child: VelocityMotionBuilder(
        converter: const SingleMotionConverter(),
        value: _xAlign,
        motion: _isDragging
            ? const Motion.interactiveSpring(snapToEnd: true)
            : const Motion.bouncySpring(snapToEnd: true),
        builder: (context, value, velocity, child) {
          final alignment = Alignment(value, 0);

          return SingleMotionBuilder(
            motion: const Motion.snappySpring(
              snapToEnd: true,
              duration: Duration(milliseconds: 300),
            ),
            value: widget.visible &&
                    (_isDown || (alignment.x - targetAlignment).abs() > 0.30)
                ? 1.0
                : 0.0,
            builder: (context, thickness, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Glass bar background
                  if (widget.useLiquidGlass)
                    const Positioned.fill(
                      child: LiquidGlass.grouped(
                        clipBehavior: Clip.none,
                        shape: _barShape,
                        child: SizedBox.expand(),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_barBorderRadius),
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
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Background indicator
                  if (thickness < 1)
                    _GlassIndicator(
                      velocity: velocity,
                      itemCount: widget.itemCount,
                      alignment: alignment,
                      thickness: thickness,
                      indicatorColor: indicatorColor,
                      isBackgroundIndicator: true,
                      useLiquidGlass: widget.useLiquidGlass,
                      colorScheme: colorScheme,
                    ),

                  // Glass indicator
                  if (thickness > 0)
                    _GlassIndicator(
                      velocity: velocity,
                      itemCount: widget.itemCount,
                      alignment: alignment,
                      thickness: thickness,
                      indicatorColor: indicatorColor,
                      isBackgroundIndicator: false,
                      useLiquidGlass: widget.useLiquidGlass,
                      colorScheme: colorScheme,
                    ),

                  // Nav bar content
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    height: 64,
                    child: child!,
                  ),
                ],
              );
            },
            child: widget.child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Interactive indicator with physics and animations.
class _GlassIndicator extends StatelessWidget {
  const _GlassIndicator({
    required this.velocity,
    required this.itemCount,
    required this.alignment,
    required this.thickness,
    required this.indicatorColor,
    required this.isBackgroundIndicator,
    required this.useLiquidGlass,
    required this.colorScheme,
  });

  final double velocity;
  final int itemCount;
  final Alignment alignment;
  final double thickness;
  final Color indicatorColor;
  final bool isBackgroundIndicator;
  final bool useLiquidGlass;
  final ColorScheme colorScheme;

  static const _expansion = 14.0;
  static const _borderRadius = 64.0;

  @override
  Widget build(BuildContext context) {
    final rect = RelativeRect.lerp(
      RelativeRect.fill,
      const RelativeRect.fromLTRB(
        -_expansion,
        -_expansion,
        -_expansion,
        -_expansion,
      ),
      thickness,
    );

    Widget indicatorChild;

    if (isBackgroundIndicator) {
      indicatorChild = AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: thickness <= 0.2 ? 1 : 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: const SizedBox.expand(),
        ),
      );
    } else {
      if (useLiquidGlass) {
        indicatorChild = LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            visibility: thickness,
            glassColor: const Color.fromARGB(25, 255, 255, 255),
            saturation: 1.8,
            refractiveIndex: 1.18,
            thickness: 25,
            lightIntensity: 3.0,
            chromaticAberration: 1.0,
            blur: 8,
          ),
          shape: const LiquidRoundedSuperellipse(borderRadius: _borderRadius),
          child: const GlassGlow(child: SizedBox.expand()),
        );
      } else {
        indicatorChild = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.3 * thickness),
                colorScheme.primary.withValues(alpha: 0.2 * thickness),
              ],
            ),
          ),
        );
      }
    }

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: FractionallySizedBox(
                widthFactor: 1 / itemCount,
                alignment: alignment,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fromRelativeRect(
                      rect: rect!,
                      child: RepaintBoundary(
                        child: SingleMotionBuilder(
                          motion: const Motion.bouncySpring(
                            duration: Duration(milliseconds: 600),
                          ),
                          value: velocity,
                          builder: (context, velocity, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform:
                                  HydroGlassNavBarPhysics.buildJellyTransform(
                                velocity: velocity,
                              ),
                              child: child,
                            );
                          },
                          child: indicatorChild,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
