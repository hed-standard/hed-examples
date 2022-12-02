# HED validation

## What is HED validation?

HED validation is the process of checking the consistency and usage of HED annotations.
This tutorial takes demonstrates tools for online validation of 
HED (Hierarchical Event Descriptor) annotations.
HED analysis tools assume that your dataset and its accompanying annotations have 
already been validated and are free from errors.
You should be sure to validate your dataset 

### Types of errors

HED annotations consist of comma-separated lists of HED tags selected from
valid HED vocabularies, referred to as **HED schema**.
HED annotations may include arbitrary levels of parentheses to clarify 
associations among HED tags.

In some cases, mainly in BIDS sidecars, HED annotations may contain `#` placeholders,
which are replaced by values from the appropriate columns of an event file when HED
annotations are assembled for analysis. 

#### Syntax errors

Syntax errors refer to annotation format errors that aren't related to any particular HED schema,
for example, missing commas or mismatched parentheses.

#### Semantic errors

Semantic errors refer to annotations that don't comply with the rules of the 
particular HED vocabularies

https://hed-specification.readthedocs.io/en/latest/Appendix_B.html#b-1-hed-validation-errors

https://hed-specification.readthedocs.io/en/latest/Appendix_B.html#b-1-hed-validation-errors

## What types of validation are available?
This tutorial also discusses types of validation errors and how
to fix them.
