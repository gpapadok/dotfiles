---
name: testing
description: Use when implementing a feature or bugfix, or when writing, changing or reviewing tests or mocks.
---

# Testing

## Cycle

1. Write one test for one behavior before the code.
2. Run it and watch it fail **for the expected reason**: the feature is missing, not a typo or an
   import error. If it passes immediately, it tests existing behavior; fix the test.
3. Write the minimal code that passes it. No options or features the test doesn't need.
4. Run the project's full suite, not just your file. Report every failure by name, including ones
   you didn't cause.
5. Refactor only while green.

Code written before its test: write the test, revert or break the fix and watch the test fail,
then restore. Throwaway spikes, generated code and declarative config skip test-first; ask when
unsure.

## A test worth having

- **Names the break.** Before writing it, name the production change that should make it fail.
  If you can't, assert an observable behavior instead.
- **Hand-derived expectations.** Literals or hand-checked fixtures; never compute the expected
  value with the code under test or its helpers.
- **No change detectors.** Don't assert constants, exact wording or private structure; assert the
  behavior that depends on them (not `MAX_RETRIES == 5`, but "the 6th attempt never happens").
- **Runs, doesn't grep.** Scripts and configs are run on controlled input; assert outputs, side
  effects and exit codes, not source text.
- **Your boundary, not the framework's.** Test what your code emits, registers or returns.
- Trivial code (getters, forwarding, constants) earns a test only if it validates, defaults,
  derives or has side effects.

## Mocks

- Mock only the slow or external level. Learn the real method's side effects first and keep the
  ones the test depends on real.
- Never assert on the mock itself (a `*-mock` test id, a call count that isn't the contract).
- When arguments, counts or ordering are the contract, assert them; one fixture per branch
  (success, error, malformed).
- Mock responses mirror the complete real structure, not just the fields the test reads.
- Cleanup only tests need lives in test utilities, never on the production class.
- Mock setup bigger than the test → use real components.

## Mutation check

Before finishing, mutate the code in your head: wrong constant or argument, wrong branch, missing
side effect, empty or default return, missing validation for empty, zero, nil, malformed or
unauthorized input. Each realistic mutation should fail at least one test.
