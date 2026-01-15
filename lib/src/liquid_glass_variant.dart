part of '../hydro_glass_nav_bar.dart';

/// Defines the style variant of the Liquid Glass effect.
///
/// Liquid Glass supports two primary variants as defined in the iOS 26
/// specification:
/// - [regular]: Fully adaptive glass that adjusts to any content
/// - [clear]: More transparent variant that requires content dimming
///
/// {@category Configuration}
enum LiquidGlassVariant {
  /// The default variant that provides guaranteed legibility in all situations.
  ///
  /// **Regular glass** features:
  /// - Full adaptive behaviors (automatic light/dark switching)
  /// - Size-based material thickness adaptation
  /// - Works over any content without special requirements
  /// - Provides optimal contrast and legibility
  ///
  /// **Use Regular glass for:**
  /// - Navigation bars and tab bars
  /// - Toolbars and control panels
  /// - Buttons and interactive elements
  /// - Any UI where legibility is critical
  regular,

  /// A more transparent variant that shows richer background content.
  ///
  /// **Clear glass** characteristics:
  /// - More transparent than Regular glass
  /// - Does not automatically flip between light/dark styles
  /// - Maintains consistent appearance across backgrounds
  /// - **Requires dimming layer** beneath the glass for contrast
  /// - **Requires bold, high-contrast content** on the glass
  ///
  /// **Use Clear glass ONLY when:**
  /// 1. Element is over **media-rich content** (photos, videos, artwork)
  /// 2. Content layer can accept a **dimming overlay** without negative impact
  /// 3. Content on glass is **bold and bright** (thick icons, high-contrast text)
  ///
  /// **Example use cases:**
  /// - Controls overlaid on photo/video galleries
  /// - Playback controls on media players
  /// - Lock screen elements on photo wallpapers
  clear,
}

/// Defines size categories for glass elements, which determine material
/// thickness and optical properties.
///
/// According to the iOS 26 specification, glass appearance adapts based on
/// element size to create appropriate visual weight and hierarchy.
///
/// {@category Configuration}
enum GlassSizeCategory {
  /// Small elements like buttons and nav bar items.
  ///
  /// **Characteristics:**
  /// - Refraction: Moderate (~1.21)
  /// - Blur: Light (6-8px)
  /// - Shadow: Subtle, soft
  /// - Feels lightweight and responsive
  ///
  /// **Typical height:** < 60px
  small,

  /// Medium elements like toolbars and tab bars.
  ///
  /// **Characteristics:**
  /// - Refraction: Medium (~1.35)
  /// - Blur: Standard (8-10px)
  /// - Shadow: Defined but soft
  ///
  /// **Typical height:** 60-100px
  medium,

  /// Large elements like menus, sheets, and sidebars.
  ///
  /// **Characteristics:**
  /// - Refraction: Strong (~1.5)
  /// - Blur: Heavy (10-14px)
  /// - Shadow: Deep, rich, with color bleeding
  /// - Specular highlights more pronounced
  /// - Feels substantial and grounded
  ///
  /// **Typical height:** > 100px
  large,
}

/// Configuration that determines glass visual properties based on size.
///
/// This class encapsulates the iOS 26 specification's size-based adaptation
/// rules, providing appropriate optical properties for different element sizes.
///
/// {@category Configuration}
class GlassSizeConfiguration {
  /// Creates a size configuration with custom values.
  const GlassSizeConfiguration({
    required this.refractiveIndex,
    required this.blur,
    required this.thickness,
    required this.saturation,
    required this.lightIntensity,
    required this.ambientStrength,
  });

  /// Creates configuration for a specific size category.
  ///
  /// This factory applies the iOS 26 specification's recommended values
  /// for each size category.
  factory GlassSizeConfiguration.forCategory(
    GlassSizeCategory category, {
    bool isDark = false,
  }) {
    switch (category) {
      case GlassSizeCategory.small:
        return GlassSizeConfiguration(
          refractiveIndex: 1.21,
          blur: 7,
          thickness: 25,
          saturation: 1.4,
          lightIntensity: isDark ? 0.6 : 0.9,
          ambientStrength: isDark ? 0.15 : 0.4,
        );
      case GlassSizeCategory.medium:
        return GlassSizeConfiguration(
          refractiveIndex: 1.35,
          blur: 9,
          thickness: 30,
          saturation: 1.5,
          lightIntensity: isDark ? 0.7 : 1.0,
          ambientStrength: isDark ? 0.2 : 0.5,
        );
      case GlassSizeCategory.large:
        return GlassSizeConfiguration(
          refractiveIndex: 1.5,
          blur: 12,
          thickness: 40,
          saturation: 1.6,
          lightIntensity: isDark ? 0.85 : 1.2,
          ambientStrength: isDark ? 0.3 : 0.6,
        );
    }
  }

  /// The refractive index determining light bending strength.
  ///
  /// Values typically range from 1.21 (light refraction) to 1.5 (strong).
  final double refractiveIndex;

  /// The blur radius in pixels.
  ///
  /// Small elements use lighter blur (6-8px), large elements use heavier
  /// blur (10-14px).
  final double blur;

  /// The material thickness value.
  ///
  /// Affects the depth and richness of the glass effect.
  final double thickness;

  /// The saturation multiplier for content viewed through glass.
  ///
  /// Values typically range from 1.2x to 1.6x.
  final double saturation;

  /// The intensity of specular highlights.
  ///
  /// Adjusted based on theme brightness (lower in dark mode).
  final double lightIntensity;

  /// The strength of ambient light reflection.
  ///
  /// Adjusted based on theme brightness (lower in dark mode).
  final double ambientStrength;
}
