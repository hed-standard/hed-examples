# HED-resources developer instructions

This particular repository is on a Windows machine with PowerShell. THIS MEANS THAT ALL COMMANDS ARE FOR POWERSHELL (no &&). ALWAYS ACTIVATE THE .venv VIRTUAL ENVIRONMENT FIRST.

When you create summaries of what you did -- always put them in a status directory at the root of the repository. When you create a markdown file only capitalize the first letter of the first word in the titles.

## Repository overview
This repository manages HED (Hierarchical Event Descriptors) documentation and user resources, including:
- Comprehensive documentation for HED tools and usage
- User guides and tutorials for HED integration
- Tool-specific documentation (Python, MATLAB, JavaScript, Online tools)
- Integration guides for platforms like EEGLAB, NWB, and BIDS
- Validation and search guides
- Schema development documentation

## Project context
- **Documentation Framework**: Sphinx with MyST parser for markdown
- **Primary Language**: Python (for build scripts and utilities)
- **Output Formats**: HTML (hosted on hedtags.org)
- **Target Audience**: HED users, tool developers, and researchers
- **Repository Focus**: User documentation, tutorials, and resource guides

## Key Principles

### 1. HED annotation standards
- HED uses hierarchical, orthogonal vocabulary organized in tag trees
- Tags are case-sensitive and use forward slashes for hierarchy (e.g., `Sensory-event/Visual/Color/Red`)
- Groups use parentheses for semantic association
- Definitions allow reusable annotation patterns with placeholders
- Library schemas extend the standard schema with domain-specific vocabulary

### 2. Documentation Standards
- Write in clear, technical language appropriate for tool implementers and advanced users
- Use precise terminology defined in `02_Terminology.md`
- Include examples with proper HED syntax
- Cross-reference related sections using markdown links
- Maintain consistency with existing specification structure

### 3. Code and Testing Standards
- Python code should follow PEP 8 style guidelines
- Test files use JSON format with error codes as keys
- Test cases should be comprehensive and cover edge cases
- Validate HED strings according to specification rules
- Use standardized error codes (e.g., `CHARACTER_INVALID`, `COMMA_MISSING`)
as defined in Appendix_B.md.  If you add a new error code, please add it to Appendix_B.md following the format there.

### 4. File Organization
- **docs/source/**: Sphinx documentation source files for HED user resources (markdown and reStructuredText)
- **docs/_static/**: Static assets including data examples and images
- **status/**: Analysis and enhancement tracking scripts

## Common tasks

### When writing documentation
- Follow the structure in existing markdown files in `docs/source/`
- Use proper markdown heading hierarchy (# for chapters, ## for sections, ### for subsections)
- Include code blocks with `hed` language tag for HED annotation examples
- Reference the current specification version (3.3.0)
- Link to external resources: [HED Resources](https://www.hedtags.org/hed-resources), [HED Tags](https://www.hedtags.org)

### When creating test cases
- Use JSON format with error code keys
- Structure: `{"error_code": {"description": "...", "tests": {"valid": [...], "invalid": [...]}}}`
- Include both valid and invalid test cases
- Add clear descriptions of what each test validates
- Reference specific specification sections when applicable

### When working with HED Schema
- HED schema files are XML with `.xml` extension
- Schema version format: `HED{major}.{minor}.{patch}.xml`
- Latest stable schema link: https://raw.githubusercontent.com/hed-standard/hed-schemas/main/standard_schema/hedxml/HEDLatest.xml
- Official schemas are now maintained in the [hed-schemas](https://github.com/hed-standard/hed-schemas) repository

### When Writing Python Scripts
- Use type hints for function parameters and return values
- Include docstrings for modules, classes, and functions
- Handle file paths using `pathlib.Path` for cross-platform compatibility
- For HED validation, consider different schema versions
- Use descriptive variable names (e.g., `hed_string`, `schema_version`)

## Important Conventions

### HED Syntax Examples
- Use backticks for inline HED tags: `Sensory-event`
- Use code blocks for multi-line HED strings:
  ```hed
  (Onset, Sensory-event, Visual-presentation, (Circle, Blue))
  ```
- Show both short form (e.g., `Red`) and long form (e.g., `Property/Sensory-property/Sensory-attribute/Visual-attribute/Color/CSS-color/Red-color/Red`)

### Version References
- Always specify which specification version introduces or modifies features
- Distinguish between specification version (3.x.x) and schema version (8.x.x)
- Note when features are "supported" vs. "proposed" vs. "in development"

### Cross-References
- Link to other chapters: `[Chapter 4: Basic annotation](04_Basic_annotation.md)`
- Link to sections: `[See Definition syntax](#45-definition-syntax)`
- Link to external HED resources with full URLs

## Build and Testing Commands

### Build Documentation
- **Sphinx HTML**: Run `build-sphinx.bat` (Windows) or use `sphinx-build docs/source docs/_build`
- **Full Build**: Run `build-docs.bat` (installs dependencies and builds)
- **Check Links**: Run `check-links.bat` or `python check_links.py`

### Run Tests
- Use Python scripts in `tests/` directory
- Test consolidation: `python tests/run_consolidate_tests.py`
- Test summarization: `python tests/test_summarize_testdata.py`

## Avoid
- Don't modify official PDF specification files in `hedspec/`
- Don't change HED schema XML files in `hedxml/` (these are for reference)
- Don't introduce breaking changes to test JSON format without discussion
- Don't use ambiguous or informal language in specification documentation
- Don't mix specification features with implementation details (keep them separate)

## Related Resources
- [HED Specification (ReadTheDocs)](https://hed-specification.readthedocs.io)
- [HED Resources](https://www.hedtags.org/hed-resources)
- [HED Schemas Repository](https://github.com/hed-standard/hed-schemas)
- [HED Standard Organization](https://github.com/hed-standard)
- [HED Tags Website](https://www.hedtags.org)

---
*This file provides context for GitHub Copilot to better assist with HED-resources development. It is excluded from version control.*
