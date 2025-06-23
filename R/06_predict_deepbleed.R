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

ifold = get_fold(default = df$fold)

df = df %>%
  filter(fold %in% ifold)
iid = 1


for (iid in seq(nrow(df))) {
  idf = df[iid,]
  
  if (!file.exists(idf$file_nifti_prediction)) {
    res = rpi_orient_file(file = idf$file_nifti_ct)
    res_mask = rpi_orient_file(file = idf$file_mask)
    if (file.exists(idf$file_nifti_roi)) {
      res_roi = rpi_orient_file(idf$file_nifti_roi)
    }
    pred = ichseg::predict_deepbleed(
      image = res$img,
      mask = res_mask$img,
      outdir = dir_model)
    
    native = pred$native_prediction
    native[abs(native) < .Machine$double.eps] = 0
    native = reverse_rpi_orient(native, convention = res$convention, orientation = res$orientation)
    neurobase::writenii(native, idf$file_nifti_prediction)
  }
}
