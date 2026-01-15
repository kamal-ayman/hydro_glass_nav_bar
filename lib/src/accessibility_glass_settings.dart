part of '../hydro_glass_nav_bar.dart';

/// Configuration for glass effects when accessibility features are enabled.
///
/// This class implements the iOS 26 specification's accessibility requirements,
/// providing appropriate visual adjustments for users who have enabled:
/// - Reduce Transparency
/// - Increase Contrast
/// - Reduce Motion
///
/// {@category Configuration}
class AccessibilityGlassSettings {
  /// Creates accessibility glass settings.
  const AccessibilityGlassSettings({
    required this.reduceTransparency,
    required this.increaseContrast,
    required this.reduceMotion,
  });

  /// Detects system accessibility settings from [MediaQueryData].
  ///
  /// This factory method inspects the platform's accessibility settings
  /// and creates an appropriate configuration.
  ///
  /// Parameters:
  /// - [mediaQuery]: The media query data from the current context
  ///
  /// Returns an [AccessibilityGlassSettings] reflecting system preferences.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final settings = AccessibilityGlassSettings.fromMediaQuery(
  ///   MediaQuery.of(context),
  /// );
  ///
  /// if (settings.reduceMotion) {
  ///   // Use simple fade instead of spring animation
  /// }
  /// ```
  factory AccessibilityGlassSettings.fromMediaQuery(MediaQueryData mediaQuery) {
    return AccessibilityGlassSettings(
      reduceTransparency: mediaQuery.highContrast,
      increaseContrast: mediaQuery.highContrast,
      reduceMotion: mediaQuery.disableAnimations,
    );
  }

  /// Whether Reduce Transparency mode is enabled.
  ///
  /// When `true`, glass elements should:
  /// - Become more opaque (frostier appearance)
  /// - Increase blur intensity (~2x)
  /// - Increase tint opacity (10% → 30-50%)
  /// - Significantly obscure background content
  /// - Maintain glass appearance while improving legibility
  final bool reduceTransparency;

  /// Whether Increase Contrast mode is enabled.
  ///
  /// When `true`, glass elements should:
  /// - Become predominantly black or white
  /// - Add contrasting border (1-2px solid, high contrast color)
  /// - Reduce subtle gradient effects
  /// - Increase shadow opacity and spread
  /// - Simplify highlights to basic solid overlays
  final bool increaseContrast;

  /// Whether Reduce Motion mode is enabled.
  ///
  /// When `true`, animations should:
  /// - Disable elastic/jelly deformations entirely
  /// - Replace spring animations with simple easeOut curves
  /// - Reduce intensity of morphing effects
  /// - Shorten animation durations (~50% reduction)
  /// - Remove parallax/motion-responsive highlights
  /// - Maintain functional animation but remove decorative motion
  final bool reduceMotion;

  /// Whether any accessibility mode is enabled.
  ///
  /// Returns `true` if any of the accessibility features are active.
  bool get hasAccessibilityEnabled =>
      reduceTransparency || increaseContrast || reduceMotion;
}

/// Applies accessibility-aware adjustments to liquid glass settings.
///
/// This class provides methods to modify [LiquidGlassSettings] based on
/// active accessibility modes, ensuring the glass effect remains functional
/// and beautiful while meeting accessibility requirements.
///
/// {@category Utilities}
class AccessibilityGlassAdapter {
  AccessibilityGlassAdapter._();

  /// Adapts liquid glass settings for Reduce Transparency mode.
  ///
  /// When Reduce Transparency is enabled, this method:
  /// - Doubles the blur radius for a frostier appearance
  /// - Increases tint opacity significantly
  /// - Reduces refractive index (less distortion)
  /// - Makes the glass more opaque overall
  ///
  /// Parameters:
  /// - [settings]: The base liquid glass settings
  /// - [glassColor]: The base glass color (opacity will be increased)
  ///
  /// Returns adjusted [LiquidGlassSettings] for better legibility.
  static LiquidGlassSettings reduceTransparency(
    LiquidGlassSettings settings,
    Color glassColor,
  ) {
    // iOS accessibility guidelines suggest 4x opacity increase
    const opacityMultiplier = 4.0;

    return LiquidGlassSettings(
      refractiveIndex: settings.refractiveIndex * 0.7, // Reduce distortion
      thickness: settings.thickness,
      blur: settings.blur * 2, // Double blur for frosted effect
      saturation: settings.saturation,
      lightIntensity: settings.lightIntensity * 0.8,
      ambientStrength: settings.ambientStrength * 0.6,
      lightAngle: settings.lightAngle,
      glassColor: glassColor.withOpacity(
        (glassColor.opacity * opacityMultiplier).clamp(0.0, 1.0),
      ),
    );
  }

  /// Adapts liquid glass settings for Increase Contrast mode.
  ///
  /// When Increase Contrast is enabled, this method:
  /// - Reduces blur for sharper edges
  /// - Increases opacity significantly
  /// - Reduces subtle lighting effects
  /// - Creates more distinct separation from background
  ///
  /// Parameters:
  /// - [settings]: The base liquid glass settings
  /// - [glassColor]: The base glass color
  /// - [isDark]: Whether dark mode is active
  ///
  /// Returns adjusted [LiquidGlassSettings] for maximum contrast.
  static LiquidGlassSettings increaseContrast(
    LiquidGlassSettings settings,
    Color glassColor,
    bool isDark,
  ) {
    // Use predominantly black or white
    final contrastColor = isDark
        ? Colors.black.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.95);

    return LiquidGlassSettings(
      refractiveIndex: 1.0, // Minimal distortion
      thickness: settings.thickness * 0.8,
      blur: settings.blur * 0.5, // Reduce blur
      saturation: 1.0, // Normal saturation
      lightIntensity: 0.3, // Minimal highlights
      ambientStrength: 0.1, // Minimal ambient
      lightAngle: settings.lightAngle,
      glassColor: contrastColor,
    );
  }

  /// Determines the appropriate animation duration based on Reduce Motion setting.
  ///
  /// Parameters:
  /// - [baseDuration]: The normal animation duration
  /// - [reduceMotion]: Whether Reduce Motion is enabled
  ///
  /// Returns the adjusted duration (50% of base if motion is reduced).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final duration = AccessibilityGlassAdapter.getAnimationDuration(
  ///   const Duration(milliseconds: 400),
  ///   reduceMotion: settings.reduceMotion,
  /// );
  /// // Returns 200ms if Reduce Motion is enabled, 400ms otherwise
  /// ```
  static Duration getAnimationDuration(
    Duration baseDuration,
    bool reduceMotion,
  ) {
    return reduceMotion
        ? Duration(milliseconds: (baseDuration.inMilliseconds * 0.5).round())
        : baseDuration;
  }

  /// Determines the appropriate animation curve based on Reduce Motion setting.
  ///
  /// Parameters:
  /// - [reduceMotion]: Whether Reduce Motion is enabled
  ///
  /// Returns [Curves.easeOut] if motion is reduced, [Curves.easeInOutCubic]
  /// otherwise.
  ///
  /// ## Example
  ///
  /// ```dart
  /// AnimatedContainer(
  ///   duration: duration,
  ///   curve: AccessibilityGlassAdapter.getAnimationCurve(
  ///     settings.reduceMotion,
  ///   ),
  ///   // ...
  /// )
  /// ```
  static Curve getAnimationCurve(bool reduceMotion) {
    return reduceMotion ? Curves.easeOut : Curves.easeInOutCubic;
  }
}
