# Jupyter notebooks for annotation

**Note: This tutorial is in the process of being developed.** 

This tutorial provides a step-by-step guide to creating a JSON sidecar
template file from one of your BIDS `events.tsv` files.
You can then edit this JSON file directly using a text editor
to put in descriptions and HED annotations of your events.
Alternatively you can convert the JSON file to a spreadsheet for easier editing
and then convert back afterwards.
See [Easy HED editing](EasierHEDEditing.md) for a walk-through of this process.
Finally, there is a standalone GUI tool called CTagger,
which provides user-friendly assistance. See []

that you can fill in with takes you through the steps of annotating the events in your 
BIDS dataset using HED (Hierarchical Event Descriptors) and the online tools
available at [hedtools.ucsd.edu/hed](https://hedtools.ucsd.edu/hed).

The goal is to construct a single `events.json` sidecar file located in 
the root directory of your dataset with all the annotations needed for
users to understand and analyze your data.

