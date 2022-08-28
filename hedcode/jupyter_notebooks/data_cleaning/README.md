### Jupyter notebooks used to clean datasets on OpenNeuro

The Jupyter notebooks in this directory were used to clean or restructure
data that was already on [OpenNeuro](https://openneuro.org) or was
subsequently deposited on OpenNeuro.

**Table 1:** Useful Jupyter notebooks used to process BIDS datasets on OpenNeuro.

| Directory            | OpenNeuro Identifier                    | 
| -------------------- | ---------------------------------- | 
| aomic_piop2 | [ds002790](https://openneuro.org/datasets/ds002790) |
| attention_shift | [ds002893](https://openneuro.org/datasets/ds002893) |
| bcit_advanced_guard_duty | [ds004106](https://openneuro.org/datasets/ds004106) |
| bcit_auditory_cueing | [ds004105](https://openneuro.org/datasets/ds004105) |
| bcit_baseline_driving | [ds004120](https://openneuro.org/datasets/ds004120) |
| bcit_basic_guard_duty | [ds004119](https://openneuro.org/datasets/ds004119) |
| bcit_calibration_driving | [ds004118](https://openneuro.org/datasets/ds004118) |
| bcit_mind_wandering | [ds004121](https://openneuro.org/datasets/ds004120) |
| bcit_rsvp_baseline | in process |
| bcit_rsvp_expertise | in process |
| bcit_speed_control | [ds004122](https://openneuro.org/datasets/ds004122) |
| bcit_traffic_complexity | [ds004123](https://openneuro.org/datasets/ds004123) |
| Face13 | in process |
| sternberg | [ds004117](https://openneuro.org/datasets/ds004117) |
| wakeman_henson | [ds003645] (https://openneuro.org/datasets/ds003645) |

These notebooks require HEDTOOLS, which can be installed using `pip` or directly.

To use `pip` to install `hedtools` from PyPI:

   ```
       pip install hedtools
   ```

To install directly from the 
[GitHub](https://github.com/hed-standard/hed-python) repository:

   ```
       pip install git+https://github.com/hed-standard/hed-python/@master
   ```

HEDTools require python 3.7 or greater.
