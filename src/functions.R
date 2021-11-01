bar_plot_simplified <- function(ta) {
  bar_plot(ta) +
    ylab("") + xlab("") +
    theme(
      axis.text.x = element_blank(), 
      axis.text.y = element_blank(), 
      axis.ticks = element_blank()
    )
}

taxcomp_plot_abundances <- function(ta) {
  
  family <- "Lactobacillaceae"
  
  taxa_pre <-
    ta %>%
    mutate_taxa(genus = genus_old) %>%
    aggregate_taxa(rank = "genus") %>%
    add_taxon_name() %>%
    add_mean_rel_abundances(condition = "dataset") %>%
    taxa() %>%
    filter(family == {{family}}) %>%
    select(taxon_name, starts_with("mean_rel_abundance")) %>%
    mutate(taxonomy = "old genus")
  taxa_post <-
    ta %>%
    aggregate_taxa(rank = "genus") %>%
    add_taxon_name() %>%
    add_mean_rel_abundances(condition = "dataset") %>%
    taxa() %>%
    filter(family == {{family}}) %>%
    select(taxon_name, starts_with("mean_rel_abundance")) %>%
    mutate(taxonomy = "new genera")
  levels <- c("old genus", "new genera")
  taxa <- 
    bind_rows(taxa_pre, taxa_post) %>% 
    pivot_longer(
      cols = starts_with("mean_rel_abundance"), names_to = "dataset", 
      values_to = "mean_rel_abundance"
    ) %>%
    mutate(dataset = str_remove(dataset, "^mean_rel_abundance_in_")) %>%
    mutate(dataset = str_replace_all(dataset, "_", " ")) %>%
    mutate(taxonomy = factor(taxonomy, levels = levels)) %>%
    group_by(taxonomy, dataset) %>%
    mutate(
      mean_rel_abundance = mean_rel_abundance / sum(mean_rel_abundance)
    ) %>%
    ungroup()
  
  taxonlevels <-
    taxa %>%
    group_by(taxon_name) %>%
    summarize(max = max(mean_rel_abundance), .groups = "drop") %>%
    filter(! is.na(taxon_name)) %>%
    arrange(desc(max)) %>%
    pull(taxon_name)
  taxa %>%
    mutate(taxon_name = factor(taxon_name, levels = taxonlevels)) %>%
    ggplot(aes(x = 1, y = mean_rel_abundance, fill = taxon_name)) +
    geom_col() +
    coord_polar(theta = "y") +
    facet_grid(taxonomy ~ dataset) +
    scale_fill_brewer(palette = "Paired", na.value = "grey", name = "taxon") +
    theme_bw() +
    theme(
      axis.text = element_blank() ,
      axis.ticks = element_blank(), 
      axis.title = element_blank(),
      panel.grid = element_blank()
    )
  
}

# probably won't work anymore
taxcomp_plot_asvs <- function(ta, old, new) {
  
  old <- rlang::enquo(old)
  new <- rlang::enquo(new)
  
  asv_counts <- 
    ta %>%
    taxa() %>%
    filter(family == "Lactobacillaceae") %>%
    {bind_rows(
      mutate(., taxonomy = "new", genus = {{new}}),
      mutate(., taxonomy = "old", genus = {{old}})
    )} %>%
    mutate(
      taxonomy = 
        factor(
          taxonomy, levels = c("old", "new"), 
          labels = c("old taxonomy", "new taxonomy")
        )
    ) %>%
    count(taxonomy, genus, name = "n_asvs")
  
  genuslevels <-
    asv_counts %>%
    group_by(genus) %>%
    summarize(tot = sum(n_asvs), .groups = "drop") %>%
    filter(! is.na(genus)) %>%
    arrange(desc(tot)) %>%
    pull(genus)
  
  asv_counts %>%
    mutate(genus = factor(genus, levels = genuslevels)) %>%
    ggplot(aes(x = 1, y = n_asvs, fill = genus)) +
    geom_col() +
    coord_polar(theta = "y") +
    facet_wrap(~ taxonomy, ncol = 1) +
    scale_fill_brewer(palette = "Paired", na.value = "grey") +
    theme_bw() +
    theme(
      axis.text = element_blank() ,
      axis.ticks = element_blank(), 
      axis.title = element_blank(),
      panel.grid = element_blank()
    )
  
}