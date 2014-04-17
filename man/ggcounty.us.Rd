\name{ggcounty.us}
\alias{ggcounty.us}
\title{Returns a ggplot2 object with a geom_map of the the lower 48 states (you can grab Hawaii & Alaska separately and map them in)}
\usage{
ggcounty.us(fill = "white", color = "#7f7f7f", size = 0.25, alpha = 1)
}
\arguments{
  \item{fill}{color string (e.g. + default = "white")}

  \item{border}{color string (e.g. + default = "#7f7f7f")}

  \item{border}{line width (e.g. + default = 0.25)}

  \item{fill}{alpha (e.g. + default = 1)}
}
\value{
list consisting of the fortified map object (map), list of
FIPS ids (fips) & the ggplot2 object (gg)
}
\description{
Returns a ggplot2 object with a geom_map of the the lower
48 states (you can grab Hawaii & Alaska separately and map
them in)
}
\examples{
g <- ggcounty.us()
}

