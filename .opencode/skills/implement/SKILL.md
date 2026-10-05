---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Build lazy (YAGNI, framework-first): stop at the first approach that holds — does it need to exist at all (if not, say so and skip it); does the codebase already have it (reuse, don't re-implement); does the stdlib do it; does a native platform feature cover it (prefer it over a dependency or custom code); does an already-installed dependency solve it (never add a new one for what a few lines do); otherwise the smallest diff that works.

Bug fixes target the root cause, not the symptom: grep every caller of the function before editing, and fix where all callers route through — not just the path the ticket names.

Ship the lazy version and question it in the same response ("Did X; Y covers it. Need full X? Say so.") — never stall on an answer you can default.

Use /tdd where possible, at pre-agreed seams — scoped to the smallest checks that fail if the logic breaks; full suites only when asked.

Run typechecking regularly, single test files regularly, and the full test suite once at the end. If the caller says a separate phase runs the tests (or otherwise asks to skip the full run), skip the full test-suite run at the end.

Implement through subagents: split the work by ticket or seam and run one subagent per independent unit, in parallel where possible; integrate their results on the current branch.

Once done, use /code-review to review the work — it spins its own parallel subagents per axis.

Commit your work to the current branch.
