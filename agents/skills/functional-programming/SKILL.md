---
name: functional-programming
description: Apply functional programming principles to any code work in any language — implementing, refactoring, debugging, designing, planning, architecting, or reviewing. This is about purity, referential transparency, immutable data, and confining side effects to explicit boundaries; it is NOT about functional syntax, so it applies just as much in Java, Go, Python, TypeScript or any OO/procedural codebase as in Clojure or Haskell. Use it on every piece of code work, including when nobody said "functional" and the existing code looks imperative.
---

# Functional Programming

"Functional" here means *function* in the mathematical sense: a mapping from one space to
another. Same inputs, same output, nothing else observable. It does not mean "code built out of
`map`, `filter` and lambdas."

The goal is a system you can hold in your head — where you can follow the flow of information
without simulating the whole program in your memory. Purity is the means, not the score: the
moment chasing it costs more comprehension than it buys, it has stopped doing its job.

## The test

Before writing or accepting any function, ask:

> Can I understand this from its signature and its body alone — or do I need to know what ran
> before it, what's in some other object's field, or what's in the database right now?

The mechanical form of the same check is **referential transparency**: you can replace any call
with the value it returned and the program behaves identically. If substituting the result
changes anything, the function is doing something its signature doesn't admit to.

If you need the surrounding history, the code isn't functional, whatever it looks like.
Everything below exists to let you answer "signature and body alone". That property is **local
reasoning**, and it is the thing being optimized for — not any particular style.

## The syntax trap

**Functional style without purity is imperative code in a costume.**

```js
// Looks functional. Is not.
const totals = orders.map(o => {
  const rate = taxRates[o.region];   // reads ambient mutable state
  db.markProcessed(o.id);            // I/O in the middle of a map
  runningTotal += o.amount;          // mutates an outer binding
  return o.amount * (1 + rate);
});
```

A higher-order function whose callback does I/O, mutates a closed-over variable, or reads
external state has bought nothing. The `map` is decoration. The code is still a sequence of
effects that must be replayed in order to be understood — and now the effects are *harder* to
see than they'd be in a plain loop. Same for a curried function that hits the network, or a
"pipeline" of steps that each write to a shared context object.

The converse matters just as much: **genuinely functional code is entirely possible in a
class-based OO language.** A class whose instances are immutable and whose methods are pure
mappings over their inputs is functional code. A frozen dataclass or `record` plus free
functions is functional code. Syntax is sugar; observable behavior is what decides.

Two consequences for how you work:

- Never reach for functional syntax as a way of *making* code functional. Change what the code
  does first — expression style follows, and sometimes doesn't need to change at all.
- Never write off a language or codebase as unsuitable. Purity, immutability, and effect
  boundaries are available in Java, Go, C, Python, TypeScript, anywhere.

## Primary concern: purity and effect boundaries

A function is pure when it depends only on its arguments and affects nothing but its return
value. Impurity is: reading or writing a global or shared mutable field, the clock, random, env,
filesystem, network, DB, console — or mutating an argument.

**Functional core, imperative shell.** Structure any non-trivial unit of work in three phases:

1. **Gather** — the shell does the reads: query, fetch, read the file, take the clock.
2. **Decide** — a pure core takes that data and returns the answer, *including a description of
   what should happen next*.
3. **Act** — the shell performs the effects the core described.

Effects go at the edges. The middle is a mapping. When the core needs to cause something, it
returns data describing it (`{kind: "email", to, body}`) rather than doing it. The shell stays
boring and thin: it is allowed to be imperative — that is its job, not a failure.

### Moves

**Refactoring an impure function:**
- Hoist the read: replace `x = db.get(id)` in the body with an `x` parameter; the caller fetches.
- Return a description instead of performing: `sendEmail(...)` becomes a returned value the
  caller sends.
- Split decide from execute: one function that computes *and* saves becomes `discountFor(order)
  -> Discount` plus a shell that persists it.
- Take the dependency as a parameter: clock, seed, config, connection — arguments, not imports,
  globals, or singletons.
- Narrow the input: if it needs three fields off a large mutable object, pass the three values.

**Designing / architecting:**
- Draw the boundary first. Name the impure shell explicitly (handler, `main`, job runner,
  adapter) and put everything else on the pure side. The default landing spot for new logic is
  the core.
