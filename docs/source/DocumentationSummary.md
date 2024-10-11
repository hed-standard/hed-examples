# Documentation summary


## HED publications

### Journal articles

Practical use of HED SCORE:  

> Dan, J., Pale, U. Amirshahi, A., Capelletti, W. Ingolfsson, T., Wang, X., Cossettini, A.,
> Bernini, A. Benini, L., Beniczky, S., Atienza, D., and P. Ryvlin (2024).  
> SzCORE: Seizure Community Open-Source Research Evaluation framework for the validation  
> of electroencephalography-based automated seizure detection algorithms  
> Epilepsia, Sept 18, 2024.   
> [**https://doi.org/10.1111/epi.18113**](https://doi.org/10.1111/epi.18113).  

Conceptual framework for HED and path for future development: 

> Makeig, S. and K. Robbins (2024).      
> Events in context—The HED framework for the study of brain, experience and behavior.    
> Front. Neuroinform. Vol. 18 Research Topic 15 Years of impact, open neuroscience.  
> [https://doi.org/10.3389/fninf.2024.1292667]( https://doi.org/10.3389/fninf.2024.1292667).  

Explanation of the history, development, and motivation for third generation HED: 

> Robbins, K., Truong, D., Jones, A., Callanan, I., and S. Makeig (2022).  
> Building FAIR functionality: Annotating events in time series data using Hierarchical Event Descriptors (HED).  
> Neuroinformatics Special Issue Building the NeuroCommons. Neuroinformatics https://doi.org/10.1007/s12021-021-09537-4.  
> [https://link.springer.com/article/10.1007/s12021-021-09537-4](https://link.springer.com/article/10.1007/s12021-021-09537-4).

Detailed case study in using HED-3G for tagging:

> Robbins, K., Truong, D., Appelhoff, S., Delorme, A., and S. Makeig (2021).   
> Capturing the nature of events and event context using Hierarchical Event Descriptors (HED).  
> NeuroImage Special Issue Practice in MEEG. NeuroImage  245  (2021)  118766.  
> [https://www.sciencedirect.com/science/article/pii/S1053811921010387](https://www.sciencedirect.com/science/article/pii/S1053811921010387).

### Preprints

Introducing the HED Lang library schema for annotation of linguistic stimulations: 

> Denissen, M., Pöll, B., Robbins, K. Makeig, S. and Hutzler, F. (2024).  
> HED LANG –A Hierarchical Event Descriptors library extension for annotation of language cognition experiments.  
> [**https://osf.io/preprints/psyarxiv/bjz9q](https://osf.io/preprints/psyarxiv/bjz9q).  
> DOI:10.31234/osf.io/bjz9q. 

Development of the HED SCORE library schema for clinical annotation of EEG:  

> Pal Attia, T., Robbins, K., Beniczky, S., Bosch-Bayard, J., Delorme, A., Lundstrom, B., Rogers, C., Rampp, S.,  
>  Valdes-Sosa, P., Truong, D., Worrell, G., Makeig, S., and D. Hermes (2023).   
> Hierarchical Event Descriptor library schema for EEG data annotation.  
> [**https://arxiv.org/abs/2310.15173**](https://arxiv.org/abs/2310.15173).  
> DOI:10.48550/arXiv.2310.15173.  



### Book chapters (preprints)

>  Truong, D., Robbins, K., Delorme, A., and S. Makeig (in press).  
> End-to-end processing of M/EEG data with BIDS, HED, and EEGLAB.  
> [**https://osf.io/8brgv/**](https://osf.io/8brgv/).   
> in [**Methods for analyzing large neuroimaging datasets**](https://osf.io/d9r3x/) edited by Whelan and Lemaitre.   


> Denissen, D., Richlan, F., Birklbauer, J., Pawlik, M., Ravenschlag, A., Himmelstoss, N., Hutzler, F. and K. Robbins (in press).   
> Actionable event annotation and analysis in fMRI: A practical guide to event handling.   
> [**https://osf.io/93km8/**](https://osf.io/93km8/).   
> in
[**Methods for analyzing large neuroimaging datasets**](https://osf.io/d9r3x/) edited by Whelan and Lemaitre.   


## HED schema viewer

The HED schema is usually developed in `.mediawiki` format and converted to XML for use by tools.
However, researchers wishing to tag datasets will find both of these views hard to read. 
All versions of the standard schema and library schemas including the prerelease versions
available via the expandable [**HTML viewer**](https://www.hedtags.org/display_hed.html).
The  `.mediawiki` sources can be viewed on the 
[**hed-schemas](https://github.com/hed-standard/hed-schemas) GitHub repository using
GitHub's default markdown viewer.

## HED Websites

The following is a summary of the HED-related websites:


`````{list-table}
:header-rows: 1
:widths: 20 50

* - Description
  - Site
* - HED project homepage
  - [https://www.hedtags.org](https://www.hedtags.org)
* - HED resources (docs)
  - [https://www.hed-resources.org](https://www.hed-resources.org)
* - HED Wikipedia Page
  - [https://https://en.wikipedia.org/wiki/Hierarchical_Event_Descriptors](https://en.wikipedia.org/wiki/Hierarchical_Event_Descriptors)
* - HED specification
  - [https://hed-specification.readthedocs.io/en/latest/index.html](https://hed-specification.readthedocs.io/en/latest/index.html)
* - CTAGGER executable jar
  - [https://github.com/hed-standard/hed-java/raw/master/ctagger.jar](https://github.com/hed-standard/hed-java/raw/master/ctagger.jar)
* - **Repositories**
  -
* - HED organization
  - [https://github.com/hed-standard](https://github.com/hed-standard)
* - HED specification
  - [https://github.com/hed-standard/hed-specification](https://github.com/hed-standard/hed-specification)
* - HED examples and datasets
  - [https://github.com/hed-standard/hed-examples](https://github.com/hed-standard/hed-examples)
* - HED Python tools
  - [https://github.com/hed-standard/hed-python](https://github.com/hed-standard/hed-python)
* - HED Javascript code
  - [https://github.com/hed-standard/hed-javascript](https://github.com/hed-standard/hed-javascript)
* - HED Matlab code and EEGLAB support
  - [https://github.com/hed-standard/hed-matlab](https://github.com/hed-standard/hed-matlab)
* - HED web deployment
  - [https://github.com/hed-standard/hed-web](https://github.com/hed-standard/hed-web)
* - HED-2G support
  - [https://github.com/hed-standard/hed2-python](https://github.com/hed-standard/hed2-python)
* - CTAGGER resources
  - [https://github.com/hed-standard/CTagger](https://github.com/hed-standard/CTagger)
* - **Online tools**
  -
* - HED tools
  - [https://hedtools.org](https://hedtools.org)
* - HED tools (development)
  - [https://hedtools.org/hed_dev](https://hedtools.org/hed_dev)
* - HED-2G support
  - [https://hedtools.org/hed2](https://hedtools.org)
`````


## HED working documents

Mapping of HED terms and their descriptions to known ontologies is:

> HED-3G Working Document on Ontology mapping   
> [https://drive.google.com/file/d/13y17OwwNBlHdhB7hguSmOBdxn0Uk4hsI/view?usp=sharing](https://drive.google.com/file/d/13y17OwwNBlHdhB7hguSmOBdxn0Uk4hsI/view?usp=sharing)

Two other working documents hold portions of the HED-3G specification that are under development 
and will not be finalized for Release 1:

> HED-3G Working Document on Spatial Annotation   
> [https://docs.google.com/document/d/1jpSASpWQwOKtan15iQeiYHVewvEeefcBUn1xipNH5-8/view?usp=sharing](https://docs.google.com/document/d/1jpSASpWQwOKtan15iQeiYHVewvEeefcBUn1xipNH5-8/view?usp=sharing)

> HED-3G Working Document on Task Annotation  
> [https://docs.google.com/document/d/1eGRI_gkYutmwmAl524ezwkX7VwikrLTQa9t8PocQMlU/view?usp=sharing](https://docs.google.com/document/d/1eGRI_gkYutmwmAl524ezwkX7VwikrLTQa9t8PocQMlU/view?usp=sharing)

