library(neurobase)
library(ichseg)
library(tibble)
library(dplyr)
library(fs)
library(freesurfer)
source(here::here("R/utils.R"))
file = here::here("data", "filenames.rds")
df = readRDS(file)

iid = get_fold()


# for (iid in seq(nrow(df))) {
print(iid)
idf = df[iid,]

file_nifti = idf$file_nifti_ct
file_mask = idf$file_mask
file_ss = idf$file_ss


if (!all(file.exists(c(file_ss, file_mask)))) {
  ss.template.file =
    system.file("scct_unsmooth_SS_0.01.nii.gz",
                package = "ichseg")
  ss.template.mask =cp 
    system.file("scct_unsmooth_SS_0.01_Mask.nii.gz",
                package = "ichseg")

  ss = CT_Skull_Strip_robust(
    img = file_nifti,
    retimg = FALSE,
    keepmask = TRUE,
    template.file = ss.template.file,
    template.mask = ss.template.mask,
    # remover = "double_remove_neck",
    outfile = file_ss,
    maskfile = file_mask)
}

#}
