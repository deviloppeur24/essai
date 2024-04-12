library(tidyverse)
library(sf)
library(readxl)

setwd("C:/Users/louan/Desktop/projet_brésil/csv_et_shp")
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

# traduire les valeurs en francais
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

# isoler les taux de sous-utilisation selon l'indicateurs
tx.sousutil <- sub.util %>%
  filter(indices == "tx_sousutilisation")

# facteur
tx.sousutil$valeur <- as.numeric(tx.sousutil$valeur)

# illustration du taux de sous-utilisation selon chaque caracteristique
ggplot(tx.sousutil, aes(x = caract, y = valeur)) +
  geom_bar(stat = "identity") +
  coord_flip()
