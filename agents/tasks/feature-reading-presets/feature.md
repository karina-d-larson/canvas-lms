# Reading Preset Modes

## Problem statement

Many users benefit from coordinated sets of reading adjustments (font, spacing, contrast, theme) but should not be required to discover and tune each control individually. Canvas partially addresses this today via separate toggles (high contrast, dyslexic font) that are not presented as unified **reading modes** and do not compose with a broader customization program.

Preset modes reduce cognitive load and support common accessibility personas (dyslexia-friendly, low visual strain, high clarity) while remaining overridable via manual controls where product policy allows.

## User value

- One action applies a researched, accessible bundle of settings.
- Clear labels and descriptions help users pick a mode that matches their needs.
- Reduces time-to-comfort compared to manual tuning alone.

## Scope

- Define **preset catalog** (minimum three): e.g. Dyslexia-Friendly, Low-Strain Reading, High-Clarity (names finalized with UX/a11y review).
- Each preset maps to concrete preference keys (theme, typography, emphasis flags) via Preference Storage.
- Apply preset: atomic write of preference bundle + client-side re-application of theme/text/emphasis hooks.
- “Active preset” indicator in settings UI; switching preset updates all mapped keys.
- Optional: “Custom” state when user diverges from any preset snapshot (detect drift).
- Coexistence plan with legacy `use_dyslexic_font` / high-contrast toggles in Profile tray (deprecate, mirror, or link—document decision).

## Out of scope

- Building the settings shell layout (Reading Settings UI).
- Low-level preference API design (Preference Storage).
- Defining base theme tokens (Dark Mode)—presets **consume** them.
- Full typography slider UI (Text Customization)—presets set values programmatically.
- Institution-mandated forced themes.

## Dependencies on other features

- **Preference Storage (required).**
- **Dark Mode and Base Theme System (required):** Presets set `themeMode` and rely on token application.
- **Text Customization (soft):** Required if presets include font size/spacing beyond legacy dyslexic font flag; otherwise ship v1 with fixed preset typography values.
- **Content Emphasis (soft):** If presets include link/quote emphasis levels.
- **Reading Settings UI (required for user-facing v1).**
- **Accessibility Testing:** Sign-off per preset bundle.

## Success criteria

- Each preset applies end-to-end on supported pages and persists across sessions.
- Preset descriptions available to assistive tech (not icon-only).
- Documented mapping table: preset → preference keys → visual outcome.
- Users can switch presets without stale CSS (no mixed light/dark artifacts).
- Tests verify preset application, persistence, and drift detection if implemented.
