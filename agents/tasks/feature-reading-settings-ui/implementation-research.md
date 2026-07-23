# Implementation Research: Reading Settings UI Shell and Navigation Entry

## Overview

Create the **primary user-facing hub** for Canvas Accessibility Reading Customization: navigation entry, page layout, section scaffolding, and integration points for feature-specific controls. The shell owns UX structure, routing, loading states, and i18n—not business rules for themes, presets, or typography.

Canvas today exposes `HighContrastModeToggle` and dyslexic font toggles inside `ProfileTray.tsx` under “Accessibility Settings.” This feature introduces a cohesive **Reading & Display** destination while documenting migration path for legacy tray controls (link-out, duplicate, or deprecate).

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-UI-01 | User opens Reading Settings from global navigation in ≤2 clicks (student path). |
| FR-UI-02 | Page sections: Theme, Presets, Text, Content Emphasis (order fixed). |
| FR-UI-03 | Sections show disabled/coming-soon only until upstream feature merges; at least one section live in M1. |
| FR-UI-04 | Global save status: saving, saved, error (accessible). |
| FR-UI-05 | Mobile-responsive layout without horizontal scroll for controls. |
| FR-UI-06 | Feature flag hides entry and route when program off. |
| FR-UI-07 | RTL and i18n supported for all labels and help text. |

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-UI-01 | New feature package `ui/features/reading_settings/` (name TBD) with route registration. |
| TR-UI-02 | Profile tray link + optional `profile` settings tab entry. |
| TR-UI-03 | `ReadingSettingsPage` composes section components from shared `@canvas/reading-customization` or feature imports. |
| TR-UI-04 | Single `ReadingSettingsProvider` wrapping Preference Storage client. |
| TR-UI-05 | InstUI layout: `View`, `Heading` levels h1→h2 per section, `FormFieldGroup`. |
| TR-UI-06 | React Testing Library: render, navigation, error state. |
| TR-UI-07 | Top nav portal integration if required by modern Canvas pages (`initializeTopNavPortal` pattern). |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| `ui/features/navigation_header/react/trays/ProfileTray.tsx` | Entry link |
| `ui/features/navigation_header/react/trays/HighContrastModeToggle.tsx` | Legacy pattern reference |
| `config/routes.rb` | `profile` scope routes |
| `app/controllers/profile_controller.rb` | Possible new action/template |
| `ui/shared/tabs/SettingsTabs` | Tab patterns for settings pages |
| `ui/features/account_settings/` | Settings page structure reference |

## Architectural considerations

- **Shell vs sections:** Each downstream feature exports a `*SettingsSection` component with props `{preferences, onChange, disabled}`.
- **No fetch in sections:** Provider loads once; sections receive context.
- **Deep linking:** URL hash `#typography` optional for section focus.
- **Permissions:** Only `@current_user` settings; no course-level admin in v1.

## Risks and challenges

- **Route discovery:** Students may still use Profile tray—keep link updated.
- **Duplicate toggles** if tray and page both edit same pref without sync.
- **Bundle size:** Lazy-load section chunks per feature flag.

## Accessibility considerations

- Page title and h1 describe purpose (“Reading and display settings”).
- Landmark regions: `main`, section headings as h2.
- Save status uses `aria-live="polite"`.
- Keyboard order follows visual order; no keyboard traps in trays.
- Meets WCAG 2.2 AA for forms (labels, errors, instructions).

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M1 | Route + shell + Profile link + Theme section stub wired |
| M2 | All section slots + provider + save status |
| M3 | Integrate live sections as upstream features land |
| M4 | Legacy tray migration decision implemented |

## Dependencies

- **Requires:** Preference Storage (provider data).
- **Integrates (incremental):** Dark Mode, Reading Presets, Text Customization, Content Emphasis.
- **Validated by:** Accessibility Testing (page-level audit).

## Testing requirements

- RTL: render smoke test.
- RTL component tests for section order and headings.
- Manual: mobile 320px width, keyboard-only navigation from Profile.
- axe on full page with all sections enabled.

## Definition of Done

- [ ] Entry point live behind feature flag.
- [ ] All four sections mounted (stubs acceptable until upstream merges).
- [ ] Provider uses only Preference Storage public API.
- [ ] a11y page audit pass or documented waivers.
- [ ] Lab 4 issues created.

---

## Lab 4 Handoff Section

### User stories

| Story ID | Title |
|----------|-------|
| US-UI-01 | As a user, I want one settings page for reading options so I do not hunt through menus. |
| US-UI-02 | As a user, I want clear section labels so I know what theme vs text controls do. |
| US-UI-03 | As a screen reader user, I want structured headings on the reading settings page. |
| US-UI-04 | As a mobile user, I want to adjust reading settings without horizontal scrolling. |

### Supporting technical tasks

| Task ID | Title |
|---------|-------|
| T-UI-01 | Spike: route location (`/profile/reading` vs dedicated path) |
| T-UI-02 | Create `reading_settings` feature package + route |
| T-UI-03 | Implement `ReadingSettingsPage` shell with four sections |
| T-UI-04 | `ReadingSettingsProvider` + Preference Storage integration |
| T-UI-05 | Add Profile tray / profile navigation entry link |
| T-UI-06 | Accessible save status + error banner components |
| T-UI-07 | Lazy-load section bundles per feature flag |
| T-UI-08 | i18n strings + RTL layout verification |
| T-UI-09 | Legacy tray migration (link, deprecate, or sync) |
| T-UI-10 | Integrate `ThemeSettingsSection` from Dark Mode |
| T-UI-11 | Integrate `PresetPicker` from Reading Presets |
| T-UI-12 | Integrate `TypographySettingsSection` |
| T-UI-13 | Integrate `EmphasisSettingsSection` |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-UI-01 | RTL component tests for shell and provider |
| QA-UI-02 | Manual keyboard navigation script |
| QA-UI-03 | axe audit full page (all sections on) |
| QA-UI-04 | Mobile viewport checklist |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-UI-01 | In-app help link from settings page |
| DOC-UI-02 | Engineering guide: adding a new settings section |

### Dependency relationships

```
T-PS-04 → T-UI-04 → T-UI-03
T-UI-01 → T-UI-02 → T-UI-05
T-DM-02, T-DM-04 → T-UI-10
T-RP-04 → T-UI-11
T-TC-04 → T-UI-12
T-CE-04 → T-UI-13
T-UI-03 → US-UI-01
QA-UI-03 blocks US-UI-03 closure
```

### Suggested milestone structure

1. **UI-M1 Shell & entry** — T-UI-01, T-UI-02, T-UI-03, T-UI-04, T-UI-05, T-UI-06  
2. **UI-M2 Section integration** — T-UI-10 through T-UI-13 (parallel as upstream lands)  
3. **UI-M3 Polish & migration** — T-UI-07, T-UI-08, T-UI-09, QA-UI-*  

### Traceability guidance

- Prefix `[UI]`; map sections to downstream feature labels in Project custom field **Section**.
- Integration tasks T-UI-10–13 must `depends on` corresponding feature UI tasks.
- US-UI-03 closure requires linked QA-UI-02 and QA-UI-03 issues closed.
