Sys.setenv("RETICULATE_PYTHON" = "managed")
library(neurobase)
library(dplyr)
library(readr)
library(here)
library(purrr)
library(tidyr)
library(ichseg)
library(fslr)
source(here::here("R/utils.R"))

file = here::here("data", "filenames.rds")
df = readRDS(file)

dir_model = here::here("deepbleed_model")
if (!file.exists(file.path(dir_model, "checkpoint"))) {
  ichseg::download_deepbleed_model(outdir = dir_model)
}

pkgs = c("numpy<2", "nibabel", "pillow", "six", "scikit-learn", "scikit-image", 
  "webcolors", "plotly", "pandas", "matplotlib", "h5py>=2.9", "fslpy", 
  "gast==0.2.2", "tensorflow<2.16", "statsmodels")
reticulate::py_require(pkgs)
iid = which(df$id == "077")
idf = df[iid,]

res = rpi_orient_file(file = idf$file_nifti_ct)
res_mask = rpi_orient_file(file = idf$file_mask)
pred = ichseg::predict_deepbleed(
  image = res$img,
  mask = res_mask$img,
  outdir = dir_model)
