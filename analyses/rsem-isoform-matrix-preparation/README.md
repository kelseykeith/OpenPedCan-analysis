# Create RSEM Isoform TPM expression table

**Contents**

- [Purpose](#purpose)
- [Usage](#usage)
- [Note](#Note)

## Purpose
Create an Isoform expression table of TPM values using Isoform Ensembl IDs as rows, and KF Biospecimen IDs as columns.

## Usage
The input file must be a merged file of isoform data with all RNA ids for TARGET, GMKF, PBTA. 

```

Required flags:
 - `--isoform_input`: File name and path for the merged input isoform data
 - `--isoform_output`: Name for the output file with expected formatting for downstream analysis
```

Input files:
```
input/rna-isoform-expression-rsem-tpm.rds
```

Output files:
```
results/rna-isoform-expression-rsem-tpm_out.rds
```

### Note
The input file contains a unique combination if `ENST_IDs_Transcript_IDs`. However, the `ENST_IDs` are not unique, and therefor can not be used to label rownames. They are included as a column in the output file `rna-isoform-expression-rsem-tpm_out.rds`. Additionally, the list of duplicated ENST_IDs in available in a separate file `results\non_unique_enst_ids.tsv`

