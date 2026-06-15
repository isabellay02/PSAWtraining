# Quick validation: do the CSVs load, and does the PBR math reproduce?
ss <- read.csv("data/stock_summary.csv", stringsAsFactors = FALSE)

# Recompute n_min and PBR from the GAMMS formulas (single source of truth check)
nmin_calc <- ss$n_best / exp(0.842 * sqrt(log(1 + ss$cv_n^2)))
pbr_calc  <- nmin_calc * 0.5 * ss$r_max * ss$f_r

chk <- data.frame(
  stock               = ss$stock_name,
  n_min_file          = ss$n_min,
  n_min_calc          = round(nmin_calc),
  pbr_file            = ss$pbr,
  pbr_calc            = round(pbr_calc, 1),
  msi                 = ss$annual_msi_total,
  strategic_should_be = ifelse(ss$annual_msi_total > pbr_calc, "strategic", "not strategic"),
  strategic_file      = ss$strategic_status
)
print(chk)

cat("\nData dictionary rows:", nrow(read.csv("data/data_dictionary.csv")), "\n")
cat("Fisheries rows:",        nrow(read.csv("data/fisheries_msi.csv")), "\n")
