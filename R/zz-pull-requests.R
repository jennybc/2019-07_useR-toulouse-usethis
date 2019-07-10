library(tidyverse)

downloads <- read_csv(here::here("data", "our-monthly-downloads.csv"))

# crude approximation of our CRAN packages
on_cran <- downloads %>%
  filter(downloads > 0)

get_pull_requests <- function(owner, repo) {
  prs <- gh::gh(
    "GET /repos/:owner/:repo/pulls",
    owner = owner,
    repo = repo,
    state = "all",
    .limit = Inf
  )
  attributes(prs) <- NULL

  if (identical(prs, "")) {
    return(NULL)
  }

  cat(owner, "/", repo, " ", length(prs), " PRs\n", sep = "")

  prs <- tibble(owner = owner, repo = repo, pr = prs) %>%
    hoist(pr,
          title = "title",
          number = "number",
          created_at = "created_at",
          updated_at = "updated_at",
          closed_at = "closed_at",
          merged_at = "merged_at"
    )

  prs %>%
    mutate_at(vars(ends_with("_at")), as.Date)
}

prs <- map2_dfr(on_cran$owner, on_cran$package, get_pull_requests)

in_play <- function(d) d >= as.Date("2018-07-01")

prs_in_play <- prs %>%
  filter(in_play(created_at) | in_play(updated_at) |
           in_play(closed_at) | in_play(merged_at))
nrow(prs_in_play) # 5953
