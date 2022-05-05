# An example for see package
# Git repository
# https://github.com/easystats/see

# install.packages("ggplot")
library("ggplot2")
# install.packages("see")
library("see")
# Sometimes languageserver is needed
# install.packages("languageserver")

ggplot(iris, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_violindot(fill_dots = "black") +
  theme_modern() +
  scale_fill_material_d()

#  plotting halfviolin halfdot plot
cor(iris$Sepal.Length, iris$Sepal.Width)
ceiling(runif(10) * 10)
plot(iris)
