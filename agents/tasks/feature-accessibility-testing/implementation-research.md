# Implementation Research: Accessibility Testing and Validation

## Overview

Establish a dedicated quality track for the reading customization program: traceability from requirements to tests, automated checks in CI, manual protocols for assistive technology, and release gates per feature. This deliverable produces **evidence and process**, not end-user customization functionality.

Canvas has existing accessibility product surfaces (course accessibility scanning routes, RCE high-contrast editor CSS, Profile tray toggles). This feature ensures new reading tools **do not regress** those paths and meet agreed WCAG targets.

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR-A11Y-01 | Traceability matrix links each FR/TR from features to test cases. |
| FR-A11Y-02 | Automated a11y tests run on CI for designated UI packages. |
| FR-A11Y-03 | Manual test protocols documented and executed per feature milestone. |
| FR-A11Y-04 | Contrast validation for theme tokens and emphasis styles. |
| FR-A11Y-05 | Regression tests for legacy high-contrast and dyslexic font toggles. |
| FR-A11Y-06 | Defect severity rubric and release gate (no open critical). |
| FR-A11Y-07 | Final sign-off report for semester deliverable. |

## Technical requirements

| ID | Requirement |
|----|-------------|
| TR-A11Y-01 | Adopt `@axe-core/react` or existing Canvas jest-axe patterns in feature tests. |
| TR-A11Y-02 | Script or spreadsheet: token pair → contrast ratio (APCA or WCAG formula documented). |
| TR-A11Y-03 | Manual test case repo: `doc/reading_customization/a11y/` or `agents/tasks/.../test-protocols/` |
| TR-A11Y-04 | CI job documentation in README or `package.json` script `test:a11y:reading`. |
| TR-A11Y-05 | NVDA + VoiceOver scripts (minimum one each) for Settings UI and preset apply. |
| TR-A11Y-06 | Browser matrix: Chrome, Firefox, Safari latest; mobile Safari smoke. |
| TR-A11Y-07 | Integrate with GitHub Project “Testing” column and `qa-*` labels. |

## Existing repository areas likely affected

| Area | Relevance |
|------|-----------|
| `ui/features/navigation_header/react/trays/__tests__/HighContrastModeToggle.test.tsx` | Regression patterns |
| `ui/features/navigation_header/react/trays/__tests__/UseDyslexicFontToggle.test.tsx` | API mock patterns |
| Feature packages under `ui/features/reading_*` | axe tests |
| `packages/canvas-rce` high contrast ENV | RCE regression scope |
| Selenium specs (optional) | E2E if team uses Selenium for a11y |

## Architectural considerations

- **Shift-left:** Each feature PR includes axe test for touched components; Accessibility Testing feature owns matrix and gates.
- **Waivers:** Document institutional exceptions with expiry date—no silent failures.
- **False positives:** axe rules tuned for Canvas (e.g. known third-party iframes excluded).
- **Evidence storage:** Test runs attached to GitHub issues or project notes for grading.

## Risks and challenges

- **Flaky axe** in async Canvas pages—use `waitFor` patterns.
- **Contrast disputes** between brand and reading tokens—escalation path defined.
- **Limited AT hardware** on student laptops—provide remote lab option in protocol.

## Accessibility considerations

(This meta-feature defines how others meet accessibility; it must itself produce perceivable, operable test reports and plain-language summaries for stakeholders.)

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M0 | Traceability matrix template + rubric |
| M1 | Tooling spike + CI doc + baseline audit (legacy toggles) |
| M2 | Per-feature test packs as features reach code complete |
| M3 | Integration audit (full program on) |
| M4 | Sign-off report + known issues list |

## Dependencies

- **Validates:** All implementation features (incremental).
- **Can start early:** M0, M1 without reading features complete.
- **Blocks release:** Final program demo per gate policy.

## Testing requirements

Meta-feature outputs tests rather than consuming a single test type:

| Output | Description |
|--------|-------------|
| Matrix | FR/TR → case ID → issue |
| Automated | jest-axe suites per package |
| Manual | Scripted AT + keyboard + zoom |
| Contrast | Token tables signed |
| Regression | Legacy toggle specs green |

## Definition of Done

- [ ] Matrix covers 100% of FR IDs from all six implementation features.
- [ ] CI documented and running on default branch for scoped packages.
- [ ] Manual protocols executed with recorded results.
- [ ] Sign-off report published; critical defects zero or waived.
- [ ] Lab 4 issues created.

