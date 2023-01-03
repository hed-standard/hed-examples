(about-hed-anchor)=
# About HED

(what-is-hed-anchor)=
## What is HED?

- **HED** (**‘Hierarchical Event Descriptors’**, pronounced either as /hed/ or /H//E//D/)
  is a framework for using a controlled yet extensible vocabulary to systematically describe
  experiment events of all types (perceptual, action, experiment control, task ...).   
<p/>

- The **goals of HED** are to enable and support its users to **store and share** recorded data in a
  fully **analysis-ready** format, and to support efficient (and/or extended cross-study) 
  data **search and analysis**.
<p/>

- HED enables users to use a standard method to **detail the nature** of each experiment event,
  and to record information about **experiment organization**, thus creating a permanent,
  both human- and machine-readable record embedded in the data record for use in any further analysis, re-analysis, and meta/mega-analysis.
<p/>

- HED may be used to **annotate any type of data** – but particularly data acquired in functional brain 
  imaging (EEG, MEG, fNIRS, fMRI), multimodal (aka MoBI, mobile brain/body imaging),
  psychophysiological (ECG, EMG, GSR), or purely behavioral experiments.
<p/>

- **HED annotations** are composed of comma-separated **tags** from a hierarchically-structured
  vocabulary called the [**HED standard schema**](https://www.hedtags.org/display_hed.html)
  (possibly augmented by terms from one or more specialized **HED library schemas**).
<p/>

- **HED library schemas** for use in individual research subfields as well as the standard
  schema and vocabularies under development are housed in the 
  [**hed-schemas**](https://github.com/).
<p/>

- The **HED working group** is an ongoing open-source development organization whose mission is
  to extend and maintain the HED standard and associated tools. 
  Visit the [**hed-standard**](https://github.com/hed-standard) site on GitHub for information on 
  how to join the HED community of users and developers.

## HED and BIDS

- HED was accepted (2019) into the top-level 
  [**BIDS**](https://bids.neuroimaging.io/) (Brain Imaging Data Structure) standard,
  thus becoming an integral part of the BIDS data storage standards for an ever-increasing 
  number of neuroimaging data modalities.
<p/>

- An efficient approach to integrating HED event descriptions into BIDS metadata has been demonstrated
in this [**2021 paper**](https://www.sciencedirect.com/science/article/pii/S1053811921010387?via%3Dihub).

## HED Tools

Currently, tools using HED for data annotation, validation, search, and extraction are  available for
use [**online**](https://hedtools.ucsd.edu/hed), or (as MATLAB functions) within the
[**EEGLAB environment**](https://sccn.ucsd.edu/eeglab/index.php) running on Matlab.

## Where to begin?

To begin using HED tools to tag, search, and analyze data, browse the 
[**HED resources**](https://www.hed-resources.org) page.
Visit the [**How can you use HED?**](HowCanYouUseHed.md) guide for information about
how specific types of users can leverage HED.

## History and Support

**HED (Gen 1, version < 4.0.0)** was first proposed and developed by Nima Bigdely-Shamlo within the HeadIT project
at the Swartz Center for Computational Neuroscience (SCCN) of the University of California 
San Diego (UCSD) under funding by The Swartz Foundation and by U.S. National Institutes of Health
(NIH) grants R01-MH084819 (Makeig, Grethe PIs) and R01-NS047293 (Makeig PI). 

Further **HED (Gen 2, 4.0.0 <= version < 8.0.0)** development led by Kay Robbins 
of the University of Texas San Antonio was
funded by The Cognition and Neuroergonomics Collaborative Technology Alliance (CaN CTA) program of U.S Army Research Laboratory (ARL) under Cooperative Agreement Number W911NF-10-2-0022. 

**HED (Gen 3, version >= 8.0.0)** is now maintained and further developed by the 
HED Working Group led by Kay Robbins and Scott Makeig with Dung Truong, Monique Denissen, 
Dora Hermes Miller, Tal Pal Attia, and Arnaud Delorme, with funding from NIH grant 
[**RF1-MH126700**](https://braininitiative.nih.gov/funded-awards/brain-initiative-hierarchical-event-descriptors-hed-system-characterize-events)

HED is an open research community effort; others interested are invited to participate and contribute – [**visit this link**](https://github.com/hed-standard) to see how.
