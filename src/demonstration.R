# The goal of this script is to demonstrate the reclassification of lactobacilli
# to the new taxonomy introduced by Zheng et al. (2020). 

# dependencies: tidyverse v1.3.1, tidyamplicons version ed7b057, dada2 v1.20.0

library(tidyverse)
library(tidyamplicons)
library(glue)
source("src/functions.R")

# specify locations of test data, reference database and output files
din_pekes <- "data/ferme_pekes_preprocessed/"
din_isala <- "data/isala_pilot_amplicon_preprocessed/"
fin_refdb <- "data/SSUrRNA_GTDB05-lactobacillaceae-all_DADA2.fna"
dout <- "results"

# create results folder 
if (! dir.exists(dout)) dir.create(dout)

# import isala data and select a subset of samples (vaginal samples only,
# extracted with powerfecal, single sample per participant, high quality only)
vaginal <-
  din_isala %>%
  read_tidyamplicons() %>%
  filter_samples(body_site == "V", method == "A", rep == "rep3") %>%
  filter_samples(high_quality) %>%
  mutate_samples(
    dataset = glue("vaginal swabs (n = {numbers(.)[['n_samples']]})")
  ) %>%
  select_samples(sample_id, dataset) %>%
  modify_at("taxa", rename, sequence = taxon)

# import ferme pekes data and select high quality samples at day 30 of
# fermentation
pekes <-
  din_pekes %>%
  read_tidyamplicons() %>%
  filter_samples(day == "D30", high_quality) %>%
  mutate_samples(
    dataset = glue("fermented carrots (n = {numbers(.)[['n_samples']]})")
  ) %>%
  select_samples(sample_id, dataset) 

# merge the datasets
combined <- merge_tidyamplicons(vaginal, pekes, taxon_identifier = sequence)

# inspect the data
bar_plot_simplified(combined)

# adapt to the new taxonomy of Lactobacillaceae
combined$taxa <-
  combined$taxa %>%
  {.$family[.$family == "Leuconostocaceae"] <- "Lactobacillaceae"; .}
combined <-
  combined %>% 
  mutate_taxa(genus_old = genus) %>%
  classify_taxa(
    refdb = fin_refdb, family == "Lactobacillaceae", sequence_var = "sequence",
    min_boot = 30
  )

# compare Lactobacillaceae pre- and post-reclassification 
combined %>% taxcomp_plot_abundances()
ggsave(
  paste0(dout, "/lactobacillaceae_reclassifiation.png"), units = "cm", 
  width = 16, heigh = 12
)
