# iOS 26 Liquid Glass: Complete Technical Implementation Guide

## Overview
Liquid Glass is Apple's revolutionary design language introduced at WWDC 2025 for iOS 26, iPadOS 26, macOS Tahoe 26, and other platforms. It represents a new digital "meta-material" that dynamically bends and shapes light, combining the optical properties of glass with fluid, liquid-like behavior. This is not simple glassmorphism—it's a sophisticated system of layered visual effects that create depth, hierarchy, and physicality.

---

## Core Visual Properties

### 1. **Lensing & Light Refraction**
The primary visual characteristic of Liquid Glass is **lensing**—the way transparent materials warp and bend light.

**Technical Implementation:**
- **Refractive Index**: ~1.21 to 1.5 (simulates glass-like light bending)
  - This value determines how much content behind the glass appears distorted
  - Higher values = more pronounced warping at curved edges
  - Content appears subtly magnified or compressed near boundaries

- **Edge Distortion**: Content warps most prominently along curved edges
  - Use displacement mapping to simulate light passing through curved glass
  - Distortion should be localized—strongest at edges, minimal at center
  - The effect mimics how real glass concentrates and bends light rays

- **Dynamic Light Concentration**: Light doesn't just pass through—it bends and focuses
  - Bright areas behind glass should appear slightly brighter through the material
  - Dark areas should show subtle refraction patterns
  - Creates visual separation without opacity

**Visual Principle**: Unlike previous materials that scattered light with blur, Liquid Glass *shapes and concentrates* light in real-time, providing definition while maintaining transparency.

---

### 2. **Multi-Layer Glass Composition**

Liquid Glass is not a single effect—it's a sophisticated stack of composited layers:

#### **Layer 1: Background Content Capture**
- Capture the content that sits behind the glass element
- This becomes the base for all optical effects

#### **Layer 2: Blur Layer**
- **Gaussian Blur**: 8-12px radius (adjustable based on element size)
- **Real-time**: Blur must update as content scrolls/moves beneath
- Creates the "frosted glass" foundation
- Heavier blur for larger elements (menus, sidebars)
- Lighter blur for small controls (buttons, nav bars)

#### **Layer 3: Refraction/Displacement Layer**
- Apply displacement mapping using refraction index
- Warps the blurred background content
- Creates the characteristic "lens" effect
- Most pronounced at curved edges and corners

#### **Layer 4: Tint/Color Layer**
- Semi-transparent color overlay (typically white or black with ~10% opacity)
- **Adaptive**: Switches between light and dark based on background brightness
- Small elements (nav bars, tab bars) flip automatically between light/dark
- Large elements (menus, sidebars) maintain consistent appearance but adapt tint

#### **Layer 5: Specular Highlights**
- Simulated light sources that produce glossy highlights
- Responds to:
  - Virtual lighting environment (configured per-platform)
  - Device motion (on iOS devices with gyroscope)
  - Interaction state (hover, tap, drag)
- Creates subtle shimmer and "wet glass" appearance
- Highlights should respect the geometry of rounded corners

#### **Layer 6: Shadow Layer**
- **Adaptive Shadow Opacity**:
  - Shadow opacity increases when glass is over text/busy content (better separation)
  - Shadow opacity decreases when glass is over solid/light backgrounds (reduces visual noise)
  - Dynamic adjustment in real-time as content scrolls beneath
- **Shadow Characteristics**:
  - Soft, diffused edges (not hard drop shadows)
  - Color tints into the shadow (light bleeds and refracts into shadow)
  - Larger elements cast deeper, richer shadows
  - Creates sense of elevation and "floating" above content

#### **Layer 7: Ambient Light Reflection**
- On larger elements (sidebars, panels), light from nearby colorful content "spills" onto the glass surface
- Simulates how real glass reflects its environment
- Subtle color bleeding from vibrant content areas
- Reinforces spatial context and material physicality

---

