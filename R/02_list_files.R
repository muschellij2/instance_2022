library(neurobase)
library(dplyr)
library(readr)
library(here)
library(purrr)
library(tidyr)
source(here::here("R/utils.R"))
df = tibble(
  file_nifti_ct = list.files(
    path = here::here("data", "nifti"),
    recursive = TRUE,
    pattern = "*.nii.gz",
    full.names = TRUE),
)
df = df %>% 
  mutate(
    file_nifti_roi = sub("nifti/", "label/", file_nifti_ct),
    file_nifti_prediction = sub("nifti/", "prediction/", file_nifti_ct),
    
    group = ifelse(!file.exists(file_nifti_roi), "evaluation", "train"),
    id = nii.stub(file_nifti_ct, bn = TRUE),
    fold = as.numeric(factor(id))
  )

dir_ss = here::here("data", "brain_extracted")
dir_prediction = here::here("data", "prediction")
dir_mask = here::here("data", "brain_mask")
dir_image = here::here("results", "image")
dir_image_ss = here::here("results", "image_ss")

fs::dir_create(
  c(
    dir_ss,
    dir_mask,
    dir_prediction,
    
    dir_image,
    dir_image_ss
  )
)

df = df %>%
  mutate(
    stub = basename(file_nifti_ct),

    file_ss = here::here(dir_ss, stub),
    file_mask = here::here(dir_mask, stub),
    file_prediction = here::here(dir_prediction, stub),
    
    stub = nii.stub(file_nifti_ct, bn = TRUE),
    file_image_nifti = here::here(dir_image, paste0(stub, ".png")),
    file_image_ss = here::here(dir_image_ss, paste0(stub, ".png")),
    
  ) %>%
  select(-stub)


outfile = here::here("data", "filenames.rds")
readr::write_rds(df, outfile)


