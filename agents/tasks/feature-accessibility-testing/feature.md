# Accessibility Testing and Validation

## Problem statement

Reading customization features directly affect perception, contrast, focus order, and assistive technology behavior. Ad-hoc “looks fine” testing will miss regressions against WCAG, break existing high-contrast/dyslexic flows, and leave the team without traceable evidence for academic or stakeholder review.

Accessibility work must be a **standalone deliverable** with its own milestones, issues, and definition of done—not an afterthought checkbox inside each development PR.

## User value

- Confidence that customization options improve—not harm—access for diverse users.
- Documented test results and known limitations for support and future maintainers.
- Prevents shipping preset bundles or themes that fail contrast or keyboard requirements.

## Scope

- **Test strategy document** tied to each reading customization feature (traceability matrix).
- **Automated checks** where feasible: axe-core (or Canvas-equivalent) in JS feature tests, contrast calculation scripts for token pairs, CI gate definitions.
- **Manual test protocols**: screen reader scripts (NVDA/VoiceOver), keyboard-only paths, zoom/reflow at 200%, `prefers-reduced-motion` and `prefers-color-scheme` scenarios.
- **Regression suite** for legacy accessibility toggles (`HighContrastModeToggle`, `DyslexicFontToggle`, `ENV.use_high_contrast`).
- **Sign-off milestones** per feature release candidate.
- Defect taxonomy and severity rubric aligned with course project grading expectations.
- Optional: lightweight user acceptance checklist for pilot testers.

## Out of scope

- Implementing reading customization features themselves.
- Canvas course content accessibility checker for authors (existing accessibility resource scan product).
- Full third-party VPAT or legal compliance certification.
- Performance/load testing except where motion/contrast scripts impact CI time (document only).

## Dependencies on other features

- **Validates (downstream of implementable slices):**
  - Preference Storage (API error messages, focus on save failure)
  - Dark Mode (contrast, theme switching announcements)
  - Reading Presets (bundled outcomes)
  - Text Customization (reflow, zoom)
  - Content Emphasis (non-color cues)
  - Reading Settings UI (structure, labels)
- Can start **early** with framework, tooling, and baseline audits before features complete.
- Final sign-off blocked until each feature reaches its Definition of Done.

## Success criteria

- Published traceability matrix: requirement ID → test case → GitHub issue label.
- Automated a11y tests run in CI for touched UI packages (document path in repo).
- Manual protocol executed per feature with recorded results (pass/fail/waiver).
- Zero open **critical** a11y defects for release candidate scope—or waivers approved with remediation plan.
- Regression tests demonstrate legacy high-contrast/dyslexic paths still work when program flag is off.
