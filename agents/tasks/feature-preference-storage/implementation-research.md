# Implementation Research: Preference Storage and Persistence

## Overview

Introduce a namespaced, versioned **reading customization preference model** on top of Canvas’s existing user preference infrastructure. Expose a small authenticated API and a client-side module that other features use exclusively for read/write—avoiding ad hoc `User#preferences` keys scattered across controllers.

Canvas today stores assorted flags in `user.preferences` hashes and feature flags (e.g. `use_dyslexic_font`), and injects accessibility state into `window.ENV` from `ApplicationController`. This feature consolidates **new** reading customization keys while documenting coexistence with legacy toggles until migration completes.

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-PS-01 | System stores reading preferences per authenticated user. |
| FR-PS-02 | Preferences include schema version for forward-compatible migrations. |
| FR-PS-03 | Client loads preferences on session start (ENV bootstrap and/or async fetch). |
| FR-PS-04 | Updates validate types, ranges, and allowed enum values server-side. |
| FR-PS-05 | Partial updates merge with existing prefs without wiping unrelated keys. |
| FR-PS-06 | Feature flag disables API/UI consumers while preserving stored data. |
| FR-PS-07 | API returns stable JSON shape documented for frontend consumers. |

### Proposed initial schema (v1)

```json
{
  "reading_customization_version": 1,
  "theme_mode": "system | light | dark",
  "active_preset_id": "none | dyslexia_friendly | low_strain | high_clarity | custom",
  "typography": {
    "font_family": "default | classic | dyslexic",
    "text_scale_percent": 100,
    "line_height_multiplier": 1.0,
    "letter_spacing_multiplier": 1.0,
    "paragraph_spacing_multiplier": 1.0
  },
  "emphasis_level": "off | standard | strong"
}
```

Exact keys may shift during design review; version field is mandatory.

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-PS-01 | Persist via `User#preferences` and/or `UserPreferenceValue` following existing patterns (see `users_controller`, `profile_controller`). |
| TR-PS-02 | Add controller endpoint or extend `UsersController` / `ProfileController` with `reading_customization` param whitelist. |
| TR-PS-03 | Include subset of prefs in `@js_env` for FOUC-sensitive consumers (coordinate with Dark Mode). |
| TR-PS-04 | Client package: `ui/shared/reading-customization-preferences/` (name TBD) with `load`, `update`, `subscribe`. |
| TR-PS-05 | Strong params + schema validation (Rails model or dry-validation style if used nearby). |
| TR-PS-06 | RSpec request specs + Jest unit tests for client merge logic. |
| TR-PS-07 | Audit permission: user may only read/write own prefs (unless admin tool added later). |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| `app/models/user.rb` | `preferences` hash, feature flag helpers |
| `app/controllers/users_controller.rb` | Preference update patterns |
| `app/controllers/profile_controller.rb` | Profile-related updates |
| `app/controllers/application_controller.rb` | `js_env` augmentation |
| `db/schema` / `user_preference_values` | Optional normalized storage |
| `ui/shared/global/env/EnvCommon.d.ts` | Type definitions for ENV slice |
| `config/initializers/jwt_workflow.rb` | Mobile/JWT env parity if needed |

## Architectural considerations

- **Single writer principle:** Only the preference service module mutates reading customization keys on the client; feature UIs call service methods.
- **ENV vs fetch:** Critical keys needed before paint (theme) should be embedded in ENV; bulky or rare keys can lazy-load.
- **Legacy coexistence:** Do not remove `prefers_high_contrast?` or `use_dyslexic_font` in v1; document sync rules if preset sets dyslexic font.
- **Idempotent migrations:** On version bump, run server-side transform once per user read.
- **Rate limiting:** Reuse Canvas API throttling patterns for rapid slider updates (debounce client-side).

## Risks and challenges

- **Preference drift** between Profile tray toggles and new keys if not synchronized.
- **Large JSON blobs** in `preferences` hash—keep schema flat and small.
- **Cached pages/CDN** may serve stale ENV—document cache bust on preference update.
- **Multi-tab races** last-write-wins—acceptable for v1 with optional ETag later.

