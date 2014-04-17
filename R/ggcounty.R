#' Returns a ggplot2 object with a geom_map of the requested county
#'
#' @param state name string (e.g. + default = "Maine")
#' @param fill color string (e.g. + default = "white")
#' @param border color string (e.g. + default = "#7f7f7f")
#' @param border line width (e.g. + default = 0.25)
#' @param fill alpha (e.g. + default = 1)
#' @return list consisting of the fortified map object (map), list of county names (county.names) & the ggplot2 object (gg)
#' @export
#' @examples
#' g <- ggcounty("New York")
ggcounty <- function(state="Maine", fill="white",
                     color="#7f7f7f", size=0.25, alpha=1) {

  state.names <- c("alabama", "alaska", "arizona", "arkansas", "california",
                   "colorado", "connecticut", "delaware", "districtofcolumbia",
                   "florida", "georgia", "hawaii", "idaho", "illinois",
                   "indiana", "iowa", "kansas", "kentucky", "louisiana",
                   "maine", "maryland", "massachusetts", "michigan", "minnesota",
                   "mississippi", "missouri", "montana", "nebraska", "nevada",
                   "newhampshire", "newjersey", "newmexico", "newyork",
                   "northcarolina", "northdakota", "ohio", "oklahoma", "oregon",
                   "pennsylvania", "rhodeisland", "southcarolina", "southdakota",
                   "tennessee", "texas", "utah", "vermont", "virginia",
                   "washington", "westvirginia", "wisconsin", "wyoming")

  state <- tolower(gsub("\ ", "", state))

  if (!state %in% state.names) { return(NULL) }

  require(sp)
  require(maptools)
  require(ggplot2)

  county.file <- system.file(package="ggcounty", "counties", sprintf("%s.shp", state))

  cty <- readShapePoly(county.file, repair=TRUE, IDvar="NAME")

  cty.f <- fortify(cty, region="NAME")

  gg <- ggplot()
  gg <- gg + geom_map(data=cty.f, map = cty.f, aes(map_id=id, x=long, y=lat),
                      fill=fill, color=color, size=size, alpha=alpha)
  gg <- gg + coord_map()
  gg <- gg + labs(x="", y="")
  gg <- gg + theme(plot.background = element_rect(fill = "transparent", colour = NA),
                   panel.border = element_blank(),
                   panel.background = element_rect(fill = "transparent", colour = NA),
                   panel.grid = element_blank(),
                   axis.text = element_blank(),
                   axis.ticks = element_blank(),
                   legend.position = "right")

  return(list(map=cty.f, county.names=unique(cty.f$id), gg=gg))

}
