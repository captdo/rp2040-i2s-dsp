# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records (ADRs) for the RP2040 I²S DSP Platform.
ADRs capture **why** important technical decisions were made, not just **what** the code looks like.

ADRs are small, version-controlled documents that describe a single architectural decision in its
context. They complement the higher-level docs in `docs/` and the milestone/issue breakdown.

## When to write an ADR

Create an ADR when a decision:

* Affects the overall structure or behavior of the system, not just one function.
* Would be hard or costly to change later (boot flow, flash layout, I²S format, logging strategy, buffer layout, etc.).
* Has meaningful alternatives that were considered and rejected.
* Is referenced by multiple milestones, modules or documentation pages.

If you’re unsure whether something deserves an ADR, it usually does as soon as you catch yourself writing a long design comment in an issue or PR.

## File naming & structure

ADRs live in this `adr/` directory and follow this naming scheme:

```text
adr/
  001-bootloader-layout.md
  002-i2s-config.md
  003-logging-strategy.md
  ...
```

**Rules:**

* Use a **3-digit numeric prefix** (`001`, `002`, …) that never changes once merged.
* Use a short, kebab-cased title after the number.
* One ADR = one decision.

The numeric order is chronological.

## Recommended ADR template

Use a simple, consistent structure so ADRs are easy to skim:

```markdown
# NNN – Title of the Decision

- Status: Proposed | Accepted | Superseded | Rejected
- Date: YYYY-MM-DD
- Related: Milestone Mx-y, Issue #NN, Docs XYZ

## Context

What problem are we solving? What constraints, hardware limitations,
requirements, or trade-offs are relevant?

## Decision

What did we decide? Be clear and concise. This is the “answer” we want to
be able to reference later.

## Alternatives considered

Short list of other options and why they were not chosen.

## Consequences

Positive and negative consequences of this decision:
- What becomes easier?
- What becomes harder or impossible?
- Any migration or compatibility implications?

## References

Links to datasheets, PRs, issues, docs pages, or external articles.
```

You don’t have to match this template perfectly, but all ADRs should include at least: **Status**, **Context**, **Decision**, and **Consequences**.

---

## ADR lifecycle

Each ADR has a **Status**:

* `Proposed` – Idea under discussion; not yet binding.
* `Accepted` – Agreed decision; code and docs should follow it.
* `Superseded` – Replaced by a newer ADR (add a link both ways).
* `Rejected` – Considered and explicitly not chosen.

## Adding a new ADR (quick checklist)

1. Pick the next free number and create `adr/NNN-short-title.md`.
2. Fill in the template with `Status: Proposed`.
3. Link it from the relevant milestone/issue and, if applicable, from `docs/architecture.md`.
4. Once the decision is implemented and stable, update the status to `Accepted`.
5. If you change your mind later, add a new ADR that supersedes the old one instead of editing it away.
