import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

void main() {
  group('AccessibilityGlassSettings', () {
    test('creates settings with all parameters', () {
      const settings = AccessibilityGlassSettings(
        reduceTransparency: true,
        increaseContrast: false,
        reduceMotion: true,
      );

      expect(settings.reduceTransparency, isTrue);
      expect(settings.increaseContrast, isFalse);
      expect(settings.reduceMotion, isTrue);
    });

    test('fromMediaQuery detects accessibility features', () {
      final mediaQuery = const MediaQueryData(
        highContrast: true,
        disableAnimations: true,
      );

      final settings = AccessibilityGlassSettings.fromMediaQuery(mediaQuery);

      expect(settings.reduceTransparency, isTrue); // Maps from highContrast
      expect(settings.increaseContrast, isTrue); // Maps from highContrast
      expect(settings.reduceMotion, isTrue); // Maps from disableAnimations
    });

    test('fromMediaQuery with no accessibility features', () {
      final mediaQuery = const MediaQueryData(
        highContrast: false,
        disableAnimations: false,
      );

      final settings = AccessibilityGlassSettings.fromMediaQuery(mediaQuery);

      expect(settings.reduceTransparency, isFalse);
      expect(settings.increaseContrast, isFalse);
      expect(settings.reduceMotion, isFalse);
    });

    test('hasAccessibilityEnabled returns true when any feature is enabled', () {
      const settings1 = AccessibilityGlassSettings(
        reduceTransparency: true,
        increaseContrast: false,
        reduceMotion: false,
      );
      expect(settings1.hasAccessibilityEnabled, isTrue);

      const settings2 = AccessibilityGlassSettings(
        reduceTransparency: false,
        increaseContrast: true,
        reduceMotion: false,
      );
      expect(settings2.hasAccessibilityEnabled, isTrue);

      const settings3 = AccessibilityGlassSettings(
        reduceTransparency: false,
        increaseContrast: false,
        reduceMotion: true,
      );
      expect(settings3.hasAccessibilityEnabled, isTrue);
    });

    test('hasAccessibilityEnabled returns false when no features are enabled',
        () {
      const settings = AccessibilityGlassSettings(
        reduceTransparency: false,
        increaseContrast: false,
        reduceMotion: false,
      );
      expect(settings.hasAccessibilityEnabled, isFalse);
    });
  });

  group('AccessibilityGlassAdapter', () {
    group('getAnimationDuration', () {
      test('reduces duration by 50% when reduce motion is enabled', () {
        const baseDuration = Duration(milliseconds: 400);

        final duration = AccessibilityGlassAdapter.getAnimationDuration(
          baseDuration,
          true,
        );

        expect(duration.inMilliseconds, equals(200));
      });

      test('keeps duration unchanged when reduce motion is disabled', () {
        const baseDuration = Duration(milliseconds: 400);

        final duration = AccessibilityGlassAdapter.getAnimationDuration(
          baseDuration,
          false,
        );

        expect(duration, equals(baseDuration));
      });
    });

    group('getAnimationCurve', () {
      test('returns easeOut curve when reduce motion is enabled', () {
        final curve = AccessibilityGlassAdapter.getAnimationCurve(true);
        expect(curve, equals(Curves.easeOut));
      });

      test('returns easeInOutCubic curve when reduce motion is disabled', () {
        final curve = AccessibilityGlassAdapter.getAnimationCurve(false);
        expect(curve, equals(Curves.easeInOutCubic));
      });
    });
  });
}
