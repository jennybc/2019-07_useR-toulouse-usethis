#+ eval = FALSE
# call once per session
library(devtools)

# alternative: put this in .Rprofile
if (interactive()) {
  suppressMessages(require(devtools))
}

# call workflow functions directly
create_package()
document()
load_all()

#+ eval = FALSE
# qualify with correct namespace
usethis::create_package()
devtools::document()
pkgload::load_all()
