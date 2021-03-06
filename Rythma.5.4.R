## Rythmanalyse 5.4
## Nouveautes
## Parametre au niveau de rythmanalyse pour activer ou non les sorties graphiques

rm(list=ls()) # on vide la memoire de RStudio
setwd("~/Documents/Projets R/RnGameDataExploitation-modularite") #choix du dossier ou se trouve le script Rythma

# Installation (si besoin) et chargement des packages requis
packages <- c("ggplot2", "gridExtra","RColorBrewer","treemapify","dplyr","data.table")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
#chargement auto de tout les packages (evite q'un package manque a l'appel)
for(package in packages){
  library(package,character.only = T,warn.conflicts = F)
}

source("RScripts/RythmaFUNZIP5.5.R") #charge la fonction d'analyse

## ANALYSE INDIVIDUELLE
## lancer Rythmanalyse ("nomdefichier", debut = 0, fin ="max"), 
## "nomdefichier" est du type "2014.02.16.MT.Doom.s1.zip"
## debut = valeur (en minutes) ou debuter l'analyse
## fin = valeur (en minutes) ou achever l'analyse
## graph = TRUE ou FALSE pour dessiner les sorties graphiques
## par defaut debut est a 0, fin a "max", graph a TRUE

## ex. Rythmanalyse ("2016.03.29.MT.Shardlight.s2.zip") avec valeurs par defaut
## ex. Rythmanalyse ("2016.03.24.MT.Sylvio.s1.zip", debut = 5, fin =60, graph = FALSE)

## Pour chaque fichier la fonction enregistre 
## (1) les resultats dans un .ok.csv
## (2) une analyse graphique minimale des appuis clavier et souris / pad

## POUR UN TRAITEMENT MASSE
## Placer dans le repertoire de travail les .zip

session <- list.files (path = "Data", pattern = ".zip") # Recuperer liste des fichiers .zip dans le repertoire de travail

resultats <- lapply(session, Rythmanalyse, debut = 0, fin = "max", graph = TRUE) # On applique la fonction d'analyse
resultats <- do.call("rbind",resultats) # On aggrege les resultats
write.csv(resultats, file="AddData.csv") #Choisir le nom du fichier de sortie
