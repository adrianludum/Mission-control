# The trust acceptance test

Decision 1.7 set the bar and deliberately left it unmeasured: *"after a few weeks of co-tuning,
briefings are actionable without verification — the product dies by trust-decay if it stays ~90%
right."* Adrian committed to break-in "till it works" rather than to a number, and the acceptance
threshold was parked for beta. This is that threshold (Decision 9.5).

It exists to answer one question: **has the break-in period ended, or is Adrian still the error
correction layer?**

## The unit of measurement: a material correction

A **material correction** is any occasion where Adrian tells a session that Mission Control stated
something false, and the false statement would have changed what he did — sent him to fix something
already fixed, hid something that needed him, named the wrong next action, or misreported git state.

Not material corrections:
- Wording, tone, ordering or layout preferences.
- Facts that were true when written and have since changed, where the board **said** it was
  reading stale data. Honest degradation is the product working, not failing.
- Things Adrian knows that no artefact records — the board cannot read his mind, and Decision 3.6
  says born-thin is honest.
- His own undisciplined sessions failing to check anything in. That is a discipline miss, logged
  to `FEEDBACK-LOG.md` with its cause, and it does not count against the board.

The distinction is already being recorded: `mission-discipline` requires every correction to be
appended to the repo's `FEEDBACK-LOG.md` **with its cause** — undisciplined chat vs broken
checkpoint. That log is the test's raw data, which is why the test costs nothing new to run.

## The bar

Mission Control passes when **all four** hold at once:

1. **Zero material corrections for 14 consecutive days.**
2. **At least 10 board renders were actually read** in that window — the standing URL opened, or
   `/mission` typed. A quiet fortnight where Adrian never looked proves nothing.
3. **At least one true escalation in the window was surfaced by the system before Adrian noticed
   it himself** — a real risk the board or the watch caught first. Without this the board has only
   proved it can be green, not that it can see.
4. **No `owner: Adrian` blocker in the window was rendered after it had already been resolved.**
   This is the specific failure of 2026-08-12 and the reason Decision 9.2 exists; it must not
   recur during the qualifying window.

Clauses 3 and 4 are the load-bearing ones. Clause 1 alone is satisfiable by a board that says
nothing useful, which is exactly the failure mode 1.7 warns about wearing the opposite costume.

## Running it

No ceremony and no new tooling. At any point, ask a session: *"run the trust test."* It reads every
tracked repo's `FEEDBACK-LOG.md` and the hub's `AGENT-LOG.md` for the last 14 days, classifies each
correction as material or not (showing its reasoning, since this is a judgement call), and reports
pass or fail against the four clauses.

A failing run is not a setback — it names which clause failed and therefore what to tune next.
That is what the break-in period is for.

## What passing changes

Break-in ends (Decision 1.7 discharged). Concretely: Adrian stops reading the board defensively,
and the escalation-only watch (9.4) becomes the primary door — he can stop checking and let it
find him. Nothing in the code changes. The system's promise changes.

If the test passes and later regresses — two material corrections inside any 7-day window —
break-in reopens, logged as such. Trust is a running state, not a certificate.
