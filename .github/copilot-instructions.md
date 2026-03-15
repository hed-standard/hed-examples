# HED-examples developer instructions

> **Local environment**: If `.status/local-environment.md` exists in this repository, check it first for machine-specific setup (OS, shell, virtual environment activation) before running any commands. That file is gitignored and local-only.

When you create markdown files, only capitalize the first letter of the first word in headings/titles.

## Repository overview
This repository contains user supporting code and example datasets for the Hierarchical Event Descriptor (HED) system, including:
- BIDS-formatted example datasets with HED annotations (in `datasets/`)
- Python Jupyter notebooks demonstrating HedTools usage (in `src/jupyter_notebooks/`)
- Example data files for tutorials and testing (in `src/data/`)
- Lightweight test datasets with empty raw data files but intact metadata

## Project context
- **Primary Language**: Python (Jupyter notebooks and scripts)
- **Python Version**: 3.10 or greater required
- **Key Dependency**: hedtools Python package
- **Dataset Format**: BIDS-compatible with HED annotations
- **Target Audience**: HED users learning to annotate and analyze data
- **Repository Focus**: Practical examples, tutorial code, and test datasets

## Key Principles

### 1. HED annotation standards
- HED uses hierarchical, orthogonal vocabulary organized in tag trees
- Tags are case-sensitive and use forward slashes for hierarchy (e.g., `Sensory-event/Visual/Color/Red`)
- Groups use parentheses for semantic association
- Definitions allow reusable annotation patterns with placeholders
- Library schemas extend the standard schema with domain-specific vocabulary

### 2. Dataset Standards
- All example datasets follow BIDS format with HED annotations
- Datasets use empty raw data files to reduce size while maintaining metadata
- Dataset names follow convention: `{modality}_ds{accession}{suffix}_{modifier}`
  - Example: `eeg_ds003645s_hed` = EEG data from OpenNeuro ds003645 with HED annotations
- Event files include HED annotations in JSON sidecars or TSV columns
- All datasets should be validatable with bids-validator

### 3. Code Standards
- Python code should follow PEP 8 style guidelines
- Jupyter notebooks should include clear markdown explanations
- Use hedtools package for all HED operations (validation, summarization, remodeling)
- Use descriptive variable names (e.g., `hed_string`, `schema_version`, `events_path`)
- Include error handling for file operations and HED validation