### 3. **Saturation & Vibrancy Boost**
- **Saturation Multiplier**: 1.2-1.5x
  - Content viewed through glass appears more vibrant and saturated
  - Simulates how light refracts through colored/tinted glass
  - Makes the interface feel more alive and energetic

- **Chromatic Aberration** (Optional):
  - Subtle color separation at edges (~0.002 intensity)
  - RGB channels slightly offset, creating rainbow-like edge highlights
  - Enhances the "real glass optics" effect

---

## Dynamic Behaviors & Motion

### 4. **Materialization (Appear/Disappear)**
Unlike traditional fade-in/fade-out, Liquid Glass elements **materialize** by gradually modulating their optical properties.

**Appearance Sequence**:
1. **Initial State**: Fully transparent (refractive index = 1.0, no blur, no tint)
2. **Lensing Increases**: Refraction gradually increases (1.0 → 1.5)
3. **Blur Fades In**: Background blur gradually intensifies (0px → 8-12px)
4. **Tint Appears**: Color tint fades from 0% to ~10% opacity
5. **Highlights Emerge**: Specular highlights fade in
6. **Shadow Deepens**: Shadow opacity increases to final value

**Animation Timing**:
- Use spring-based animations (not linear easing)
- Duration: 300-600ms depending on element size
- The material "bends into existence" rather than simply appearing

**Disappearance**: Reverse the sequence—optical properties return to neutral state, preserving the "glass integrity" throughout transition.

---

### 5. **Gel-Like Elasticity & Jelly Physics**
Liquid Glass has an **inherent flexibility** that communicates its transient, malleable nature.

**Squash & Stretch Deformation**:
- When elements move quickly (drag, swipe, scroll), they deform like gel
- **Squash Direction**: Compress in the direction of motion
- **Stretch Direction**: Elongate perpendicular to motion
- Deformation proportional to velocity:
  - Slow motion = minimal deformation
  - Fast motion = pronounced jelly effect (up to 20-30% distortion)

**Using Motor Package for Physics**:
```dart
// Track velocity during drag
VelocityMotionBuilder(
  builder: (context, velocity, child) {
    // Calculate jelly distortion based on velocity magnitude
    final speed = velocity.magnitude;
    final distortionFactor = (speed / 10.0).clamp(0.0, 1.0);
    
    // Squash: compress horizontally by up to 50% of distortion
    final scaleX = 1.0 - (distortionFactor * 0.5);
    
    // Stretch: expand vertically by up to 30% of distortion  
    final scaleY = 1.0 + (distortionFactor * 0.3);
    
    return Transform(
      transform: Matrix4.diagonal3Values(scaleX, scaleY, 1.0),
      alignment: Alignment.center,
      child: child,
    );
  },
)
```

**Recovery Animation**:
- Use `Motion.bouncySpring` for return to normal shape
- Duration: ~600ms with gentle overshoot
- Velocity smoothly interpolates back to zero
- Creates satisfying, organic "bounce-back" feel

---

### 6. **Instant Response to Touch**
The material must feel **alive and directly connected** to user input.

**On Touch Down**:
1. **Light Burst**: Localized glow illuminates from touch point
   - Radial gradient centered on finger position
   - Spreads outward across element (~150ms expansion)
   - Light intensity peaks then gradually fades
   
2. **Nearby Elements React**: Light "spills" onto adjacent Liquid Glass elements
   - Creates sense of connected, unified material
   - Reinforces that glass elements exist on same floating plane

3. **Subtle Scale Pulse**: Element very slightly scales up (1.02x)
   - Quick, snappy animation (~100ms)
   - Provides immediate haptic-like feedback visually

**Using Motor Package**:
```dart
SingleMotionBuilder(
  startValue: 0.0,
  endValue: onPressed ? 1.0 : 0.0,
  motion: Motion.interactiveSpring,
  builder: (context, value, child) {
    final glowOpacity = value;
    final glowSpread = value * 50; // Pixels
    
    return Stack(
      children: [
        // Base glass element
        child!,
        // Touch glow overlay
        Positioned.fill(
          child: CustomPaint(
            painter: TouchGlowPainter(
              center: touchPosition,
              opacity: glowOpacity,
              spread: glowSpread,
            ),
          ),
        ),
      ],
    );
  },
)
```

