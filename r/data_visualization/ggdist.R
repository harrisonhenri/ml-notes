library("tidyverse")
library("tidyquant")
library("ggplot2")
library("ggdist")


mpg %>%
  filter(cyl %in% c(4, 6, 8)) %>%
  ggplot(aes(x = cyl, y = hwy, fill=factor(cyl))) +
  stat_halfeye(
    adjust = 0.5,
    justification = -.2,
    .width = 0, point_colour = NA
  ) +
  geom_boxplot(
    width = .12
  ) +
  stat_dots(
    side = "left",
    justification = 1.1,
    binwidth = 0.25
  ) +
  scale_fill_tq() +
  theme_tq() +
  labs(
    title = "Raincloud Plot",
    x = "Engine",
    y = "MPG",
    fill = "Cylinders"
  ) +
  coord_flip()
