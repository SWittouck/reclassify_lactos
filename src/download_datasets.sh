#!/usr/bin/env bash 

# This script will download the datasets necessary to demonstrate the 
# reclassification of Lactobacillaceae amplicon sequences to the new taxonomy. 

url_pekes=https://github.com/SWittouck/datasets/raw/main/ferme_pekes_preprocessed.tar.gz
url_isala=https://github.com/SWittouck/datasets/raw/main/isala_pilot_amplicon_preprocessed.tar.gz
url_refdb=https://github.com/SWittouck/datasets/raw/main/SSUrRNA_GTDB05-lactobacillaceae-all_DADA2.fna.gz
dout=../data

# create data folder
[ -d $dout ] || mkdir $dout

# download datasets
wget $url_pekes -P $dout/
wget $url_isala -P $dout/
wget $url_refdb -P $dout/

# extract and/or unzip data
tar -xzf $dout/ferme_pekes_preprocessed.tar.gz -C $dout
tar -xzf $dout/isala_pilot_amplicon_preprocessed.tar.gz -C $dout
gunzip $dout/SSUrRNA_GTDB05-lactobacillaceae-all_DADA2.fna.gz

# remove archives
rm $dout/ferme_pekes_preprocessed.tar.gz
rm $dout/isala_pilot_amplicon_preprocessed.tar.gz