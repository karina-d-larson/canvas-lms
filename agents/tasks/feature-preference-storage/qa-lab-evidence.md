# QA Lab Evidence

## Work Item

* ID: `T-PS-01`
* Title: Define `reading_customization` preference schema v1 + version field
* Feature: Preference Storage and Persistence (`feature-preference-storage`)
* Research source: `agents/tasks/feature-preference-storage/implementation-research.md` (Proposed initial schema; FR-PS-02; Lab 4 handoff → T-PS-01; Definition of Done schema documentation)
* Implementation evidence: `agents/tasks/feature-preference-storage/implementation-evidence.md`
* Commit or PR: Implementation commit `b9a3e2999418be5b7538a9d905da545644f4d134` on `dev` (fast-forward integration; **no GitHub Pull Request**). QA review at `d6057c234e60450844b6379c04c14ef84c0f74d3` (`dev` HEAD).
* QA review date: `2026-07-23` (UTC)

## Behavior Covered

T-PS-01 added:

* Canonical schema version constant (`VERSION = 1`) and mandatory `reading_customization_version`
* Published default preference document (theme, preset, typography, emphasis)
* Enum and range validation via `PreferenceSchema.validate!`
* Partial merge onto defaults via `PreferenceSchema.merge_with_defaults`
* Storage key constant `ReadingCustomization::PREFERENCES_KEY`
* Contract documentation in `doc/api/reading_customization_preferences.md`

## Tests Reviewed or Updated

| Test path | Purpose | Action |
| --------- | ------- | ------ |
| `spec/lib/reading_customization/preference_schema_spec.rb` | Unit coverage for version, defaults, validate!, merge_with_defaults, preferences key | Reviewed existing test |

No test file changes were made. Existing coverage was judged adequate for T-PS-01; tests were not rewritten merely to increase count.

## Test Execution

| Command | Expected result | Actual result |
| ------- | --------------- | ------------- |
| `docker compose exec -T -e DISABLE_SPRING=1 web bundle exec rspec spec/lib/reading_customization/preference_schema_spec.rb --format documentation` | Exit 0; zero failures; version/defaults/validation/merge exercised | **Pass** — `11 examples, 0 failures`; exit status `0` (seed `14886`) |

## Passing Result

* Number of examples: **11**
* Number of failures: **0**
* Exit status: **0**
* Satisfies T-PS-01: **Yes** — schema version, defaults, validation, and merge behavior are exercised with zero failures

## Traceability

| Work item requirement | Implementation path | Test evidence | Result |
| --------------------- | ------------------- | ------------- | ------ |
| Schema v1 + version field (FR-PS-02 / T-PS-01) | `lib/reading_customization/preference_schema.rb` (`VERSION`, defaults key) | `VERSION is 1`; `defaults` includes version `1`; `validate!` rejects version `2` | Pass |
| Default preference document | `PreferenceSchema::DEFAULTS` / `.defaults` | Full default shape equality; deep-copy isolation | Pass |
| Validation of enums/ranges (supports FR-PS-04) | `PreferenceSchema.validate!` | Accepts defaults; rejects bad `theme_mode`, out-of-range `text_scale_percent` | Pass |
| Partial merge without wiping keys (FR-PS-05) | `PreferenceSchema.merge_with_defaults` | Partial theme/typography merge keeps unrelated keys; invalid enum raises | Pass |
| Preferences storage key name | `lib/reading_customization.rb` (`PREFERENCES_KEY`) | Expects `:reading_customization` | Pass |
| Schema documentation (DoD) | `doc/api/reading_customization_preferences.md` | Reviewed for consistency with code/defaults | Pass (doc review) |

Unknown-key ignore behavior is stated in the API doc and implemented by only applying known keys; no dedicated example was added because core T-PS-01 behaviors were already covered and the lab forbids padding the suite.

## QA Conclusion

**T-PS-01 passes QA.** Targeted RSpec coverage matches the planned schema-only slice, the suite was rerun under this QA workflow with `11 examples, 0 failures`, and documentation is consistent with the implementation. The GitHub Project item was **not** marked Complete (Projects MCP authorization failure).

## MCP and Board Status

* GitHub Projects MCP tools were present (`projects_list`, `projects_get`, `projects_write`).
* Projects API calls returned **`Resource not accessible by personal access token`**.
* Intended workflow was `In Progress → QA Pass → Complete`.
* No successful board update is claimed.
* The MCP limitation did **not** prevent local automated testing.

## Exceptions or Skipped Tests

No test exception was used, because T-PS-01 changes behavior and required automated tests.

Tests not run (out of scope for this item): request specs, JS/client suites, full Canvas RSpec — T-PS-01 is pure Ruby schema logic with no endpoints or UI.

## Scope

QA covered only **T-PS-01**. It did not test or implement endpoints, feature flags, migrations, client UI, or later Preference Storage items (T-PS-02+).