---

## Lab 4 Handoff Section

### User stories

| Story ID | Title |
|----------|-------|
| US-A11Y-01 | As a project stakeholder, I want a traceability matrix so I can see requirements are tested. |
| US-A11Y-02 | As a developer, I want automated a11y checks in CI so regressions are caught early. |
| US-A11Y-03 | As a QA tester, I want screen reader scripts so manual testing is repeatable. |
| US-A11Y-04 | As a user with low vision, I want contrast verified for reading themes before release. |

### Supporting technical tasks

| Task ID | Title |
|---------|-------|
| T-A11Y-01 | Create traceability matrix template (sheet + issue labels) |
| T-A11Y-02 | Tooling spike: jest-axe in reading_settings package |
| T-A11Y-03 | Document CI command and required checks for PRs |
| T-A11Y-04 | Contrast audit script for Dark Mode tokens |
| T-A11Y-05 | Contrast audit for Content Emphasis levels |
| T-A11Y-06 | Baseline regression suite for Profile tray toggles |
| T-A11Y-07 | NVDA manual script for Reading Settings page |
| T-A11Y-08 | VoiceOver manual script for preset apply flow |
| T-A11Y-09 | Keyboard-only navigation script (global → settings) |
| T-A11Y-10 | Reflow/zoom protocol (200%) for Text Customization |
| T-A11Y-11 | Integration test pass: all flags on |
| T-A11Y-12 | Sign-off report template + final report |

### Testing tasks

| Task ID | Title |
|---------|-------|
| QA-A11Y-01 | Execute M1 baseline audit — record results |
| QA-A11Y-02 | Execute per-feature packs (link from matrix) |
| QA-A11Y-03 | Cross-browser smoke per TR-A11Y-06 |
| QA-A11Y-04 | `prefers-reduced-motion` and `prefers-color-scheme` scenarios |

### Documentation tasks

| Task ID | Title |
|---------|-------|
| DOC-A11Y-01 | Accessibility test plan (master document) |
| DOC-A11Y-02 | Known limitations and waiver log |
| DOC-A11Y-03 | Semester sign-off summary for instructors |

### Dependency relationships

```
T-A11Y-01 → all QA-A11Y-02 subtasks (per feature)
T-DM-01 → T-A11Y-04
T-CE-02 → T-A11Y-05
T-UI-03 → T-A11Y-07, T-A11Y-09
T-RP-02 → T-A11Y-08
T-TC-02 → T-A11Y-10
All features code-complete → T-A11Y-11 → T-A11Y-12
```

### Suggested milestone structure

1. **A11Y-M0 Framework** — T-A11Y-01, DOC-A11Y-01, US-A11Y-01  
2. **A11Y-M1 Tooling & baseline** — T-A11Y-02, T-A11Y-03, T-A11Y-06, QA-A11Y-01  
3. **A11Y-M2 Feature gates** — T-A11Y-04–10, QA-A11Y-02 (parallel sub-issues per feature)  
4. **A11Y-M3 Release** — T-A11Y-11, T-A11Y-12, DOC-A11Y-03  

### Traceability guidance

- Matrix columns: `Requirement ID` | `Feature folder` | `Test case ID` | `Automated (Y/N)` | `GitHub issue` | `Status`.
- Label issues: `a11y`, `reading-customization`, plus feature prefix (`[DM]`, etc.).
- **Gate rule:** No feature milestone “Done” in Project until linked QA-A11Y-02 row is Pass or Waiver.
- US-A11Y-04 closes when T-A11Y-04 and T-A11Y-05 attach signed contrast tables.
- Project creation agent (`agents/project-creation.md`) should import milestones A11Y-M0–M3 as final column in timeline after implementation milestones.

### Cross-feature release checklist (for integration milestone)

| Check | Owner issue label |
|-------|-------------------|
| Preference save failure announced accessibly | `[PS]` + `[UI]` |
| Theme FOUC &lt; 1 frame on supported pages (or documented) | `[DM]` |
| Each preset passes contrast bundle | `[RP]` |
| Max text scale reflow | `[TC]` |
| Link non-color cue at strong emphasis | `[CE]` |
| Settings page axe clean | `[UI]` |
| Legacy toggles with flag off | `[A11Y]` |
