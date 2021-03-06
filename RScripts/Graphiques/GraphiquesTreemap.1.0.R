
#==#==#==#==#

# Fonction graphiques.density : cr�e une carte proportionnell via geom_treemap

# Return : le plot cr�er via ggplot

#==#==#==#==#

graphiques.treemap <- function (data,aes.area,aes.fill,aes.label,title,subtitle,save.file,save=TRUE,width = 15,height = 15){
  
  attach(data)
  
  plot <- ggplot (data = data, aes (area = aes.area, fill = aes.fill, label = aes.label))+
    geom_treemap(linetype = 1, colour ="white", size =3) +
    scale_fill_brewer(palette = "Set1") +
    ggtitle (label = title, subtitle = subtitle) +
    theme(plot.title = element_text(size = 20, face = "bold", hjust = 0)) +
    geom_treemap_text(grow = TRUE, reflow = TRUE) +
    guides (fill = FALSE)
  
  if (save){
    ggsave(filename = save.file, width = width, height = height)
  }
  
  detach(data)
  
  return(plot)
}