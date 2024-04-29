library(tidyverse)
library(readxl)


setwd("C:/Users/louan/Desktop/projet_bresil/csv_et_shp")

# Tabela 1.18, instruction de la population (geo)
instr_geo <- read_excel("Tabela 1.18 (Instr_Geo).xls", skip = 4)%>%
  select(-2)

# Tabela 1.25, desocup (geo)
chomage <- read_excel("Tabela 1.25 (desoc_geo).xls", skip=4)%>%
  select(...1,`14 a 29 anos`,`30 a 49 anos`,`50 anos ou mais`)


# supprimer les rangées NA
instr_geo <- na.omit(instr_geo)
chomage <- na.omit(chomage)

# nommer les colonnes en francais
colnames(instr_geo) <- c("province et régions","Sans instruction ou primaire incomplet",
                         "Primaire complet ou secondaire incomplet",
                         "Secondaire complet ou supérieur incomplet",
                         "Supérieur complet"
)

colnames(chomage) <- c("province","14-29 ans","30-49 ans","50 ans et plus")

# le df d'interet (chomage) possede trop de lignes, on veut garder uniquement
# les noms de régions et de provinces 
provinces <- instr_geo %>%
  filter(!`province et régions` == "Brasil")

# mettre dans un objet les noms de provinces uniquement pour les retrouver dans chomage
noms_dinteret <- unique(provinces$`province et régions`)

# filtrer le df chomage (exclure les villes)
chomage <- chomage %>%
  filter(province %in% noms_dinteret)

# enlever les villes de Rio de Janeiro et de Sao Paulo qui sont encore présentes
# (seulement garder les provinces du même nom)
chomage <- chomage[-c(23, 25), ]


# mutate une colonne qui indique à QUELLE région appartiennent chaque province
# possible de reprendre le vecteur "noms_dinteret" pour les classifier
#chomage <- chomage %>%
#  mutate(région = case_when(
#    province %in% c("Acre", "Amapá", "Amazonas", "Pará", "Rondônia", "Roraima", "Tocantins") ~ "Norte",
#    province %in% c("Alagoas", "Bahia", "Ceará", "Maranhão", "Paraíba", "Pernambuco", "Piauí", "Rio Grande do Norte", "Sergipe") ~ "Nordeste",
#    province %in% c("Espírito Santo", "Minas Gerais", "Rio de Janeiro", "São Paulo") ~ "Sudeste",
#    province %in% c("Goiás", "Mato Grosso", "Mato Grosso do Sul", "Distrito Federal") ~ "Centro-Oeste",
#    province %in% c("Paraná", "Santa Catarina", "Rio Grande do Sul") ~ "Sul"
#  ))
# maintenant que les provinces sont identifiée par leur région,
# supprimer les noms de région de la colonne province
chomage <- chomage %>%
  filter(!province %in% c("Norte","Nordeste","Sudeste","Centro-Oeste","Sul"))

# faire pivoter les données pour les illustrer avec ggplot
chomage <- chomage %>%
  pivot_longer(
    cols = c(`14-29 ans`, `30-49 ans`, `50 ans et plus`),  
    names_to = "Âge",  
    values_to = "Valeur"  
  )



#####

# créer des espaces blancs pour pouvoir modifier le graphique avec inkscape
spacing <- data.frame(province = paste("Spacer", 1:2), Âge = "14-29 ans", Valeur = 0)
chomage <- rbind(spacing, chomage)

# ggplot du graphique circulaire à barres
p <- ggplot(chomage, aes(x = province, y = Valeur, fill = Âge)) +
 geom_bar(stat = "identity", position = "stack", width = 1) +
   coord_polar(start = 0) +
 scale_fill_manual(values = c("14-29 ans" = "#106227", "30-49 ans" = "darkblue", "50 ans et plus" = "gold2")) +
   labs(title = "Pourcentage de la population brésilienne au chômage",
               subtitle = "selon l'âge et la province (2022)",
               x = NULL, y = NULL,
              fill = "Groupe d'âge") +
  theme_bw() +
   theme(
       plot.background = element_rect(fill = "transparent", colour = NA), 
        panel.background = element_rect(fill = "transparent", colour = NA),
        legend.background = element_rect(fill = "transparent", colour = NA), 
        plot.title = element_text(hjust = 0.5, margin = margin(b = 10, unit = "pt")), 
        plot.subtitle = element_text(hjust = 0.5, face = "italic", margin = margin(t = 0, unit = "pt")), 
        legend.position = "bottom",
      plot.margin = margin(0.3, 1, 0.5, 0.5, unit = "cm"),
      axis.text.x = element_text(size = 5)
     )

p

ggsave("provinces.png", plot = p, bg = "transparent", width = 10, height = 8, units = "in")

###################################

# le même graphique en format non circulaire ... 
ggplot(chomage, aes(x = province, y = Valeur, fill = Âge)) +
     geom_bar(stat = "identity", position = "stack", width = 1) +
     labs(title = "Population par groupe d'âge et province", x = NULL, y = NULL, fill = "Groupe d'âge") +
     theme_void()+
     theme(legend.position = "bottom",
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size = 9))