---

### 7. **Dynamic Morphing Between States**
As users navigate between app sections, glass elements **fluidly transform** rather than discrete transitions.

**Shape Morphing**:
- A tab bar button that opens a menu doesn't fade out—it **expands and morphs** into the menu shape
- Rounded rectangle animates its corner radii, width, height simultaneously
- Maintains the concept of a "singular floating plane"

**Content Transformation**:
- Icons/labels inside glass containers crossfade during morph
- Blur and refraction effects remain consistent throughout transition
- Shadow depth and spread animate smoothly

**Animation Approach**:
```dart
SingleMotionBuilder(
  startValue: isCollapsed ? 0.0 : 1.0,
  motion: Motion.bouncySpring,
  builder: (context, value, child) {
    // Interpolate between collapsed and expanded shapes
    final width = lerpDouble(collapsedWidth, expandedWidth, value)!;
    final height = lerpDouble(collapsedHeight, expandedHeight, value)!;
    final radius = lerpDouble(collapsedRadius, expandedRadius, value)!;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        // Apply glass effects
      ),
    );
  },
)
```

**Principle**: The glass material is a living, shape-shifting entity that adapts to context seamlessly.

---

### 8. **Shrink/Expand on Scroll**
Navigation bars and tab bars **dynamically resize** to give content more space while maintaining instant accessibility.

**Scroll Detection**:
- Monitor scroll offset of parent ScrollView/ListView
- Calculate scroll direction (up = expanding content, down = collapsing content)

**Tab Bar Shrink Behavior**:
- **At Top**: Tab bar is full size with labels visible
- **Scrolling Down**: Bar smoothly shrinks
  - Labels fade out (opacity 1.0 → 0.0)
  - Icons remain visible but may reduce size
  - Bar height reduces (e.g., 70px → 50px)
  - Corner radii may adjust to maintain proportions
- **Scroll Up**: Bar instantly expands back to full size
  - Labels fade back in
  - Height returns to original

**Animation Characteristics**:
```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeOutCubic,
  height: isScrolling ? collapsedHeight : fullHeight,
  // Glass material properties
)
```

**Sidebar Behavior** (iPad/Mac):
- Sidebars can shrink to icon-only mode
- Width animates smoothly (e.g., 280px → 60px)
- Text labels slide out/fade as icons center
- Glass effects remain consistent throughout

---

## Adaptive Intelligence

### 9. **Automatic Light/Dark Mode Switching**
Small glass elements (buttons, nav bars, tab bars) **intelligently flip** between light and dark appearances based on background content.

**Brightness Detection Algorithm**:
1. Sample background content beneath glass element
2. Calculate average luminance using perceived brightness formula:
   ```
   luminance = (0.299 × R) + (0.587 × G) + (0.114 × B)
   ```
3. If luminance > 0.5 (bright background):
   - Use **dark glass style**: Dark tint, light shadow
4. If luminance ≤ 0.5 (dark background):
   - Use **light glass style**: Light tint, dark shadow

**Transition**:
- Smooth crossfade between light/dark styles (200-300ms)
- All layers transition together (tint, highlight, shadow)
- Icons/labels also flip color to maintain contrast

**Important**: Large elements (menus, sidebars, panels) do NOT flip—they maintain a consistent appearance but adjust tint intensity subtly.

---

### 10. **Scroll Edge Effects**
When content scrolls beneath glass elements, **scroll edge effects** maintain visual separation and legibility.

**Gradient Fade Effect**:
- As content enters the "danger zone" beneath glass (typically 20-50px from edge):
- Apply a **fade gradient** that gently dissolves content into background
- Gradient should be soft and natural (not harsh cutoff)
- Direction: Fades content *towards* the glass element

**Adaptive Dimming**:
- If dark content scrolls under light glass → Apply subtle dimming gradient
- If light content scrolls under dark glass → Apply brightening gradient
- Maintains contrast and readability of glass controls

