/// A beautiful, Apple-style hydro glass floating navigation bar with advanced
/// physics-based animations for Flutter.
///
/// This package implements the complete iOS 26 Liquid Glass specification,
/// providing a premium navigation experience with:
///
/// ## Core Features
///
/// - **Advanced Liquid Glass Morphism** - Multi-layer rendering with refraction,
///   blur, saturation boost, and specular highlights
/// - **Glass Variants** - Regular (adaptive) and Clear (transparent) styles
///   following iOS 26 specification
/// - **Size-Based Adaptation** - Material thickness automatically adjusts for
///   small, medium, and large elements
/// - **Background Brightness Detection** - Automatic light/dark style switching
///   based on content beneath glass
/// - **Full Accessibility Support** - Reduce Transparency, Increase Contrast,
///   and Reduce Motion modes
/// - **Physics-Based Animations** - iOS-style rubber band resistance and jelly
///   transforms using Motor package
/// - **Draggable Indicator** - Swipe between items with smooth animations
/// - **Expandable FAB** - Optional floating action button with action menu
/// - **Performance Optimized** - RepaintBoundary isolation and GPU-accelerated
///   rendering
///
/// ## Getting Started
///
/// ```dart
/// import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';
///
/// class MyHomePage extends StatefulWidget {
///   @override
///   _MyHomePageState createState() => _MyHomePageState();
/// }
///
/// class _MyHomePageState extends State<MyHomePage>
///     with SingleTickerProviderStateMixin {
///   late TabController _tabController;
///
///   @override
///   void initState() {
///     super.initState();
///     _tabController = TabController(length: 3, vsync: this);
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Stack(
///         children: [
///           TabBarView(
///             controller: _tabController,
///             children: [...],
///           ),
///           HydroGlassNavBar(
///             controller: _tabController,
///             items: [
///               HydroGlassNavItem(label: 'Home', icon: Icons.home),
///               HydroGlassNavItem(label: 'Search', icon: Icons.search),
///               HydroGlassNavItem(label: 'Profile', icon: Icons.person),
///             ],
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// ## iOS 26 Liquid Glass Features
///
/// ### Glass Variants
///
/// Choose between Regular and Clear glass:
///
/// ```dart
/// HydroGlassNavBar(
///   variant: LiquidGlassVariant.regular, // Fully adaptive (default)
///   // or
///   variant: LiquidGlassVariant.clear, // More transparent
/// )
/// ```
///
/// ### Size-Based Material Thickness
///
/// Glass adapts based on element size:
///
/// ```dart
/// HydroGlassNavBar(
///   sizeCategory: GlassSizeCategory.medium, // Default
///   // or GlassSizeCategory.small for buttons
///   // or GlassSizeCategory.large for menus
/// )
/// ```
///
/// ### Utilities
///
/// Access brightness detection and physics utilities:
///
/// ```dart
/// // Brightness detection
/// final luminance = BackgroundBrightnessDetector.calculateLuminance(color);
/// final isBright = BackgroundBrightnessDetector.isBrightBackground(color);
///
/// // Physics
/// final rubberBand = HydroGlassNavBarPhysics.applyRubberBandResistance(value);
/// final jellyTransform = HydroGlassNavBarPhysics.buildJellyTransform(velocity: 5);
///
/// // Size configuration
/// final config = GlassSizeConfiguration.forCategory(GlassSizeCategory.large);
/// ```
///
/// See the example app and README for more details.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:motor/motor.dart';

part 'src/hydro_glass_nav_bar.dart';
part 'src/hydro_glass_nav_bar_config.dart';
part 'src/hydro_glass_nav_bar_physics.dart';
part 'src/liquid_glass_variant.dart';
part 'src/background_brightness_detector.dart';
part 'src/accessibility_glass_settings.dart';
part 'src/widgets/hydro_glass_nav_indicator.dart';
part 'src/widgets/hydro_glass_nav_item.dart';
part 'src/widgets/hydro_glass_floating_action_button.dart';
