library(tidyverse)
library(sf)
library(readxl)

setwd("C:/Users/louan/Desktop/projet_bresil/csv_et_shp")

# sous utilisation dans tous le pays
sub.util <- read_excel("Tabela 1.39 (CompSubutil_BR).xls")
# tabela 1.40 ; sous utilisation de la main d'oeuvre (col2 = total)
sub.util.reg <- read_excel("Tabela 1.40 (Subutil_Geo).xls")

# traduire les noms de colonnes en francais
colnames(sub.util) <- c("caract","population","tx_sousutilisation",
                        "heure","innocupé","potentiel")

# sélectionner les indicateurs pertinents seulement
sub.util <- sub.util %>%
  filter(caract %in% c("Brasil",
                      "Homens","Mulheres","14 a 29 anos",
                      "30 a 49 anos","50 a 59 anos", "60 anos ou mais",
                      "Sem instrução ou Ensino Fundamental incompleto",
                      "Ensino Fundamental completo ou Ensino Médio incompleto",
                      "Ensino Médio completo ou Ensino Superior Incompleto",
                      "Ensino Superior completo"))

infos.sub <- colnames(sub.util[,2:6])

# réorganiser le data frame avec pivot_longer pour produire des graphiques
# selon l'information qu'on veut

sub.util <- sub.util %>%
  pivot_longer(cols = infos.sub, names_to = "indices", values_to = "valeur")%>%
  mutate(indicateur = case_when(
  caract %in% c("14 a 29 anos", "30 a 49 anos", "50 a 59 anos", "60 anos ou mais") ~ "age",
  caract %in% c("Homens","Mulheres") ~ "sexe",
  caract %in% c("Sem instrução ou Ensino Fundamental incompleto",
                "Ensino Fundamental completo ou Ensino Médio incompleto",
                "Ensino Médio completo ou Ensino Superior Incompleto",
                "Ensino Superior completo") ~ "education",
  caract %in% "Brasil" ~ "national"))%>%
  select(indicateur, everything())

# traduire les valeurs en français
sub.util <- sub.util %>%
  mutate(caract = case_when(
    caract == "14 a 29 anos" ~ "14 à 29 ans",
    caract == "30 a 49 anos" ~ "30 à 49 ans",
    caract == "50 a 59 anos" ~ "50 à 59 ans",
    caract == "60 anos ou mais" ~ "60 ans ou plus",
    caract == "Homens" ~ "homme",
    caract == "Mulheres" ~ "femme",
    caract == "Sem instrução ou Ensino Fundamental incompleto" ~ "Sans instruction|Prim. incomplet",
    caract == "Ensino Fundamental completo ou Ensino Médio incompleto" ~ "Prim. complet|Sec. incomplet",
    caract == "Ensino Médio completo ou Ensino Superior Incompleto" ~ "Sec. complet|Ens. sup. incomplet",
    caract == "Ensino Superior completo" ~ "Ens. sup. complet",
    caract == "Brasil" ~ "Brésil",
    TRUE ~ caract
  )) %>%
  select(indicateur, everything())

# valeurs en numerique
sub.util$valeur <- as.numeric(sub.util$valeur)

# isoler les taux de sous-utilisation selon l'indicateurs
tx.sousutil <- sub.util %>%
  filter(indices == "tx_sousutilisation")



# illustration du taux de sous-utilisation selon chaque caracteristique
ggplot(tx.sousutil, aes(x = caract, y = valeur)) +
  geom_bar(stat = "identity") +
  coord_flip()+
  labs(
    title = "Proportion de la population dont la force de travail est sous-utilisée",
    subtitle = "Selon plusieurs caractéristiques (2022)",
    caption = "Institut de la Géographie et de la Statistique du Brésil (IGBE)",
    y = "Pourcentage",
    x = "Indicateurs"
     )+
  theme(plot.subtitle = element_text(hjust = 0.5, face = "italic"))

# créer un diverging bar
valeur_bresil <- tx.sousutil %>% 
  filter(caract == 'Brésil') %>% 
  pull(valeur)

tx.sousutil <- tx.sousutil %>%
  mutate(ecart = valeur - valeur_bresil)

tx.sousutil <- tx.sousutil %>%
  filter(caract != 'Brésil')

m <- ggplot(tx.sousutil, aes(x=reorder(caract, ecart), y=ecart))+
  geom_bar(stat='identity', fill='darkblue')+ 
  coord_flip()+ 
  labs(
    title = 'Sous-utilisation de la force de travail selon certains indicateurs',
    subtitle = 'Écart par rapport à la moyenne nationale (20.9%), Brésil, 2022',
    x = 'Indicateur',
    y = 'Écart en pourcentage',
    caption = 'Source : Institut de la Géographie et de la Statistique du Brésil'
  )+
  theme_minimal()+
  theme(legend.position = 'none',
        plot.subtitle = element_text(face = "italic", hjust = 0.5),
        plot.title = element_text(hjust = 0.5),
        plot.background = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
  )

m

ggsave("divergingbar.png", plot = m, bg = "transparent",
       height = 7, width = 16)

###################################
# observer les variations dans les groupes d'âge
# de sous utilisation du travail
# https://www.dmtemdebate.com.br/a-elevada-taxa-de-subutilizacao-da-forca-de-trabalho-no-brasil/
# pour comprendre la sous utilisation du travail au Brésil
sub.util.age <- sub.util %>%
  filter(indicateur == "age" & indices %in% c("innocupé", "heure", "potentiel"))

head(sub.util.age)

ggplot(sub.util.age, aes(x = "", y = valeur, fill = indices)) +
  geom_bar(stat = "identity", width = 1) +
  facet_wrap(~ caract, scales = "free") +  
  coord_polar("y", start = 0) +  
  theme_void() +  
  theme(legend.position = "right") + 
  labs(fill = "Indices",
       title = "Type de sous-utilisation de la force de travail au Brésil",
       subtitle = "par tranche d'âge (2022)")

