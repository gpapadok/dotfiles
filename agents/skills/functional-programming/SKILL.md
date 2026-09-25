---
name: functional-programming
description: Functional programming for controlling complexity — purity and effect boundaries first, functional style second. Use on every code task in any language, OO and procedural included — writing, refactoring, debugging, designing, reviewing — even when nobody said "functional".
---

# Functional Programming

## The goal: control complexity

The one end is **reducing what you must hold in your head to understand a piece of code**. You
should be able to follow the flow of information without simulating the whole program in your
memory. Everything else in this skill is a means to that end, never an end in itself. The
moment a technique costs more comprehension than it saves, it has stopped doing its job. Drop it.

The tools, in order of importance:

1. **Referential transparency / purity** — "functional" means *function* in the mathematical
   sense: same inputs, same output, nothing else observable. This gives *local reasoning*, and
   everything else grows from it.
2. **Immutability** — no shared mutable state: no races, no "who changed this?", no aliasing.
3. **Composition** — small functions that combine predictably.
4. **Explicit side effects** — I/O and state at the edges, visible in types where the language
   allows.
5. **ADTs and exhaustive pattern matching** — illegal states unrepresentable, caught at compile
   time.

## The test

Before writing or accepting any function, ask:

> Can I understand this from its signature and its body alone — or do I need to know what ran
> before it, what's in some other object's field, or what's in the database right now?

The mechanical form of the same check is **referential transparency**: you can replace any call
with the value it returned and the program behaves identically. If substituting the result
changes anything, the function is doing something its signature doesn't admit to.

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

The `map` is decoration: the effects still have to be replayed in order, and are now *harder*
to see than in a plain loop. Change what the code does first, then express it in functional style.

The converse matters just as much: **genuinely functional code is entirely possible in a
class-based OO language.** A class whose instances are immutable and whose methods are pure
mappings over their inputs is functional code. A frozen dataclass or `record` plus free
functions is functional code. Syntax is sugar; observable behavior is what decides.

## Primary concern: purity and effect boundaries

Impurity is: reading or writing a global or shared mutable field, the clock, random, env,
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
- Model data before behavior: plain immutable structures with total constructors, so downstream
  functions don't each re-validate.
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

## Secondary concern: functional style

Once behavior is pure, write it in functional style. Pure functions are values: you can pass
them, return them, specialize them and combine them. The style is how you cash that in. Code
then says *what* it computes, as a composition of small named transformations, instead of
*how* to step through it. Make it the default. Fall back to a plain loop or statement only when
it genuinely reads better.

### Toolkit

- **Higher-order functions** over hand-written index loops: name the transformation, not the
  iteration. When several functions share a shape and differ in one step, write your own HOF
  that takes that step as a parameter.
- **Anonymous functions** for short, single-use logic. Once one grows past a line or two, or
  needs a comment, name it.
- **Closures** capture configuration once instead of threading it through every call. Close over
  immutable values only; a closure over a mutable binding is shared state in disguise.
- **Partial application** specializes a general function. Order parameters for it: what varies
  least (config, rules) first, the data being transformed last.
- **Composition and pipelines** of small named steps, so the pipeline reads as the spec.
- **Expressions over statements** — conditionals, `match`/exhaustive `switch` and destructuring
  that yield a value. Don't assign in branches and read the result after.
- **Data-driven dispatch** — a map from key to function instead of a `switch` that calls.

### Readability is the tiebreak

The style exists to make code more declarative and easier to read. When a functional phrasing
reads *worse*, it has failed at its only job, so rewrite it:

- Point-free chains where the reader loses track of what the data is.
- Deep currying in languages without automatic currying. Use a closure or `partial` instead.
- Monad stacks without do-notation, and `reduce` where a comprehension or loop is clearer.
- Lambda soup: nested anonymous functions that should have been named helpers.
- Compositions that need a comment to explain.

**Follow the host language's idiom.** In Python that means a comprehension over
`map(lambda …)`. In Go it means a small loop over a hand-rolled generic `Map`. Wherever the
language has them, use its built-in collection operations. A construct that reads as foreign
costs more comprehension than the style buys.

## Where to stop

Purity is about **observable** behavior, not about avoiding assignment. An 80%-pure module with
one clear boundary beats a fully pure one nobody wants to touch — and beats by a mile a "pure"
one where the impurity merely moved somewhere harder to see.

Not violations:

- **Local mutation.** A loop accumulator, a builder, a mutable buffer that never escapes. A
  function that builds a list in a loop and returns it *is* a pure function.
- **Memoization / caching** of a pure function.
- **Logging, metrics, tracing.** Technically effects. Keep them out of the core where that's
  free; never restructure a module to avoid a log line.
- **Hot paths.** In-place mutation for measured performance is a legitimate trade. Confine it,
  name it, keep the surrounding interface pure.
- **Pre-existing stateful code.** Don't crusade. Make the piece you're touching pure and leave
  the boundary slightly cleaner than you found it.

Back off entirely when — each means you reached for form instead of changing behavior:

- The pure version is meaningfully longer than the impure one.
- You added a type whose only job is to describe an effect the shell could have just performed.
- You're threading a parameter through five call sites so one leaf can stay pure.
- A reviewer would need a term that appears nowhere else in the codebase. Machinery from
  functional languages exists there because a compiler enforces something; imported without that
  enforcement, it is ceremony without the guarantee.
