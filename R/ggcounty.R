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
ggcounty <- function(state="Maine", fips=FALSE, fill="white",
                     color="#7f7f7f", size=0.25, alpha=1) {

  # http://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html

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

  cty <- readShapePoly(county.file, repair=TRUE, IDvar=ifelse(fips,"FIPS","NAME"))

  cty.f <- fortify(cty, region=ifelse(fips,"FIPS","NAME"))

  gg <- ggplot()
  cnty.geom <- geom_map(data=cty.f, map = cty.f, aes(map_id=id, x=long, y=lat),
                        fill=fill, color=color, size=size, alpha=alpha)
  gg <- gg + cnty.geom
  gg <- gg + coord_map()
  gg <- gg + labs(x="", y="")
  gg <- gg + theme(plot.background = element_rect(fill = "transparent", colour = NA),
                   panel.border = element_blank(),
                   panel.background = element_rect(fill = "transparent", colour = NA),
                   panel.grid = element_blank(),
                   axis.text = element_blank(),
                   axis.ticks = element_blank(),
                   legend.position = "right")

  return(list(map=cty.f, county.names=unique(cty.f$id), gg=gg, geom=cnty.geom))

}

#' Returns a ggplot2 object with a geom_map of the the lower 48 states (you can grab Hawaii & Alaska separately and map them in)
#'
#' @param fill color string (e.g. + default = "white")
#' @param border color string (e.g. + default = "#7f7f7f")
#' @param border line width (e.g. + default = 0.25)
#' @param fill alpha (e.g. + default = 1)
#' @return list consisting of the fortified map object (map), list of FIPS ids (fips) & the ggplot2 object (gg)
#' @export
#' @examples
#' g <- ggcounty.us()
ggcounty.us <- function(fill="white", color="#7f7f7f", size=0.25, alpha=1) {

  # http://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html

  require(sp)
  require(maptools)
  require(ggplot2)

  us.file <- system.file(package="ggcounty", "counties", "48.shp")

  cty <- readShapePoly(us.file, repair=TRUE, IDvar="FIPS")

  cty.f <- fortify(cty, region="FIPS")

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

  return(list(map=cty.f, fips=unique(cty.f$id), gg=gg))

}

#' Returns a ggplot2 object with a geom_map of the lower 48 states and the non-contiguous states of Alaska and Hawaii
#'
#' @param fill color string (e.g. + default = "white")
#' @param border color string (e.g. + default = "#7f7f7f")
#' @param border line width (e.g. + default = 0.25)
#' @param fill alpha (e.g. + default = 1)
#' @return list consisting of the fortified map object (map), list of FIPS ids (fips) & the ggplot2 object (gg)
#' @export
#' @examples
#' g <- ggcounty.us_full()
ggcounty.us_full <- function(fill="white", color="#7f7f7f", size=0.25, alpha=1) {

  # http://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html

  require(sp)
  require(maptools)
  require(ggplot2)

  us.file <- system.file(package="ggcounty", "counties", "48.shp")

  cty <- readShapePoly(us.file, repair=TRUE, IDvar="FIPS")

  cty.f <- fortify(cty, region="FIPS")

  # Add projections

  albers_proj <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"
  original_proj <- "+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"

  # Add hawaii

  hawaii.file <- system.file(package="ggcounty", "counties", sprintf("%s.shp", "hawaii"))
  hawaii <- readShapePoly(hawaii.file, repair=TRUE, IDvar="FIPS")

  proj4string(hawaii) <- original_proj
  hawaii <- spTransform(hawaii, CRS(albers_proj))
  hawaii <- elide(hawaii, rotate = -35)
  hawaii <- elide(hawaii, shift = c(5400000, -1400000))

  proj4string(hawaii) <- albers_proj
  hawaii <- spTransform(hawaii, CRS(original_proj))
  hawaii.f <- fortify(hawaii, region = "FIPS")

  cty.f <- rbind(cty.f, hawaii.f)

  # Add Alaska

  alaska.file <- system.file(package="ggcounty", "counties", sprintf("%s.shp", "alaska"))
  alaska <- readShapePoly(alaska.file, repair=TRUE, IDvar="FIPS")

  proj4string(alaska) <- original_proj
  alaska <- spTransform(alaska, CRS(albers_proj))
  alaska <- elide(alaska, rotate = -50)
  alaska <- elide(alaska, scale = max(apply(bbox(alaska), 1, diff)) / 2.3)
  alaska <- elide(alaska, shift = c(-2100000, -2500000))

  proj4string(alaska) <- albers_proj
  alaska <- spTransform(alaska, CRS(original_proj))
  alaska.f <- fortify(alaska, region = "FIPS")

  cty.f <- rbind(cty.f, alaska.f)

  # Add gg

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

  return(list(map=cty.f, fips=unique(cty.f$id), gg=gg))

}
