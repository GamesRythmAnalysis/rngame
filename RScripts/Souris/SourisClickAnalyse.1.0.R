
#==#==#==#==#

# Fonction souris.click.analyse : analyse les données des click souris

# Return : une list avec :
# - resultats :les resultat obtenus des différents calcul sous la forme d'un data frame
# - clickRythm : un data frame du meme format que ceux renvoyes par click.rythm
# - scrollData : un subset de data ne contenant que les valeur lier aux scroll

#==#==#==#==#

souris.click.analyse <- function(data) {
  # Nettoyage des donnees on obtien une ligne par click
  # la duree des clicks et quand il on ete effectue

  leftClickRythm <- click.rythm("mouse 1",data)
  RightClickRythm <- click.rythm("mouse 2",data)
  middleClickRythm <- click.rythm("mouse 3",data)
  
  clickRythm <- rbind(leftClickRythm, 
                      RightClickRythm, 
                      middleClickRythm)
  
  # Recuperation des donnees des mouvement de mollette
  scrollData <- filter (data,
                        M.EVENEMENT %in% c ("mouse scroll down", "mouse scroll up"))
  
  clickDown <- filter (data, M.EVENEMENT %in% c ("mouse 1 down","mouse 2 down","mouse 3 down") )
  
  ## Retraiment des différents input
  
  # Nombre de click
  M.NbClics <- nrow(clickDown)
  
  # Pourcentage clic gauche
  M.LR <- length (leftClickRythm$down.time) /
    length (clickRythm$down.time) * 100
  
  # Pourcentage scroll
  M.Scroll <- nrow (scrollData) / 
    (M.NbClics + nrow (scrollData)) * 100
  
  # Duree secondes, minutes activite souris
  M.DuS <- max (data$M.TEMPS, na.rm= TRUE) - min (data$M.TEMPS, na.rm= TRUE)
  M.DuM <- M.DuS / 60
  
  # Nombre clics par seconde
  M.NbCliclsS <- M.NbClics / M.DuS
  
  # Temps entre deux clics et ecart-type
  tempsEntreAppuis <- clickDown$M.TEMPS[-1] -
    clickDown$M.TEMPS[-M.NbClics]
  
  M.TpMoyEntreAppuis <- mean (tempsEntreAppuis)
  M.TpSDEntreAppuis <- sd (tempsEntreAppuis)
  
  # Duree reel d'activite des clicks
  M.TpsClickR <- sum(RightClickRythm$duration, na.rm = TRUE)
  M.TpsClickL <- sum(leftClickRythm$duration, na.rm = TRUE)
  M.TpsClickM <- sum(middleClickRythm$duration, na.rm = TRUE)
  
  M.TpsTotClick <- M.TpsClickL + M.TpsClickR + M.TpsClickM
  
  ## Duree moyenne et ecart type
  
  # click gauche
  M.MoyTpsClickL <- mean(leftClickRythm$duration, na.rm = TRUE)
  M.SDTpsClickL <- sd(leftClickRythm$duration, na.rm = TRUE)
  
  # Click droit
  M.MoyTpsClickR <- mean(RightClickRythm$duration, na.rm = TRUE)
  M.SDTpsClickR <- sd(RightClickRythm$duration, na.rm = TRUE)
  
  # Click molette
  M.MoyTpsClickM <- mean(middleClickRythm$duration, na.rm = TRUE)
  M.SDTpsClickM <- sd(middleClickRythm$duration, na.rm = TRUE)
  
  #M.DuM # Duree activite souris en minutes
  #M.NbClics # Nombre total d'appuis
  #M.NbCliclsS # Clics par seconde
  #M.TpsClickR #Temps cumuler a faire click droit
  #M.TpsClickL #Temps cumuler a faire click gauche
  #M.TpsClickM #Temps cumuler a faire click molette
  #M.TpsTotClick #Temps Cumuler a clicker
  #M.MoyTpsClickR #Temps moyen d'un click droit
  #M.SDTpsClickR #Ecart type du temps d'un click droit
  #M.MoyTpsClickL #Temps moyen d'un click gauche
  #M.SDTpsClickL #Ecart type du temps d'un click gauche
  #M.MoyTpsClickM #Temps moyen d'un click molette
  #M.SDTpsClickM #Ecart type du temps d'un click molette
  #M.LR # Pourcentage de clics gauche
  #M.TpMoyEntreAppuis # Temps moyen entre deux appuis
  #M.TpSDEntreAppuis # Ecart type entre deux appuis
  
  resultats <- data.table(
    M.DuM,
    M.NbClics,
    M.NbCliclsS,
    M.TpsClickR,
    M.TpsClickL,
    M.TpsClickM,
    M.TpsTotClick,
    M.MoyTpsClickR,
    M.SDTpsClickR,
    M.MoyTpsClickL,
    M.SDTpsClickL,
    M.MoyTpsClickM,
    M.SDTpsClickM,
    M.LR,
    M.Scroll,
    M.TpMoyEntreAppuis,
    M.TpSDEntreAppuis
  )
  
  return (list(resultats, clickRythm, scrollData))
}
