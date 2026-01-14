/// A beautiful, Apple-style hydro glass floating navigation bar with advanced
/// physics-based animations for Flutter.
///
/// This package provides a premium navigation bar experience with:
/// - **Hydro glass morphism** - Stunning visual effect with refraction and blur
/// - **Physics-based animations** - iOS-style rubber band resistance and jelly transforms
/// - **Draggable indicator** - Swipe between items with smooth animations
/// - **Expandable FAB** - Optional floating action button with action menu
/// - **Dark/Light mode** - Automatic theme adaptation
/// - **Accessibility** - Full semantic label support
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
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:motor/motor.dart';

part 'src/hydro_glass_nav_bar.dart';
part 'src/hydro_glass_nav_bar_config.dart';
part 'src/hydro_glass_nav_bar_physics.dart';
part 'src/widgets/hydro_glass_nav_indicator.dart';
part 'src/widgets/hydro_glass_nav_item.dart';
part 'src/widgets/hydro_glass_floating_action_button.dart';
