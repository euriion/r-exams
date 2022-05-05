library(tidyverse)
library(rvest)
library(extrafont)
loadfonts()
# devtools::install_github("torvaney/ggsoccer")
library(ggsoccer)
library(tweenr)
library(gganimate)
library(ggimage)
library(gifski)

first_ball_df <- tribble(~x,      ~y,  ~time,
                         0,      100,   1,
                         6.78, 67.94,   2,
                         7.5,  56.84,   3,
                         4.64, 38.94,   4,
                         -0.8,	47,   5)

first_player_df <- tribble(~x, ~y, ~name,
                           0,    100,   "손흥민",
                           9.78, 67.94, "이승우",
                           9.5,  56.84, "윤영선",
                           7.64, 38.94, "김영권")

first_goal_ani <- first_ball_df %>%
  ggplot() +
  annotate_pitch() +
  theme_pitch() +
  coord_flip() +
  xlim(-10, 51) +
  ylim(-15, 101) +
  labs(title="한국과 독일 월드컵 예선",
       subtitle="김영권 첫번째골(90+2)") +
  geom_label(data = first_player_df, aes(x = x, y = y, label = name), family = "NanumGothic") +
  theme(legend.position = "none",
        text = element_text(family = "NanumGothic")) +
  ggimage::geom_emoji(
    aes(x = x,
        y = y),
    image = "26bd", size = 0.035) +
  transition_states(
    time,
    transition_length = 0.5,
    state_length = 0.0001,
    wrap = FALSE) +
  ease_aes("linear")

animate(first_goal_ani, nframes = 24, renderer = gifski_renderer("first_goal.gif"))
