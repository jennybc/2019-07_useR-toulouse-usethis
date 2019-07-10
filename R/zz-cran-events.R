library(pkgsearch)

n <- 20000 # pretty arbitrary, need at least a year's worth of data
events <- cran_events(limit = n, releases = TRUE, archivals = FALSE)

events[[n]]$date # 2017-12-02

saveRDS(events, here::here("data", "crandb-events.rds"))

