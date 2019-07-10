library(tidyverse)
library(pkgsearch)

downloads <- read_csv(here::here("data", "our-monthly-downloads.csv"))
events <- readRDS(here::here("data", "crandb-events.rds"))

# crude approximation of our CRAN packages
on_cran <- downloads %>%
  filter(downloads > 0)

nrow(on_cran)
#> 182

# crude approximation of our releases in past year-ish
ours <- events %>%
  keep(~ .x$name %in% on_cran$package) %>%
  keep(~ as.Date(.x$date) >= as.Date("2018-07-01"))

ours <- tibble(events = ours) %>%
  unnest_wider(events)

ours %>%
  count(event)
# yeah, all events are "released"

nrow(ours) # 343 CRAN releases

n_distinct(ours$name) # coming from 139 packages (compare to 182)

ours %>%
  group_by(name) %>%
  count(sort = TRUE) # %>% print(n = Inf)

length(ours) # 343 releases

