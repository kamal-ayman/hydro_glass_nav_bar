import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

void main() {
  group('BackgroundBrightnessDetector', () {
    group('calculateLuminance', () {
      test('calculates luminance for pure white', () {
        final luminance = BackgroundBrightnessDetector.calculateLuminance(
          Colors.white,
        );
        expect(luminance, equals(1.0));
      });

      test('calculates luminance for pure black', () {
        final luminance = BackgroundBrightnessDetector.calculateLuminance(
          Colors.black,
        );
        expect(luminance, equals(0.0));
      });

      test('calculates luminance for gray', () {
        final luminance = BackgroundBrightnessDetector.calculateLuminance(
          Colors.grey,
        );
        // Grey (0x9E9E9E) should be around 0.62
        expect(luminance, greaterThan(0.6));
        expect(luminance, lessThan(0.65));
      });

      test('calculates luminance using perceived brightness formula', () {
        // Green should be perceived as brighter than red or blue
        final greenLuminance = BackgroundBrightnessDetector.calculateLuminance(
          const Color(0xFF00FF00),
        );
        final redLuminance = BackgroundBrightnessDetector.calculateLuminance(
          const Color(0xFFFF0000),
        );
        final blueLuminance = BackgroundBrightnessDetector.calculateLuminance(
          const Color(0xFF0000FF),
        );

        expect(greenLuminance, greaterThan(redLuminance));
        expect(greenLuminance, greaterThan(blueLuminance));
      });
    });

    group('isBrightBackground', () {
      test('identifies white as bright', () {
        expect(
          BackgroundBrightnessDetector.isBrightBackground(Colors.white),
          isTrue,
        );
      });

      test('identifies black as dark', () {
        expect(
          BackgroundBrightnessDetector.isBrightBackground(Colors.black),
          isFalse,
        );
      });

      test('uses threshold correctly', () {
        const testColor = Color(0xFF808080); // Mid-gray
        final luminance =
            BackgroundBrightnessDetector.calculateLuminance(testColor);

        // With default threshold (0.5)
        final defaultResult =
            BackgroundBrightnessDetector.isBrightBackground(testColor);

        // With custom threshold
        final customResult = BackgroundBrightnessDetector.isBrightBackground(
          testColor,
          threshold: luminance + 0.1,
        );

        // Results should differ based on threshold
        expect(defaultResult, isNot(equals(customResult)));
      });
    });

    group('getGlassStyle', () {
      test('returns dark style for bright backgrounds', () {
        final style = BackgroundBrightnessDetector.getGlassStyle(Colors.white);
        expect(style, equals(Brightness.dark));
      });

      test('returns light style for dark backgrounds', () {
        final style = BackgroundBrightnessDetector.getGlassStyle(Colors.black);
        expect(style, equals(Brightness.light));
      });

      test('respects custom threshold', () {
        const testColor = Color(0xFF888888);
        final luminance =
            BackgroundBrightnessDetector.calculateLuminance(testColor);

        final defaultStyle =
            BackgroundBrightnessDetector.getGlassStyle(testColor);
        final customStyle = BackgroundBrightnessDetector.getGlassStyle(
          testColor,
          threshold: luminance + 0.1,
        );

        // Results should differ based on threshold
        expect(defaultStyle, isNot(equals(customStyle)));
      });
    });

    group('getAdaptiveTint', () {
      test('returns black tint for bright backgrounds', () {
        final tint = BackgroundBrightnessDetector.getAdaptiveTint(Colors.white);
        expect(tint.red, equals(0));
        expect(tint.green, equals(0));
        expect(tint.blue, equals(0));
        expect(tint.opacity, greaterThan(0));
      });

      test('returns white tint for dark backgrounds', () {
        final tint = BackgroundBrightnessDetector.getAdaptiveTint(Colors.black);
        expect(tint.red, equals(255));
        expect(tint.green, equals(255));
        expect(tint.blue, equals(255));
        expect(tint.opacity, greaterThan(0));
      });

      test('respects base opacity parameter', () {
        final tint1 = BackgroundBrightnessDetector.getAdaptiveTint(
          Colors.white,
          baseOpacity: 0.1,
        );
        final tint2 = BackgroundBrightnessDetector.getAdaptiveTint(
          Colors.white,
          baseOpacity: 0.3,
        );

        expect(tint2.opacity, greaterThan(tint1.opacity));
      });
    });

    group('averageLuminance', () {
      test('returns 0.5 for empty list', () {
        final avg = BackgroundBrightnessDetector.averageLuminance([]);
        expect(avg, equals(0.5));
      });

      test('calculates average correctly', () {
        final avg = BackgroundBrightnessDetector.averageLuminance([
          Colors.white, // 1.0
          Colors.black, // 0.0
        ]);
        expect(avg, equals(0.5));
      });

      test('handles multiple colors', () {
        final avg = BackgroundBrightnessDetector.averageLuminance([
          Colors.white,
          Colors.white,
          Colors.black,
        ]);
        // (1.0 + 1.0 + 0.0) / 3 = 0.666...
        expect(avg, closeTo(0.667, 0.01));
      });
    });
  });
}
