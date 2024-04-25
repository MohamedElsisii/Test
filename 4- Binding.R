############################################
#Download packages

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(("tidyverse"),force = TRUE)
############################################
#1] Import libraries
library(tidyverse)
############################################
#2] Set working directory
setwd(normalizePath(dirname(rstudioapi::getSourceEditorContext()$path)))
############################################
#3] RNA DF

# List all files in the working directory with "_RNA.rda" extension
files_rna <- list.files(pattern = "_RNA\\.rda$")

# Load all matrices and store them in a list using readRDS()
matrices_list_rna <- lapply(files_rna, function(file) {
  readRDS(file) # Directly read the RDS file
})

# Find common rows across all RNA matrices
common_rows_rna <- Reduce(intersect, lapply(matrices_list_rna, rownames))

# Bind columns of all RNA matrices, keeping only the common rows
combined_matrix_rna <- do.call(cbind, lapply(matrices_list_rna, function(mat) mat[common_rows_rna, ]))

# Convert the combined RNA matrix to a dataframe
combined_df_rna <- as.data.frame(combined_matrix_rna)

# Save the combined RNA dataframe
saveRDS(combined_df_rna, "expression.rda")


###########################################
#4] Methylation DF

# List all files in the working directory with "_Methylation.rda" extension
files_meth <- list.files(pattern = "_Methylation\\.rda$")

# Load all matrices and store them in a list using readRDS()
matrices_list_meth <- lapply(files_meth, function(file) {
  readRDS(file) # Directly read the RDS file
})

# Find common rows across all Methylation matrices
common_rows_meth <- Reduce(intersect, lapply(matrices_list_meth, rownames))

# Bind columns of all Methylation matrices, keeping only the common rows
combined_matrix_meth <- do.call(cbind, lapply(matrices_list_meth, function(mat) mat[common_rows_meth, ]))

# Convert the combined Methylation matrix to a dataframe
combined_df_meth <- as.data.frame(combined_matrix_meth)

# Clean up the row names if needed
rownames(combined_df_meth) <- common_rows_meth

# Save the combined Methylation dataframe
saveRDS(combined_df_meth, "methylation.rda")
