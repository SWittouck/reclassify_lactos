# Reclassify lacto's

In 2020, two taxonomic changes to the family _Lactobacillaceae_ were [published in IJSEM](https://doi.org/10.1099/ijsem.0.004107): (1) the merger of the family _Leuconostocaceae_ into _Lactobacillaceae_ and (2) the split of the genus _Lactobacillus_ into 25 separate genera (one of which retained the name _Lactobacillus_). This taxonomic change increases the taxonomic resolution of 16S rRNA amplicon sequencing studies, as sequences can now be classified to smaller, more meaningful genera. Here we provide code that can be used to reclassify the _Lactobacillaceae_ sequences present in an amplicon dataset (where reference sequences of ASVs/OTUs are still present) to the new taxonomy.

A demonstration of such a reclassification can be found in `src/demonstration.R`.

## Dependencies

* R version 4.1.1
* R packages: 
    * tidyverse version 1.3.1
    * tidyamplicons version ed7b057
    * dada2 version 1.20.0

## Data

ferme_pekes_preprocessed

* samples from carrot juice fermentations that volunteers did at home 
* amplicon: V4 region of the 16S rRNA gene
* from [this publication](https://doi.org/10.1128/AEM.00134-18)

isala_pilot_study_preprocessed

* vaginal samples from volunteers (not taken in a clinical context)
* amplicon: V4 region of the 16S rRNA gene
* from [this publication](https://doi.org/10.1016/j.isci.2021.103306)
