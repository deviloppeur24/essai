library(tidyverse)
library(readxl)
library(rvest)
library(sf)

######## fichier pour observation de toutes les données de travail dispo'


# directory avec toutes les tables xlsx des données du IBGE
setwd("C:/Users/louan/Desktop/projet_brésil/csv_et_shp")

# indicateurs sociaux au brésil
# https://www.ibge.gov.br/estatisticas/sociais/trabalho/9221-sintese-de-indicadores-sociais.html

# tabela 1.1 (Indic_BR), taux d'activité selon l'âge et le sexe
working.pop <- read_xls("Tabela 1.1 (Indic_BR).xls", skip = 2)

# tabela 1.2 (Indic_Geo), taux d'activité selon la région du pays
work.pop.region <- read_xls("Tabela 1.2 (Indic_Geo).xls", skip = 2)

# tabela 1.3 (IndicSexCor_BR), ta
work.pop.sex.col <- read_xls("Tabela 1.3 (IndicSexCor_BR).xls", skip = 2)

# tabela 1.3 (IndicSexCor_BR), ta
work.pop.sex.col <- read_xls("Tabela 1.3 (IndicSexCor_BR).xls", skip = 2)

# tabela 1.4 ; rendecement moyen par mois & par heure, sexe/race
work.revenu <- read_xls("Tabela 1.4 (Indic_BR_Rend).xls", skip = 2)

# tabela 1.5 ; revenu moyen selon region
revenu.region <- read_excel("Tabela 1.5 (Indic_Geo_Rend).xls")

# tabela 1.6 ; 
indicsexcor <- read_excel("Tabela 1.6 (IndicSexCor_BR_Rend).xls")

# tabela 1.7 ; secteur d'emploi, homme/femme/total
# nb absolu et proportions
ativcaract <- read_excel("Tabela 1.7 (AtivCaract_BR).xls")

# tabela 1.8
ativpos <- read_excel("Tabela 1.8 (AtivPos_BR).xls")

# tabela 1.10
# "carteira de trabalho" : document de preuve d'emploi (accès à la sécurité)
# https://en.wikipedia.org/wiki/Employment_record_book
pos_br <- read_excel("Tabela 1.10 (Pos_BR).xls")

# tabela 1.12 :  
pos_geo <- read_excel("Tabela 1.12 (Pos_Geo).xls")

# tabela 1.14
ocupcaract <- read_excel("Tabela 1.14 (OcupCaract_Geo).xls")

# tabela 1.15 ; distribution du niveau d'instruction (sexe)
instructCaract <- read_excel("Tabela 1.16 (InstrCaract).xls")

# tabela.1.8
instr_geo <- read_excel("Tabela 1.18 (Instr_Geo).xls")

# tabela 1.22
cargos.geo <- read_excel("Tabela 1.22 (Cargos_Geo).xls")

# tabela 1.23
formalcar <- read_excel("Tabela 1.23 (FormalCaract_Geo).xls")

# sous utilisation dans tous le pays
sub.util <- read_excel("Tabela 1.39 (CompSubutil_BR).xls")

# tabela 1.40 ; sous utilisation de la main d'oeuvre (col2 = total)
sub.util.reg <- read_excel("Tabela 1.40 (Subutil_Geo).xls")



# pib par municipalité du pays, pour produire carte sf
pib.munic <- read_excel("pib.municipalite.2010-2021.xlsx")

# pour 2021
pib.2021 <- pib.munic %>%
  filter(Ano == "2021")

