library(tidyverse)
library(wisconsink12)

# CFC Hight-Quality School Metric,
# based on equal achievement and growth weights
cfc_rated <- read_rds("../report_cards_2024_25/data/cfc_scored.rda")

# Wisconsin School Report Cards
rc <- make_wi_rc(exclude_milwaukee = FALSE)

rc <- rc |>
    select(
        school_year,
        dpi_true_id,
        school_name,
        accurate_agency_type,
        overall_score,
        overall_rating,
        school_enrollment,
        sch_ach,
        sch_growth,
        sch_cg,
        sch_tgo,
        sch_ot
    )

# CFC's Similar Schools Metric, based on regression model output
ssm <- read_rds("../similar_schools_metric/data/wi_ssm_ratings_2024_25.rda")

ssm <- ssm |>
    select(
        school_year,
        dpi_true_id,
        cfc_ssm_score = ssm_score,
        cfc_ssm_rating = ssm_rating
    )

all <- rc |>
    left_join(cfc_rated) |>
    left_join(ssm) |>
    left_join(
        schools |>
            select(
                school_year,
                dpi_true_id,
                cfc_milwaukee_indicator = milwaukee_indicator
            )
    )

write_csv(all, "data/school_metrics_by_year.csv")
