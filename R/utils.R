get_fold = function(default = 1L) {
  ifold = as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))
  if (all(is.na(ifold))) {
    ifold = default
  }
  ifold
}

read_header = function(x) {
  if (is.vector(x)) {
    x = data.frame(file = x)
  }
  out = copy_dcm_files(x)
  tdir = out$outdir
  file_df = out$file_df
  on.exit({
    unlink(tdir, recursive = TRUE)
  })

  header = try({
    read_dicom_header(file_df$new_file,
                      fail_on_nonzero_exit = TRUE)
  })
  if (is.null(header) || inherits(header, "try-error")) {
    header = try({
      read_dicom_header(file_df$new_file,
                        fail_on_nonzero_exit = TRUE,
                        add_opts = "+E")
    })
  }
  if (is.null(header) || inherits(header, "try-error")) {
    header = try({
      py_dcmread(file_df$new_file)
    })
  }

  if (is.null(header) || inherits(header, "try-error")) {
    msg = "Error reading header"
    message(msg)
    print(msg)
    return(NULL)
  }
  header = header %>%
    rename(new_fname = file) %>%
    mutate(new_fname = basename(new_fname))
  header = header %>%
    left_join(file_df)
  header = header %>%
    select(-any_of(c("new_file", "new_fname")))
  header

}
