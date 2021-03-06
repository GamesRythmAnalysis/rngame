gachette.rythm <- function(gachData){
  posHaut <- grep ("Haut", gachData$P.UPDOWN)
  
  # Les mouvement sont down - haut - down car haut => pression de la gachette maximal
  
  l <- length(posHaut)
  
  down.time <- gachData$P.TEMPS[posHaut -1]
  
  durApp <- gachData$P.TEMPS[posHaut +1] - gachData$P.TEMPS[posHaut -1]
  
  #les vitesse sont en %/s % de pression par seconde 
  # ex: v = 0.86 => en une seconde on est passer de 0% de la pression max sur la gachette a 86%
  
  vit.pression <- (gachData$P.VALEUR[posHaut] - gachData$P.VALEUR[posHaut - 1])/durApp
  vit.relache <- (gachData$P.VALEUR[posHaut] - gachData$P.VALEUR[posHaut + 1])/durApp
  
  gachRythm <- data.table(down.time = down.time,durApp = durApp,vit.pression = vit.pression, vit.relache = vit.relache)
  
  return(gachRythm)
  
}