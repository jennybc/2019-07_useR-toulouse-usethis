library(tidyverse)

get_org_pkgs <- function(org) {
  repos <- gh::gh(
    "GET /orgs/:org/repos",
    org = org,
    type = "public",
    .limit = Inf
  )
  pkgs <- purrr::map_chr(repos, "name")

  valid_pkgs <- grep(
    paste0("^", .standard_regexps()$valid_package_name, "$"),
    pkgs,
    value = TRUE
  )

  tibble(owner = org, package = valid_pkgs)
}

orgs <- c("r-dbi", "rstudio", "tidyverse", "r-lib", "tidymodels")

pkgs <- map_dfr(orgs, get_org_pkgs)

downloads <- pkgs$package %>%
  cranlogs::cran_downloads(when = "last-month") %>%
  group_by(package) %>%
  summarise(downloads = sum(count))

total <- cranlogs::cran_downloads(when = "last-month") %>%
  summarise(sum(count)) %>%
  pull()

## Total of top 100 downloads
top_100_packages <- cranlogs::cran_top_downloads(
  when = "last-month",
  count = 100
)

total_top_100 <- sum(top_100_packages$count)

out <- left_join(pkgs, downloads) %>%
  mutate(
    is_top_100 = package %in% top_100_packages$package,
    overall_percentage = downloads / total,
    top_100_percentage = if_else(is_top_100, downloads / total_top_100, 0)
  )
#> Joining, by = "package"

write_csv(out, here::here("data", "our-monthly-downloads.csv"))

sum(out$overall_percentage)
#> ~36%

sum(out$top_100_percentage)
#> ~57%
