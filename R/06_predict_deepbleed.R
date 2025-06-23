Sys.setenv("RETICULATE_PYTHON" = "managed")
library(neurobase)
library(dplyr)
library(readr)
library(here)
library(purrr)
library(tidyr)
library(ichseg)
source(here::here("R/utils.R"))

file = here::here("data", "filenames.rds")
df = readRDS(file)

dir_model = here::here("deepbleed_model")
if (!file.exists(file.path(dir_model, "checkpoint"))) {
  ichseg::download_deepbleed_model(outdir = dir_model)
}

iid = 1
idf = df[iid,]

pred = ichseg::predict_deepbleed(image = idf$file_nifti_ct,
                          mask = idf$file_mask,
                          outdir = dir_model)
