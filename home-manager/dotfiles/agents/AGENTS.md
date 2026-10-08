# Personal global instructions

Applies to every project. Project-level `CLAUDE.md` / `AGENTS.md` files override anything here.

## Communication

- Be direct and concise. No preamble, no "Great question!", no summarising back what I just asked.
- Lead with the answer, then the reasoning. Don't bury the conclusion under a walkthrough.
- When you recommend something, give one recommendation — not a survey of options I have to pick from. Mention alternatives only if the trade-off is real.
- Tell me when something is uncertain or unverified. Say "I didn't check X" rather than sounding confident about it.
- I sometimes write in Greek. Reply in the language I used.

## Working style

- **Read before writing.** Find the existing pattern in the repo and follow it. Don't invent an approach when a reference implementation is sitting two files away.
- **Small, reviewable diffs.** One concern per change. If a task fans out into 15 files, stop and tell me — it probably needs splitting.
- **No speculative code.** No fallbacks for inputs that can't be missing, no `try/catch` around code that can't throw, no normalizers for shapes we already control, no wrappers/factories/options-objects for a single caller. Write the simple version first.
- **No unrequested cleanup.** Don't reformat, rename, or "while I'm here" fix things outside the task. Mention them instead.
- **Don't touch my uncommitted work.** If the working tree is dirty in files you'd modify, say so before proceeding.
- For non-trivial work, state the plan in a few lines and wait for my approval before editing. For CSS/copy/one-liners, just do it.

## Delegation & style

- Delegate mechanical or bulk work (the same change across many files, boilerplate) to a subagent running a lower-power model. Do small or subtle changes, debugging and design inline.
- Use the `functional-programming` skill on every code task (purity, effect boundaries, immutability, declarative expression, data-oriented design). When delegating, tell the subagent to invoke it first — a fresh subagent starts cold and won't pick it up on its own.
- Existing codebase conventions (formatter configs, local idioms) take precedence over the skill.

## Verification

- "It compiles" is not "it works". Run the relevant tests, linter, or type-check for the paths you touched.
- Report results honestly: if tests fail, paste the failure; if you skipped a check, name it and say why. Never describe unverified work as done.
- Prefer the repo's own tooling wrapper (`make`, `just`, `mise run`, package scripts) over hand-rolled equivalents.

## Git & shipping

- I often amend commits myself to reword them. Moved or amended history on a branch you're working on isn't a sign something went wrong — don't flag it as suspicious or ask if it was intentional.
- [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): description`. Reference a ticket ID when one exists; never invent one.
- Never commit or push unless I ask. Never push to `main`/`master`, never force-push a shared branch, never `--no-verify`.
- Branch naming: `type/short-description`.
- Keep commit messages factual about what changed and why. No changelog essays.

## Secrets & safety

- Never hardcode, log, echo, or commit credentials, tokens, or connection strings. If you find one in the code, flag it immediately.
- Confirm before anything destructive or outward-facing: deleting data, dropping/truncating tables or collections, unbounded `deleteMany`/`updateMany`, rewriting history, or posting to an external service.