## Accessibility considerations

- API error messages exposed to UI must be perceivable (not toast-only with timeout &lt; 5s).
- Save failures must not trap keyboard focus.
- No user-facing strings in this feature alone—coordinate with Settings UI for announcements on save.

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M1 | Schema doc + feature flag + read API |
| M2 | Write API + validation + RSpec |
| M3 | Client module + ENV bootstrap contract |
| M4 | Integration hook documented for Dark Mode consumer |

## Dependencies

- **Upstream:** None.
- **Downstream:** All other reading customization features.

## Testing requirements

- Request specs: authz, validation failures, merge semantics, version migration.
- Client unit tests: default merge, subscribe callbacks, debounced update batching.
- Contract test: JSON fixture matches TypeScript types.

## Definition of Done

- [ ] Schema and API documented in repo (inline YARD or `doc/api` if project uses it).
- [ ] Feature flag `reading_customization` (name TBD) gates endpoints.
- [ ] Client module exported for feature packages.
- [ ] No direct `preferences[:reading_*]` writes outside service/controller layer.
- [ ] Lab 4 GitHub issues created from handoff section below.

---

## Lab 4 Handoff Section

### User stories (create as GitHub issues)

| Story ID | Title | Acceptance hints |
|----------|-------|------------------|
| US-PS-01 | As a student, I want my reading settings saved to my account so they apply every time I log in. | Reload session shows same JSON values |
| US-PS-02 | As a developer, I want a documented API to read/write reading prefs so features do not duplicate persistence. | Consumer demo PR uses only public client API |
| US-PS-03 | As a user, I want invalid settings rejected with clear feedback so I am not stuck in a broken state. | 422 + accessible error in UI shell |

### Supporting technical tasks

| Task ID | Title | Labels |
|---------|-------|--------|
| T-PS-01 | Define `reading_customization` preference schema v1 + version field | `technical`, `feature-preference-storage` |
| T-PS-02 | Implement Rails update endpoint with strong params and validation | `backend`, `feature-preference-storage` |
| T-PS-03 | Add RSpec request specs for read/update/authz | `testing`, `feature-preference-storage` |
| T-PS-04 | Create `ui/shared/reading-customization-preferences` client module | `frontend`, `feature-preference-storage` |
| T-PS-05 | Embed critical prefs in `js_env` contract (document keys) | `backend`, `frontend`, `feature-preference-storage` |
| T-PS-06 | Add feature flag and guard endpoints | `backend`, `feature-preference-storage` |
| T-PS-07 | Write migration helper for schema version bumps | `backend`, `feature-preference-storage` |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-PS-01 | Contract test: API JSON matches TypeScript interface |
| QA-PS-02 | Manual: two-browser session persistence check |
| QA-PS-03 | Security: attempt cross-user pref access (expect 403) |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-PS-01 | Developer guide: adding a new preference key |
| DOC-PS-02 | Changelog entry for schema v1 |

### Dependency relationships (GitHub issue linking)

```
T-PS-01 → T-PS-02 → T-PS-03
T-PS-01 → T-PS-04 → T-PS-05
T-PS-06 blocks T-PS-02 (flag before expose)
US-PS-01 depends on T-PS-02, T-PS-04
```

### Suggested milestone structure (GitHub Project)

1. **PS-M1 Schema & Read API** — T-PS-01, T-PS-02 (read-only), T-PS-06  
2. **PS-M2 Write & Validation** — T-PS-02 (write), T-PS-03, US-PS-03  
3. **PS-M3 Client & ENV** — T-PS-04, T-PS-05, US-PS-01, US-PS-02  

### Traceability guidance

- Prefix issues: `[PS]` + requirement ID (`FR-PS-01` in issue body).
- GitHub Project custom field **Feature** = `preference-storage`.
- Each downstream feature issue that touches persistence must link **depends on** `T-PS-04` or `US-PS-02`.
- Close US-PS-02 only when Dark Mode or Settings UI has merged a consumer PR referencing the client module.
