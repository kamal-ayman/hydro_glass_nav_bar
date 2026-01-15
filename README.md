# Hydro Glass Nav Bar

[![Pub Version](https://img.shields.io/pub/v/hydro_glass_nav_bar.svg)](https://pub.dev/packages/hydro_glass_nav_bar)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.24.0-blue.svg)](https://flutter.dev)

A beautiful, **Apple-style hydro glass** floating navigation bar with advanced physics-based animations for Flutter. Create stunning, premium navigation experiences with hydro glass morphism, draggable indicators, and expandable floating action buttons.

<p align="center">
  <img src="https://raw.githubusercontent.com/kamal-ayman/hydro_glass_nav_bar/main/screenshots/preview.gif" alt="Preview" width="300"/>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/kamal-ayman/hydro_glass_nav_bar/main/screenshots/image.png" alt="Screenshot" width="300"/>
</p>

## ✨ Features

- 🌊 **Hydro Glass Morphism** - Stunning visual effect with refraction, blur, and glass glow
- 🎯 **Draggable Indicator** - Swipe between items with smooth, physics-based animations
- 🧲 **iOS-style Physics** - Rubber band resistance and jelly transform effects
- ➕ **Expandable FAB** - Optional floating action button with action menu
- 🎨 **Theme Adaptive** - Automatic dark/light mode support
- ♿ **Accessible** - Full semantic label support for screen readers
- 📳 **Haptic Feedback** - Tactile response on interactions
- ⚡ **Performance Optimized** - RepaintBoundary and efficient rendering
- 🎭 **Fallback Mode** - Works without hydro glass effect for older devices

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  hydro_glass_nav_bar: ^1.0.0-pre.1
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

```dart
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your page content
          TabBarView(
            controller: _tabController,
            children: [
              Center(child: Text('Home')),
              Center(child: Text('Search')),
              Center(child: Text('Profile')),
            ],
          ),
          
          // The hydro glass nav bar
          HydroGlassNavBar(
            controller: _tabController,
            items: [
              HydroGlassNavItem(
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
              ),
              HydroGlassNavItem(
                label: 'Search',
                icon: Icons.search,
              ),
              HydroGlassNavItem(
                label: 'Profile',
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## 📖 Components

### HydroGlassNavBar

The main widget that creates the floating navigation bar.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `TabController` | **Required** | Controls item selection |
| `items` | `List<HydroGlassNavItem>` | **Required** | List of 2-5 items |
| `fabConfig` | `HydroGlassNavBarFABConfig?` | `null` | Optional FAB configuration |
| `showIndicator` | `bool` | `true` | Whether to show the sliding indicator |
| `indicatorColor` | `Color?` | `null` | Custom indicator color |
| `selectedItemsCount` | `ValueNotifier<int>?` | `null` | For selection mode with FAB |
| `padding` | `EdgeInsets` | `EdgeInsets.fromLTRB(20, 20, 20, 20)` | Padding around the bar |
| `useLiquidGlass` | `bool` | `true` | Enable/disable hydro glass effect |

### HydroGlassNavItem

Configuration for individual navigation items.

```dart
HydroGlassNavItem(
  label: 'Home',           // Required: Item label
  icon: Icons.home_outlined, // Required: Default icon
  selectedIcon: Icons.home,  // Optional: Icon when selected
  glowColor: Colors.blue,    // Optional: Custom glow color
)
```

### HydroGlassNavBarFABConfig

Configuration for the expandable floating action button.

```dart
HydroGlassNavBarFABConfig(
  icon: Icons.more_vert,
  semanticLabel: 'Actions menu',
  size: 56, // Default: 56
  actions: [
    HydroGlassNavBarAction(
      icon: Icons.share,
      label: 'Share',
      onTap: () => handleShare(),
    ),
    HydroGlassNavBarAction(
      icon: Icons.delete,
      label: 'Delete',
      onTap: () => handleDelete(),
      isDanger: true, // Shows in error color
    ),
  ],
)
```

## 🎨 Selection Mode with FAB

Create a powerful selection experience with the built-in FAB:

```dart
class _MyPageState extends State<MyPage> {
  final ValueNotifier<int> _selectedCount = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your selectable content
          GridView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  // Toggle selection
                  _selectedCount.value++;
                },
                child: YourItemWidget(),
              );
            },
          ),
          
          // Nav bar with FAB
          HydroGlassNavBar(
            controller: _tabController,
            items: [...],
            selectedItemsCount: _selectedCount, // FAB appears when > 0
            fabConfig: HydroGlassNavBarFABConfig(
              icon: Icons.more_vert,
              actions: [
                HydroGlassNavBarAction(
                  icon: Icons.share,
                  label: 'Share Selected',
                  onTap: () => shareItems(),
                ),
                HydroGlassNavBarAction(
                  icon: Icons.delete,
                  label: 'Delete Selected',
                  onTap: () {
                    deleteItems();
                    _selectedCount.value = 0;
                  },
                  isDanger: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🔧 Fallback Mode

For devices that don't support the hydro glass effect, or for performance optimization:

```dart
HydroGlassNavBar(
  controller: _tabController,
  items: [...],
  useLiquidGlass: false, // Uses gradient background instead
)
```

## 🧪 Physics Utilities

The package exposes `HydroGlassNavBarPhysics` for custom implementations:

```dart
// iOS-style rubber band resistance
final adjusted = HydroGlassNavBarPhysics.applyRubberBandResistance(
  1.2, // value beyond 0-1 range
  resistance: 0.4,
  maxOverdrag: 0.3,
);

// Jelly transform for squash-and-stretch
final transform = HydroGlassNavBarPhysics.buildJellyTransform(
  velocity: 5.0,
  maxDistortion: 0.8,
);

// Convert item index to alignment
final alignment = HydroGlassNavBarPhysics.computeAlignment(1, 3);
// Returns 0.0 (center for 3 items)
```

## 🎬 How Animations Work

The hydro glass nav bar features a sophisticated multi-layered animation system that creates a premium, fluid user experience. Here's a detailed breakdown of how each animation component works:

### 🎯 Draggable Indicator Animation

The sliding indicator is the centerpiece of the navigation bar's animation system:

#### **Physics-Based Movement**
- Uses the `motor` package for spring-based animations with configurable damping and stiffness
- Two animation modes:
  - **Interactive Spring** (`Motion.interactiveSpring`): Applied during active dragging for immediate, responsive feedback
  - **Bouncy Spring** (`Motion.bouncySpring`): Applied when released, creating a smooth settling effect with gentle overshoot

#### **Drag Interaction**
1. **Drag Detection**: Horizontal drag gestures are captured on the navigation bar
2. **Position Calculation**: Converts global touch position to alignment value (-1.0 to 1.0)
3. **Real-Time Updates**: Indicator position updates continuously during drag via `VelocityMotionBuilder`
4. **Velocity Tracking**: Drag velocity is measured and used for both physics calculations and visual effects

#### **Rubber Band Resistance**
When dragging beyond the navigation bar edges:
- **Resistance Factor** (default: 0.4): Reduces drag speed proportionally to distance beyond bounds
- **Max Overdrag** (default: 0.3): Limits how far the indicator can be pulled past edges
- Creates an iOS-style "bouncy" feel that prevents disorientation
- Formula: Overdrag is multiplied by resistance factor and clamped to maximum

#### **Smart Target Selection**
When drag is released, the target item is calculated using:
- **Current Position**: Where the indicator currently sits
- **Velocity**: Speed and direction of the drag motion
- **Momentum Projection**: Velocity is projected forward 300ms to predict intended target
- **Velocity Threshold** (0.5): Minimum speed required to trigger momentum-based selection
- Falls back to nearest item if velocity is below threshold

### 🎪 Jelly Transform Effect

The indicator has a squash-and-stretch animation that makes it feel organic:

#### **Velocity-Based Distortion**
- **Speed Detection**: Monitors drag velocity magnitude
- **Distortion Calculation**: Speed is normalized (divided by velocity scale of 10) and clamped to 0-1
- **Squash Factor**: Horizontal compression up to 50% of distortion factor (makes it narrower)
- **Stretch Factor**: Vertical expansion up to 30% of distortion factor (makes it taller)
- **Matrix Transform**: Creates a `Matrix4` with diagonal scaling values

#### **Animation Timing**
- Uses `Motion.bouncySpring` with 600ms duration for smooth return to normal shape
- Smoothly interpolates velocity back to zero after drag ends
- Applied via `Transform` widget wrapped around the indicator

### ✨ Indicator Visibility Animation

The indicator has dynamic thickness based on interaction state:

#### **Thickness States**
- **Hidden** (thickness: 0.0): When not interacting and aligned with current item
- **Visible** (thickness: 1.0): When dragging or when indicator is far from target (>0.30 alignment difference)
- **Transition**: Animated with `Motion.snappySpring` over 300ms

#### **Dual-Layer Rendering**
1. **Background Indicator**: Simple color overlay, visible when thickness < 1
   - Opacity animates out when thickness > 0.2
   - Provides subtle position feedback without hydro glass overhead
2. **Glass Indicator**: Full hydro glass effect, visible when thickness > 0
   - Expensive rendering only when needed
   - Includes glow effects and refraction

#### **Expansion Effect**
- Indicator expands 14 pixels beyond its normal bounds when fully visible
- Uses `RelativeRect.lerp` to smoothly interpolate between normal and expanded state
- Creates emphasis during interaction

### 🔄 FAB Animation System

The expandable Floating Action Button has several coordinated animations:

#### **Appearance Animation**
- **Trigger**: When `selectedItemsCount` > 0
- **Scale Animation**: `SingleMotionBuilder` with `Motion.bouncySpring`
  - Scales from 0.0 to 1.0 when appearing
  - Anchor point: `Alignment.centerRight` for natural expansion from navbar
- **Opacity**: Synchronized with scale for smooth fade-in
- **IgnorePointer**: Disables touch when opacity < 0.1 to prevent ghost taps
- **Container Width**: Animates from 0 to natural width with 400ms duration using `Curves.easeInOutCubic`

#### **Rotation Animation**
- **Icon Rotation**: When menu expands, icon rotates 45° (0.125 turns)
- **Duration**: 300ms with linear interpolation
- Creates visual feedback that menu state changed

#### **Options Menu Expansion**
- **Position**: Menu appears above FAB with 8px gap
- **Scale Animation**: Same `Motion.bouncySpring` as FAB appearance
  - Scales from 0.0 to 1.0 from bottom-right anchor
- **Staggered Appearance**: Each option item rendered in sequence
- **Spacing**: 8px between each action item

#### **Badge Counter Animation**
- **Appearance**: Only shows when `selectedCount > 0` and menu not expanded
- **Count Changes**: `AnimatedSwitcher` with `ScaleTransition`
  - Old count scales out, new count scales in
  - 200ms duration with `Curves.easeOutBack`
- **Container**: Auto-sizes with min 20x20 constraint
- **Style**: Circular badge with error color and surface border

### 🎨 Navigation Item Animations

Each navigation item has subtle state-based animations:

#### **Selection State**
- **Icon Scale**: Selected items scale to 1.1x (10% larger)
- **Icon Change**: Swaps between default and selected icon (if provided)
- **Font Weight**: Selected label uses 600 weight, unselected uses 500
- **Color Transition**: Animated between full opacity (selected) and 60% opacity (unselected)
- **Duration**: All transitions are 150ms for snappy response

#### **Performance Optimization**
- Each item wrapped in `RepaintBoundary` to isolate repaints
- Prevents animation overhead from affecting other items

### 🌊 Hydro Glass Visual Effects

The glass morphism effect is purely visual and doesn't animate, but works with the animations:

#### **Settings**
- **Refraction Index**: 1.21 (simulates glass-like light bending)
- **Thickness**: 30 (virtual glass thickness)
- **Blur**: 8 (background blur radius)
- **Saturation**: 1.5 (enhanced colors through glass)
- **Light Intensity**: 0.7 (dark mode) or 1.0 (light mode)
- **Ambient Strength**: 0.2 (dark) or 0.5 (light)

#### **Rendering**
- Uses `liquid_glass_renderer` package for GPU-accelerated effects
- `LiquidGlassBlendGroup` with blend factor 15.0 merges effects smoothly
- All animated elements render **inside** the glass layer for cohesive effect

### ⚡ Performance Characteristics

#### **Optimization Strategies**
1. **Conditional Rendering**: Glass effects only render when visible
2. **RepaintBoundary**: Isolates frequently updating elements
3. **IgnorePointer**: Disables invisible elements from hit testing
4. **Visibility Widget**: Removes collapsed elements from render tree
5. **Spring Animations**: Use native interpolation, no manual frame calculations

#### **Animation Hierarchy**
```text
VelocityMotionBuilder (tracks drag velocity)
  └─ SingleMotionBuilder (controls indicator thickness)
      ├─ Transform (applies jelly distortion)
      └─ SingleMotionBuilder (animates FAB visibility)
          └─ SingleMotionBuilder (animates menu expansion)
```

All animations run at 60 FPS (or 120 FPS on ProMotion displays) with automatic frame rate adaptation.

## 📱 Requirements

- Flutter SDK: `>=3.24.0`
- Dart SDK: `>=3.5.0`

## 📄 Dependencies

- [liquid_glass_renderer](https://pub.dev/packages/liquid_glass_renderer) - For the hydro glass morphism effect
- [motor](https://pub.dev/packages/motor) - For physics-based spring animations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ☕ Support

If you find this package helpful, consider supporting my work:

<a href="https://buymeacoffee.com/kamalayman">
  <img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=☕&slug=kamalayman&button_colour=FFDD00&font_colour=000000&font_family=Poppins&outline_colour=000000&coffee_colour=ffffff" alt="Buy Me A Coffee" height="50">
</a>

Your support helps me maintain and improve this package! 🙏

## 🙏 Credits

Created by [Kamal Ayman](https://github.com/kamal-ayman)

---

<p align="center">
  Made with ❤️ and Flutter
  <br><br>
  <a href="https://buymeacoffee.com/kamalayman"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>
</p>
