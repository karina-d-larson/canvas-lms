# Implementation Research: Dark Mode and Base Theme System

## Overview

Establish a **reading theme layer** that applies light, dark, and system-aligned color schemes using shared CSS custom properties and InstUI theme overrides. Persist selection via Preference Storage and apply as early as possible in the page lifecycle to minimize flash of incorrect theme.

Canvas already uses `@instructure/platform-instui-bindings`, `CanvasThemeProvider`, career themes via URL params, and high-contrast InstUI themes (`canvasHighContrast`). This feature adds a **user-controlled reading dark mode** distinct from institutional branding, with explicit boundaries so brand colors and admin themes are not broken.

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-DM-01 | User selects Light, Dark, or System default for reading theme. |
| FR-DM-02 | System option follows `prefers-color-scheme` with listener for changes. |
| FR-DM-03 | Theme applies to global shell and defined reading content regions. |
| FR-DM-04 | Selection persists across sessions via Preference Storage. |
| FR-DM-05 | Theme does not activate when program feature flag is off. |
| FR-DM-06 | Existing high-contrast preference continues to work; document interaction order (HC may override or stack). |

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-DM-01 | CSS variable map `--reading-*` on `document.documentElement` or `body`. |
| TR-DM-02 | Bridge to `getStableTheme` / `CanvasThemeProvider` for React islands. |
| TR-DM-03 | Boot script or inline ENV: apply `data-reading-theme` before first paint where possible. |
| TR-DM-04 | Extend `css_variant` / brandable CSS only if required—prefer overlay layer to reduce bundle churn. |
| TR-DM-05 | Update `EnvCommon.d.ts` with `reading_theme_mode` when embedded in ENV. |
| TR-DM-06 | Jest tests: theme class toggling; visual regression optional. |
| TR-DM-07 | Document pages excluded (SpeedGrader iframe, LTI, print stylesheet). |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| `ui/shared/react/index.tsx` | `getStableTheme`, `CanvasThemeProvider` |
| `ui/shared/planner/getThemeVars.js` | High contrast + dyslexic theme vars |
| `ui/shared/k5/react/K5ThemeProvider.tsx` | K5 theme path |
| `app/helpers/application_helper.rb` | `css_variant`, stylesheet URLs |
| `app/controllers/application_controller.rb` | `js_env` |
| `ui/features/navigation_header/` | Global chrome |
| Course content wrappers | Wiki, assignments, discussions DOM |

## Architectural considerations

- **Layered themes:** Reading dark mode as overlay; InstUI brand theme remains base for components unless explicitly overridden.
- **Specificity budget:** Use `data-reading-theme="dark"` attribute selectors to avoid `!important` wars with legacy SCSS.
- **Career theme URL params:** Reading theme must not conflict with `instui_theme=career-dark`—define precedence table.
- **SSR/hybrid pages:** Some ERB pages may need body class from server using same pref as ENV.

## Risks and challenges

- **Incomplete dark coverage** on legacy jQuery pages—maintain exception list and phased rollout.
- **Third-party content** in iframes will not inherit parent theme.
- **Contrast failures** when institution brand colors clash—token map must be self-contained.
- **Double dark** if user also uses OS dark and Canvas light—System mode must be tested.

## Accessibility considerations

- Maintain WCAG AA contrast for text/background pairs in both modes (validated in Accessibility Testing feature).
- Respect `prefers-contrast: more` where browsers support it (enhancement, not v1 blocker).
- Theme switch should not steal focus; optional `aria-live="polite"` announcement via Settings UI.
- Do not disable focus rings when swapping colors.

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M1 | Token map + `data-reading-theme` application on boot |
| M2 | Light/dark/system persistence + ENV sync |
| M3 | InstUI bridge for major React layouts |
| M4 | Reading content region coverage + exception doc |

## Dependencies

- **Requires:** Preference Storage (`theme_mode` key, ENV contract).
- **Recommends:** Reading Settings UI for theme selector component.
- **Blocks:** Reading Presets, Text Customization, Content Emphasis (visual assumptions).

## Testing requirements

- Unit: resolver for system/light/dark given ENV + `matchMedia`.
- Integration: preference update → reload → correct `data-reading-theme`.
- Manual: spot-check course home, wiki, discussion, mobile width.
- A11y: contrast table for token pairs (hand off to feature-accessibility-testing).

## Definition of Done

- [ ] Token documentation with contrast ratios attached.
- [ ] Theme applies on supported pages per exception doc.
- [ ] No regression when `reading_customization` flag off.
- [ ] Integrated with Preference Storage and Settings UI theme control.
- [ ] GitHub issues from Lab 4 handoff created.

---

## Lab 4 Handoff Section

### User stories

| Story ID | Title | Acceptance hints |
|----------|-------|------------------|
| US-DM-01 | As a user, I want dark mode for Canvas reading areas so I can study in low light. | Dark backgrounds on shell + wiki-like pages |
| US-DM-02 | As a user, I want Canvas to follow my device theme when I choose System. | OS theme change updates Canvas without re-login |
| US-DM-03 | As a user, I want my theme choice saved so I do not reset it every visit. | Persists via Preference Storage |

### Supporting technical tasks

| Task ID | Title |
|---------|-------|
| T-DM-01 | Design `--reading-*` CSS token map (light + dark) |
| T-DM-02 | Implement `applyReadingTheme(mode)` client utility |
| T-DM-03 | Boot-time application from ENV / inline snippet |
| T-DM-04 | Integrate `theme_mode` with Preference Storage read/write |
| T-DM-05 | InstUI `CanvasThemeProvider` override bridge spike + implementation |
| T-DM-06 | Scope stylesheet for reading content selectors |
| T-DM-07 | Document precedence vs `use_high_contrast` and career themes |
| T-DM-08 | Feature flag guard + fallback to legacy behavior |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-DM-01 | Automated tests for theme resolver and DOM attributes |
| QA-DM-02 | Manual matrix: light/dark/system × high contrast on/off |
| QA-DM-03 | Contrast audit (link to FR-A11Y contrast tasks) |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-DM-01 | Supported pages and known exclusions list |
| DOC-DM-02 | Token reference for downstream features (emphasis, presets) |

### Dependency relationships

```
T-PS-04, T-PS-05 (Preference Storage) → T-DM-04
T-DM-01 → T-DM-02 → T-DM-03
T-DM-04 → US-DM-03
T-DM-05 depends on T-DM-01
Reading Settings UI: T-UI-* hosts theme selector → depends on T-DM-02, T-DM-04
```

### Suggested milestone structure

1. **DM-M1 Tokens & DOM application** — T-DM-01, T-DM-02, T-DM-03  
2. **DM-M2 Persistence & ENV** — T-DM-04, US-DM-03, T-DM-08  
3. **DM-M3 InstUI & content scope** — T-DM-05, T-DM-06, US-DM-01, US-DM-02  

### Traceability guidance

- Prefix: `[DM]` + `FR-DM-*` / `TR-DM-*` in issue bodies.
- Link all contrast failures to **feature-accessibility-testing** issues with `blocks` relationship.
- Preset feature issues that set `theme_mode` must reference `DOC-DM-02` for allowed values.
