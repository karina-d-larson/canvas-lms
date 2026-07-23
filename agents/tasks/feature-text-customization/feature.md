# Text Customization Controls

## Problem statement

Fixed typography in Canvas course content and UI chrome does not accommodate users with dyslexia, low vision, or cognitive fatigue who need larger text, increased line spacing, or alternative typefaces. Existing dyslexic font support is feature-flagged and narrow; there is no general-purpose, user-controlled typography layer for **reading surfaces**.

Without granular controls backed by persistence, users depend on browser zoom—which scales chrome unevenly and does not always affect iframe or legacy HTML content predictably.

## User value

- Adjust font family (from an approved list), text size, line height, letter spacing, and paragraph spacing for reading areas.
- Fine-tune reading comfort without leaving Canvas.
- Manual settings compose with presets when users need small tweaks after selecting a mode.

## Scope

- User-facing controls (wired through Reading Settings UI) for:
  - Font family (curated list; include OpenDyslexic or equivalent only if licensed and already approved in Canvas stack).
  - Base text size scale (relative steps, e.g. 100%–150%).
  - Line height and letter spacing multipliers.
  - Paragraph spacing (margin-block) for course content containers.
- CSS application strategy scoped to **reading content selectors** (wiki pages, assignment descriptions, discussion bodies, module items)—document exact selector list.
- Persist all values via Preference Storage; live preview on change.
- Respect `prefers-reduced-motion` for preview transitions.
- Minimum font size floor and maximum scale ceiling to prevent layout breakage.

## Out of scope

- Changing institution brand fonts globally.
- Typography inside third-party LTI tools unless they inherit parent document styles.
- RCE authoring-time font picker changes (instructor content creation).
- Color theme selection (Dark Mode).
- Link/quote styling (Content Emphasis).

## Dependencies on other features

- **Preference Storage (required).**
- **Dark Mode and Base Theme System (required):** Typography scales must work on light and dark token backgrounds.
- **Reading Settings UI (required)** for controls placement and labeling.
- **Reading Presets (consumer):** Presets may set typography keys; Text Customization must handle override semantics.
- **Accessibility Testing:** Validation of readability and reflow.

## Success criteria

- Users adjust each control and see changes in defined reading regions without full page reload.
- Settings persist and reapply on navigation within Canvas SPA boundaries where applicable.
- Layout remains usable at maximum allowed scale (no critical action buttons permanently off-screen in primary flows).
- Screen reader announcements for control changes where dynamic updates occur.
- Automated tests for CSS variable application and API persistence.
