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


