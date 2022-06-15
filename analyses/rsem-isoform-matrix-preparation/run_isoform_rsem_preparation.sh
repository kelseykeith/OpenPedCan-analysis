#!/bin/bash
# PediatricOpenTargets 2022
# Sangeeta Shukla
set -e
set -o pipefail

# This script should always run as if it were being called from
# the directory it lives in.
script_directory="$(perl -e 'use File::Basename;
  use Cwd "abs_path";
  print dirname(abs_path(@ARGV[0]));' -- "$0")"
cd "$script_directory" || exit


# Set up paths to data files consumed by analysis
data_path='input'


# Files for input and output of RSEM isoform TPM data
isoform_data="${data_path}/rna-isoform-expression-rsem-tpm.rds"
isoform_out="rna-isoform-expression-rsem-tpm_out.rds"


#Run post processing on the RSEM isoform to generate harmonized matrix in a file
Rscript prepare_rsem_isoform_matrix.R \
--isoform_input $isoform_data \
--isoform_output $isoform_out
