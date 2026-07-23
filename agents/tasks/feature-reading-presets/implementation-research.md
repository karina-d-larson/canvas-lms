# Implementation Research: Reading Preset Modes

## Overview

Deliver **one-click reading modes** that atomically apply a curated bundle of preference values (theme, typography, emphasis, and legacy-compatible flags). Presets sit above individual controls: they write through Preference Storage and trigger the same application hooks as manual changes (theme engine, typography CSS, emphasis styles).

Align with existing Canvas accessibility affordances (`use_dyslexic_font`, `prefers_high_contrast?`) by defining explicit mapping rather than duplicating parallel toggles indefinitely.

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-RP-01 | User selects a preset from a fixed catalog with plain-language descriptions. |
| FR-RP-02 | Applying a preset updates all mapped preference keys in one transaction. |
| FR-RP-03 | UI shows which preset is active. |
| FR-RP-04 | User can switch presets without page reload (where SPA applies hooks). |
| FR-RP-05 | Optional: entering manual controls marks state as Custom when values diverge from preset snapshot. |
| FR-RP-06 | Preset Off / None restores documented baseline defaults. |

### Preset catalog (v1 draft)

| Preset ID | Intent | Maps to (example) |
|-----------|--------|-------------------|
| `dyslexia_friendly` | Dyslexia support | dyslexic font, increased line height, standard emphasis, light theme |
| `low_strain` | Reduced visual fatigue | dark theme, reduced contrast saturation, soft emphasis |
| `high_clarity` | Maximum legibility | light theme, high text scale, strong emphasis, increased line height |

Final values require a11y review with feature-accessibility-testing.

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-RP-01 | `presets.ts` (or YAML) single source of truth for preset → preference map. |
| TR-RP-02 | `applyPreset(id)` calls Preference Storage batch update then `ReadingCustomizationCoordinator` refresh. |
| TR-RP-03 | Server validates `active_preset_id` enum. |
| TR-RP-04 | Legacy sync: optional bridge to `Features::Flags` for `use_dyslexic_font` when preset requires it. |
| TR-RP-05 | i18n strings for names/descriptions via `@canvas/i18n`. |
| TR-RP-06 | Jest: each preset produces expected preference object. |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| `ui/features/navigation_header/react/trays/ProfileTray.tsx` | Existing accessibility section |
| `HighContrastModeToggle.tsx`, dyslexic toggle components | Legacy UX |
| `app/models/user.rb` | `prefers_dyslexic_font?`, `prefers_high_contrast?` |
| Preference Storage module | Batch writes |
| Dark Mode / Text / Emphasis apply hooks | Post-preset refresh |

## Architectural considerations

- **Atomic apply:** Single API call with full snapshot prevents half-applied presets.
- **Snapshot drift:** Store `preset_snapshot_version` if catalog changes mid-semester.
- **Coordinator pattern:** One `refreshReadingCustomization()` invoked after preset apply to order: theme → typography → emphasis.
- **Do not fork** high-contrast CSS bundles (`new_styles_*`) without engineering review—prefer reading layer first.

## Risks and challenges

- **Conflicting toggles** in Profile tray vs new presets—UX must explain source of truth.
- **Preset marketing names** vs medical claims—use “friendly” not “treatment” language.
- **Performance** applying many CSS variables at once—batch DOM writes.

## Accessibility considerations

- Preset control is a **radio group** or single-select list with full descriptions exposed to AT.
- Avoid color-only preset icons.
- Verify each preset bundle passes contrast/reflow tests (Accessibility Testing feature).
- Changing preset announces result via Settings UI live region.

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M1 | Preset catalog + `applyPreset` + tests |
| M2 | Persistence + active indicator |
| M3 | Settings UI integration + i18n |
| M4 | Legacy toggle coexistence doc + optional sync |

## Dependencies

- **Requires:** Preference Storage, Dark Mode, Reading Settings UI.
- **Soft:** Text Customization, Content Emphasis (for full mapped keys).
- **Validates:** Accessibility Testing per preset.

## Testing requirements

- Unit: mapping tables per preset ID.
- Integration: apply preset → DOM attributes + ENV-consistent state.
- Manual: switch presets on course wiki and discussion.
- Regression: legacy dyslexic/high-contrast when flag off.

## Definition of Done

- [ ] Three presets shipped with signed a11y matrix.
- [ ] Catalog versioned and documented.
- [ ] No half-state on failed API (rollback or error UI).
- [ ] Issues created from Lab 4 handoff.

---

## Lab 4 Handoff Section

### User stories

| Story ID | Title |
|----------|-------|
| US-RP-01 | As a user with dyslexia, I want a dyslexia-friendly mode that configures multiple settings at once. |
| US-RP-02 | As a user with eye strain, I want a low-strain mode I can enable without tuning each slider. |
| US-RP-03 | As a user, I want to see which reading mode is active so I know what changed. |
| US-RP-04 | As a user, I want to turn off presets and return to default reading settings. |

### Supporting technical tasks

| Task ID | Title |
|---------|-------|
| T-RP-01 | Author preset catalog v1 with preference mappings |
| T-RP-02 | Implement `applyPreset` + coordinator refresh |
| T-RP-03 | Server enum validation for `active_preset_id` |
| T-RP-04 | Build PresetPicker component for Settings UI |
| T-RP-05 | Drift detection → Custom state (optional) |
| T-RP-06 | Legacy toggle sync spike + implementation decision |
| T-RP-07 | i18n for preset names and help text |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-RP-01 | Unit tests per preset mapping |
| QA-RP-02 | Manual cross-page preset persistence |
| QA-RP-03 | A11y sign-off per preset (link QA-A11Y issues) |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-RP-01 | Preset catalog table for support/docs |
| DOC-RP-02 | Coexistence with Profile tray accessibility toggles |

### Dependency relationships

```
T-PS-04, T-DM-04 → T-RP-02
T-RP-01 → T-RP-03 → T-RP-02
T-RP-04 → T-UI-03 (Settings shell section)
T-RP-02 → US-RP-01, US-RP-02
QA-RP-03 blocks release of each preset
```

### Suggested milestone structure

1. **RP-M1 Catalog & apply logic** — T-RP-01, T-RP-02, T-RP-03  
2. **RP-M2 UX** — T-RP-04, T-RP-07, US-RP-03, US-RP-04  
3. **RP-M3 Legacy & drift** — T-RP-05, T-RP-06, QA-RP-03  

### Traceability guidance

- Prefix `[RP]`; reference preset ID in acceptance criteria (`dyslexia_friendly`).
- Each preset row in a11y matrix links to `QA-RP-03` sub-issue or checklist item.
- Manual typography issues link `depends on` Text Customization only if FR-RP maps those keys.
