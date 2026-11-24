---
name: debugging
description: Use when encountering a bug, test failure, build failure or unexpected behavior, before proposing a fix.
---

# Debugging

Find the root cause before changing code. A fix for a cause you haven't found is a guess.

1. **Read the error completely**: the whole message and stack trace, file:line, error codes.
2. **Reproduce it reliably.** If you can't, gather more data; don't guess.
3. **Check what changed**: `git diff`, recent commits, dependency, config and environment changes.
4. **Multi-component systems** (CI → build → deploy, API → service → DB): log what enters and
   leaves each boundary, run once, and let the output show which layer breaks before you dig in.
5. **Trace backward** from where the bad value surfaces to where it originates: what passed it in,
   and what passed it to that. Fix at the source, not where it surfaced.
6. **Compare with working code**: find a similar path in the repo that works and list every
   difference, including ones that "can't matter".
7. **One hypothesis at a time**: "X causes this because Y". Test it with the smallest change, one
   variable. Wrong → form a new hypothesis; don't stack fixes. Don't understand something → say so.
8. **Fix test-first**: a failing test that reproduces the bug (`gp:testing`), then one fix for the
   root cause, nothing bundled. Confirm the original symptom is gone and the full suite is green.

**Three failed fixes → stop.** When each fix exposes a new problem somewhere else, the design is
wrong, not the hypothesis. Tell the user what you tried and question the approach together before
a fourth fix.

Specific cases:
- A test passes alone but fails in the suite: bisect the suite to find the test that leaks state.
- Flaky timing: replace sleeps with waiting for the actual condition (poll with a timeout).
- The cause really is external or timing-dependent: say what you investigated, then add handling
  (retry, timeout, clear error message) and logging.
