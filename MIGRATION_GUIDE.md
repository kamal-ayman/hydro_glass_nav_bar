# Migration Guide - iOS 26 Liquid Glass Features

This guide helps you upgrade from earlier versions and take advantage of the new iOS 26 Liquid Glass features.

## Overview of Changes

Version 1.0.0 introduces comprehensive iOS 26 Liquid Glass specification compliance with:
- Glass variants (Regular and Clear)
- Size-based material thickness adaptation
- Background brightness detection
- Enhanced accessibility support
- New utility classes for custom implementations

## Breaking Changes

**None!** All changes are backward compatible. Existing code continues to work without modifications.

## New Features (Optional)

### 1. Glass Variants

**What's New:**
Choose between Regular (fully adaptive) and Clear (transparent) glass styles.

**Migration:**
```dart
// Before (still works)
HydroGlassNavBar(
  controller: controller,
  items: items,
)

// After (with new variant parameter)
HydroGlassNavBar(
  controller: controller,
  items: items,
  variant: LiquidGlassVariant.regular, // or .clear
)
```

**When to Use Clear Glass:**
- Over media-rich content (photos, videos, artwork)
- When content beneath can accept a dimming overlay
- When using bold, high-contrast icons/text

**Default:** `LiquidGlassVariant.regular` (maintains existing behavior)

### 2. Size-Based Material Thickness

**What's New:**
Glass optical properties (blur, refraction, saturation) now adapt based on element size category.

**Migration:**
```dart
// Before (still works)
HydroGlassNavBar(
  controller: controller,
  items: items,
)

// After (with size category)
HydroGlassNavBar(
  controller: controller,
  items: items,
  sizeCategory: GlassSizeCategory.medium, // small, medium, or large
)
```

**Size Guidelines:**
- **Small** (`GlassSizeCategory.small`): Height < 60px - buttons, small controls
- **Medium** (`GlassSizeCategory.medium`): Height 60-100px - nav bars, toolbars (default)
- **Large** (`GlassSizeCategory.large`): Height > 100px - menus, sheets, sidebars

**Default:** `GlassSizeCategory.medium` (appropriate for nav bars)

### 3. Background Brightness Detection

**What's New:**
For Regular glass variant, the nav bar automatically detects background brightness and adapts its style for optimal contrast.

**Migration:**
No code changes needed! This feature works automatically when using `LiquidGlassVariant.regular`.

**How It Works:**
- Analyzes `Theme.of(context).scaffoldBackgroundColor`
- Uses perceived luminance calculation (accounts for human eye sensitivity)
- Automatically switches between light/dark glass styles
- Ensures optimal legibility on any background

**To Use:**
```dart
HydroGlassNavBar(
  variant: LiquidGlassVariant.regular, // Enable automatic adaptation
  // ... other parameters
)
```

**To Disable:**
Use Clear glass variant or set `useLiquidGlass: false`.

### 4. Enhanced Accessibility

**What's New:**
Full support for system accessibility modes:
- Reduce Transparency
- Increase Contrast
- Reduce Motion

**Migration:**
No code changes needed! Accessibility features are detected and applied automatically via `MediaQuery`.

**What Changes:**
- **Reduce Transparency**: Glass becomes frostier (2x blur, increased opacity)
- **Increase Contrast**: Glass becomes black/white with high-contrast borders
- **Reduce Motion**: Animations simplified (50% shorter, easeOut curves instead of springs)

**Testing Accessibility:**
```dart
// Simulate accessibility modes in development
MediaQuery(
  data: MediaQueryData(
    highContrast: true,     // Triggers Reduce Transparency & Increase Contrast
    disableAnimations: true, // Triggers Reduce Motion
  ),
  child: YourApp(),
)
```

## New Utility Classes

### BackgroundBrightnessDetector

Utility for brightness detection and adaptive styling.

**Use Cases:**
- Custom glass implementations
- Determining appropriate text colors
- Creating your own adaptive UI elements

**Example:**
```dart
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

// Calculate luminance (0.0 = black, 1.0 = white)
final luminance = BackgroundBrightnessDetector.calculateLuminance(
  backgroundColor,
);

// Check if background is bright
final isBright = BackgroundBrightnessDetector.isBrightBackground(
  backgroundColor,
);

// Get recommended glass style
final glassStyle = BackgroundBrightnessDetector.getGlassStyle(
  backgroundColor,
);

// Get adaptive tint color
final tintColor = BackgroundBrightnessDetector.getAdaptiveTint(
  backgroundColor,
  baseOpacity: 0.1,
);
```

### GlassSizeConfiguration

Access size-based configurations programmatically.

**Use Cases:**
- Custom glass implementations
- Understanding size-based parameters
- Creating custom size categories

**Example:**
```dart
// Get configuration for a size category
final config = GlassSizeConfiguration.forCategory(
  GlassSizeCategory.large,
  isDark: Theme.of(context).brightness == Brightness.dark,
);

print('Refractive Index: ${config.refractiveIndex}'); // 1.5
print('Blur: ${config.blur}'); // 12.0
print('Thickness: ${config.thickness}'); // 40.0

// Create custom configuration
const customConfig = GlassSizeConfiguration(
  refractiveIndex: 1.4,
  blur: 10,
  thickness: 35,
  saturation: 1.3,
  lightIntensity: 0.8,
  ambientStrength: 0.4,
);
```

### AccessibilityGlassSettings

Detect and respond to accessibility preferences.

