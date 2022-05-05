# remote working environment: r-studio-01
cat("test")
cat(system("hostname", T))
# install.packages("ggforce")
library(ggplot2)
library(ggforce)
# install.packages("rlang")
# library("rlang")
# R#> Loading required package: ggplot2
ggplot(iris, aes(Petal.Length, Petal.Width, colour = Species)) +
  geom_point() +
  facet_zoom(x = Species == "versicolor")

# install.packages("pak")
cat("test")
library(devtools)
devtools::install_github("r-lib/rlang")
plot(iris)
Sys.setlocale("LC_ALL", "English")
