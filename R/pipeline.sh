
Rnosave R/03_plot_nifti.R -J PLOT --mem=8G -o %x_%A.out -e %x_%A.err
Rnosave R/03_get_image_dimensions.R -J DIMS --mem=8G -o %x_%A.out -e %x_%A.err


Rnosave R/03.999_convert_nifti_cluster.R -J SS --array=1-5109 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err

Rnosave R/03.999_convert_nifti_cluster.R -J NIFTI --mem=8G -o %x_%A.out -e %x_%A.err


Rnosave R/04_skull_strip.R -J SS --array=1-130 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err

Rnosave R/04_brainchop_skull_strip.R -J BRAINCHOP --array=1-5 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err

Rnosave R/05_plot_skull_strip.R -J SSPLOT --array=1-5116 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err




Rnosave R/05_template_registration.R -J REG --array=2-5109 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err
Rnosave R/06_plot_registration.R -J PLOTREG --array=6-5109 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err

Rnosave R/06_template_registration.R -J REG --array=4-5116 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err



Rnosave R/volbers_03_plot_nifti.R -J PLOT --array=1-1479 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err
Rnosave R/volbers_04_skull_strip.R -J VSS --array=1-1479 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err
Rnosave R/volbers_05_plot_skull_strip.R -J VPLOT --array=1-1479 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err

Rnosave R/volbers_05_plot_skull_strip.R -J VPLOT --array=1-1479 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err
Rnosave R/volbers_05_template_registration.R -J VREG --array=6-1479 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err

Rnosave R/volbers_05_template_registration.R -J VREG --array=74,79,80,81,82,131,132,133,134,199,200,235,236,237,238,264,265,266,267,270,271,290,291,292,293,298,299,300,301,327,328,351,376,399,400,401,402,423,424,425,428,429,460,461,490,491,492,493,599,1241,1479 --mem=8G -o %x_%A_%a.out -e %x_%A_%a.err


sbatch R/hd_ct_bet.sh
# sbatch R/run_ct_bet.sh
sbatch R/run_ct_bet_cpu.sh
