
pad.bouton.analyse<- function(boutData) {
  # Recodage avec les noms appropries
  
  
  key <- c("Bouton 0"="A","Bouton 1"="B","Bouton 2"="X","Bouton 3"="Y","Bouton 4"="LB","Bouton 5"="RB","Bouton 6"="Select","Bouton 7"="Start","Bouton 8"="StickG","Bouton 9"="StickD")
  boutData$P.TOUCHE <- as.factor(key[boutData$P.TOUCHE])
  
  # Traitement des boutton analogue a ceux du clavier
  # Comme on veut pouvoir agrerger les resultat avec ceux des gachettes on doit se basser sur les donn?e nettoyer
  # normalement pas de problemme car les donnee pad sont stable 
  # pour obtenir les donn?e entre appuis il faudras trier le data frame sur P.TEMPS avant le calcul une fois l'agr?gation finie
  
  results <- lapply (levels (boutData$P.TOUCHE), bouton.rythm,boutData = boutData)
  results <- do.call ("rbind", results)
  
  return(results)
}
