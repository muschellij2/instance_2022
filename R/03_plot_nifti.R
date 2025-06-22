library(neurobase)
library(ichseg)
library(tibble)
library(dplyr)
library(fs)
library(oro.nifti)
library(png)
library(grid)
library(gridExtra)
library(tidyr)
source(here::here("R/utils.R"))
source(here::here("R/helper_functions.R"))
file = here::here("data", "filenames.rds")
df = readRDS(file)

ifold = get_fold(default = df$fold)

df = df %>%
  filter(fold %in% ifold)

iid = 1
all_bad = NULL

print(nrow(df))
for (iid in seq(nrow(df))) {
  print(iid)
  idf = df[iid,]
  
  file_image_nifti = idf$file_image_nifti
  file_ct = idf$file_nifti_ct
  file_roi = idf$file_nifti_roi
  dir_study = idf$id
  
  if (!file.exists(file_image_nifti) &&
      file.exists(file_ct)) {
    img = readnii(file_ct)
    img = window_img(img, c(0, 100))
    if (!is.na(file_roi)) {
      roi = readnii(file_roi)
      roi = roi > 0
    } else {
      roi = img*0
    }
    # expand the image a bit for slices
    overlay_file = create_overlay(img, roi)
    ortho_file = create_ortho(img, roi, dir_study)
    img1 <-  rasterGrob(as.raster(readPNG(overlay_file)), interpolate = FALSE)
    img2 <-  rasterGrob(as.raster(readPNG(ortho_file)), interpolate = FALSE)
    png(file_image_nifti, res = 300, width = 2000, height = 1000)
    grid.arrange(img1, img2, ncol = 2)
    dev.off()
  } else {
    # res = readnii(file_nifti, drop_dim = FALSE)
  }
  
}
