library(tidyverse)
library(readxl)
library(rvest)
library(sf)

# directory avec toutes les tables xlsx des données du IBGE
setwd("C:/Users/louan/Desktop/sf_datas/brazil")

# indicateurs sociaux au brésil
# https://www.ibge.gov.br/estatisticas/sociais/trabalho/9221-sintese-de-indicadores-sociais.html

# tabela 1.1 (Indic_BR), taux d'activité selon l'âge et le sexe
working.pop <- read_xls("Tabela 1.1 (Indic_BR).xls", skip = 2)

# tabela 1.2 (Indic_Geo), taux d'activité selon la région du pays
work.pop.region <- read_xls("Tabela 1.2 (Indic_Geo).xls", skip = 2)

# tabela 1.3 (IndicSexCor_BR), ta
work.pop.sex.col <- read_xls("Tabela 1.3 (IndicSexCor_BR).xls", skip = 2)






# fichier contenant les municipalités
pib.munic <- read_excel("C:/Users/louan/Desktop/sf_datas/brazil/pib.municipalite.2010-2021.xlsx")

# pour 2021
pib.2021 <- pib.munic %>%
  filter(Ano == "2021")