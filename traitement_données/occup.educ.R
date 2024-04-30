library(tidyverse)
library(readxl)


setwd("C:/Users/louan/Desktop/projet_bresil/csv_et_shp")

# Tabela 1.18, instruction de la population (geo)
instr_geo <- read_excel("Tabela 1.18 (Instr_Geo).xls", skip = 4)%>%
  select(-2)

# supprimer les rangées NA
instr_geo <- na.omit(instr_geo)

# nommer les colonnes en francais
colnames(instr_geo) <- c("région","Sans instr. ou prim. incomplet",
                         "Prim. complet ou sec. incomplet",
                         "Sec. complet ou sup. incomplet",
                         "Sup. complet"
)


# garder les cinq régions pour le graphique stacked bar plot
instr_geo <- instr_geo %>%
  filter(région %in% c("Norte","Nordeste","Sul","Sudeste","Centro-Oeste"))

# regrouper les valeurs 
instr_geo <- instr_geo %>%
  pivot_longer(
    cols = c("Sans instr. ou prim. incomplet",
    "Prim. complet ou sec. incomplet",
    "Sec. complet ou sup. incomplet",
    "Sup. complet"),  
    names_to = "Éducation",  
    values_to = "Valeur"  
  )


########
p <- ggplot(data = instr_geo, aes(x = région, y = Valeur, fill = Éducation))+
  geom_bar(stat = "identity", position = "stack")+
  labs(
    title = "Répartition du niveau d'instruction chez les personnes au chômage",
    subtitle = "Selon la région (2022)",
    y = "Pourcentage"
  )+
  theme_gray()+
  scale_fill_manual(values = c("Sans instr. ou prim. incomplet" = "#235F90",
                       "Prim. complet ou sec. incomplet" = "#00365B",
                       "Sec. complet ou sup. incomplet" = "#4B8643",
                       "Sup. complet" = "#013C00"))+
  theme_minimal()+
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),  
    plot.subtitle = element_text(hjust = 0.5, size = 14), 
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10), 
    legend.title = element_text(face = "bold", size = 12),
    legend.position = "right",
    text = element_text(size = 10),
    plot.background = element_rect(fill = "transparent", colour = NA),
    panel.background = element_rect(fill = "transparent", colour = NA)
  )

p

ggsave("instr.png", plot = p, width = 10, height = 8, dpi = 300)

