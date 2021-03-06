
#==#==#==#==#

# Fonction graphiques.density : cr�e un graphique de densit� en utilisant geom_density

# Return : le plot cr�er via ggplot

#==#==#==#==#

graphiques.density<-function(data,aes.x,color,title,subtitle,save.file,xlab,ylab,bw=10,save=TRUE,width = 15,height = 7){

  attach(data)
  
  plot <- ggplot(data = data, aes (aes.x)) +
    geom_density (kernel = "gaussian", bw = bw,linetype = 1, size = 2, color = color) +
    xlab (xlab) +
    ylab (ylab) +
    ggtitle (label = title, subtitle = subtitle) +
    theme_classic()

  if (save){
    ggsave(filename = save.file, width = width, height = height)
  }
  
  detach(data)
  
  return(plot)
}
