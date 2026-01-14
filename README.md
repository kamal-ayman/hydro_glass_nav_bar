# Hydro Glass Nav Bar

[![Pub Version](https://img.shields.io/pub/v/hydro_glass_nav_bar.svg)](https://pub.dev/packages/hydro_glass_nav_bar)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.24.0-blue.svg)](https://flutter.dev)

A beautiful, **Apple-style hydro glass** floating navigation bar with advanced physics-based animations for Flutter. Create stunning, premium navigation experiences with hydro glass morphism, draggable indicators, and expandable floating action buttons.

<p align="center">
  <img src="https://raw.githubusercontent.com/kamal-ayman/hydro_glass_nav_bar/main/screenshots/demo.gif" alt="Demo" width="300"/>
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
  hydro_glass_nav_bar: ^1.0.0-dev.2
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
# hydro_glass_nav_bar
