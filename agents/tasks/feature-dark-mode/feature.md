# Dark Mode and Base Theme System

## Problem statement

Canvas’s default presentation is optimized for institutional branding and general usability, not individualized low-light or reduced-glare reading. Users who need darker backgrounds, adjusted foreground contrast, or a consistent token layer for other reading tools currently rely on ad hoc browser extensions or OS-level inversion—which breaks Canvas layouts, InstUI components, and course content styling.

A first-party **base theme system** is required so reading customization can apply predictable, testable visual changes across React (InstUI) surfaces and legacy stylesheet bundles without each feature inventing its own CSS strategy.

## User value

- Comfortable reading in low-light environments with a Canvas-native dark theme (not browser hacks).
- Consistent colors and contrast across navigation, course content, and common widgets.
- Foundation for presets and manual customization that reference shared design tokens.

## Scope

- **Theme token map** for reading customization (background, text, border, link, focus, surface elevations) aligned where possible with InstUI/`@instructure/ui-themes`.
- **Light and dark** (and “system” follow `prefers-color-scheme` if product agrees) modes.
- **Application mechanism**: document-level class and/or `data-reading-theme` attribute; bridge to `CanvasThemeProvider` / `getStableTheme` patterns in `ui/shared/react/index.tsx`.
- Integration with **preference storage** for selected theme mode.
- FOUC prevention: apply saved theme as early as permitted in page boot (inline snippet or synchronous read from embedded ENV slice).
- Scope boundaries for v1: which page types and bundles receive dark styles (minimum: global shell + primary content regions used for reading).

## Out of scope

- Full remapping of every Canvas plugin and third-party LTI iframe (document as known limitation).
- Dyslexia or low-strain **presets** (Reading Presets feature).
- Per-element font/spacing sliders (Text Customization).
- Link/quote emphasis rules (Content Emphasis).
- Institution brand theme editor changes.

## Dependencies on other features

- **Preference Storage (required):** Persist `themeMode` (and related keys).
- **Reading Settings UI (recommended for v1 UX):** Users need a discoverable control; interim ENV-only toggles acceptable only for dev milestones.
- **Blocks:** Reading Presets, Text Customization, Content Emphasis (token/contrast assumptions).

## Success criteria

- User can select light/dark/system and see theme applied on reload without flash of wrong theme (within defined pages).
- Theme tokens drive at least global shell and course content reading areas; documented exceptions list.
- Contrast ratios for core text/background pairs meet WCAG AA targets defined in Accessibility Testing feature (or documented waivers with rationale).
- No regression to existing `use_high_contrast` behavior when reading customization flag is off.
- Automated tests cover theme application and preference round-trip.
