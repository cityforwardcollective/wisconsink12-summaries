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
        wi_overall_score = overall_score,
        wi_overall_rating = overall_rating,
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
        ssm_score,
        ssm_rating
    )

rc |>
    left_join(cfc_rated) |>
    left_join(ssm) |>
    left_join(
        schools |>
            select(school_year, dpi_true_id, milwaukee_indicator)
    )
