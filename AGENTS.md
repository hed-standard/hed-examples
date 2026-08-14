# hed-examples

Purpose: BIDS-formatted example datasets annotated with HED (Hierarchical
Event Descriptors), used for lightweight software tests and as models for
annotating real data.
Not in scope: HED tools, schemas, or documentation - those live in their own
repositories (see below). There is no application code here.

## Commands

Test framework: none - this is a dataset-only repo with no Python suite.
Validation stands in for tests and CI runs it on every PR.

- Validate one dataset: `uvx --from hedtools validate_bids datasets/<name> -s "*"`
  (add `--verbose` for detail; CI installs hedtools with `uv tool install hedtools`
  and runs `validate_bids` on every `datasets/*/` directory)
- Spell check: `uvx typos --config .typos.toml`
- Alternative validator: `bids-validator datasets/<name> --config.ignore=99`
  (requires npm; add `--ignoreNiftiHeaders` for fMRI datasets; the ignore flag
  suppresses the empty-file error - all raw files here are empty stubs)

## Layout

- `datasets/` - the BIDS example datasets, one directory each; the table in
  `datasets/README.md` describes them
- `.github/workflows/` - CI: `validate_examples.yml` (HED validation, runs on
  changes to `datasets/**`) and `typos.yaml` (spelling, runs on everything)
- `.status/` - working notes. Gitignored; local to each machine.

## Conventions that differ from defaults

- **ASCII only** in prose, code, comments, and filenames: `-` not em or en
  dashes, `->` not arrows, `...` not an ellipsis character, straight quotes.
  Exception: genuine data (author names, dataset titles, recorded API
  responses) keeps whatever characters it actually contains.
- Markdown headings capitalize only the first word, proper nouns, and acronyms.
- Dataset names follow `{modality}_ds{accession}{suffix}_{modifier}`, e.g.
  `eeg_ds003645s_hed` = EEG data from OpenNeuro ds003645, reduced ('s'), with
  HED annotations. Datasets derived from OpenNeuro keep the accession number.
- Raw data files are deliberately empty stubs; metadata and headers are real.
  Never commit actual data.

## Rules that are easy to get wrong

- HED tags are hierarchical with `/` separators, e.g.
  `Sensory-event/Visual-presentation`; however, preferred usage is the leaf tag.
  groups use parentheses. Use backticks for inline HED tags in markdown.
- HED annotations live in JSON sidecars (`*_events.json`) or in a HED
  column of the events TSV - a dataset's choice between them is intentional;
  do not move annotations between the two.
- Column order in `events.tsv` files is significant - never reorder.
- `dataset_description.json` must include the HED version; validation reads it.
- A spelling CI failure is fixed by correcting the typo or, for a legitimate
  term, adding it to `[default.extend-words]` in `.typos.toml` - never by
  excluding the file.

## Related repositories

- `hed-python` - the hedtools package that provides `validate_bids`
- `hed-schemas` - the HED schema (vocabulary) XML files
- `hed-specification` and `hed-resources` (www.hedtags.org) - the docs

None are vendored here; a session that needs one must be granted access to
that checkout.

## Where the thinking lives

`.status/` is gitignored, so it exists only on the machine that wrote it and
never in a fresh clone or worktree.

- `.status/README.md` - the index. Read this first; it lists what is active.
- `.status/decisions.md` - why things are the way they are. Read before
  proposing structural changes. Append entries; never rewrite one.
- `.status/plans/*.md` - active plans. Check the `Status:` header and the
  `[ ]` / `[x]` markers before starting work.
- `.status/local-environment.md` - this machine's paths, interpreter, and
  quirks. Tool-agnostic. Never copy its contents into a committed file.
- IMPORTANT: do not read `.status/archive/` unless a file is named for you.
  Nothing new is created at the `.status/` root.

## Working agreements

- IMPORTANT: every file written to `.status/` opens with a `For humans:`
  summary - three or four sentences, at the very top: what the file is and
  what a person needs to take from it. The same applies to a long answer in a
  session: lead with the conclusion.
- IMPORTANT: temporary scripts, experiments, and one-off test files go in
  `.status/scratch/` - **never the repository root**.
- Show evidence, not assertions: the command that was run and its actual
  output. For dataset work, counts and a sample of records.
- Never push; the maintainer does the pushes.
