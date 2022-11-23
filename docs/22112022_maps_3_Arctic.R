# Script name
# Author
# Date


# Libraries ---------------------------------------------------------------

library(tidyverse)
library(ggOceanMaps)
library(ggOceanMapsData)

# Data --------------------------------------------------------------------

# NB: ggOceanMapsData is not on CRAN
# Uncomment and run this line of code:
remotes::install_github("MikkoVihtakari/ggOceanMapsData")
# If this causes an error, think about why

# Example -----------------------------------------------------------------

#### The basic map####
ggplot() +
  borders(fill = "grey70", colour = "black") +
  coord_polar()

#### Fixed base map####
map_global_fix <- map_data('world') %>% 
  rename(lon = long) %>% 
  mutate(group = ifelse(lon > 180, group+2000, group),
         lon = ifelse(lon > 180, lon-360, lon))

# Load sea surface temperatures for 2000-01-01
#not on this computer
#load("../data/OISST_2022.RData")

####Cartesian projection####

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group)) +
  # Numeric sizing for lon/lat 
  coord_cartesian() #cartesian is the default function

####Equal projections####

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group)) +
  # Equal sizing for lon/lat 
  coord_equal()

####Fixed projections####
ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group)) +
  # Ratio (Y divided by X) sizing for lon/lat 
  coord_fixed(ratio = 2)

####Map projections####
ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group)) +
  # Behind the scenes this adapts the "mercator" projection, best for basic mapping
  coord_quickmap()

####Polar projections####

# #Don't use this for Arctic mapping
# ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
#   geom_polygon(aes(group = group)) +
#   scale_y_reverse() + #flips over the map to show Arctic not Antarktica
#   # A very different projection
#   coord_polar()

#This can be used for most things
ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group)) +
  # Look up the help file for moer info
  coord_map(projection = "ortho", orientation = c(90, 0, 0)) 

#Better to use this line of code
basemap(limits = 55)

####Polar projections with Bathymetry####

#Also includes the Bathymetry automatically
basemap(limits = 55, bathymetry = TRUE)

#Bathymetry with glaciers
basemap(limits = 55, bathymetry = TRUE, glaciers = TRUE)

#Zooming into the Arctic
basemap(limits = c(-50, -20, 60, 85), rotate = TRUE, bathymetry = TRUE)

####Citing packages####
citation("ggOceanMaps")

# Exercise 1 --------------------------------------------------------------

# Directly access the shape of a region near a pole and plot with polar projection
basemap(limits = c(-35, -17, 68, 79), rotate = TRUE) +
        scale_x_continuous(breaks = c(-30,-25, -20), 
                           labels = c("30°W", "25°W", "20°W"), 
                           expand = c(0,0))+
        scale_y_continuous(breaks = c(68,72,76), 
                           labels = c("68°N", "72°N", "76°N"), 
                           expand = c(0,0))
# Exercise 2 --------------------------------------------------------------

# Add a data layer to a polar projection plot
dt_polar <- data.frame(lon = c(-20, -19.2, -21), 
                        lat = c(72.5, 75, 70.5))

green_polar <- basemap(limits = c(-35, -17, 68, 78), rotate = TRUE) +
        scale_x_continuous(breaks = c(-30,-25, -20), 
                     labels = c("30°W", "25°W", "20°W"), 
                     expand = c(0,0))+
        scale_y_continuous(breaks = c(70,73,76), 
                     labels = c("70°N", "73°N", "76°N"), 
                     expand = c(0,0))+
        geom_spatial_point(data = dt_polar, aes(x = lon, y = lat), size = 2,
                      shape = 21, fill = "red")+
        geom_spatial_rect(aes(xmin = -24, xmax = -16, ymin = 74.5, ymax = 75.8),
                          fill = NA, colour = "red")+
        geom_spatial_rect(aes(xmin = -26, xmax = -18, ymin = 71.8, ymax = 73.1),
                    fill = NA, colour = "red")+
        geom_spatial_rect(aes(xmin = -26, xmax = -18, ymin = 70.1, ymax = 71),
                    fill = NA, colour = "red")+
        geom_spatial_text(aes(label = "Greenland"), x = -30, y = 75.0, size = 1.0)+
  # Remove the axis label text
  theme(axis.title = element_blank(),
        # Add black border
        panel.border = element_rect(fill = NA, colour = "black"),
        # # Change position of legend
        # legend.position = c(0.9, 0.5),
        )
green_polar

green_polar_an <- green_polar +
  ggtitle("Observation Sites", subtitle = "(3 sites around East Greenland)")+
  # geom_text("text", label = "Greenland",
  #        x = -30, y = 75.0, size = 1, fontface = "bold.italic")+
  annotation_spatial("text", label = "North\nAtlantic\nOcean", 
           x = -20, y = 73, size = 1,  angle = 330, colour = "navy")
green_polar_an

# Exercise 3 --------------------------------------------------------------

# Use ggoceanmaps to create a similar plot


# BONUS -------------------------------------------------------------------

# Create a workflow for creating a polar plot for any region

