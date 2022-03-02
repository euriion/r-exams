# remote working environment: r-studio-01
cat("test")
cat(system("hostname", T))
# install.packages("ggforce")
library(ggforce)
#> Loading required package: ggplot2
ggplot(iris, aes(Petal.Length, Petal.Width, colour = Species)) +
  geom_point() +
  facet_zoom(x = Species == "versicolor")
