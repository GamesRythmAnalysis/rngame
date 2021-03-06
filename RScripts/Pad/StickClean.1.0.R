
stick.clean <- function(stickData){
  if (nrow(stickData) < 10){
    return(stickXY <- data.table (P.TEMPS=numeric(), X =numeric(), 
                                  Y = numeric()))
  }
  
  # recreer les coordonnees x/y a chaque temps
  # de une colone qui contient les chagment x et Y on cree 2 colone des valeur x et y
  condition <- grepl ("y",stickData$P.TOUCHE,ignore.case =TRUE)
  Y <- ifelse (condition,stickData$P.VALEUR,NA)
  X <- ifelse (!condition,stickData$P.VALEUR,NA)
  
  Y <- c (0,Y)
  X <- c (0,X)
  condition <- is.na (Y)
  for (i in 2:length(Y)){
    if (condition[i]){
      Y[i] <- Y[i-1]
    } else {
      X[i] <- X[i-1]
    }
  }
  
  stickXY <- data.table (P.TEMPS=stickData$P.TEMPS, X = X[-1], 
                         Y = Y[-1])
  
  # on utilise unique car on as des ligne qui se duplique lors du processus (environs 1% de ligne dupliqu�)
  return(stickXY)
}
