library(beakr)
library(ggplot2)

# Create a plot of a US state
state_plot <- function(state = NULL, res) {
  states <- ggplot2::map_data('state')
  
  if ( !is.null(state) ) {
    states <- subset(states, region == tolower(state))
  }
  
  plot <-
    ggplot(data = states) +
    geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") +
    coord_fixed(1.3) +
    guides(fill = "none")
  
  # Pass the plot to the beakrs response plot method
  res$plot(plot, base64 = FALSE, height = 800, width = 800)
}

# Create and start a default beakr instance
newBeakr() %>%
  httpGET(path = '/usa', decorate(state_plot)) %>%
  handleErrors() %>%
  listen(host = "0.0.0.0", port = 8080)