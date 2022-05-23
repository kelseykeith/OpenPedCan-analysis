## Add formatted sample id column for PedCBio upload

**Module author:** Run Jin ([@runjin326](https://github.com/runjin326)) & Jo Lynne Rokita

Pre-sample name updates include (temporary):
- Adding GTEx group --> `cancer_group` (HISTOLOGY on pedcbio)
- Adding GTEx subgroup --> `harmonized_diagnosis` (CANCER_TYPE_DETAILED on pedcbio)
- Ensuring all tumor samples previously without a `harmonized_diagnosis` have one (`cancer group`, or `cancer group` + `molecular subtype`, in the case of NBL)
- Fix `broad_histology` discrepancy for heme malignancies


Currently, for some of the samples, when multiple DNA or RNA specimens are associated with the same sample, there 
is no column that would distinguish between different aliquots while still tying DNA and RNA together.
This module adds a column called `formatted_sample_id` where the base name is the sample id and additional `tiebreaks` were added when multiple RNA or DNA samples are associated with the same participant.

For PBTA samples, `sample_id` column is used as the basename
- Using `sample_id` column, we can tie all DNA and RNA samples together
- Using `formatted_sample_id` column, we can distinguish amongst multiple DNA or RNA samples 
  - Multiple DNA samples associated with the same sample would use `aliquot_id` as the tie breaker
  - Multiple RNA samples associated with the same sample would use `RNA_library` as the tie breaker 

For TARGET, TCGA, and GTEx samples, `Kids_First_Participant_ID` column is used as the basename
- Using `Kids_First_Participant_ID` column, we can tie all DNA and RNA samples together
- Using `formatted_sample_id` column, we can distinguish amongst multiple DNA or RNA samples 
  - For TARGET, `Kids_First_Participant_ID` + last 7 digits from the `Kids_First_Specimen_ID` is used as formatted sample ID
  - For TCGA, `Kids_First_Participant_ID` + `sample_id` + `aliquot_id` is used as formatted sample ID
  - For GTEx, `Kids_First_Participant_ID` + `aliquot_id` is used as formatted sample ID

Usage:
  ```
Rscript -e "rmarkdown::render('pedcbio_sample_name_col.Rmd', clean = TRUE)"

```
or
```
bash run_add_name.sh
```

Input:
- `input/cbtn_cbio_sample.csv`
- `input/oligo_nation_cbio_sample.csv`
- `input/dgd_cbio_sample.csv`
- `input/x01_fy16_nbl_maris_cbio_sample.csv`

Output:
- `results/histologies-formatted-id-added.tsv`

The output files are directly uploaded to S3 buckets for loading into PedCBio.

## Histology-to-cBio data_clinical_patient.txt and data_clinical_sample.txt
This script is used take in the modified histologies file created by this module and convert to a format ingestable by the cBioportal ETL

clinical_to_datasheets.py
 ```
usage: clinical_to_datasheets.py [-h] [-f HEAD] [-c CLIN] [-s CL_SUPP]

Script to convert clinical data to cbio clinical data sheets

optional arguments:
  -h, --help            show this help message and exit
  -f HEAD, --header-file HEAD
                        tsv file with input file original sample names, output
                        sheet flag, and conversion
  -c CLIN, --clinical-data CLIN
                        Input clinical data sheet
  -s CL_SUPP, --cell-line-supplement CL_SUPP
                        supplemental file with cell line meta data - bs
                        id<tab>type. optional
 ```
 - `-f` Header file example can be found here: `analyses/pedcbio-sample-name/header_desc.tsv`
 - `-c` `histologies.tsv`

The `-s` input can be skipped, as this ends up being covered by the input provided to the module for `input/cbtn_cbio_sample.csv`.
Outputs a `data_clinical_sample.txt` and `data_clinical_patient.txt` for the cBio package, and a `bs_id_sample_map.txt` mapping file to link BS IDs to generated cBioPortal IDs based on the rules for creating a proper somatic event using column `parent_aliquot_id`


Example run:
`python3 analyses/pedcbio-sample-name/clinical_to_datasheets.py -f analyses/pedcbio-sample-name/header_desc.tsv  -c histologies.tsv`