- Model data before behavior: plain immutable structures with total constructors. Make illegal
  states unrepresentable so downstream functions don't each re-validate.
- Parse, don't validate: convert unstructured input into a precise type *once*, at the edge.
- Keep shell types out of the core — no request objects, ORM entities, or connection handles
  crossing the boundary.

**Implementing:**
- Write the pure part first and exercise it directly before wiring in I/O. Pure code needs no
  mocks; if a test needs a mock, the boundary is in the wrong place.

**Debugging:**
- Impure code hides bugs in *when* things ran. Reproduce by finding the inputs, not the
  sequence. A bug that can't be reproduced from inputs alone is pointing at hidden state —
  that's the actual bug's address.

**Reviewing:**
- Apply the test question to each function. Then count: how many functions in this diff could be
  called from a test with no setup at all? That number is the score.

## Secondary concern: how it reads

Once behavior is pure, prefer the declarative phrasing — but only when it makes the code
*easier* to hold in your head. That's the tiebreak: local reasoning was the whole point, so any
composition trick that costs comprehension loses to a plain loop.

Worth reaching for: expressions over statements; `map`/`filter`/`fold` over manual index loops;
returning new values over mutating; exhaustive pattern matching over `if`-chains; pipelines of
named transformations; closures to capture configuration instead of threading it everywhere.

Not worth bending the language for: point-free style, currying where the language has no
partial application, monad stacks without do-notation, lambda soup to avoid naming a helper,
compositions that need a comment to explain.

**Follow the host language's idiom** — a construct that reads as foreign costs more
comprehension than the purity it buys:

- **Go** — pure funcs over structs, errors as values, explicit copies. No currying.
- **Python** — comprehensions, `frozen=True` dataclasses / NamedTuple, module-level pure
  functions. Not `reduce` chains or third-party FP toolkits.
- **TypeScript/JS** — `const`, `readonly`, discriminated unions + exhaustive switch, array
  methods. Not fp-ts unless the codebase already uses it.
- **Rust** — iterators, `Option`/`Result`; ownership already buys most of this.
- **Java/C#** — records, `final`, streams/LINQ, static pure methods, sealed hierarchies.
- **Clojure / Elixir / Haskell / OCaml** — idioms are already functional; spend the effort on
  the core/shell split instead.
- **Lisps (Emacs Lisp, Common Lisp)** — prefer `let` bindings and returned values to `setq` and
  global defvars; keep the effectful command layer thin over pure helpers.
- **Lua** — return new tables rather than mutating arguments; locals, not globals.
- **C** — pass and return structs by value, out-params over globals, isolate `malloc`/IO.
- **Nix / declarative config** — already a pure expression language; keep it that way.

## Where to stop

Purity is about **observable** behavior, not about avoiding assignment, and there is no score
for being pure. An 80%-pure module with one clear boundary beats a fully pure one nobody wants
to touch — and beats by a mile a "pure" one where the impurity merely moved somewhere harder to
see.

None of these is a violation:

- **Local mutation.** A loop accumulator, a builder, a mutable buffer that never escapes. A
  function that builds a list in a loop and returns it *is* a pure function. Don't rewrite it
  into a worse `reduce`.
- **Memoization / caching** of a pure function.
- **Logging, metrics, tracing.** Technically effects. Keep them out of the core where that's
  free; never restructure a module to avoid a log line.
- **Hot paths.** In-place mutation for measured performance is a legitimate trade. Confine it,
  name it, keep the surrounding interface pure.
- **Pre-existing stateful code.** Don't crusade. Make the piece you're touching pure and leave
  the boundary slightly cleaner than you found it.

Back off entirely when:

- The pure version is meaningfully longer than the impure one.
- You added a type whose only job is to describe an effect the shell could have just performed.
- You're threading a parameter through five call sites so one leaf can stay pure.
- A reviewer would need a term that appears nowhere else in the codebase. Machinery from
  functional languages exists there because a compiler enforces something; imported without that
  enforcement, it is ceremony without the guarantee.
- You're arguing with yourself about whether a log line breaks purity.

Each of these means you reached for form instead of changing behavior. Purity is not
abstraction — removing a mutation normally makes code *shorter*. If the "purer" version scores
worse on the test question, it is worse; ship the simpler one.
