# Reading Settings UI Shell and Navigation Entry

## Problem statement

Reading customization capabilities spread across disconnected surfaces (Profile tray accessibility toggles, feature flags, future preference keys) create poor **discoverability** and inconsistent mental models. Users cannot find “how to make Canvas easier to read” in one place, and engineering teams lack a single mount point for new controls.

A dedicated settings shell is required to host dark mode, presets, typography, and emphasis controls with accessible structure, mobile layout, and clear navigation entry from global Chrome.

## User value

- One obvious place to manage all reading-related preferences.
- Predictable navigation from profile/account areas and/or global header.
- Grouped controls with helper text reduce trial-and-error configuration.

## Scope

- **Navigation entry points** (minimum one primary):
  - Link from Profile tray / profile settings area to “Reading & Display” (final label via i18n).
  - Optional deep link route under `/profile` or dedicated feature route (research spike in implementation doc).
- **Settings shell layout**:
  - Sections: Theme, Presets, Text, Content Emphasis (placeholders render disabled until upstream features land).
  - Responsive InstUI layout (FormFieldGroup, Heading hierarchy, save/status feedback).
- **Integration contracts**: shell imports presentational control components from feature packages or shared `@canvas/reading-customization` module—no business logic duplication.
- Loading and error states while Preference Storage fetches.
- Feature flag gating aligned with program rollout.
- i18n for all strings; RTL-safe layout.

## Out of scope

- Implementing persistence layer (Preference Storage).
- Theme token definitions (Dark Mode).
- Preset catalog logic (Reading Presets).
- Individual slider implementations beyond thin wrappers (owned by Text Customization / other features—but may ship stubbed sections).
- Account-admin configuration of forced reading modes.

## Dependencies on other features

- **Preference Storage (required):** Shell reads/writes through shared client API.
- **Consumes UI from (parallel or sequential delivery):**
  - Dark Mode (theme mode selector)
  - Reading Presets (preset picker)
  - Text Customization (typography controls)
  - Content Emphasis (emphasis level control)
- Shell can ship **Milestone 1** with skeleton sections + one integrated control (e.g. theme) before all consumers are ready.
- **Accessibility Testing:** UX review, keyboard path, screen reader structure.

## Success criteria

- Users open Reading Settings from documented entry point in ≤2 clicks from common student navigation.
- Page meets heading order, landmark, and form labeling requirements from a11y test plan.
- Each section delegates save/load to Preference Storage; no duplicate fetch logic per section.
- Mobile viewport usable without horizontal scroll for primary controls.
- Component tests cover navigation, loading, and error states.
