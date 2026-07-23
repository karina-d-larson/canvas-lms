Reading Customization Preferences
=================================

This document defines **schema v1** for Accessibility Reading Customization
preference storage (work item **T-PS-01**).

It is the published contract for keys, defaults, enums, and ranges. Persistence
API endpoints, feature flags, and the client module are separate later tasks
(T-PS-02, T-PS-06, T-PS-04).

Canonical code: `ReadingCustomization::PreferenceSchema`
(`lib/reading_customization/preference_schema.rb`).

Storage key
-----------

When persisted under `User#preferences`, the document is stored at:

    preferences[:reading_customization]

(`ReadingCustomization::PREFERENCES_KEY`)

Schema version
--------------

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `reading_customization_version` | Integer | yes | Must be `1` for schema v1 |

The version field is **mandatory** and enables forward-compatible migrations
(FR-PS-02).

Document shape (v1)
-------------------

```json
{
  "reading_customization_version": 1,
  "theme_mode": "system",
  "active_preset_id": "none",
  "typography": {
    "font_family": "default",
    "text_scale_percent": 100,
    "line_height_multiplier": 1.0,
    "letter_spacing_multiplier": 1.0,
    "paragraph_spacing_multiplier": 1.0
  },
  "emphasis_level": "off"
}
```

Field reference
---------------

| Field | Type | Allowed values / range | Default |
|-------|------|------------------------|---------|
| `theme_mode` | String | `system`, `light`, `dark` | `system` |
| `active_preset_id` | String | `none`, `dyslexia_friendly`, `low_strain`, `high_clarity`, `custom` | `none` |
| `typography.font_family` | String | `default`, `classic`, `dyslexic` | `default` |
| `typography.text_scale_percent` | Integer | 100–150 | `100` |
| `typography.line_height_multiplier` | Number | 1.0–2.0 | `1.0` |
| `typography.letter_spacing_multiplier` | Number | 1.0–1.5 | `1.0` |
| `typography.paragraph_spacing_multiplier` | Number | 1.0–2.0 | `1.0` |
| `emphasis_level` | String | `off`, `standard`, `strong` | `off` |

Merge semantics
---------------

Partial updates **merge** onto defaults (and later onto stored documents)
without wiping unrelated keys (FR-PS-05). Unknown keys are ignored by the
schema helper; invalid values raise `ArgumentError` and must map to HTTP 422
in the future API (T-PS-02 / US-PS-03).

Legacy coexistence
------------------

Schema v1 does **not** remove or replace `prefers_high_contrast?` or
`use_dyslexic_font`. Sync rules with Profile tray toggles are deferred to later
tasks.

Related planning
----------------

* `agents/tasks/feature-preference-storage/implementation-research.md`
* `agents/tasks/feature-preference-storage/feature.md`
