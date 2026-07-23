# Implementation Research: Text Customization Controls

## Overview

Provide user-controlled typography adjustments for **reading surfaces** in Canvas, persisted through Preference Storage and applied via CSS custom properties scoped to course content containers. Complements—not replaces—existing `use_dyslexic_font` and classic font ENV flags by offering granular scale and spacing within the reading customization program.

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-TC-01 | User adjusts text size on a stepped scale within safe min/max. |
| FR-TC-02 | User selects font family from approved list. |
| FR-TC-03 | User adjusts line height and letter spacing. |
| FR-TC-04 | User adjusts paragraph spacing in reading content. |
| FR-TC-05 | Changes preview live in reading regions. |
| FR-TC-06 | Values persist and reload on navigation. |
| FR-TC-07 | Controls respect feature flag and do not affect admin/account settings pages. |

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-TC-01 | Map preferences to CSS vars: `--reading-font-size`, `--reading-line-height`, etc. |
| TR-TC-02 | Selector manifest shared with Content Emphasis (`reading-content-root` class or data attribute on wrappers). |
| TR-TC-03 | Integrate `ENV.USE_CLASSIC_FONT` / `use_dyslexic_font` rules—document override order. |
| TR-TC-04 | Debounce API writes (300ms) during slider drag. |
| TR-TC-05 | InstUI `RangeInput` / `Select` components in Settings UI section. |
| TR-TC-06 | Jest + optional style snapshot tests. |
| TR-TC-07 | Cap `text_scale_percent` at 150% for v1 (tunable). |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| `ui/shared/react/index.tsx` | `useDyslexicFont`, `USE_CLASSIC_FONT` in theme key |
| `app/controllers/application_controller.rb` | ENV injection |
| `app/helpers/application_helper.rb` | `css_variant` dyslexic suffix |
| Wiki / assignment / discussion view templates | Content wrapper hooks |
| `ui/shared/rce/` | Display of authored HTML (read-only path) |

## Architectural considerations

- **Relative units:** Use `rem`/% based on root reading scale, not px-only, for zoom compatibility.
- **Wrapper requirement:** Engineering must add stable wrapper on content hosts—coordinate with course team templates.
- **RCE content** may include inline font sizes—document that scale multiplies where possible without fighting inline styles.
- **Preset interaction:** Manual change after preset sets `active_preset_id` to `custom` if drift detection enabled.

## Risks and challenges

- **Layout breakage** at max scale in tables and rubrics—test critical flows.
- **Font licensing** for dyslexic typefaces.
- **Mixed React/jQuery pages** missing wrapper—extend manifest over time.

## Accessibility considerations

- All controls have visible labels and `aria-valuemin/max/now` on ranges.
- Reflow at 200% zoom must not require horizontal scroll for primary reading column (WCAG 1.4.10).
- Motion: no animating font size beyond  prefers-reduced-motion.
- Settings UI announces applied changes politely.

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M1 | Selector manifest + CSS var application |
| M2 | Typography preference keys + persistence |
| M3 | Settings UI controls + debounced save |
| M4 | Preset override / custom state integration |

## Dependencies

- **Requires:** Preference Storage, Dark Mode, Reading Settings UI.
- **Related:** Reading Presets, Accessibility Testing.

## Testing requirements

- Unit: CSS var computation from preference object.
- Integration: slider change → API → reload → same computed styles.
- Manual: discussion thread, wiki page, assignment description at min/max scale.
- A11y: reflow and AT reading order unchanged.

## Definition of Done

- [ ] Selector manifest checked in and used by emphasis feature.
- [ ] All FR-TC controls functional in Settings UI.
- [ ] Caps documented; no critical UI clipped at max scale on primary student paths.
- [ ] Lab 4 issues created.

---

## Lab 4 Handoff Section

### User stories

| Story ID | Title |
|----------|-------|
| US-TC-01 | As a user, I want to increase text size in course content so I can read without browser zoom. |
| US-TC-02 | As a user, I want to change line spacing so lines do not blur together. |
| US-TC-03 | As a user, I want to pick a readable font from a list safe for Canvas. |
| US-TC-04 | As a user, I want more space between paragraphs when reading long pages. |

### Supporting technical tasks

| Task ID | Title |
|---------|-------|
| T-TC-01 | Define reading content selector manifest |
| T-TC-02 | Implement typography CSS variable application |
| T-TC-03 | Wire typography keys to Preference Storage |
| T-TC-04 | Build TypographySettings section components |
| T-TC-05 | Debounced save + error handling |
| T-TC-06 | Font family list + licensing check |
| T-TC-07 | Integrate preset/custom state with Reading Presets |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-TC-01 | Unit tests for style computation |
| QA-TC-02 | Manual reflow at 100% and 150% scale |
| QA-TC-03 | Cross-browser: Chrome, Firefox, Safari (project minimum) |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-TC-01 | Selector manifest and page coverage |
| DOC-TC-02 | User-facing help: typography controls |

### Dependency relationships

```
T-PS-04 → T-TC-03
T-DM-01 → T-TC-02 (tokens on dark bg)
T-UI-02 → T-TC-04 (Settings shell hosts section)
T-TC-01 → T-CE-01 (shared manifest with Content Emphasis)
```

### Suggested milestone structure

1. **TC-M1 Application layer** — T-TC-01, T-TC-02  
2. **TC-M2 Persistence & UI** — T-TC-03, T-TC-04, T-TC-05  
3. **TC-M3 Integration** — T-TC-06, T-TC-07, US-TC-*  

### Traceability guidance

- Prefix `[TC]`; link each US-TC to `FR-TC-*`.
- QA-TC-02 must reference WCAG 1.4.4 / 1.4.12 criteria IDs in a11y matrix.
