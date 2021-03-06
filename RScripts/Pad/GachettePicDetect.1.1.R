# GACHETTES
# fonction pour detection des pics appuis et relaches

gachette.pic.detect <- function (gachData) {
  
  l <- nrow (gachData)
  
  testDup <- c(FALSE,
          (gachData$P.VALEUR[c(-1,-l)] == gachData$P.VALEUR[c(-l,-l+1)]) & (gachData$P.VALEUR[c(-1,-l)] == gachData$P.VALEUR[c(-1:-2)]),
          FALSE)
  
  gachData <- gachData[!testDup,]
  
  
  l <- nrow (gachData)
  
  ## on d�tecte les maximum et minimum locaux, un maximum correspond a la fin de la pression sur la gachette 
  # un minimum soit a un d�but de pression soit a une fin de relachement
  
  # d�placement du test
  # (gachData$P.VALEUR[i] > gachData$P.VALEUR[i-1]) & (gachData$P.VALEUR[i] > gachData$P.VALEUR[i+1])
  # a l'ext�rieure de la boucle c'est moins intuitif mais plus rapide et utile pour la suite du code
  testHaut <- c(FALSE,
                (gachData$P.VALEUR[c(-1,-l)] > gachData$P.VALEUR[c(-l,-l+1)]) & (gachData$P.VALEUR[c(-1,-l)] >= gachData$P.VALEUR[c(-1:-2)]),
                FALSE)
  
  testBas <- c(TRUE,
               (gachData$P.VALEUR[c(-1,-l)] < gachData$P.VALEUR[c(-l,-l+1)]) & (gachData$P.VALEUR[c(-1,-l)] <= gachData$P.VALEUR[c(-1:-2)]),
               TRUE)
  
  testHB <- testBas | testHaut
  
  # Nettoyage des Haut excessif
  
  poshaut <- which(testHaut[testHB])
  dumbH <- which(testHaut[testHB][poshaut-1])
  dumbH <- poshaut[dumbH] -1
  if (sum(dumbH) > 0) {testHaut[testHB][dumbH]<-FALSE}
  
  # Nettoyage des Bas excessif
  
  posbas <- which(testBas[testHB])
  dumbB <- which(testBas[testHB][posbas-1])
  dumbB <- posbas[dumbB]
  if (sum(dumbB) > 0) {testBas[testHB][dumbB]<-FALSE}
  
  # Creation des DF contenant les valeurs
  
  bas <- data.table (P.VALEUR = gachData$P.VALEUR[testBas],P.TEMPS = gachData$P.TEMPS[testBas],
                     P.UPDOWN = factor("Bas"))
  
  haut <- data.table (P.VALEUR = gachData$P.VALEUR[testHaut],P.TEMPS = gachData$P.TEMPS[testHaut],
                      P.UPDOWN = factor("Haut"))
  
  lbas <- length(testBas)
  
  testBas <- testBas[c(-1,-lbas)]
  
  testBas2 <- logical(lbas)
  
  for (i in which(testBas)){
    if(gachData$P.VALEUR[i+1]==gachData$P.VALEUR[i+2]){
      testBas2[i+2]<-TRUE
    }else {
      if(testHaut[i]){
        testBas2[i+1]<-TRUE
      }else{
        testBas2[i]<-TRUE
      }
      
    }
  }
  
  bas<- rbind(bas,data.table (P.VALEUR = gachData$P.VALEUR[testBas2],P.TEMPS = gachData$P.TEMPS[testBas2],
                              P.UPDOWN = factor("Bas")))
  
  # on suprime les eventuelle ligne superflus
  bas <- bas[bas$P.TEMPS != 0,]
  haut <- haut[haut$P.TEMPS != 0,]
  
  pics <- rbind (bas,haut)
  pics <- pics [order(pics$P.TEMPS),]
  
  return(pics)
  
}
