# Feature Implementation Agent — Preference Storage

## Role and non-goals

Implement **one** planned Preference Storage work item at a time in the existing Canvas LMS brownfield fork (`karina-d-larson/canvas-lms`).

**Non-goals**

* Do not implement the entire feature in one pull request.
* Do not invent scope beyond the selected Lab 4 handoff item.
* Do not bypass research, tests, review, or merge gates.
* Do not modify AWS infrastructure unless a safe runtime check is explicitly required for verification.
* Do not mark work complete before the PR is **merged into `dev`**.
* Do not claim GitHub Project board updates succeeded when Projects MCP returns authorization errors.

---

## Inputs and source priority

| Path | Role |
|------|------|
| `agents/tasks/feature-preference-storage/feature.md` | Scope / out-of-scope framing |
| `agents/tasks/feature-preference-storage/implementation-research.md` | **Primary** FR/TR, schema, Lab 4 handoff |
| `agents/project-creation.md` | Project identity and planning rules |
| `agents/analyze-repo.md` | Brownfield analysis approach |
| `agents/memory-practice.md` | Last-verified re-grounding |
| `agents/aws-canvas-runbook.md` | Runtime checkpoint (optional for schema-only slices) |

**Source priority**

1. Explicit scope and Lab 4 handoff in `implementation-research.md`
2. Current repository code and tests
3. `feature.md` framing
4. Project-plan artifacts (`project-creation.md`)
5. Prior summaries or chat context

Source code and current tests override stale summaries.

---

## Project identity

| Field | Value |
|-------|--------|
| Owner | `karina-d-larson` |
| Repository | `canvas-lms` |
| Integration branch | `dev` |
| Feature | Preference Storage and Persistence |
| Proposed project | `Feature 1 — Preference Storage and Persistence` |

GitHub Projects MCP may be unavailable (`Resource not accessible by personal access token`). Record intended board transitions honestly in `implementation-evidence.md`; do not invent board state.

Course template path `agents/tasks/feature-1/` does **not** exist; use `agents/tasks/feature-preference-storage/` only.

---

## Memory and re-grounding

Apply `agents/memory-practice.md`.

**Session start — record**

* Branch, commit SHA, git status
* Relevant source files reread
* Environment checkpoint (if runtime verification needed)

**Re-ground after:** branch changes, merges, pulls, dependency changes, or contradictions with prior research.

---

## Work-item selection

1. Select **one** existing planned item (e.g. `T-PS-01`).
2. Cite ID and research section.
3. Confirm it is not already complete in the repo.
4. Identify dependencies (T-PS-01 has none upstream).
5. Define a narrow change boundary.
6. Define verification before editing.
7. Stop if blocked or scope would expand unplanned.

---

## MCP: move to In Progress

When substantive implementation begins:

1. Confirm GitHub MCP connection and user `karina-d-larson`.
2. Verify target `karina-d-larson/canvas-lms`.
3. Locate project item; read status; move to `In Progress`; read back.

**If Projects MCP unavailable:** do not claim the move; log attempted action, UTC time, intended status, exact blocker; continue with manual fallback; include failure in evidence.

**Status mapping**

| Board | Meaning |
|-------|---------|
| Planned / Ready | Not started |
| In Progress | Implementation active |
| Complete / Done | Merged into `dev` |

---

## Branching

* Start from updated `dev`.
* Create one focused branch: `feature/preference-storage-<work-item-id-lowercase>`
* Example: `feature/preference-storage-t-ps-01`
* Do not push to `master` or directly to `dev`.
* Confirm working tree will not overwrite unrelated human changes (stage only slice files).

---

## Implementation loop

1. Inspect relevant code/tests.
2. Propose smallest plan.
3. Implement only the selected slice.
4. Review the diff; remove unrelated changes.
5. Run targeted checks; broader checks only when justified.
6. Update docs only when required by the item.
7. Compare to acceptance criteria; record deviations.
8. Prefer small, reviewable commits.

---

## Verification

Tie checks to the research item. Record commands, pass/fail, output summary, and tests not run (with why). Do not claim completion if required verification fails.

---

## Commit and push

* Focused message naming the work item (e.g. `Define preference schema v1 for T-PS-01`).
* Push **only** the feature branch.
* Exclude secrets, credentials, unrelated logs, local env files.

---

## Pull request

Mandatory PR:

* Base: `dev` · Head: feature branch
* Title includes work-item ID
* Body: planned item, plan sources, summary, verification, limitations, board/MCP status, scope-deviation statement
* Link issue/project item when it exists; otherwise link planning artifact paths and note Lab 2.2 Projects authorization failure

---

## Review and merge gate

Before merge: tests/docs OK, no secrets, no unrelated diffs, matches plan, targets `dev`.  
After merge: confirm merge commit/status. Do not mark Complete before merge.

---

## MCP: mark Complete after merge

Only after merge into `dev`: locate item → Complete/Done → read back.  
On Projects failure: log intended `In Progress → Complete` and authorization error; use merged PR as completion evidence.

---

## Evidence

Update `agents/tasks/feature-preference-storage/implementation-evidence.md` with work-item ID, plan refs, branch, commits, PR URL, merge evidence, board timeline (intended vs actual), MCP attempts, verification, deviations, plan-trace paragraph.

---

## Guardrails

* Never expose secrets; never commit keys/PATs/`.pem`/secret env files.
* Never modify another repository; never push to `master`.
* Never implement unplanned work silently; never mark complete before merge.
* Never claim MCP success without read-back.
* Never overwrite unrelated human changes; keep PRs small; no broad refactors.
* Do not modify AWS for this slice.
* Stop and report when verification failure changes scope.