**Hard Style** (for pinned headers):
- When accessory views are pinned beneath toolbar (e.g., column headers)
- Use uniform fade/dim across full toolbar + accessory height
- Creates clear distinction between floating controls and scrolling content

**Implementation Approach**:
- Use `ShaderMask` or `ClipRect` with gradient mask
- Mask opacity driven by scroll position
- Animate smoothly as content enters/exits the glass zone

---

### 11. **Size-Based Material Thickness**
Glass appearance adapts based on element size—larger elements feel "thicker" and more substantial.

**Small Elements** (buttons, nav bar items):
- Refraction: Moderate (index ~1.21)
- Blur: Light (6-8px)
- Shadow: Subtle, soft
- Feels lightweight and responsive

**Medium Elements** (toolbars, tab bars):
- Refraction: Medium (index ~1.35)
- Blur: Standard (8-10px)
- Shadow: Defined but soft

**Large Elements** (menus, sheets, sidebars):
- Refraction: Strong (index ~1.5)
- Blur: Heavy (10-14px)
- Shadow: Deep, rich, with color bleeding
- Specular highlights more pronounced
- Feels substantial and grounded

**Transition**: When an element morphs from small to large (e.g., button expanding into menu), optical properties smoothly interpolate between small/large configurations.

---

## Motion & Animation Principles

### 12. **Spring-Based Physics (Motor Package)**
All Liquid Glass animations use **spring physics**, never linear easing. This creates organic, natural movement.

**Spring Types in Motor**:

1. **`Motion.interactiveSpring`**:
   - Use for: Active dragging, immediate response to touch
   - Characteristics: High stiffness, instant response
   - Duration: ~200-300ms
   - Minimal overshoot

2. **`Motion.bouncySpring`**:
   - Use for: Release animations, settling into place
   - Characteristics: Gentle overshoot, playful feel
   - Duration: ~400-600ms
   - Creates satisfying "bounce" at end

3. **`Motion.snappySpring`**:
   - Use for: Quick state changes, toggles
   - Characteristics: Fast, responsive, minimal bounce
   - Duration: ~150-300ms
   - Feels precise and immediate

**Velocity Inheritance**:
- When user releases a drag, capture the drag velocity
- Feed this velocity into the settling animation
- Creates momentum-based, realistic motion
- Example: Draggable indicator continues moving in direction of drag before settling

---

### 13. **Rubber Band Resistance (Beyond Boundaries)**
When users drag elements beyond their valid range, apply **iOS-style rubber band resistance**.

**Algorithm**:
```dart
double applyRubberBandResistance(
  double value,
  double min,
  double max, {
  double resistance = 0.4,
  double maxOverdrag = 0.3,
}) {
  if (value < min) {
    final overdrag = min - value;
    final adjustedOverdrag = overdrag * resistance;
    return min - adjustedOverdrag.clamp(0.0, maxOverdrag);
  } else if (value > max) {
    final overdrag = value - max;
    final adjustedOverdrag = overdrag * resistance;
    return max + adjustedOverdrag.clamp(0.0, maxOverdrag);
  }
  return value;
}
```

**Parameters**:
- **resistance**: How much to slow down drag beyond bounds (0.0 = no limit, 1.0 = complete stop)
  - Recommended: 0.4 (60% slower than normal drag)
- **maxOverdrag**: Maximum distance user can pull beyond bounds
  - Recommended: 0.3 (30% of element size)

**Feel**: Creates satisfying "pull against tension" feedback, prevents disorientation.

---

### 14. **Velocity-Based Target Selection**
When user releases a drag gesture, use both **position** and **velocity** to determine target.

