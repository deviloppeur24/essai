library(sf)
library(tidyverse)
library(readxl)
library(fuzzyjoin)


# importation des fichiers
setwd("C:/Users/louan/Desktop/projet_bresil/csv_et_shp")

brazil_sf <- read_sf("Brazil_adm2_uscb_2022.shp")
brazil_pib <- read_excel("pib.municipalite.2010-2021.xlsx")

#garder les colonnes pertinentes et l'année 2021
brazil_pib <- brazil_pib %>%
  filter(Ano == "2021") %>%
  select(`Nome da Unidade da Federação`, `Nome do Município`, `Produto Interno Bruto per capita, \r\na preços correntes\r\n(R$ 1,00)`)

colnames(brazil_pib) <- c("province","municipalite","PIB")

##### tout en lowercase pour fusionner les data frames
brazil_pib$municipalite <- tolower(brazil_pib$municipalite)
brazil_sf$AREA_NAME <- tolower(brazil_sf$AREA_NAME)

#### fusion des data frame
brazil_carte <- stringdist_left_join(brazil_pib, brazil_sf, by = c("municipalite" = "AREA_NAME"),
                                     method = "jaccard", max_dist = 0.3)
### mettre data frame en objet sf
brazil_carte <- st_as_sf(brazil_carte)

### éliminer les décimales
brazil_carte$PIB <- trunc(brazil_carte$PIB)

###
k <- ggplot(data = brazil_carte) +
  geom_sf(aes(fill = log_PIB, geometry = geometry), color = NA) +
  scale_fill_continuous(
    low = "palegreen", high = "darkgreen",
    na.value = "transparent",
    name = "PIB",
    breaks = log10(c(8000, 10000, 15000, 25000, 50000, 100000, 200000, 500000, 900000)),
    labels = c("8000", "10000", "15000", "25000", "50000", "100000", "200000", "500000", "900000")
  ) +
  theme_void() +
  labs(
    title = "Produit intérieur brut de chaque municipalité du Brésil",
    subtitle = "Real brésilien $, (2021)",
    caption = "IGBE"
  ) +
  theme(
    plot.background = element_rect(fill = "transparent", colour = NA),
    panel.background = element_rect(fill = "transparent", colour = NA),
    legend.position = "right"
  )


k


ggsave("brazil.gdp.png", plot = k, bg = "transparent",
       height = 7, width = 16)


