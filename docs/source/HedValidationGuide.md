# HED validation guide

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

Two types of errors can occur: syntactic and semantic.

**Syntactic** errors refer to annotation format errors that aren't related to any particular HED schema,
for example, missing commas or mismatched parentheses.

**Semantic** errors refer to annotations that don't comply with the rules of the 
particular HED vocabularies used in the annotation.

Current versions of the validators do not separate these phases and require that the appropriate
HED schemas are input at the time of validation.

See [HED validation errors](https://hed-specification.readthedocs.io/en/latest/Appendix_B.html#b-1-hed-validation-errors) for a list of the validation errors that should be
supported by validation tools.

Most HED analysis tools, such as those used for searching, summarizing, or creating design matrices,
assume that the dataset and its respective event files have already been validated 
and do not re-validate during analysis.


## Validation strategies

### Validation in BIDS

### Validate using online tools

### Validate using remodeling tools

### Validate using a Jupyter notebook

### Validate in Python

### Validate in MATLAB


##