### 4. File Organization
- **datasets/**: BIDS-formatted example datasets with HED annotations
- **src/jupyter_notebooks/**: Python Jupyter notebooks organized by topic
  - **bids/**: Notebooks for BIDS dataset operations (validation, summarization, etc.)
  - **remodeling/**: Notebooks demonstrating HED remodeling operations
- **src/data/**: Example data files for tutorials and testing
- **`.status/`**: Temporary analysis and tracking files (gitignored — local only)
- **docs/source/**: Documentation source files (currently empty)

## Common tasks

### When working with datasets
- Validate datasets using bids-validator: `bids-validator {dataset_name} --config.ignore=99`
- Check HED annotations in event JSON sidecars (`task-*_events.json`)
- Verify event TSV files have proper structure
- Ensure dataset_description.json includes HED version information
- Test with hedtools validation before committing changes

### When creating or modifying Jupyter notebooks
- Start with imports: `from hed import HedValidator, TabularInput, load_schema_version`, etc.
- Include cell with dataset/file path setup
- Add markdown cells explaining each step
- Show both successful operations and error handling
- Save notebooks with output cleared for version control
- Test notebooks in clean environment before committing

### When working with HED schemas
- HED schema files are XML with `.xml` extension
- Schema version format: `HED{major}.{minor}.{patch}.xml`
- Use `load_schema_version()` to load specific versions
- Latest stable schema: loaded with `load_schema_version(None)` or `load_schema_version('8.3.0')`
- Library schemas: loaded with `load_schema_version('score_1.1.0')` format

### When writing Python scripts
- Use type hints for function parameters and return values
- Handle file paths using `pathlib.Path` for cross-platform compatibility
- Include docstrings for functions and classes
- Use context managers for file operations
- Test with both string and file-based inputs

## Important Conventions

### HED Syntax in Examples
- Use backticks for inline HED tags: `Sensory-event`
- Use code blocks for multi-line HED strings:
  ```hed
  (Onset, Sensory-event, Visual-presentation, (Circle, Blue))
  ```
- Show both short form (e.g., `Red`) and long form when teaching concepts

### Dataset References
- Link to OpenNeuro for full datasets: `https://openneuro.org/datasets/ds{accession}`
- Reference BIDS specification: `https://bids.neuroimaging.io/`
- Include dataset table from `datasets/README.md` when describing multiple datasets

### Jupyter Notebook Patterns
- Import cell at top with all required packages
- Path setup cell with configurable paths
- Processing cells with clear operations
- Result display/validation cells
- Error handling demonstrations where applicable

## Setup and installation

### Initial setup
1. Create and activate a Python virtual environment (`.venv/` at repo root) — see `.status/local-environment.md` for OS-specific activation command
2. Install hedtools: `pip install hedtools` or `pip install git+https://github.com/hed-standard/hed-python/@main`
3. Verify installation: `python -c "import hed; print(hed.__version__)"`

### Running Jupyter notebooks
1. Activate virtual environment
2. Start Jupyter: `jupyter notebook` or `jupyter lab`
3. Navigate to `src/jupyter_notebooks/{topic}/`
4. Open and run desired notebook

### Validating datasets locally
- Install hedtools (`pip install hedtools`) to get the `validate_bids` CLI tool
- Run from repo root: `validate_bids datasets/{dataset_name} -s "*" --verbose`
- Alternatively: `bids-validator datasets/{dataset_name} --config.ignore=99` (requires npm + bids-validator)
- The `--config.ignore=99` flag ignores empty data files (all raw files in this repo are empty stubs)
- FMRI datasets also need `--ignoreNiftiHeaders`

## CI/CD workflows

Two GitHub Actions workflows run on pull requests (defined in `.github/workflows/`):

### `validate_examples.yml` — HED BIDS validation
- **Triggers**: push or PR touching `datasets/**`
- **Tool**: `hedtools` installed via `uv tool install hedtools`, runs `validate_bids` on every `datasets/*/` directory
- **Must pass** for any PR that modifies dataset files

### `codespell.yml` — spelling check
- **Triggers**: push or PR to `main` (all files)
- **Tool**: `uvx --with tomli codespell .`
- **Config**: `.codespellrc` at repo root — skips `datasets/`, `.venv/`, `*.xml`, `*.svg`, `deprecated/`, etc.; ignores words: `covert`, `hed`, `recuse`
- **Must pass** for every PR — fix spelling errors before committing, or add legitimate words to `.codespellrc` `ignore-words-list`

## Avoid
- Don't commit Jupyter notebooks with cell outputs (clear before committing)
- Don't modify dataset files without understanding BIDS structure
- Don't use absolute paths in notebooks (use relative paths from notebook location)
- Don't install packages directly in notebooks (use requirements or environment setup)
- Don't commit large data files (datasets use empty stubs only)
- Don't mix test/temporary files with example code (use `.status/` directory)

## Related Resources
- [HED Resources Documentation](https://www.hedtags.org/hed-resources)
- [HED Specification](https://hed-specification.readthedocs.io)
- [HED Schemas Repository](https://github.com/hed-standard/hed-schemas)
- [HED Python Tools](https://github.com/hed-standard/hed-python)
- [HED MATLAB Tools](https://github.com/hed-standard/hed-matlab)
- [HED Standard Organization](https://github.com/hed-standard)
- [BIDS Specification](https://bids.neuroimaging.io/)
- [OpenNeuro](https://openneuro.org/)

---
*This file provides context for GitHub Copilot to better assist with hed-examples development.*