**Use Cases:**
- Custom UI elements with accessibility support
- Conditional rendering based on accessibility modes
- Debugging accessibility behavior

**Example:**
```dart
final settings = AccessibilityGlassSettings.fromMediaQuery(
  MediaQuery.of(context),
);

if (settings.reduceMotion) {
  // Use simple animations
  return AnimatedContainer(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOut,
    // ...
  );
}

// Get adjusted animation parameters
final duration = AccessibilityGlassAdapter.getAnimationDuration(
  const Duration(milliseconds: 400),
  settings.reduceMotion, // Reduces to 200ms if true
);

final curve = AccessibilityGlassAdapter.getAnimationCurve(
  settings.reduceMotion, // Returns Curves.easeOut if true
);
```

## Updating Dependencies

The package now requires:
- Flutter SDK: `>=3.24.0`
- Dart SDK: `>=3.5.0`
- liquid_glass_renderer: `^0.2.0-dev.4`
- motor: `^1.1.0`

Update your `pubspec.yaml`:
```yaml
dependencies:
  hydro_glass_nav_bar: ^1.0.0 # or latest version
```

Run:
```bash
flutter pub upgrade hydro_glass_nav_bar
```

## Best Practices

### 1. Choosing Glass Variants

**Use Regular Glass (default) when:**
- Nav bars and tab bars
- Toolbars and control panels
- Buttons and interactive elements
- Any UI where legibility is critical
- Unsure which variant to use

**Use Clear Glass when:**
- Overlaying photo/video galleries
- Media player controls
- Lock screen elements
- ALL three conditions met:
  1. Over media-rich content
  2. Can apply dimming to background
  3. Using bold, high-contrast content

### 2. Selecting Size Categories

**Small:** Use for individual buttons and small interactive elements
- Height typically < 60px
- Lightweight, responsive feel

**Medium:** Use for nav bars and toolbars (default)
- Height typically 60-100px
- Balanced appearance

**Large:** Use for menus, sheets, and large panels
- Height typically > 100px
- Substantial, grounded feel

### 3. Accessibility Considerations

**Always test with accessibility modes enabled:**
```dart
// Enable in device settings (iOS/Android)
// Or use MediaQuery override in development
```

**Don't override accessibility behaviors** unless absolutely necessary. The package's automatic handling follows platform conventions and user preferences.

### 4. Performance Tips

**Use RepaintBoundary** for custom glass implementations:
```dart
RepaintBoundary(
  child: YourCustomGlassWidget(),
)
```

**Consider useLiquidGlass flag** for performance-critical scenarios:
```dart
HydroGlassNavBar(
  useLiquidGlass: performanceMode ? false : true,
  // ...
)
```

**Trust the package's optimizations** - already includes:
- RepaintBoundary isolation
- Conditional rendering
- GPU-accelerated effects
- Efficient state management

## Testing Your Migration

### 1. Visual Testing

Test with different themes and backgrounds:
```dart
// Light theme
ThemeMode.light

// Dark theme
ThemeMode.dark

// Different background colors
scaffoldBackgroundColor: Colors.white / Colors.black / Colors.blue
```

### 2. Accessibility Testing

Enable and test each accessibility mode:
- iOS Settings → Accessibility → Display → Reduce Transparency
- iOS Settings → Accessibility → Display → Increase Contrast
- iOS Settings → Accessibility → Motion → Reduce Motion

### 3. Size Testing

Try each size category:
```dart
sizeCategory: GlassSizeCategory.small
sizeCategory: GlassSizeCategory.medium
sizeCategory: GlassSizeCategory.large
```

Verify optical properties look appropriate for your use case.

### 4. Variant Testing

Test both variants:
```dart
variant: LiquidGlassVariant.regular
variant: LiquidGlassVariant.clear
```

Ensure Clear glass has appropriate dimming and high-contrast content.

## Common Issues & Solutions

### Issue: Clear glass is hard to read

**Solution:** Ensure you're meeting all three requirements:
1. Media-rich background (not plain colors)
2. Dimming layer applied beneath glass
3. Bold, high-contrast icons/text on glass

If not, use Regular glass variant instead.

### Issue: Glass doesn't adapt to background

**Solution:** Ensure you're using `LiquidGlassVariant.regular`:
```dart
HydroGlassNavBar(
  variant: LiquidGlassVariant.regular, // Enables adaptation
  // ...
)
```

Clear glass doesn't auto-adapt (by design).

### Issue: Animations still bouncy in Reduce Motion mode

**Solution:** Ensure you're not overriding accessibility settings. The package detects and respects Reduce Motion automatically. Check:
1. System accessibility settings are correctly enabled
2. No custom motion overrides in your code
3. Using latest package version

### Issue: Size category doesn't seem to change anything

**Solution:** The differences are subtle and primarily affect:
- Blur radius (6-12px range)
- Refractive index (1.21-1.5 range)
- Saturation boost (1.4x-1.6x)

View in different lighting and over varied backgrounds to see the effect. Consider using the example app for side-by-side comparison.

## Need Help?

- **Documentation**: See README.md for full feature documentation
- **Architecture**: See ARCHITECTURE.md for design decisions
- **Issues**: https://github.com/kamal-ayman/hydro_glass_nav_bar/issues
- **Examples**: Check the example/ directory for working code

## What's Next?

Future enhancements being considered:
- Widget tests and integration tests
- Golden tests for visual regression
- Performance benchmarking tools
- Additional glass variants
- Enhanced pixel-based brightness detection
- Custom animation curves

Stay tuned for updates!
