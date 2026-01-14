import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydro_glass_nav_bar/hydro_glass_nav_bar.dart';

void main() {
  group('HydroGlassNavBarPhysics', () {
    group('applyRubberBandResistance', () {
      test('returns value unchanged when within 0-1 range', () {
        expect(
          HydroGlassNavBarPhysics.applyRubberBandResistance(0.5),
          equals(0.5),
        );
        expect(
          HydroGlassNavBarPhysics.applyRubberBandResistance(0.0),
          equals(0.0),
        );
        expect(
          HydroGlassNavBarPhysics.applyRubberBandResistance(1.0),
          equals(1.0),
        );
      });

      test('applies resistance when value is below 0', () {
        final result = HydroGlassNavBarPhysics.applyRubberBandResistance(-0.5);
        expect(result, lessThan(0));
        expect(result, greaterThan(-0.5));
      });

      test('applies resistance when value is above 1', () {
        final result = HydroGlassNavBarPhysics.applyRubberBandResistance(1.5);
        expect(result, greaterThan(1));
        expect(result, lessThan(1.5));
      });

      test('respects maxOverdrag limit', () {
        final result = HydroGlassNavBarPhysics.applyRubberBandResistance(
          2.0,
          maxOverdrag: 0.1,
        );
        expect(result, lessThanOrEqualTo(1.1));
      });
    });

    group('buildJellyTransform', () {
      test('returns identity matrix when velocity is 0', () {
        final result = HydroGlassNavBarPhysics.buildJellyTransform(velocity: 0);
        expect(result, equals(Matrix4.identity()));
      });

      test('returns non-identity matrix when velocity is non-zero', () {
        final result = HydroGlassNavBarPhysics.buildJellyTransform(velocity: 5);
        expect(result, isNot(equals(Matrix4.identity())));
      });

      test('handles negative velocity', () {
        final result =
            HydroGlassNavBarPhysics.buildJellyTransform(velocity: -5);
        expect(result, isNot(equals(Matrix4.identity())));
      });
    });

    group('computeAlignment', () {
      test('returns -1 for first item', () {
        expect(HydroGlassNavBarPhysics.computeAlignment(0, 3), equals(-1.0));
      });

      test('returns 1 for last item', () {
        expect(HydroGlassNavBarPhysics.computeAlignment(2, 3), equals(1.0));
      });

      test('returns 0 for middle item with odd count', () {
        expect(HydroGlassNavBarPhysics.computeAlignment(1, 3), equals(0.0));
      });

      test('handles two items', () {
        expect(HydroGlassNavBarPhysics.computeAlignment(0, 2), equals(-1.0));
        expect(HydroGlassNavBarPhysics.computeAlignment(1, 2), equals(1.0));
      });
    });

    group('computeTargetIndex', () {
      test('returns 0 when currentRelativeX is negative', () {
        final result = HydroGlassNavBarPhysics.computeTargetIndex(
          currentRelativeX: -0.1,
          velocityX: 0,
          itemWidth: 0.333,
          itemCount: 3,
        );
        expect(result, equals(0));
      });

      test('returns last index when currentRelativeX exceeds 1', () {
        final result = HydroGlassNavBarPhysics.computeTargetIndex(
          currentRelativeX: 1.1,
          velocityX: 0,
          itemWidth: 0.333,
          itemCount: 3,
        );
        expect(result, equals(2));
      });

      test('rounds to nearest item without velocity', () {
        final result = HydroGlassNavBarPhysics.computeTargetIndex(
          currentRelativeX: 0.4,
          velocityX: 0,
          itemWidth: 0.333,
          itemCount: 3,
        );
        expect(result, equals(1));
      });

      test('considers velocity for target calculation', () {
        final result = HydroGlassNavBarPhysics.computeTargetIndex(
          currentRelativeX: 0.2,
          velocityX: 1.0,
          itemWidth: 0.333,
          itemCount: 3,
        );
        expect(result, greaterThan(0));
      });
    });
  });

  group('HydroGlassNavItem', () {
    test('creates with required parameters', () {
      const item = HydroGlassNavItem(
        label: 'Home',
        icon: Icons.home,
      );
      expect(item.label, equals('Home'));
      expect(item.icon, equals(Icons.home));
      expect(item.selectedIcon, isNull);
      expect(item.glowColor, isNull);
    });

    test('creates with all parameters', () {
      const item = HydroGlassNavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        glowColor: Colors.blue,
      );
      expect(item.selectedIcon, equals(Icons.home));
      expect(item.glowColor, equals(Colors.blue));
    });
  });

  group('HydroGlassNavBarFABConfig', () {
    test('creates with required parameters', () {
      final config = HydroGlassNavBarFABConfig(
        icon: Icons.add,
        actions: [
          HydroGlassNavBarAction(
            icon: Icons.share,
            label: 'Share',
            onTap: () {},
          ),
        ],
      );
      expect(config.icon, equals(Icons.add));
      expect(config.actions.length, equals(1));
      expect(config.semanticLabel, isNull);
      expect(config.size, equals(56));
    });

    test('creates with custom size', () {
      const config = HydroGlassNavBarFABConfig(
        icon: Icons.add,
        actions: [],
        size: 64,
      );
      expect(config.size, equals(64));
    });
  });

  group('HydroGlassNavBarAction', () {
    test('creates with required parameters', () {
      final action = HydroGlassNavBarAction(
        icon: Icons.share,
        label: 'Share',
        onTap: () {},
      );
      expect(action.icon, equals(Icons.share));
      expect(action.label, equals('Share'));
      expect(action.isDanger, isFalse);
    });

    test('creates danger action', () {
      final action = HydroGlassNavBarAction(
        icon: Icons.delete,
        label: 'Delete',
        onTap: () {},
        isDanger: true,
      );
      expect(action.isDanger, isTrue);
    });
  });

  group('HydroGlassNavBar Widget', () {
    testWidgets('renders with minimum 2 items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Builder(
                    builder: (context) {
                      return HydroGlassNavBar(
                        controller: DefaultTabController.of(context),
                        items: const [
                          HydroGlassNavItem(label: 'Item 1', icon: Icons.home),
                          HydroGlassNavItem(
                              label: 'Item 2', icon: Icons.search),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('renders without hydro glass when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Builder(
                    builder: (context) {
                      return HydroGlassNavBar(
                        controller: DefaultTabController.of(context),
                        items: const [
                          HydroGlassNavItem(label: 'Item 1', icon: Icons.home),
                          HydroGlassNavItem(
                              label: 'Item 2', icon: Icons.search),
                        ],
                        useLiquidGlass: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });
  });
}
