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
    file_nifti_roi = ifelse(!file.exists(file_nifti_roi), NA, file_nifti_roi),
    group = ifelse(!file.exists(file_nifti_roi), "evaluation", "train"),
    id = nii.stub(file_nifti_ct, bn = TRUE),
    fold = as.numeric(factor(id))
  )

dir_ss = here::here("data", "brain_extracted")
dir_mask = here::here("data", "brain_mask")

fs::dir_create(
  c(
    dir_ss,
    dir_mask
  )
)

df = df %>%
  mutate(
    stub = basename(file_nifti_ct),

    file_ss = here::here(dir_ss, stub),
    file_mask = here::here(dir_mask, stub),
    
  ) %>%
  select(-stub)


outfile = here::here("data", "filenames.rds")
readr::write_rds(df, outfile)


