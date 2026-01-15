import 'package:flutter/material.dart';
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

void main() {
  runApp(const HydroGlassNavBarExample());
}

/// Example app demonstrating the hydro_glass_nav_bar package.
class HydroGlassNavBarExample extends StatelessWidget {
  const HydroGlassNavBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydro Glass Nav Bar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

/// Home screen with the hydro glass nav bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> _selectedCount = ValueNotifier(0);
  LiquidGlassVariant _variant = LiquidGlassVariant.regular;
  GlassSizeCategory _sizeCategory = GlassSizeCategory.medium;

  static const _items = [
    HydroGlassNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    HydroGlassNavItem(
      label: 'Search',
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
    ),
    HydroGlassNavItem(
      label: 'Favorites',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
    ),
    HydroGlassNavItem(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _items.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydro Glass Nav Bar'),
        actions: [
          PopupMenuButton<LiquidGlassVariant>(
            tooltip: 'Glass Variant',
            icon: const Icon(Icons.style),
            onSelected: (variant) => setState(() => _variant = variant),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: LiquidGlassVariant.regular,
                child: Text('Regular Glass'),
              ),
              const PopupMenuItem(
                value: LiquidGlassVariant.clear,
                child: Text('Clear Glass'),
              ),
            ],
          ),
          PopupMenuButton<GlassSizeCategory>(
            tooltip: 'Size Category',
            icon: const Icon(Icons.format_size),
            onSelected: (size) => setState(() => _sizeCategory = size),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: GlassSizeCategory.small,
                child: Text('Small'),
              ),
              const PopupMenuItem(
                value: GlassSizeCategory.medium,
                child: Text('Medium'),
              ),
              const PopupMenuItem(
                value: GlassSizeCategory.large,
                child: Text('Large'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background content
          TabBarView(
            controller: _tabController,
            children: [
              _PageContent(
                title: 'Home',
                icon: Icons.home,
                color: Colors.blue,
                onSelectionChanged: (count) => _selectedCount.value = count,
              ),
              _PageContent(
                title: 'Search',
                icon: Icons.search,
                color: Colors.green,
                onSelectionChanged: (count) => _selectedCount.value = count,
              ),
              _PageContent(
                title: 'Favorites',
                icon: Icons.favorite,
                color: Colors.red,
                onSelectionChanged: (count) => _selectedCount.value = count,
              ),
              _PageContent(
                title: 'Profile',
                icon: Icons.person,
                color: Colors.purple,
                onSelectionChanged: (count) => _selectedCount.value = count,
              ),
            ],
          ),

          // Hydro Glass Nav Bar
          HydroGlassNavBar(
            controller: _tabController,
            items: _items,
            variant: _variant,
            sizeCategory: _sizeCategory,
            selectedItemsCount: _selectedCount,
            fabConfig: HydroGlassNavBarFABConfig(
              icon: Icons.more_vert,
              semanticLabel: 'Actions',
              actions: [
                HydroGlassNavBarAction(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () => _showSnackBar(context, 'Share tapped'),
                ),
                HydroGlassNavBarAction(
                  icon: Icons.download,
                  label: 'Download',
                  onTap: () => _showSnackBar(context, 'Download tapped'),
                ),
                HydroGlassNavBarAction(
                  icon: Icons.delete,
                  label: 'Delete',
                  onTap: () {
                    _showSnackBar(context, 'Delete tapped');
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      ),
    );
  }
}

/// Content for each page.
class _PageContent extends StatefulWidget {
  const _PageContent({
    required this.title,
    required this.icon,
    required this.color,
    required this.onSelectionChanged,
  });

  final String title;
  final IconData icon;
  final Color color;
  final ValueChanged<int> onSelectionChanged;

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  final Set<int> _selectedItems = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
    });
    widget.onSelectionChanged(_selectedItems.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.color.withValues(alpha: 0.1),
            widget.color.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(widget.title),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            actions: [
              if (_selectedItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('${_selectedItems.length} selected'),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() => _selectedItems.clear());
                      widget.onSelectionChanged(0);
                    },
                  ),
                ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                final isSelected = _selectedItems.contains(index);
                return GestureDetector(
                  onLongPress: () => _toggleSelection(index),
                  onTap: _selectedItems.isNotEmpty
                      ? () => _toggleSelection(index)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? widget.color : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.icon,
                                size: 48,
                                color: widget.color.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Item ${index + 1}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Long press to select',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: widget.color,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
