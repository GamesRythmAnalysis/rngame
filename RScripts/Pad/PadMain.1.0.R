# Analyse Pad
# Fonction pour l'analyse du Pad Rythmanalyse

pad.main <- function (padData, infobaz, graph) {
  
  # possibilite de repasser valfreq pour touches freq. en argument
  # button change et analog change ne changent pas selon systeme et langue
  # mais les designations ensuite changent ! Source de bugs
  # determiner les bons tests
  
  # on fait les test avant et on sous divise en deux grande cat�gorie :
  # plus rapide qu'avan
  isAnalog <- padData$P.ANALOG == "analog change"
  analog <- padData[isAnalog,]
  boutonChange <-padData[!isAnalog,]
  
  codeDpad <- c ("Commande de pouce", "pov")
  isDpad <- boutonChange$P.TOUCHE %in% codeDpad
  
  isGach <- grepl ("z", analog$P.TOUCHE, ignore.case = TRUE)
  
  # separer appuis : boutons
  boutData <-boutonChange[!(isDpad),]
  boutData$P.TOUCHE <- droplevels (boutData$P.TOUCHE)
  
  # separer DPAD
  dpadData <- boutonChange[isDpad,]
  dpadData$P.TOUCHE <- droplevels (dpadData$P.TOUCHE)
  
  # separer gachettes
  gachData <- analog[isGach,]
  gachData$P.TOUCHE <- droplevels (gachData$P.TOUCHE)
  
  # separer mouvement des sticks (analogique, mais sans gachettes traitees comme boutons)
  stickData <- analog[!isGach,]
  stickData$P.TOUCHE <- droplevels (stickData$P.TOUCHE)
  
  # P.DuM Duree en minute de l'activite pad
  P.DuS <- (max (padData$P.TEMPS) - min (padData$P.TEMPS))
  P.DuM <- P.DuS / 60
  
  boutonResult <- pad.bouton.analyse(boutData)
  
  gachetteResult <- pad.gachette.analyse(gachData)
  boutonResult <- rbind(boutonResult, gachetteResult[,1:3])
  
  # si on as pas ou peut de donn�e dpad le retraitement marche pas
  if (nrow(dpadData) > 10){
    dpadResult <- pad.dpad.analyse(dpadData)
    boutonResult <- rbind(boutonResult, dpadResult)
  }
  
  stickResult <- pad.stick.analyse(stickData)
  
  # on trie par ordre chronologique sinon plus rien n'as de sens
  boutonResult <- boutonResult[order(boutonResult$down.time), ]
  
  # calcules des temps entre appuis
  boutonEntreApp <-
    boutonResult$down.time[-1] - boutonResult$down.time[-nrow(boutonResult)] - boutonResult$durApp[-nrow(boutonResult)]
  
  # on determine les bouton frequent
  P.NbAppuis <- nrow(boutonResult)
  VALFREQ <- 0.01 * P.NbAppuis
  
  tableBouton <- sort(table(boutonResult$bouton), decreasing = TRUE)
  boutonFreq <- subset (tableBouton,
                         tableBouton > VALFREQ)
  
  # On ne conserve que la touche la plus frequente
  mostFreq <- subset (boutonResult,
                      boutonResult$bouton == names (boutonFreq[1]))
  mostFreqEntreAp <-
    mostFreq$down.time[-1] - mostFreq$down.time[-nrow(mostFreq)] - mostFreq$durApp[-nrow(mostFreq)]
  
  # apelle a la fonction de cr�ationd des graphiques
  if(graph){
    pad.graphiques(infobaz,P.DuM,length(boutonFreq),boutonResult,stickResult[[1]],stickResult[[2]])
  }
  P.DurActivite <- sum(boutonResult$durApp,na.rm = TRUE)/60
  P.PopActivite <- P.DurActivite/P.DuM
  P.DurApMoy <- mean(boutonResult$durApp,na.rm = TRUE)
  P.DurApSD <- sd(boutonResult$durApp,na.rm = TRUE)
  P.DurApTot <- sum(boutonResult$durApp,na.rm = TRUE)
  P.TpEntreApMoy <- mean(boutonEntreApp,na.rm = TRUE)
  P.TprEntreApSD <- sd(boutonEntreApp,na.rm = TRUE)
  
  P.NbBouton <- length(levels(boutonResult$bouton))
  P.NbAppuisS <- P.NbAppuis / P.DuS
  P.NbBoutonFreq <- length(boutonFreq)
  
  P.BoutFreq <- mostFreq$bouton[1]
  P.PropFreq <- (nrow (mostFreq) / P.NbAppuis) * 100
  P.durApFreqMoy <- mean(mostFreq$durApp,na.rm = TRUE)
  P.durApFreqSD <- sd(mostFreq$durApp,na.rm = TRUE)
  P.TpEntreAppuisFreqMoy <- mean(mostFreqEntreAp,na.rm = TRUE)
  P.TpEntreAppuisFreqSD <- sd(mostFreqEntreAp,na.rm = TRUE)
  
  P.VitPresGachetteMoy <- mean(gachetteResult$vit.pression,na.rm = TRUE)
  P.VitPresGachetteSD <- sd(gachetteResult$vit.pression,na.rm = TRUE)
  P.VitRelachGachetteMoy <- mean(gachetteResult$vit.relache,na.rm = TRUE)
  P.VitRelachGachetteSD <- sd(gachetteResult$vit.relache,na.rm = TRUE)
  
  P.PropLR <- length(stickResult[[3]])/(length(stickResult[[3]])+length(stickResult[[4]]))
  P.VitJoyStickL <- sum(stickResult[[3]])/P.DuS
  P.VitJoyStickR <- sum(stickResult[[4]])/P.DuS
  P.VitJoyStickMoy <- (P.VitJoyStickL*length(stickResult[[3]])+P.VitJoyStickR*length(stickResult[[4]]))/(length(stickResult[[3]])+length(stickResult[[4]]))
  
  #==#==#==#==#
  
  # P.DuM                   # dur�e en seconde de la session
  
  # P.DurActivite           # duree totale d'activit� reel des boutons
  # P.PopActivite           # proportion d'activit� reel des boutons
  # P.durApMoy              # duree d'appuis moyenne des touches
  # P.durApSD               # ecart type
  # P.durApTot              # cumule des duree d'appuis des touches
  # P.TpEntreApMoy          # duree moyenne entre deux appuis
  # P.TpEntreApSD           # ecrat type
  
  # P.NbBouton              # nombre de bouton utilis�
  # P.NbAppuis              # nombre d'appuis
  # P.NbAppuisS             # nombre d'appuis par seconde
  # P.NbBoutonFreq          # nombre de bouton freq : ceux qui repr�sente + de 1% du nombre d'appuis
  
  # P.BoutFreq              # le bouton le plus utilis�
  # P.PropFreq              # proportion d'utilisation de se bouton
  # P.durApFreqMoy          # duree d'appuis moyenne dela touche la plus frequente
  # P.durApFreqSD           # ecart type
  # P.TpEntreAppuisFreqMoy  # duree moyenne entre deux appuis
  # P.TpEntreAppuisFreqSD   # ecart type
  
  # P.vitPresGachetteMoy    # vitesse moyenne de pression des gachettes en %/s
  # P.vitPresGachetteSD     # ecart type
  # P.vitRelachGachetteMoy  # vitesse moyenne de relachement des gachette en %/s
  # P.vitRelachGachetteSD   # ecart type
  
  # P.PropLR                # propotion d'utilisation du stick gauche par rapport au stick droit
  # P.VitJoyStickL          # vitesse moyenne du stick gauche
  # P.VitJoyStickR          # vitesse moyenne du stick droit
  # P.VitJoyStickMoy        # vitesse moyenne pond�r�e des deux stick
  
  #==#==#==#==#
  
  resultats <- data.table(
    P.DuM,
    
    P.DurActivite,
    P.PopActivite,
    P.DurApMoy,
    P.DurApSD,
    P.DurApTot,
    P.TpEntreApMoy,
    P.TprEntreApSD,
    
    P.NbBouton,
    P.NbAppuis,
    P.NbAppuisS,
    P.NbBoutonFreq,
    
    P.BoutFreq,
    P.PropFreq,
    P.durApFreqMoy,
    P.durApFreqSD,
    P.TpEntreAppuisFreqMoy,
    P.TpEntreAppuisFreqSD,
    
    P.VitPresGachetteMoy,
    P.VitPresGachetteSD,
    P.VitRelachGachetteMoy,
    P.VitRelachGachetteSD,
    
    P.PropLR,
    P.VitJoyStickL,
    P.VitJoyStickR,
    P.VitJoyStickMoy
  )
  
  return (resultats)
}
