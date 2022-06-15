suppressPackageStartupMessages({
  library(optparse)
  library(data.table)
  library(dplyr)
  library(tidyverse)
})


option_list <- list(
  make_option(c("-i", "--isoform_input"), type = "character",
              help = "Input file for merged RSEM isoform TPM"),
  make_option(c("-o", "--isoform_output"), type = "character",
              default = "comparison-results",
              help = "Output RDS file for RSEM isoform TPM expression table")
)

# parse the parameters
opt <- parse_args(OptionParser(option_list = option_list))

isoform_input <- opt$isoform_input
isoform_output <- opt$isoform_output


isoform_data <- readRDS(file = isoform_input)
#isoform_data <- readRDS(file = 'input/rna-isoform-expression-rsem-tpm.rds')

outdir <- 'results'
cmd_mkdir <- paste("mkdir",outdir,sep=" ")
system(cmd_mkdir)


isoform_final <- isoform_data %>%
  mutate(enst_id_new = stringr::str_split(transcript_id, "_") %>% purrr::map_chr(., 1)) %>%
  mutate(new_transcript_id = stringr::str_split(transcript_id, "_") %>% purrr::map_chr(., 2)) %>%
  select(-transcript_id) %>%
  rename(transcript_id = new_transcript_id) #%>%
  #column_to_rownames(var="ensg_id_new")


output_file=paste(outdir,"//",isoform_output,sep="")
saveRDS(isoform_final, file = output_file)

check_data=paste(outdir,"//","non_unique_enst_ids",sep="")
non_unique_enst_ids <-unique(isoform_final$enst_id_new[ 
  isoform_final$enst_id_new %in% isoform_final$enst_id_new[duplicated(isoform_final$enst_id_new)] 
  ])

investigate_enst_ids <- data.frame(enst_id = non_unique_enst_ids)
write.table(investigate_enst_ids, file=paste(check_data,".tsv",sep=""), sep="\t", col.names = T, row.names = F,quote = F)

#length(non_unique_enst_ids)




