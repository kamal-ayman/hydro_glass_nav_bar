import 'package:flutter_test/flutter_test.dart';
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

void main() {
  group('LiquidGlassVariant', () {
    test('has regular variant', () {
      expect(LiquidGlassVariant.regular, isNotNull);
    });

    test('has clear variant', () {
      expect(LiquidGlassVariant.clear, isNotNull);
    });

    test('variants are distinct', () {
      expect(
        LiquidGlassVariant.regular,
        isNot(equals(LiquidGlassVariant.clear)),
      );
    });
  });

  group('GlassSizeCategory', () {
    test('has all size categories', () {
      expect(GlassSizeCategory.small, isNotNull);
      expect(GlassSizeCategory.medium, isNotNull);
      expect(GlassSizeCategory.large, isNotNull);
    });

    test('categories are distinct', () {
      expect(
        GlassSizeCategory.small,
        isNot(equals(GlassSizeCategory.medium)),
      );
      expect(
        GlassSizeCategory.medium,
        isNot(equals(GlassSizeCategory.large)),
      );
    });
  });

  group('GlassSizeConfiguration', () {
    group('forCategory factory', () {
      test('creates small configuration', () {
        final config =
            GlassSizeConfiguration.forCategory(GlassSizeCategory.small);

        expect(config.refractiveIndex, equals(1.21));
        expect(config.blur, equals(7));
        expect(config.thickness, equals(25));
        expect(config.saturation, equals(1.4));
      });

      test('creates medium configuration', () {
        final config =
            GlassSizeConfiguration.forCategory(GlassSizeCategory.medium);

        expect(config.refractiveIndex, equals(1.35));
        expect(config.blur, equals(9));
        expect(config.thickness, equals(30));
        expect(config.saturation, equals(1.5));
      });

      test('creates large configuration', () {
        final config =
            GlassSizeConfiguration.forCategory(GlassSizeCategory.large);

        expect(config.refractiveIndex, equals(1.5));
        expect(config.blur, equals(12));
        expect(config.thickness, equals(40));
        expect(config.saturation, equals(1.6));
      });

      test('applies progressive values from small to large', () {
        final small =
            GlassSizeConfiguration.forCategory(GlassSizeCategory.small);
        final medium =
            GlassSizeConfiguration.forCategory(GlassSizeCategory.medium);
        final large =
            GlassSizeConfiguration.forCategory(GlassSizeCategory.large);

        // Refraction increases with size
        expect(small.refractiveIndex, lessThan(medium.refractiveIndex));
        expect(medium.refractiveIndex, lessThan(large.refractiveIndex));

        // Blur increases with size
        expect(small.blur, lessThan(medium.blur));
        expect(medium.blur, lessThan(large.blur));

        // Thickness increases with size
        expect(small.thickness, lessThan(medium.thickness));
        expect(medium.thickness, lessThan(large.thickness));

        // Saturation increases with size
        expect(small.saturation, lessThan(medium.saturation));
        expect(medium.saturation, lessThan(large.saturation));
      });

      test('adjusts light intensity for dark mode', () {
        final lightConfig = GlassSizeConfiguration.forCategory(
          GlassSizeCategory.medium,
          isDark: false,
        );
        final darkConfig = GlassSizeConfiguration.forCategory(
          GlassSizeCategory.medium,
          isDark: true,
        );

        // Dark mode should have lower light intensity
        expect(darkConfig.lightIntensity, lessThan(lightConfig.lightIntensity));
        expect(
          darkConfig.ambientStrength,
          lessThan(lightConfig.ambientStrength),
        );
      });
    });

    test('custom configuration accepts all parameters', () {
      const config = GlassSizeConfiguration(
        refractiveIndex: 1.4,
        blur: 10,
        thickness: 35,
        saturation: 1.3,
        lightIntensity: 0.8,
        ambientStrength: 0.4,
      );

      expect(config.refractiveIndex, equals(1.4));
      expect(config.blur, equals(10));
      expect(config.thickness, equals(35));
      expect(config.saturation, equals(1.3));
      expect(config.lightIntensity, equals(0.8));
      expect(config.ambientStrength, equals(0.4));
    });
  });
}
