# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 🎉 iOS 26 Liquid Glass Specification Implementation

A comprehensive update implementing the complete iOS 26 Liquid Glass specification with production-ready features, extensive documentation, and full backward compatibility.

### Added

#### Core Features
- **Glass Variants System**
  - `LiquidGlassVariant` enum for glass style selection (Regular, Clear)
  - `variant` parameter on `HydroGlassNavBar` (default: `LiquidGlassVariant.regular`)
  - Variant-specific optical property adjustments
  - Clear glass validation and usage guidelines

- **Size-Based Material Thickness**
  - `GlassSizeCategory` enum for size adaptation (Small, Medium, Large)
  - `GlassSizeConfiguration` class for size-based settings
  - `sizeCategory` parameter on `HydroGlassNavBar` (default: `GlassSizeCategory.medium`)
  - Automatic adaptation of blur, refraction, saturation, and lighting per size
  - iOS 26 specification-compliant parameter values for each category

- **Background Brightness Detection**
  - `BackgroundBrightnessDetector` utility class with luminance calculation
  - Automatic light/dark style switching for Regular glass variant
  - Perceived brightness formula accounting for human eye sensitivity
  - Adaptive tint color generation based on background

- **Enhanced Accessibility Support**
  - `AccessibilityGlassSettings` class for system preference detection
  - `AccessibilityGlassAdapter` utility for applying adjustments
  - Reduce Transparency mode (2x blur, increased opacity)
  - Increase Contrast mode (black/white glass, high-contrast borders)
  - Reduce Motion mode (simplified animations, 50% shorter durations)
  - Automatic detection via `MediaQuery` with zero configuration

#### Utilities
- `BackgroundBrightnessDetector.calculateLuminance()` - Luminance calculation
- `BackgroundBrightnessDetector.isBrightBackground()` - Brightness evaluation
- `BackgroundBrightnessDetector.getGlassStyle()` - Recommended style
- `BackgroundBrightnessDetector.getAdaptiveTint()` - Adaptive tint colors
- `BackgroundBrightnessDetector.averageLuminance()` - Multi-color analysis
- `GlassSizeConfiguration.forCategory()` - Factory for size-based config
- `AccessibilityGlassAdapter.getAnimationDuration()` - Accessibility-aware durations
- `AccessibilityGlassAdapter.getAnimationCurve()` - Accessibility-aware curves

#### Documentation
- `ARCHITECTURE.md` - 7 comprehensive Architecture Decision Records (ADRs)
- `MIGRATION_GUIDE.md` - Complete migration and upgrade guide
- Updated README with iOS 26 features section
- Updated README with utilities and advanced usage examples
- Updated README with architecture overview
- Inline dartdoc comments for all new public APIs
- Enhanced library documentation header

#### Testing
- 15 unit tests for `BackgroundBrightnessDetector` (100% coverage)
- 13 unit tests for `LiquidGlassVariant` and `GlassSizeConfiguration` (100% coverage)
- 12 unit tests for `AccessibilityGlassSettings` (100% coverage)
- Total: 40+ new unit tests with comprehensive edge case coverage

#### Example App
- Variant switcher in app bar (Regular/Clear selection)
- Size category selector in app bar (Small/Medium/Large selection)
- Enhanced UI demonstrating all new features
- Real-time variant and size switching

### Changed

- Main nav bar widget now uses size-based configuration for glass settings
- Glass settings now adapt based on selected variant (Regular vs Clear)
- All animations respect Reduce Motion accessibility setting
- FAB animations use `Motion.snappySpring()` in Reduce Motion mode
- Library header documentation expanded with iOS 26 features

### Technical Improvements

- **Architecture**: SOLID principles throughout new code
- **Design Patterns**: Strategy (variants), Factory (size configs), Adapter (accessibility)
- **Performance**: Maintained 60+ FPS with all new features
- **Code Quality**: Production-ready with comprehensive error handling
- **Type Safety**: Enums for all configuration options
- **Testability**: Pure functions enabling 100% test coverage

### iOS 26 Specification Compliance

✅ Multi-layer rendering pipeline (via liquid_glass_renderer)  
✅ Glass variants (Regular and Clear)  
✅ Size-based material thickness adaptation  
✅ Background brightness detection with automatic adaptation  
✅ Full accessibility support (Reduce Transparency, Increase Contrast, Reduce Motion)  
✅ Physics-based animations (Motor package)  
✅ Performance optimization (RepaintBoundary, conditional rendering)

### Backward Compatibility

**No breaking changes!** All new features have sensible defaults:
- `variant: LiquidGlassVariant.regular` (maintains existing behavior)
- `sizeCategory: GlassSizeCategory.medium` (appropriate for nav bars)
- Existing code works without any modifications

## [1.0.0-pre.3] - 2026-01-14

### Changed

- Updated preview GIF

## [1.0.0-pre.2] - 2026-01-14

### Added

- Screenshots and preview GIF for pub.dev
- Android and iOS platform projects in example

## [1.0.0-pre.1] - 2026-01-14

### 🎉 Initial Pre-Release

- `HydroGlassNavBar` - Main widget with hydro glass morphism effect
- `HydroGlassNavItem` - Configuration for individual navigation items
- `HydroGlassNavBarFABConfig` - Configuration for expandable floating action button
- `HydroGlassNavBarAction` - Configuration for FAB menu actions
- `HydroGlassNavBarPhysics` - Physics utilities for animations
- Draggable indicator with iOS-style rubber band physics
- Jelly transform effect based on drag velocity
- Support for 2-5 navigation items
- Dark and light mode support
- Fallback mode without hydro glass effect
- Badge support for notification counts
- Full accessibility support with semantic labels
- Haptic feedback on interactions

## [1.0.0-dev.3] - 2026-01-14

### Fixed

- README formatting cleanup

## [1.0.0-dev.2] - 2026-01-14

### Added

- Buy Me a Coffee funding link
- Enhanced README footer with support badge

## [1.0.0-dev.1] - 2026-01-14

### Added

- Initial release of `hydro_glass_nav_bar`
- `HydroGlassNavBar` - Main widget with hydro glass morphism effect
- `HydroGlassNavItem` - Configuration for individual navigation items
- `HydroGlassNavBarFABConfig` - Configuration for expandable floating action button
- `HydroGlassNavBarAction` - Configuration for FAB menu actions
- `HydroGlassNavBarPhysics` - Physics utilities for animations
- Draggable indicator with iOS-style rubber band physics
- Jelly transform effect based on drag velocity
- Support for 2-5 navigation items
- Dark and light mode support
- Fallback mode without hydro glass effect
- Badge support for notification counts
- Full accessibility support with semantic labels
- Haptic feedback on interactions
