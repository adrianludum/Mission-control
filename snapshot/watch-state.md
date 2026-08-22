# Watch state

*Machine-maintained by `/mission-watch` (Decision 9.4). Do not hand-edit unless you want an
escalation re-raised — deleting a row makes it eligible again immediately.*

One row per escalation that has been raised. A row here means "Adrian has already been told";
its presence is what keeps the watch silent. Rows are removed silently once the condition clears.
Cooling period before re-raising a still-true condition: **14 days**.

| Key | Project | First raised | Last raised | Condition |
|---|---|---|---|---|
| blocker-14d:ulbc-oq051 | ULBC-salesforce | 2026-08-16 | 2026-08-16 | owner:Adrian, open since 2026-04-29 — OQ-051, new email account/hosting decision, gates resuming OQ-039..045 |
| blocker-14d:ulbc-martin-peel-stripe-xero | ULBC-salesforce | 2026-08-16 | 2026-08-16 | owner:Adrian, open since 2026-07-08 (Decision 7.9) — confirm with Martin Peel how Stripe money lands in Xero, decides if payout-splitting is needed |
| unpushed-branches:training-status | Training Status | 2026-08-21 | 2026-08-21 | 3 local branches exist only on the mac mini, no matching ref on origin: fix/build-26-release-guard (current checkout, dirty), merge/resting-measurements, mission/seed-on-main |
| unpushed-commits:ulbc-salesforce | ULBC-salesforce | 2026-08-22 | 2026-08-22 | main is 3 commits ahead of origin, unpushed since last commit 2026-08-14 — no remote copy of that work |
| uncommitted:language | Learn a Language | 2026-08-22 | 2026-08-22 | 10 uncommitted files, sitting since last commit 2026-08-12 — no commit or push activity since |
