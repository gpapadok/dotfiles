---
name: writing-skills
description: Use alongside skill-creator when deciding how to word a skill's rules, or when a skill doesn't change the agent's behavior the way it should.
---

# Writing skills

Complements `skill-creator`, which owns the process (evals, baselines, description tuning).

- **No baseline failure, no skill.** Run the tempting task without the skill first. If the agent
  already behaves, there is nothing to write.
- **Micro-test wording before full scenarios:** fresh context per sample, a no-guidance control,
  5+ samples per variant, and read every match yourself. Wording that works makes samples
  converge; five different interpretations mean it doesn't bind yet.
- **Description:** triggers only. Never summarize the workflow; an agent that reads a summary
  follows it instead of the skill.

**Match the form to the failure:**

| Baseline failure | Form that works |
|---|---|
| Knows the rule, breaks it under pressure | Prohibition + the rationalizations it used, rebutted |
| Complies, but output has the wrong shape | A positive recipe: what the output is, its parts in order |
| Leaves out a required element | A required slot in the template it fills |
| Behavior should depend on a condition | A conditional on an observable predicate |

Prohibitions backfire on shape problems: agents negotiate with "don't X". Avoid nuance clauses
("don't X unless it matters"), which reopen the negotiation, and exemption clauses, which don't
scope; restructure so the rule can't reach the exempt part.
