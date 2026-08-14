# hed-examples

**`AGENTS.md` at the repository root is the instruction set for this project.
Read it before answering, and follow it.**

This file is a pointer and duplicates no project rules. One source, several
pointers: a rule stated in two files is a rule that will disagree with itself.
The one deliberate exception is the path-scoped `.status/` conduct rules,
which exist in two copies because each tool reads only its own format
(`.claude/rules/status_conduct.md` for Claude Code,
`.github/instructions/status_conduct.instructions.md` for Copilot); any change
to one must be mirrored in the other.

Path-specific instructions live in `.github/instructions/*.instructions.md`
and load automatically when the files being worked on match their `applyTo`
glob - for example, `status_conduct.instructions.md` applies under `.status/`.
Nothing needs to reference them; this note exists so a reader knows they are
there.

Machine-specific facts - interpreter, local paths, cache locations - are in
`.status/local-environment.md`, which is gitignored: read it when it is there
and ignore its absence when it is not. No committed file in this repository
may contain a local path or a drive letter.