**Smart Target Algorithm**:
```dart
int calculateDragTarget({
  required double currentPosition, // -1.0 to 1.0 (alignment)
  required double velocity,        // pixels/second
  required int itemCount,
  double velocityThreshold = 0.5,
  Duration projection = const Duration(milliseconds: 300),
}) {
  // Project position forward based on velocity
  final projectedPosition = currentPosition + 
    (velocity / 10.0) * (projection.inMilliseconds / 1000.0);
  
  // If velocity is high enough, use projected position
  final targetPosition = velocity.abs() > velocityThreshold
    ? projectedPosition
    : currentPosition;
  
  // Convert position to item index
  return positionToItemIndex(targetPosition, itemCount);
}
```

**Behavior**:
- **High velocity**: Indicator "flies" to item in direction of swipe, even if it's far
- **Low velocity**: Indicator settles to nearest item from current position
- **Threshold**: ~0.5 pixels/second is good default

---

## Glass Variants

### 15. **Regular Glass (Default)**
The most versatile variant—adapts to all contexts automatically.

**Characteristics**:
- Full adaptive behaviors (light/dark switching, size adaptation, etc.)
- Works over any content
- Provides guaranteed legibility in all situations
- Can have any content placed on top

**Use For**:
- Navigation bars and tab bars
- Toolbars and control panels
- Buttons and interactive elements
- Menus and dropdowns
- Any UI where legibility is critical

---

### 16. **Clear Glass (Transparent Variant)**
More transparent than Regular—shows richer background content but sacrifices some legibility.

**Characteristics**:
- **Permanently Transparent**: Does not adapt tint as much
- **No Automatic Dark/Light Flip**: Maintains consistent appearance
- **Requires Dimming Layer**: Must darken background content for contrast
- **Content Must Be Bold**: Only use with high-contrast symbols/labels

**Use Only When**:
1. Element is over **media-rich content** (photos, videos, colorful artwork)
2. Content layer can accept a **dimming overlay** without negative impact
3. Content on glass is **bold and bright** (thick icons, high-contrast text)

**Dimming Layer**:
- Apply semi-transparent black overlay (~20-40% opacity) beneath glass but above background content
- Can be **localized dimming** (only dim small area beneath glass element)
- Allows surrounding content to retain vibrancy

**Example Use Cases**:
- Controls overlaid on photo/video galleries
- Playback controls on media players
- Lock screen clock on photo wallpapers

---

## Tinting System

### 17. **Dynamic Color Tinting**
Liquid Glass supports custom colors that intelligently adapt to background content.

**How Tinting Works**:
1. Choose a base color (e.g., blue for primary action button)
2. System generates **a range of tonal variations** of that color
3. As background content changes, system **maps appropriate tone** based on brightness beneath element
4. Color shifts hue, brightness, and saturation to maintain:
   - Recognizable color identity
   - Maximum legibility and contrast
   - Physical glass-like behavior

**Tone Mapping**:
- **Over Dark Backgrounds**: Use brighter, more saturated tones
- **Over Bright Backgrounds**: Use darker, less saturated tones
- **Over Colorful Backgrounds**: Adjust hue slightly to maintain separation

**Behavior Example**:
- Red tinted button over black background: Bright, vivid red
- Same button over white background: Deep, rich burgundy
- Same button over blue content: Red with slight purple shift

**When to Use**:
- Primary action buttons (e.g., "Add", "Share", "Buy")
- Important status indicators
- Brand-specific elements that need color identity
- Selective emphasis—tint sparingly

**When NOT to Use**:
- Avoid tinting all elements (creates visual chaos)
- Don't tint secondary/tertiary actions
- Keep most navigation neutral (use tinting only for active state)

---

## Accessibility Features

### 18. **Reduce Transparency Mode**
When users enable "Reduce Transparency" in system settings:

**Changes**:
- Glass becomes **frostier** (more opaque)
- Blur intensity increases (~2x)
- Tint opacity increases (10% → 30-50%)
- Background content becomes significantly more obscured
- Maintains glass *appearance* but improves legibility dramatically

**Implementation**:
- Check `MediaQuery.of(context).accessibleNavigation` or equivalent
- Apply alternate glass settings when accessibility mode is active
- Transition smoothly between normal and accessible modes

---

### 19. **Increase Contrast Mode**
When users enable "Increase Contrast":

