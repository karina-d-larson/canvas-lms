# Implementation Research: Content Emphasis Enhancements

## Overview

Improve scanability of **rendered course HTML** by applying user-selected emphasis levels to links, blockquotes, and strong emphasis elements within reading scopes. Styles consume Dark Mode tokens and persist via Preference Storage; controls live in Reading Settings UI.

Distinct from instructor-facing accessibility scanning (`config/routes.rb` `resources :accessibility`)—this feature targets **student reading experience**, not author remediation workflows.

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-CE-01 | User selects emphasis level: Off, Standard, Strong. |
| FR-CE-02 | Links gain progressive visual distinction (underline, weight, focus ring enhancement). |
| FR-CE-03 | Blockquotes gain border/background cues visible in light and dark themes. |
| FR-CE-04 | `strong`/`em` content has optional background or weight bump at Strong level. |
| FR-CE-05 | Emphasis applies only inside reading selector manifest. |
| FR-CE-06 | Setting persists across sessions. |

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-CE-01 | CSS classes: `reading-emphasis--standard`, `reading-emphasis--strong` on root or wrapper. |
| TR-CE-02 | Link styles must include non-color cue at Strong (underline min 2px or equivalent). |
| TR-CE-03 | `:focus-visible` outlines meet contrast in both themes. |
| TR-CE-04 | Avoid breaking `:visited` link semantics—document color choices. |
| TR-CE-05 | Preference key `emphasis_level` via Preference Storage. |
| TR-CE-06 | Jest: class toggling; axe tests in reading fixture HTML. |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| Course wiki / page show templates | HTML output hosts |
| Discussion topic views | User-generated HTML |
| Assignment show | Description HTML |
| `ui/shared/rce/contentStyles.css` (if present) | Baseline content styles—coordinate |
| Dark Mode token file | Link/quote colors |

## Architectural considerations

- **Specificity:** Prefer `.reading-content-root.reading-emphasis--strong a` over global `a` rules.
- **Sanitized HTML:** Only target tags Canvas already allows; do not style unknown elements aggressively.
- **Instructor themes:** Inline styles from RCE may override—document limitations in user help.
- **Print stylesheet:** Emphasis should remain meaningful in print (underline preserved).

## Risks and challenges

- **Over-emphasis** causing clown-like pages—Strong level still restrained.
- **Visited links** contrast in dark mode.
- **Discussion quotes** nested blockquotes—test depth.

## Accessibility considerations

- WCAG 1.4.1 Use of Color: Strong level requires non-color identification for links.
- Do not remove focus indicators.
- Blockquote emphasis must not rely on color alone (border/pattern).
- Screen reader users benefit from semantic HTML unchanged—this is visual only.

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M1 | CSS emphasis levels + selector manifest integration |
| M2 | Persistence + apply hook in coordinator |
| M3 | Settings UI Emphasis section |
| M4 | Preset mapping for emphasis keys |

## Dependencies

- **Requires:** Preference Storage, Dark Mode, Reading Settings UI, selector manifest (from Text Customization M1 or shared task).
- **Soft:** Reading Presets.
- **Validates:** Accessibility Testing.

## Testing requirements

- Fixture HTML with links, quotes, strong/em at each level.
- axe: no new violations vs baseline.
- Keyboard tab through links—focus visible.
- Dark + light screenshot review (manual).

## Definition of Done

- [ ] Three levels implemented per spec.
- [ ] Contrast sign-off for link/quote in both themes.
- [ ] Shared selector manifest with typography feature.
- [ ] Lab 4 issues filed.

---

## Lab 4 Handoff Section

### User stories

| Story ID | Title |
|----------|-------|
| US-CE-01 | As a user, I want links in readings to stand out so I do not lose them in paragraphs. |
| US-CE-02 | As a user, I want quotations visually distinct so I can separate cited text. |
| US-CE-03 | As a user, I want to reduce emphasis effects if they feel distracting. |

### Supporting technical tasks

| Task ID | Title |
|---------|-------|
| T-CE-01 | Share/consume reading content selector manifest |
| T-CE-02 | Implement emphasis level CSS (off/standard/strong) |
| T-CE-03 | Wire `emphasis_level` to Preference Storage |
| T-CE-04 | Build EmphasisSettings section in Settings UI |
| T-CE-05 | Token integration for link/quote colors (Dark Mode) |
| T-CE-06 | Coordinator hook after emphasis change |
| T-CE-07 | Preset bundle includes emphasis keys |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-CE-01 | HTML fixture tests per emphasis level |
| QA-CE-02 | axe regression on sample course page markup |
| QA-CE-03 | Keyboard focus visibility manual script |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-CE-01 | User help: what emphasis changes |
| DOC-CE-02 | Known limitations with inline RCE styles |

### Dependency relationships

```
T-TC-01 or T-CE-01 → T-CE-02
T-DM-01 → T-CE-05
T-PS-04 → T-CE-03
T-UI-02 → T-CE-04
T-RP-01 → T-CE-07 (optional mapping)
```

### Suggested milestone structure

1. **CE-M1 Styles** — T-CE-01, T-CE-02, T-CE-05  
2. **CE-M2 Persistence & UI** — T-CE-03, T-CE-04, T-CE-06  
3. **CE-M3 Presets & QA** — T-CE-07, QA-CE-*  

### Traceability guidance

- Prefix `[CE]`; acceptance must cite non-color link cue for US-CE-01 at Strong level.
- Link QA-CE-02 to Accessibility Testing epic.
