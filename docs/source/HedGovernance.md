-------------------DRAFT---------------------------------------------------
# HED governance and decision-making

Table of Contents

[**1. Introduction**](#1-introduction)

[**2. HED mission statement**](#2-hed-mission-statement)

[**3. HED organizational structure**](#3-hed-organizational-structure)  

- [**HED Scientific Advisory Board**](#hed-scientific-advisory-board)  
- [**HED Working Group**](#hed-working-group)  
- [**HED Library Development Teams**](#hed-library-development-teams)  
- [**HED Maintainers**](#hed-maintainers)  
- [**HED User Community**](#hed-user-community)  

[**4. HED processes**](#4-hed-processes)

[**5. Operational guidelines**](#5-operational-guidelines)  

[**6. License**](#6-license)  

[**7. Acknowledgments**](#7-acknowledgments)


## 1. Introduction

*Hierarchical Event Descriptors (HED)* is an open standard 
and supporting ecosystem for describing experimental events, conditions,
and experiment organization in a format that is both human- and machine-readable to enable analysis, re-analysis, and meta/mega-analysis.

This document describes HED's
mission principles, scope, and organizational processes. 
See [**Brief history of HED**](https://www.hed-resources.org/en/latest/IntroductionToHed.html#brief-history-of-hed) 
for a discussion of HED origins and development.
The HED [**project homepage**](https://www.hedtags.org) is a
good place to start for an overview of HED and links to major resources.

## 2. HED mission statement

- To <b>enable and support</b> the storing and sharing of recorded data in a fully analysis-ready format for efficient and effective within and cross-study data search, summary, and analysis.  
<p> </p>

- To make the process of annotation <b>accessible and usable</b> for the global neuroimaging and related communities.   
<p> </p>  

- To <b>open opportunities</b> for new types of analysis and automation.  

   
## 3. HED organizational structure

Managing a standard and integrating it into an ecosystem of other standards
and tools requires many types of skills and tasks.
To this end, the HED community has a number of identified groups acting in concert 
to promote HED and achieve its goals as show in the
following organization chart and detailed in the following sections.
The arrows indicate lines of communication.
Final decision-making is by consensus of the HED Working Group.


![leadership_figure](./_static/images/HEDOrganizationalChart.png "HED Leadership
Structure")



| Group | Function | Contact | GitHub |   
| ---- | ---- | ---- | ---- |   
| [**HED Scientific Advisory Board**](#hed-scientific-advisory-board) | Strategic planning   | Scott Makeig | [**smakeig**](https://github.com/smakeig)  |   
| [**HED Working Group**](#hed-working-group) | Oversight and <br/>day-to-day decisions | Kay Robbins<br/>Scott Makeig | [**VisLab**](https://github.com/VisLab)<br/>[**smakeig**](https://github.com/smakeig) |  
| [**HED Library Development Teams**](#hed-library-development-teams) | Library development issues | Dora Hermes<br/>Tal Pal Attia | [**dorahermes**](https://github.com/dorahermes)<br/>[**tpatpa**](https://github.com/tpatpa) |  
| [**HED Maintainers**](#hed-maintainers) | Repository management | Kay Robbins<br/>Dung Truong     | [**VisLab**](https://github.com/VisLab)<br/>[**dungscout96**](https://github.com/dungscout96) |  
| [**HED Outreach**](#hed-outreach) | Annotation assistance | Annalisa Salazar | [**asalazar4**](https://github.com/asalazar4) |   



If you have a question or wish to become more involved in the HED efforts,
post an issue to the main [**HED issues forum**](https://github.com/hed-standard/hed-schemas) or email
[**hed.maintainers@gmail.com**](mailto:hed.maintainers@gmail.com )

### HED Scientific Advisory Board

The HED Scientific Advisory Board includes senior members 
of the neuroimaging community whose role is to evaluate the needs of the user
community and to suggest strategic directions for HED development.
The initial membership of this committee was by invitation of
the HED Working Group based on their involvement in major
neuroinformatics efforts relevant to HED.

Additional/replacement members may be invited at the discretion of the
HED Scientific Advisory Board with input from the HED Working Group.

### HED Working Group

The HED Working Group is made up of volunteers committed to
spearheading the development of HED. The HED Working Group is responsible for developing the detailed technical
roadmap for HED development, including vetting library projects,
suggesting and planning for releases of new HED features,
revising the HED standard vocabulary, 
exploring integration with other standards and relevant repositories,
and resolving conflicts.

While the HED Scientific Advisory Board is concerned with high-level
strategic directions, the HED Working Group is concerned with the tactical
planning of HED development.
Any member of the HED community can propose an
agenda item and attend a HED Working Group meeting to discuss the item.
The HED Working Group currently meets twice a week and keeps a running
agenda and minutes. 


### HED Library Development Teams

In recognition that a single standardized vocabulary cannot capture
the relevant metadata for all subfields, HED supports/encourages the
development of specialized vocabularies to support detailed
annotation of experiments in specialized areas. 
These specialized vocabularies are called **HED library schemas**.
Each library schema has its own HED Library Development Team 
to initially develop the schema and to update the schema as needs arise.
The HED Maintainers are responsible for checking that proposed changes
meet the requirements of HED, but the library schema developers are
responsible for the vocabulary itself.


### HED Maintainers

This volunteer group is responsible for maintaining the 
[**HED Organization**](https://github.com/hed-standard) 
GitHub site. The maintainers facilitate issue discussions
in the various HED issue forums, review pull requests (PRs), 
do releases, and perform routine maintenance on the HED repositories.

### HED Outreach

A central goal of HED is to facilitate the creation of a large corpus of standardized
neuroimaging and behavioral datasets that have sufficient annotation to
be understood by users and handled by analysis tools. To that end, 
significant thrust of the HED standards initiative is to help users
learn to annotate and to promote good annotation and event reporting practices.
If you have questions about how to annotate particular aspect of your data,
Post an issue to [**hed-examples**](https://github.com/hed-standard/hed-examples/issues)
explaining the issue.

### HED User Community

This group consists of individuals who have contributed to the HED
community. If you make a contribution of any kind to the HED effort
please email [**hed-maintainers**](mailto:hed-maintainers@gmail.com)
with your name, GitHub ID, and contribution so that you can be 
recognized as part of our community.

Along with members of the preceding groups, this group comprises broadly
any individual who has used or has interest in using HED. All members
are invited and encouraged to join the HED User Community by
supporting the project in one of the many ways 

## 4. HED processes

The HED approach to standards development follows the principles of the
[Modern Paradigm for
Standards](https://open-stand.org/about-us/principles/) developed by
OpenStand:

1. Respectful cooperation between standards organizations
2. Adherence to fundamental principles of standards development:  
  a. Due Process  
  b. Broad Consensus  
  c. Transparency  
  d. Balance  
  e. Openness  
3. Collective empowerment
4. Availability
5. Voluntary adoption

The foundation of HED decision-making is listening to all members of
the HED Community and striving to achieve consensus on each level of
the HED standard process.

The criteria for forming a new HED Library Schema Development Team
is a statement of intent with defined scope, proposed name, members of the team.

The HED Working Group reviews the statement of intent to make sure
that the scope is well-defined and that the library schema does 
not have significant overlap with existing schemas. 

The actual development process
is iterative and schemas are always initially in a prerelease
format while community discussion and technical reviews are conducted.
An official release entails creating a permanent copy on
[**zenodo**](https://zenodo.org) with a DOI as well as
a permanent copy on [**hed-schemas**](https://github.com/hed-standard/hed-schemas).
Once a schema version has been officially released, it cannot be
changed, as tools use these released versions in computation.



## 5. Operational guidelines

There are several resources that can help a new user get started
on the [**HED resources**](https://www.hed-resources.org). The [**HED resources**](https://www.hed-resources.org) website
contains links to all the HED informational and help materials.

Users are encouraged to post questions, suggestions, and discussion on the appropriate GitHub issues forum
on the GitHub [**hed-standard**](https://github.com/hed-standard)
organization site as indicated in the following table.

| Issue/suggestion type | Issue forum                                                                   | Comments                                                                                            |
|-----------------------|-------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| Main issue forum      | [hed-schemas](https://github.com/hed-standard/hed-schemas/issues)             | Primary forum for schema development.<br/>Any issue can be posted and will be redirected if needed. |  
| Docs/examples         | [hed-examples](https://github.com/hed-standard/hed-examples/issues)           | Documentation corrections.<br/>Questions on examples.<br/>Help on annotation.                       |   
| Specification | [hed-specification](https://github.com/hed-standard/hed-specification/issues) | Clarification/suggestions on the<br/>specification document and JSON tests.                         |
| Python codebase | [hed-python](https://github.com/hed-standard/hed-python/issues)               | Bug reports and feature requests.                                                                   |  
| JavaScript codebase | [hed-validator](https://github.com/hed-standard/hed-validator/issues)         | Bug reports and feature requests.                                                                   | 

HED also has a HED discussion group. (Subscribe by emailing:
[**hed-discussion+subscribe@googlegroups.com**](mailto:hed-discussion+subscribe@googlegroups.com).

If you do not feel comfortable
asking your question publicly or have a concern please feel free to email the HED maintainers at
[**hed.maintainers@gmail.com**](mailto:hed.maintainers@gmail.com). 


````{admonition} How to propose a library schema.
Anyone can propose a HED library schema.
As early as possible in the process, a member of the
library schema development team should [**post an issue**](https://github.com/hed-standard/hed-schemas/issues) to the 
[**hed-schemas**](https://github.com/hed-standard/hed-schemas) 
GitHub repository indicating the
proposed library name, team members (with GitHub usernames), and brief description
to start the open process development.  

Alternatively, an interested user can post an GitHub issue to
inquire about user interest and the HED Working Group can
publicize the potential development and ask for participation
to get things started.
This process and schema design guidelines are described 
in the [**HED schema developer's guide**](https://www.hed-resources.org/en/latest/HedSchemaDevelopersGuide.html).
````

All HED community members are required to follow the HED
[**Code of conduct**](https://github.com/hed-standard/hed-examples/blob/main/CODE_OF_CONDUCT.md).
Please contact the HED maintainers at [**hed.maintainers+coc@gmail.com**](mailto:hed.maintainers+coc@gmail.com)
if you have any concerns or would like to report a violation.


## 6. License

To the extent possible under the law, the authors have waived all
copyright and related or neighboring rights to the HED project
governance and decision-making document, as per the [CC0 public domain
dedication /
license](https://creativecommons.org/publicdomain/zero/1.0/).

## 7. Acknowledgments

We gratefully acknowledge the BIDS Community for providing an
inclusive and balanced model of open-standard development.
HED has borrowed heavily from BIDS in developing a working
governance model to guide its evolution.

This document draws from the
[**Modern Paradigm for Standards**](https://open-stand.org/about-us/principles/)
and from other open-source governance documents.

