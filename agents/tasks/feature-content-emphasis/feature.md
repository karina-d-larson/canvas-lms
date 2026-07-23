# Content Emphasis Enhancements

## Problem statement

Course HTML content often under-emphasizes structural cues that aid scanning: links blend with body text, blockquotes are subtle, and “important” instructor callouts may not stand out for users with low vision or attention difficulties. Global theme changes alone do not improve **within-content** discriminability.

Users need optional, consistent emphasis treatments applied to rendered course content—not one-off instructor styling—that remain accessible (contrast, not color-only cues).

## User value

- Links, quotations, and emphasized passages are easier to locate while reading long pages.
- Reduced eye strain when skimming discussions, syllabi, and assignment instructions.
- Settings align with user preference rather than browser extensions that break Canvas CSS.

## Scope

- Preference-driven emphasis levels (e.g. off / standard / strong) for:
  - Hyperlinks (`a[href]` in reading scopes)
  - `blockquote` and instructor quote patterns
  - Semantic emphasis: `strong`, `em`, and common callout classes if present in Canvas HTML sanitization output
- Styles implemented via scoped CSS (classes or `data-emphasis-level`) tied to Preference Storage.
- Optional underline + focus-visible enhancements for links (must not rely on color alone).
- Document interaction with Dark Mode tokens (emphasis colors from theme map).
- Reading surface selector list shared with Text Customization where possible.

## Out of scope

- Changing Canvas HTML sanitizer rules or RCE authoring toolbar.
- Accessibility checker for **author** content (existing `accessibility` routes for course scanning).
- Typography size/family controls (Text Customization).
- Full preset bundles (Reading Presets)—may set emphasis level as part of preset.
- Emphasis inside TinyMCE editor chrome while editing (student read path only for v1).

## Dependencies on other features

- **Preference Storage (required).**
- **Dark Mode and Base Theme System (required):** Emphasis colors must meet contrast in both themes.
- **Reading Settings UI (required)** for emphasis level control.
- **Reading Presets (soft):** May set default emphasis level per preset.
- **Accessibility Testing:** Verify non-color cues and contrast.

## Success criteria

- User can toggle emphasis levels and see consistent changes in scoped course content on reload/navigation.
- Link styles include non-color differentiation at “strong” level (underline, weight, or icon pattern per design spec).
- No breakage of keyboard focus indicators on emphasized links.
- Instructor-authored layouts remain readable; document max specificity to avoid fighting inline styles.
- Tests cover CSS application per level and persistence.
