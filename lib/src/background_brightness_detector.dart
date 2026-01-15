part of '../hydro_glass_nav_bar.dart';

/// Utility class for detecting background brightness beneath glass elements.
///
/// This implements the iOS 26 specification's brightness detection algorithm,
/// which enables automatic light/dark style switching for small glass elements
/// based on the content beneath them.
///
/// The algorithm uses perceived luminance calculation to determine if the
/// background is light or dark, allowing the glass to maintain optimal
/// contrast and legibility.
///
/// {@category Utilities}
class BackgroundBrightnessDetector {
  BackgroundBrightnessDetector._();

  /// Calculates the perceived luminance of a color.
  ///
  /// Uses the standard formula for human perception:
  /// ```
  /// luminance = (0.299 × R) + (0.587 × G) + (0.114 × B)
  /// ```
  ///
  /// This accounts for the human eye's greater sensitivity to green light
  /// and lesser sensitivity to blue.
  ///
  /// Parameters:
  /// - [color]: The color to analyze
  ///
  /// Returns a value from 0.0 (black) to 1.0 (white).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final luminance = BackgroundBrightnessDetector.calculateLuminance(
  ///   Colors.blue,
  /// );
  /// // Returns ~0.11 (dark blue is perceived as dark)
  /// ```
  static double calculateLuminance(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    return (0.299 * r) + (0.587 * g) + (0.114 * b);
  }

  /// Determines if a color should be considered "bright" for glass styling.
  ///
  /// Uses a threshold of 0.5 luminance:
  /// - Above 0.5: Bright background (use dark glass style)
  /// - At or below 0.5: Dark background (use light glass style)
  ///
  /// Parameters:
  /// - [color]: The background color to evaluate
  /// - [threshold]: Custom threshold value (default: 0.5)
  ///
  /// Returns `true` if the background is bright, `false` if dark.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final isBright = BackgroundBrightnessDetector.isBrightBackground(
  ///   Colors.white,
  /// );
  /// // Returns true (use dark glass style)
  ///
  /// final isDark = BackgroundBrightnessDetector.isBrightBackground(
  ///   Colors.black,
  /// );
  /// // Returns false (use light glass style)
  /// ```
  static bool isBrightBackground(
    Color color, {
    double threshold = 0.5,
  }) {
    return calculateLuminance(color) > threshold;
  }

  /// Determines the appropriate glass style based on background brightness.
  ///
  /// This is the primary method for implementing automatic light/dark
  /// style switching as specified in iOS 26.
  ///
  /// Parameters:
  /// - [backgroundColor]: The color beneath the glass element
  /// - [threshold]: Custom brightness threshold (default: 0.5)
  ///
  /// Returns [Brightness.light] for light glass style (over dark backgrounds)
  /// or [Brightness.dark] for dark glass style (over bright backgrounds).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final glassStyle = BackgroundBrightnessDetector.getGlassStyle(
  ///   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  /// );
  ///
  /// // Use glassStyle to select appropriate tint colors and icon colors
  /// ```
  static Brightness getGlassStyle(
    Color backgroundColor, {
    double threshold = 0.5,
  }) {
    return isBrightBackground(backgroundColor, threshold: threshold)
        ? Brightness.dark // Dark style for bright backgrounds
        : Brightness.light; // Light style for dark backgrounds
  }

  /// Calculates an adaptive tint color based on background brightness.
  ///
  /// This creates a semi-transparent tint that provides appropriate contrast
  /// while maintaining the glass aesthetic.
  ///
  /// Parameters:
  /// - [backgroundColor]: The color beneath the glass
  /// - [baseOpacity]: Base opacity for the tint (default: 0.1)
  ///
  /// Returns a tint color (white or black) with appropriate opacity.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final tintColor = BackgroundBrightnessDetector.getAdaptiveTint(
  ///   Theme.of(context).scaffoldBackgroundColor,
  /// );
  /// // Returns white tint over dark backgrounds, black tint over bright
  /// ```
  static Color getAdaptiveTint(
    Color backgroundColor, {
    double baseOpacity = 0.1,
  }) {
    final isBright = isBrightBackground(backgroundColor);

    if (isBright) {
      // Dark tint over bright backgrounds
      return Colors.black.withOpacity(baseOpacity);
    } else {
      // Light tint over dark backgrounds
      return Colors.white.withOpacity(baseOpacity);
    }
  }

  /// Calculates the average luminance from a list of colors.
  ///
  /// Useful when sampling multiple points in the background to get
  /// a more accurate brightness assessment.
  ///
  /// Parameters:
  /// - [colors]: List of colors to analyze
  ///
  /// Returns the average luminance value from 0.0 to 1.0.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final averageLuminance = BackgroundBrightnessDetector.averageLuminance([
  ///   Colors.white,
  ///   Colors.grey,
  ///   Colors.black,
  /// ]);
  /// // Returns ~0.5 (average of bright, medium, and dark)
  /// ```
  static double averageLuminance(List<Color> colors) {
    if (colors.isEmpty) return 0.5;

    final totalLuminance = colors.fold<double>(
      0.0,
      (sum, color) => sum + calculateLuminance(color),
    );

    return totalLuminance / colors.length;
  }
}
