# ImportZip
# Decoder les fichiers pour fonction rythmanalyse principale

# Debug
# debut <-0
# fin <- "max"
# nomfichier <- "2017.06.13.gd.SuperNukoWorld-yuikonnu-ayaponzu-AllStar12-Guys-Extra.zip"
# setwd("~/Documents/Projets R/Rythmanalyse/Data")

ImportZip <- function (nomfichier, debut, fin) {  # ou nomfichier est du type "2014.02.16.MT.Doom.s1.zip"
  unzip (nomfichier)
  tmp <- substr (nomfichier, 1, nchar (nomfichier)-4)
  fichiersouris <- paste (tmp,".M",".csv",sep="")
  fichierclavier <- paste (tmp,".K",".csv",sep="")
  fichierpad <- paste (tmp,".P",".csv",sep="")
  
  # Recuperer les donnees des .csv avec un check d'existence pour ne pas engendrer d'erreurs
  # Export en variable globale <<-
  testf <- file.access(c(fichiersouris,fichierclavier,fichierpad))
  
  if (testf[1] == 0) {
    d.M <- fread(file=fichiersouris, dec=".",encoding="UTF-8",stringsAsFactors=TRUE)
    names (d.M) <- c("M.EVENEMENT", "M.XPOS", "M.YPOS", "M.TEMPS")
    d.M$M.TEMPS <- d.M$M.TEMPS / 1000 # Passer l'unite de temps en secondes
    
    # Integrer les bornes temporelles
    ifelse (fin == "max", fin2 <- max(d.M$M.TEMPS, na.rm = TRUE)/60, fin2 <- fin)
    ifelse (debut > fin2, debut2 <- 0, debut2 <- debut)
    
    d.M <<- d.M[d.M$M.TEMPS >= debut2*60 & d.M$M.TEMPS <= fin2*60,]   
    
    if (length(d.M$M.EVENEMENT) < 5) {
      rm (d.M,envir = .GlobalEnv)
    } 
  } 
  
  if (testf[2] == 0) {
    d.K <- fread(file=fichierclavier, dec=".",encoding="UTF-8",stringsAsFactors=TRUE)
    names (d.K) <- c("K.EVENEMENT","K.TOUCHE","K.TEMPS")
    d.K$K.TEMPS <- d.K$K.TEMPS / 1000 # Passer l'unite de temps en secondes
    
    # Integrer les bornes temporelles
    ifelse (fin == "max", fin2 <- max (d.K$K.TEMPS, na.rm = TRUE)/60, fin2 <- fin)
    ifelse (debut > fin2, debut2 <- 0, debut2 <- debut)
    d.K <<- d.K[d.K$K.TEMPS >= debut2*60 & d.K$K.TEMPS <= fin2*60,]  
    
    if (length(d.K$K.EVENEMENT) < 5) {
      rm (d.K,envir = .GlobalEnv)
    } 
  }
  if (testf[3] == 0) {
    d.P <- fread(file=fichierpad, dec=".",encoding="UTF-8",stringsAsFactors=TRUE) # remettre export var. globale <<-
    names (d.P) <- c("P.ANALOG","P.TOUCHE","P.VALEUR","P.TEMPS")
    d.P$P.TEMPS <- d.P$P.TEMPS / 1000 # Passer l'unite de temps en secondes
    
    # Integrer les bornes temporelles
    ifelse (fin == "max", fin2 <- max(d.P$P.TEMPS, na.rm = TRUE)/60, fin2 <- fin)
    ifelse (debut > fin2, debut2 <- 0, debut2 <- debut)
    d.P <<- d.P[d.P$P.TEMPS >= debut2*60 & d.P$P.TEMPS <= fin2*60,]   
    
    if (mean(d.P$P.TEMPS) == 0) {
      rm (d.P,envir = .GlobalEnv)
    }
  }
}