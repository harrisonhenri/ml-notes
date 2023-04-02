library("tidyverse")
library("lvplot")

ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = price, y=..density.., color = cut), binwidth = 500)

diamonds %>% 
  ggplot() +
    geom_lv(aes(x = cut, y = price, alpha = ..LV..), fill = "blue")+
      scale_alpha_discrete(range = c(0.7, 0))

diamonds %>% 
  count(color, cut) %>% 
    ggplot() + 
      geom_tile(mapping = aes(x = cut, y = color, fill = n)) +
        scale_fill_distiller(palette = "RdPu") 

diamonds %>% 
  ggplot() +
    geom_bin2d(aes(x = carat, y = price))

diamonds %>% 
  ggplot() +
    geom_boxplot(aes(x = carat, y = price, group = cut_width(carat, 0.1)), varwidth = TRUE)