**Changes**:
- Glass elements become predominantly **black or white**
- Add **contrasting border** (1-2px solid, high contrast color)
- Reduce subtle gradient effects
- Increase shadow opacity and spread
- Simplify highlights to basic solid overlays

**Goal**: Maximum differentiation between UI layers, removes all ambiguity.

---

### 20. **Reduce Motion Mode**
When users enable "Reduce Motion":

**Changes**:
- **Disable elastic/jelly deformations** entirely
- Replace spring animations with **simple easeOut curves**
- Reduce intensity of morphing effects
- Shorten animation durations (cut by ~50%)
- Remove parallax/motion-responsive highlights
- Maintain functional animation (still show state changes) but remove decorative motion

---

## Performance Optimization

### 21. **RepaintBoundary Isolation**
Wrap frequently-animating elements in `RepaintBoundary` to isolate repaints.

**Apply To**:
- Individual nav bar items
- Draggable indicators
- FAB and action menus
- Any element with independent animation state

**Prevents**: One element's animation from triggering repaints of entire glass layer.

---

### 22. **Conditional Rendering**
Only render expensive effects when actually visible.

**Strategies**:
- Use `Visibility` widget to remove collapsed elements from render tree
- Use `Opacity(opacity: 0.0)` for invisible but layout-maintained elements
- Gate heavy effects behind visibility checks:
  ```dart
  if (isVisible && thickness > 0.0) {
    // Render expensive glass effects
  } else {
    // Render simple fallback
  }
  ```

---

### 23. **GPU-Accelerated Rendering**
Use shader-based rendering for glass effects when possible (via `liquid_glass_renderer` package or custom shaders).

**Benefits**:
- Offloads computation to GPU
- Handles blur, refraction, lighting in parallel
- Maintains 60+ FPS even with multiple glass layers

---

### 24. **Adaptive Quality**
On lower-end devices or when many glass elements are visible:
- Reduce blur radius
- Simplify refraction calculations
- Disable chromatic aberration
- Lower highlight detail
- Maintain appearance but optimize performance

---

## Design Principles (Key Guidelines)

### ✅ **DO:**
- Reserve Liquid Glass for **navigation layer** that floats above content
- Use Regular glass variant for most UI elements
- Allow glass to morph and adapt fluidly between states
- Let content shine through—glass should enhance, not obscure
- Apply tinting selectively to emphasize primary actions
- Embrace spring physics and organic motion
- Test across light/dark backgrounds to ensure adaptivity works

### ❌ **DON'T:**
- Never stack glass on glass (avoid glass in content layer)
- Don't place glass elements inside other glass elements
- Avoid tinting every element (creates confusion)
- Don't use Clear glass variant without meeting all three requirements
- Never mix Regular and Clear variants in same context
- Avoid overlapping glass content with glass controls (maintain separation)
- Don't use linear easing—always use spring physics

---

## Summary: The Complete System

**Liquid Glass is:**
1. **Multi-layered optical system**: Blur + refraction + tint + highlights + shadows + reflections
2. **Physically-inspired motion**: Spring physics, jelly deformation, momentum
3. **Intelligent adaptation**: Light/dark switching, size-based thickness, scroll effects
4. **Context-aware**: Responds to background content, user motion, interaction state
5. **Accessible**: Adapts for transparency, contrast, and motion preferences
6. **Performance-optimized**: RepaintBoundary, conditional rendering, GPU acceleration

**Implementation Strategy**:
- Use `motor` package for all animations (spring physics)
- Use `liquid_glass_renderer` for GPU-accelerated optical effects
- Implement multi-layer composition (blur → refract → tint → highlight → shadow)
- Add adaptive logic (brightness detection, size-based parameters)
- Wrap physics behaviors (rubber band, velocity tracking, jelly transform)
- Optimize rendering (RepaintBoundary, visibility checks)
- Support accessibility modes (reduce transparency, contrast, motion)

This creates an implementation that **feels like iOS 26**—fluid, alive, physically grounded, and intelligently adaptive.