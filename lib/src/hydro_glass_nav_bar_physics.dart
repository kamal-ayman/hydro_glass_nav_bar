part of '../hydro_glass_nav_bar.dart';

/// Physics and animation utilities for the hydro glass navigation bar.
///
/// This class provides static methods for computing physics-based animations
/// including iOS-style rubber band resistance, jelly transform effects, and
/// item index calculations based on drag velocity.
///
/// {@category Utilities}
class HydroGlassNavBarPhysics {
  HydroGlassNavBarPhysics._();

  /// Applies iOS-style rubber band resistance when dragging beyond edges.
  ///
  /// When [value] is outside the 0.0-1.0 range, this method applies a
  /// resistance factor to create the "bouncy" feel of iOS scroll views.
  ///
  /// Parameters:
  /// - [value]: The current normalized position (0.0 to 1.0)
  /// - [resistance]: How much to resist overdrag (default: 0.4)
  /// - [maxOverdrag]: Maximum overdrag distance (default: 0.3)
  ///
  /// Returns the adjusted value with rubber band resistance applied.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // If value is 1.2 (20% past the end)
  /// final adjusted = HydroGlassNavBarPhysics.applyRubberBandResistance(1.2);
  /// // Returns ~1.08 (resisted overdrag)
  /// ```
  static double applyRubberBandResistance(
    double value, {
    double resistance = 0.4,
    double maxOverdrag = 0.3,
  }) {
    if (value < 0) {
      final overdrag = -value;
      final resistedOverdrag = overdrag * resistance;
      return -resistedOverdrag.clamp(0.0, maxOverdrag);
    } else if (value > 1) {
      final overdrag = value - 1;
      final resistedOverdrag = overdrag * resistance;
      return 1 + resistedOverdrag.clamp(0.0, maxOverdrag);
    }
    return value;
  }

  /// Creates a jelly transform matrix based on velocity.
  ///
  /// This creates a squash-and-stretch effect that makes the indicator
  /// feel organic and fluid during drag operations.
  ///
  /// Parameters:
  /// - [velocity]: The current drag velocity
  /// - [maxDistortion]: Maximum distortion factor (default: 0.8)
  /// - [velocityScale]: Scale factor for velocity (default: 10)
  ///
  /// Returns a [Matrix4] with the jelly transform applied.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final transform = HydroGlassNavBarPhysics.buildJellyTransform(
  ///   velocity: 5.0,
  /// );
  /// // Returns a matrix that squashes horizontally and stretches vertically
  /// ```
  static Matrix4 buildJellyTransform({
    required double velocity,
    double maxDistortion = 0.8,
    double velocityScale = 10,
  }) {
    final speed = velocity.abs();
    if (speed == 0) return Matrix4.identity();

    final distortionFactor =
        (speed / velocityScale).clamp(0.0, 1.0) * maxDistortion;

    final squashX = 1.0 - (distortionFactor * 0.5);
    final stretchY = 1.0 + (distortionFactor * 0.3);

    return Matrix4.diagonal3Values(squashX, stretchY, 1.0);
  }

  /// Converts item index to horizontal alignment (-1 to 1).
  ///
  /// This is used to position the indicator widget using [Alignment].
  ///
  /// Parameters:
  /// - [index]: The item index (0-based)
  /// - [itemCount]: Total number of items
  ///
  /// Returns an alignment value from -1.0 (leftmost) to 1.0 (rightmost).
  ///
  /// ## Example
  ///
  /// ```dart
  /// // For a 3-item nav bar
  /// computeAlignment(0, 3); // Returns -1.0 (left)
  /// computeAlignment(1, 3); // Returns 0.0 (center)
  /// computeAlignment(2, 3); // Returns 1.0 (right)
  /// ```
  static double computeAlignment(int index, int itemCount) {
    final relativeIndex = (index / (itemCount - 1)).clamp(0.0, 1.0);
    return (relativeIndex * 2) - 1;
  }

  /// Computes target item based on drag position and velocity.
  ///
  /// This method determines which item should be selected when the user
  /// releases the drag, taking into account both position and momentum.
  ///
  /// Parameters:
  /// - [currentRelativeX]: Current position (0.0 to 1.0)
  /// - [velocityX]: Horizontal velocity of the drag
  /// - [itemWidth]: Width of each nav item (1.0 / itemCount)
  /// - [itemCount]: Total number of items
  /// - [velocityThreshold]: Minimum velocity to trigger momentum (default: 0.5)
  /// - [projectionTime]: Time to project velocity forward (default: 0.3)
  ///
  /// Returns the index of the target item (0-based).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final target = HydroGlassNavBarPhysics.computeTargetIndex(
  ///   currentRelativeX: 0.3,
  ///   velocityX: 2.0, // Moving right with momentum
  ///   itemWidth: 0.333,
  ///   itemCount: 3,
  /// );
  /// // Returns 1 or 2 depending on velocity
  /// ```
  static int computeTargetIndex({
    required double currentRelativeX,
    required double velocityX,
    required double itemWidth,
    required int itemCount,
    double velocityThreshold = 0.5,
    double projectionTime = 0.3,
  }) {
    if (currentRelativeX < 0) return 0;
    if (currentRelativeX > 1) return itemCount - 1;

    if (velocityX.abs() > velocityThreshold) {
      final projectedX = (currentRelativeX + velocityX * projectionTime).clamp(
        0.0,
        1.0,
      );
      var targetIndex = (projectedX / itemWidth).round().clamp(
            0,
            itemCount - 1,
          );

      final currentIndex = (currentRelativeX / itemWidth).round().clamp(
            0,
            itemCount - 1,
          );

      if (velocityX > velocityThreshold &&
          targetIndex <= currentIndex &&
          currentIndex < itemCount - 1) {
        targetIndex = currentIndex + 1;
      } else if (velocityX < -velocityThreshold &&
          targetIndex >= currentIndex &&
          currentIndex > 0) {
        targetIndex = currentIndex - 1;
      }

      return targetIndex;
    }

    return (currentRelativeX / itemWidth).round().clamp(0, itemCount - 1);
  }
}
