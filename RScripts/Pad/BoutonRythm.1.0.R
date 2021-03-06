bouton.rythm <- function (key,boutData)  {
  
  keyData <- subset (boutData, boutData$P.TOUCHE == key)
  
  keyDown <- subset(keyData, keyData$P.VALEUR == 1)
  keyUp <- subset(keyData, keyData$P.VALEUR == 0)
  
  diff <- nrow(keyUp) - nrow(keyDown)
  
  # on rrenvoie une erreur si les donn�e demande un process comme key.rythm 
  if (diff > 1 | diff < -1){stop( paste("Data are too damaged for actual process : diff = ", diff,"with key : ", key ,sep = ""))}
  
  # on suppose qu'il n'y as pas plus de 1 de diff�rence 
  #(on s'est servis du pad pour couper l'enregistrement, on as pas tronqu� au bonne endroit)
  if(diff > 0){
    
    #trop de up on regarde soit l'erreur est au d�but soit a la fin soit on renvoie une erreur
    if(keyData$P.VALEUR[1] == 0){
      keyUp <- keyUp[-1,]
    } else {
      
      #avoir un 0 a la fin n'est un soucis que si on en as 2
      if(keyData$P.VALEUR[nrow(keyData)] == 0 & keyData$P.VALEUR[nrow(keyData)-1] == 0 ){ 
        keyUp <- keyUp[-nrow(keyUp),]
      } else{
        stop(paste("Data are too damaged for actual process with key : ", key ,sep = "")) 
      }
    }
    
  } 
  
  if(diff < 0) {
    
    #trop de down on regarde soit l'erreur est au d�but soit a la fin soit on renvoie une erreur
    if(keyData$P.VALEUR[nrow(keyData)] == 1){
      keyDown <- keyDown[-nrow(keyDown),]
    } else {
      # avoir un up au d�but n'est un probleme que si on en as deux conc�cutif
      if(keyData$P.VALEUR[1] == 1 & keyData$P.VALEUR[2] == 1 ){ 
        keyDown <- keyDown[-1,]
      } else{
        stop(paste("Data are too damaged for actual process with key : ", key ,sep = "")) 
      }
    }
  }
  
  
  if (length(keyDown$P.TEMPS) == 0){
    resultat <- data.table(bouton = factor(),down.time=numeric() ,durApp= numeric())
  }else{
    resultat <- data.table(bouton = factor(key),down.time=keyDown$P.TEMPS ,durApp= keyUp$P.TEMPS - keyDown$P.TEMPS)
  }
  
  
  return(resultat)
  
}
