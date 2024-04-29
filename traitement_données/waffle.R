library(waffle)
library(tidyverse)
library(readxl)

pop_age <- read_csv("pop.age.csv")%>%
  select(`Series Name`, `2022 [YR2022]`)

pop_age <- na.omit(pop_age)

colnames(pop_age) <- c("age","valeur")

pop_age$valeur <-  round(pop_age$valeur, digits = 0)

# valeurs et labels des cases
pop_age <- data.frame(
  age = factor(c("Jeune", "En âge de travailler", "Âgée"), levels = c("Jeune", "En âge de travailler", "Âgée")),
  valeur = c(20, 50, 30)
)

p <- ggplot(pop_age) +
  geom_waffle(aes(fill = age, values = valeur), size = 0.5, n_rows = 10, flip = TRUE) +
  scale_fill_manual(values = c("darkblue", "darkgreen", "gold2"),
                    labels = c("Jeune", "En âge de travailler", "Âgée")) +
  theme_void() +
  labs(
    title = "Répartition en pourcentage de la population brésilienne (2022)",
    subtitle = "Jeune, en âge de travailler et âgée (une case = 1%)"
  ) +
  guides(fill = guide_legend(title = NULL))+
  theme(
  plot.title = element_text(hjust = 3.5, size = 15), 
plot.subtitle = element_text(hjust = 2, size = 15),
legend.text = element_text(size = 28),
legend.position = "bottom"
)

p

ggsave("age.pop.png", plot = p, width = 10, height = 8, dpi = 300)

