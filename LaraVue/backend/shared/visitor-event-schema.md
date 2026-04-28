# Visitor event schema

This schema is shared by every backend sample in LaraVue.

## Event fields

| Field | Type | Meaning |
| --- | --- | --- |
| event_id | string | Unique identifier for the event |
| timestamp_utc | string | ISO 8601 UTC timestamp |
| session_id | string | Session-scoped identifier |
| route | string | Requested route |
| referrer | string | Referrer URL |
| user_agent | string | Browser user agent |
| ip_hash | string | Pseudonymized IP hash |
| consent | boolean | Whether analytics consent is present |
| dwell_seconds | number | Time spent on page |
| scroll_depth_pct | number | Max scroll depth |
| event_type | string | page_view, click, conversion, or custom |
| conversion_name | string | Optional conversion label |
| anomaly_score | number | Simple heuristic score |

## Normalization rules

1. Convert empty strings to null.
2. Trim whitespace from all text fields.
3. Hash IP address values before storage.
4. Preserve only the minimum data needed for the chosen use case.
5. Treat all aggregation output as analytics, not identity resolution.

## Research workflow

1. ingest raw event
2. normalize it
3. store it in an append-only structure
4. roll up route and referrer counts
5. measure dwell time and scroll depth
6. compare recent windows against the baseline
7. emit a trend summary
