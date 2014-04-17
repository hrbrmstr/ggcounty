\name{ggcounty}
\alias{ggcounty}
\title{Returns a ggplot2 object with a geom_map of the requested county}
\usage{
ggcounty(state = "Maine", fill = "white", color = "#7f7f7f",
  size = 0.25, alpha = 1)
}
\arguments{
  \item{state}{name string (e.g. + default = "Maine")}

  \item{fill}{color string (e.g. + default = "white")}

  \item{border}{color string (e.g. + default = "#7f7f7f")}

  \item{border}{line width (e.g. + default = 0.25)}

  \item{fill}{alpha (e.g. + default = 1)}
}
\value{
list consisting of the fortified map object (map), list of
county names (county.names) & the ggplot2 object (gg)
}
\description{
Returns a ggplot2 object with a geom_map of the requested
county
}
\examples{
g <- ggcounty("New York")
}

