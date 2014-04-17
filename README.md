ggcounty
========

Generate ggplot2 geom_map county maps

This is a simple package with one purpose: make it easier to generate US County maps with ggplot2 & geom_map

After installation, just do:

    library(ggcounty)
    
    maine <- ggcounty("Maine")
    maine$gg
    
To get:

![map](https://rawgit.com/hrbrmstr/ggcounty/master/maine.svg)

The `maine` object in the above code contains

- the `gg` ggplot2 object
- a `map` object which is a "fortified" data frame
- a `county.names` object which is a list of all county names in that county

Here is an example of the structure (truncated for brevity):

    > str(maine)
    List of 3
     $ map         :'data.frame':	724 obs. of  7 variables:
      ..$ long : num [1:724] -70 -70 -70 -70 -70 ...
      ..$ lat  : num [1:724] 44.1 44.1 44 44 44 ...
      ..$ order: int [1:724] 1 2 3 4 5 6 7 8 9 10 ...
      ..$ hole : logi [1:724] FALSE FALSE FALSE FALSE FALSE FALSE ...
      ..$ piece: Factor w/ 2 levels "1","2": 1 1 1 1 1 1 1 1 1 1 ...
      ..$ group: Factor w/ 18 levels "Androscoggin.1",..: 1 1 1 1 1 1 1 1 1 1 ...
      ..$ id   : chr [1:724] "Androscoggin" "Androscoggin" "Androscoggin" "Androscoggin" ...
     $ county.names: chr [1:16] "Androscoggin" "Aroostook" "Cumberland" "Franklin" ...
     $ gg          :List of 9
     ...
 
This lets you add further map layers (e.g. for a choropleth):


    library(gdata)
    library(ggcounty)
    
    maine <- ggcounty("Maine")

    pop <- read.xls("http://www.maine.gov/economist/census/pub/ME-Pop-County-2010.xls")
    pop$Count.2010 <- as.numeric(gsub(",", "", pop$Count.2010))

    gg <- maine$gg + geom_map(data=pop, map=maine$map, 
                              aes(map_id=X2010.Decennial.Census, 
                                  fill=Count.2010)) 
    gg <- gg + scale_fill_gradient(low="#fff7bc", high="#cc4c02", name="Population")
    gg


![map2](https://rawgit.com/hrbrmstr/ggcounty/master/mainechoro.png)

or have the county names as a quick reference or for verifitcation.
