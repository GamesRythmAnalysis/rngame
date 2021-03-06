# SORTIES GRAPHIQUES
# GRAPHIQUES PAD

pad.graphiques <- function(infobaz,duree,nbTouchesFreq,boutonResult,stickG,stickD){
  bouton.graphique(infobaz,nbTouchesFreq,duree,boutonResult)
  
  if (nrow(stickG)>100) {
    plotG<-stick.graphique (stickG,paste(infobaz,"\n","Mouvement Stick Gauche"),paste (infobaz,".LStick",".png", sep =""))
  }
  if (nrow(stickD)>100) {
    plotD <- stick.graphique (stickD,paste(infobaz,"\n","Mouvement Stick Droit"),paste (infobaz,".RStick",".png", sep =""))
  }
  
  if (exists("plotG", environment()) & exists ("plotD", environment())) {
    if (is.null(plotG) & is.null(plotD) ){
      png (filename = paste (infobaz,".Sticks",".png", sep =""), width = 1500, height = 700)
      grid.arrange(plotG, plotD, nrow=1, ncol=2)
      dev.off()
    }
  }
}