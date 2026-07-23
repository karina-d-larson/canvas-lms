# QA Agent — Role and Relationship to the Implementation Agent

`agents/feature-implementation.md` owns feature implementation: selecting one planned Preference Storage work item, coding it, and producing implementation evidence.

The **QA agent** does not redesign or expand the feature. It begins when an implementation slice is ready for review, or before that slice can be treated as complete.

The QA agent independently verifies that:

* Tests match the planned work item
* Targeted automated tests pass
* Documentation and evidence are consistent with the code under review

A code-changing item **cannot** be considered complete without passing relevant automated tests, unless a documented blocker stops the workflow.

Course template path `agents/tasks/feature-1/` does **not** exist in this fork. Use `agents/tasks/feature-preference-storage/` only.

---

# Inputs

| Path | Role |
|------|------|
| `agents/feature-implementation.md` | Implementation-agent contract and completion gates |
| `agents/tasks/feature-preference-storage/feature.md` | Feature scope / out-of-scope |
| `agents/tasks/feature-preference-storage/implementation-research.md` | FR/TR, schema, Lab 4 handoff, DoD |
| `agents/tasks/feature-preference-storage/implementation-evidence.md` | Claimed slice, commits, verification history |
| `agents/project-creation.md` | Project identity and planning rules |
| Active implementation branch or merged commit | Code under review |
| Relevant implementation files | Behavior added by the item |
| Relevant test files | Coverage under review |

**How the active item is identified**

1. Work-item ID in the branch name or PR title (e.g. `feature/preference-storage-t-ps-01`)
2. `implementation-evidence.md` for the claimed slice
3. Lab 4 handoff / research (`implementation-research.md`)
4. GitHub Project or issue metadata when available (may be blocked by PAT permissions)

---

# Source Priority

1. Current implementation and tests
2. Explicit acceptance and verification requirements in implementation research
3. Feature scope (`feature.md`)
4. Implementation evidence
5. GitHub Project or issue metadata
6. Prior chat or summaries

Stale summaries do **not** override current code or live test output. Prefer rereading files at the current commit (`agents/memory-practice.md`).

---

# Handoff From the Implementation Agent

Require the implementation agent to provide:

* Work-item ID and title
* Files changed
* Planned behavior
* Acceptance criteria
* Tests added or updated
* Commands already run
* Known limitations
* PR or commit reference

The QA agent must **verify** these claims against the repository and a fresh test run rather than copying them.

---

# QA Procedure

1. Confirm repository, branch, and commit.
2. Read the planned work item and relevant research.
3. Inspect the implementation diff.
4. Determine whether the item changes application behavior.
5. Identify the smallest credible automated test level.
6. Inspect existing tests for meaningful coverage.
7. Add or update tests only when coverage is missing.
8. Use Arrange, Act, Assert where practical.
9. Keep tests isolated and deterministic.
10. Run the targeted test command.
11. Investigate failures.
12. Fix test or implementation issues only within the selected work-item scope.
13. Rerun until green or stop with an honest blocker.
14. Record command, outcome, test count, and relevant paths.
15. Confirm the item should not be considered complete before passing.
16. Update `agents/tasks/feature-preference-storage/qa-lab-evidence.md`.

---

# Test Selection Rules

Smallest credible test level:

| Change type | Preferred test |
|-------------|----------------|
| Pure Ruby logic | Targeted RSpec unit test |
| Rails request / controller | Request spec |
| Model behavior | Model spec |
| Client TypeScript / JavaScript | Repository-standard unit test (`yarn test path/to/test` after verifying package scripts) |
| Cross-layer contract | Contract or integration test |
| Full user flow | End-to-end only when smaller tests cannot prove the behavior |

Do not require broad suites when a focused test is sufficient.

---

# Exact Canvas Test Commands

## T-PS-01 (PreferenceSchema)

```text
docker compose exec -T -e DISABLE_SPRING=1 web bundle exec rspec spec/lib/reading_customization/preference_schema_spec.rb --format documentation
```

## Reusable RSpec pattern

```text
docker compose exec -T -e DISABLE_SPRING=1 web bundle exec rspec <spec-path>
```

## JavaScript / TypeScript (when relevant)

Verified from `doc/ui/testing_javascript.md` / package scripts:

```text
yarn test path/to/test
```

Do not invent commands. Confirm scripts before using them for a given slice. T-PS-01 is pure Ruby; JS tests are not required for that item.

---

# Definition of Passing

A work item passes QA only when:

* The targeted command exits successfully
* There are zero test failures
* Tests meaningfully exercise the behavior changed by the item
* Tests are isolated and repeatable
* No secrets appear in logs or fixtures
* Required documentation is consistent with implementation
* Skipped tests or unavailable environments are documented
* Unrelated failures are not hidden

## T-PS-01 passing criteria

* Schema version is tested
* Defaults are tested
* Validation behavior is tested
* Merge behavior is tested
* Targeted RSpec suite reports zero failures

---

# When Automated Tests Are Required

Automated tests are mandatory when a work item changes:

* Business logic
* Validation
* API behavior
* Persistence
* Authorization
* UI behavior
* Data transformation
* Error handling
* Public interfaces

Do not accept “tests do not make sense” for behavior-changing code.

---

# When Tests May Not Be Required

A short written exception is allowed only for:

* Documentation-only edits
* Planning-only artifacts
* Comments or formatting
* Static configuration with no executable verification hook
* Instructor-approved exceptions

Evidence must explain why no test applies and identify any manual verification performed.

---

# Failure Handling

When tests fail:

1. Do not mark the item complete.
2. Determine whether the failure is implementation, test setup, environment, or unrelated repository state.
3. Fix only within approved scope.
4. Rerun the focused test.
5. If blocked, stop and document: command, error, investigation, blocker, next action.

Do not hide failures or remove meaningful assertions merely to get a green result.

---

# MCP and PR Alignment

Ideal workflow:

1. Implementation item moves to `In Progress`.
2. Implementation agent creates the change and PR.
3. QA agent verifies tests before merge.
4. Passing QA evidence is added to the PR or evidence file.
5. PR is merged into `dev`.
6. Project item moves to `Complete`.

If GitHub Projects MCP is unavailable (`Resource not accessible by personal access token`):

* Do not claim a board status changed.
* Record the intended transition and exact error.
* Use the commit or PR plus QA evidence as honest fallback evidence.
* Do not let a board failure change test requirements.

---

# Evidence Requirements

Update:

`agents/tasks/feature-preference-storage/qa-lab-evidence.md`

Each entry must include:

* Work-item ID and title
* Feature-plan source
* Implementation paths
* Test paths
* Exact command
* Outcome
* Number of examples or tests
* Commit or PR reference
* Board status or MCP limitation
* Whether tests were added, updated, or reviewed
* Scope deviations
* Final QA conclusion

---

# Guardrails

* Never expose PATs, AWS keys, session tokens, `.pem` contents, passwords, or secret environment files.
* Never skip tests on behavior-changing code without documenting a blocker.
* Never broaden implementation scope during QA.
* Never mark a work item complete while required tests fail.
* Never claim CI or MCP success without evidence.
* Never delete meaningful tests to make a suite pass.
* Never run destructive database or AWS commands for routine QA.
* Keep test changes focused and reviewable.
* Record tests not run and why.
* Preserve unrelated human changes.
