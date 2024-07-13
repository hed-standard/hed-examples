HED resources
===========================

.. image:: _static/images/croppedWideLogo.png
  :width: 220
  :alt: HedLogo

.. sidebar:: **Links**

   * `PDF docs <https://hed-examples.readthedocs.io/_/downloads/en/latest/pdf/>`_

   * `Source code <https://github.com/hed-standard/hed-examples/>`_  

   * `HED homepage <https://www.hedtags.org/>`_ 

What is HED?
************

**HED** (**‘Hierarchical Event Descriptors’**, pronounced either as /hed/ or /H//E//D/)
is a framework for using a controlled yet extensible vocabulary to systematically describe
experiment events of all types (perceptual, action, experiment control, task ...).


The **goals of HED** are to enable and support its users to **store and share** recorded data in a
fully **analysis-ready** format, and to support efficient (and/or extended cross-study)
data **search and analysis**.

How is HED used?
****************

HED enables users to use a standard method to **detail the nature** of each experiment event,
and to record information about **experiment organization**, thus creating a permanent,
both human- and machine-readable record embedded in the data record for use in any further
analysis, re-analysis, and meta/mega-analysis.

HED may be used to **annotate any type of data** – but particularly data acquired in
functional brain imaging (EEG, MEG, fNIRS, fMRI), multimodal (aka MoBI, mobile brain/body imaging),
psychophysiological (ECG, EMG, GSR), or purely behavioral experiments.

**HED annotations** are composed of comma-separated **tags** from a hierarchically-structured
vocabulary called the `HED standard schema <https://www.hedtags.org/display_hed.html>`_
(possibly augmented by terms from one or more specialized **HED library schemas**).

**HED library schemas** for use in individual research subfields as well as the standard
schema and vocabularies under development are housed in the
`hed-schemas <https://github.com/>`_.

The **HED working group** is an ongoing open-source development organization whose mission is
to extend and maintain the HED standard and associated tools.
Visit the `hed-standard <https://github.com/hed-standard>`_ site on GitHub for information on
how to join the HED community of users and developers.

HED and BIDS
************

HED was accepted (2019) into the top-level
`BIDS <https://bids.neuroimaging.io/>`_ (Brain Imaging Data Structure) standard,
thus becoming an integral part of the BIDS data storage standards for an ever-increasing
number of neuroimaging data modalities.

An efficient approach to integrating HED event descriptions into BIDS metadata has been
demonstrated in this `2021 paper <https://www.sciencedirect.com/science/article/pii/S1053811921010387?via%3Dihub>`_.

HED Tools
*********

Currently, tools using HED for data annotation, validation, search, and extraction are
available for use `online <https://hedtools.ucsd.edu/hed>`_, or (as MATLAB functions) within the
`EEGLAB environment <https://sccn.ucsd.edu/eeglab/index.php>`_ running on Matlab.

Where to begin?
***************

To begin using HED tools to tag, search, and analyze data, browse the
`HED resources <https://www.hed-resources.org>`_ page.
Visit the `How can you use HED? <HowCanYouUseHed.md>`_ guide for information about
how specific types of users can leverage HED.

History and Support
*******************

**HED (Gen 1, version < 4.0.0)** was first proposed and developed by Nima Bigdely-Shamlo within the HeadIT project
at the Swartz Center for Computational Neuroscience (SCCN) of the University of California
San Diego (UCSD) under funding by The Swartz Foundation and by U.S. National Institutes of Health
(NIH) grants R01-MH084819 (Makeig, Grethe PIs) and R01-NS047293 (Makeig PI).

Further **HED (Gen 2, 4.0.0 <= version < 8.0.0)** development led by Kay Robbins
of the University of Texas San Antonio was
funded by The Cognition and Neuroergonomics Collaborative Technology Alliance (CaN CTA) program
of U.S Army Research Laboratory (ARL) under Cooperative Agreement Number W911NF-10-2-0022.

**HED (Gen 3, version >= 8.0.0)** is now maintained and further developed by the
HED Working Group led by Kay Robbins and Scott Makeig with Dung Truong, Monique Denissen,
Dora Hermes Miller, Tal Pal Attia, and Arnaud Delorme, with funding from NIH grant
`RF1-MH126700 <https://reporter.nih.gov/project-details/10480619>`_.

HED is an open research community effort; others interested are invited to participate and contribute.
Visit the `HED project homepage <https://github.com/hed-standard>`_ for links to the latest developments..


.. toctree::
   :maxdepth: 5
   :hidden:
   :caption: Overview:

   IntroductionToHed.md
   WhatsNew.md
   HowCanYouUseHed.md
   HedGovernance.md


.. toctree::
   :maxdepth: 5
   :hidden:
   :caption: Tutorials:

   BidsAnnotationQuickstart.md
   HedAnnotationQuickstart.md
   HedAnnotationInNWB.md
   HedValidationGuide.md
   HedSearchGuide.md
   HedSummaryGuide.md
   HedConditionsAndDesignMatrices.md
   FileRemodelingQuickstart.md
   HedSchemaDevelopersGuide.md


.. toctree::
   :maxdepth: 3
   :hidden:
   :caption: Tool documentation:

   HedOnlineTools.md
   CTaggerGuiTaggingTool.md
   FileRemodelingTools.md
   HedPythonTools.md
   HedJavascriptTools.md
   HedMatlabTools.md
   HedAndEEGLAB.md
   DocumentationSummary.md


.. toctree::
   :maxdepth: 3
   :hidden:
   :caption: Data resources:

   HedSchemas.md
   HedTestDatasets.md


Indices and tables
==================

* :ref:`genindex`
* :ref:`search`