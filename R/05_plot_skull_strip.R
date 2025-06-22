library(neurobase)
library(ichseg)
library(tibble)
library(dplyr)
library(fs)
source(here::here("R/utils.R"))
file = here::here("data", "filenames.rds")
df = readRDS(file)

ifold = get_fold()

df = df %>%
  filter(fold %in% ifold)
print(nrow(df))

file_empty = function(file) {
  !file.exists(file) ||
    (file.size(file) == 0 && file.exists(file))
}

plot_seg = function(
    file_nifti,
    file_mask,
    file_image_ss) {
  if (file_empty(file_image_ss) && file.exists(file_mask)) {
    img = readnii(file_nifti)
    img = window_img(img, c(0, 100))
    mask = readnii(file_mask)
    mask = mask > 0
    dir.create(dirname(file_image_ss), recursive = TRUE, showWarnings = FALSE)
    # write some text to show what image
    text = nii.stub(file_nifti, bn = TRUE)
    text = sub("_CT_", "_", text)
    text = gsub("_", "\n", text)
    png(file_image_ss, res = 300, width = 2000, height = 1000)
    ortho2(
      img,
      mask,
      NA.y = TRUE,
      col.y = scales::alpha("red", 0.5),
      text = text
    )
    dev.off()
  }
  
}

iid = 1

for (iid in seq(nrow(df))) {
  print(iid)
  idf = df[iid,]
  
  file_nifti = idf$file_nifti_ct
  
  
  
  file_mask = idf$file_mask
  file_image_ss = idf$file_image_ss
  
  plot_seg(file_nifti,
           file_mask,
           file_image_ss)
  
}
