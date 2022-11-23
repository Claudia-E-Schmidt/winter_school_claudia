# Script name
# Author
# Date


# Libraries ---------------------------------------------------------------

library(tidyverse) # The base

library(marmap) # For downloading bathymetry data


# Data --------------------------------------------------------------------

map_data_world <- map_data("world")




# Example -----------------------------------------------------------------

# The basic map
# longitude goes over 180 degrees
ggplot() +
  borders(fill = "grey70", colour = "black") +
  coord_equal(xlim = c(-90, -70), ylim = c(20, 40))

#Fix global map data

map_global_fix <- map_data('world') %>% 
  rename(lon = long) %>% 
  # Why +2000? If lon is over 180, add 2000 to group, otherwise leave group -> make new group for areas that are over the date line
  mutate(group = ifelse(lon > 180, group+2000, group), #mutate creates a new variable/overwrites it
         lon = ifelse(lon > 180, lon-360, lon)) #converts to east/west coordinates
map_global_fix

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # The default coordinate system, with specific limits
  coord_cartesian(xlim = c(-180, 180), ylim = c(-90, 90), expand = FALSE)

#### Download bathy data####
bathy_WA <-  getNOAA.bathy(lon1 = 111, lon2 = 117,
                            # NB: smaller value first, i.e. more negative
                            lat1 = -36, lat2 = -19,
                            # In degree minutes
                            resolution = 4) #resolution 1 about 10 km resolution, 4 more coarse resolution

#Convert to data.frame for use with ggplot2
bathy_WA_df <- fortify.bathy(bathy_WA) %>% #converts special NOAA file to something useable
  # Remove altimetry data
   filter(z <= 0) #filter out altimetry/above surface

#### Save Bathymetry####
save(bathy_WA_df, file = "course_material/data/bathy_WA_df.RData")

#### Load####
load("course_material/data/bathy_WA_df.RData")

#### A basic bathymetry map####

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # Add 200 m contour
  geom_contour(data = bathy_WA_df, 
               aes(x = x, y = y, z = z),
               breaks = c(-200), 
               linewidth = c(0.3), colour = "grey") +
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)

####Choose multiple bathymetry lines####
ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # Add 200 and 2000 m contours
  geom_contour(data = bathy_WA_df, 
               aes(x = x, y = y, z = z),
               breaks = c(-200, -2000), 
               linewidth = c(0.3), colour = "grey") +
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)

####Changing colours with aes####

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # Rather use `aes()`
  geom_contour(data = bathy_WA_df, 
               aes(x = x, y = y, z = z, colour = after_stat(level)), #calculating statistics from bathy data - gives contours
               linewidth = c(0.3)) +
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)

####Discrete colour palettes####
ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # Combine `aes()` and `breaks = c()` for more control
  geom_contour(data = bathy_WA_df, 
               aes(x = x, y = y, z = z, colour = after_stat(level)),
               breaks = c(-50, -200, -1000, -2000), 
               linewidth = c(0.3)) +
  # Also change colour palette
  scale_colour_distiller(palette = "BuPu") + 
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)

####Tidy up the bathy appearance####
ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # create discrete factors
  geom_contour(data = bathy_WA_df, 
               aes(x = x, y = y, z = z, colour = as.factor(after_stat(level))), #makes discrete value
               breaks = c(-50, -200, -1000, -2000), 
               linewidth = c(0.3)) +
  # Use discrete palette
  scale_colour_brewer("Depth [m]", palette = "Set1", direction = -1) +  
  # Reverse legend order and make symbols thicker
  guides(color = guide_legend(reverse = TRUE, #access legend 
                              override.aes = list(linewidth = 5))) +
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)

# Load sea surface temperatures for 2000-01-01
load("course_material/data/OISST_2000.RData")

####Plot Western Australia####

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_polygon(aes(group = group), 
               colour = "black", fill = "grey60") +
  geom_raster(data = OISST_2000, aes(fill = temp)) +
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)
  #land should be plotted on top of bathymetry

####Combining layers####

#Remember that the order of the code is how the layers are plotted

ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  # First layer
  geom_raster(data = OISST_2000, aes(fill = temp)) + 
  # Second layer
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  # Third layer
  geom_contour(data = bathy_WA_df, 
               aes(x = x, y = y, z = z, colour = as.factor(after_stat(level))), 
               breaks = c(-50, -200, -1000, -2000), 
               linewidth = c(0.3)) +
  guides(color = guide_legend(reverse = TRUE, 
                              override.aes = list(linewidth = 5))) + 
  scale_fill_viridis_c("Temperature [°C]") +
  scale_colour_brewer("Depth [m]", palette = "BuPu") +
  coord_cartesian(xlim = c(111, 117), 
                  ylim = c(-36, -19), expand = FALSE)

####Final touches####

final_map <- ggplot(data = map_global_fix, aes(x = lon, y = lat)) +
  geom_raster(data = OISST_2000, aes(fill = temp)) +
  geom_polygon(aes(group = group), colour = "black", fill = "grey60") +
  geom_contour(data = bathy_WA_df,
               aes(x = x, y = y, z = z, colour = as.factor(..level..)), 
               breaks = c(-50, -200, -1000, -2000), linewidth = c(0.3)) +
  guides(color = guide_legend(reverse = TRUE, override.aes = list(linewidth = 5))) + 
  scale_fill_viridis_c("Temperature [°C]") +
  scale_colour_brewer("Depth [m]", palette = "BuPu") +
  coord_cartesian(xlim = c(111, 117), ylim = c(-36, -19), expand = FALSE) +
  # Put x axis labels on top of figure and assign °E
  scale_x_continuous(position = "top", 
                     breaks = c(112, 114, 116), labels = c("112°E", "114°E", "116°E")) + 
  # Put y axis labels on right of figure and assign °S
  scale_y_continuous(position = "right",
                     breaks = c(-34, -28, -22), labels = c("34°S", "28°S", "22°S")) +
  # Remove the axis label text
  theme(axis.title = element_blank(),
        # Add black border
        panel.border = element_rect(fill = NA, colour = "black"), 
        # Change text size in legend
        legend.text = element_text(size = 7), 
        # Change legend title text size
        legend.title = element_text(size = 7), 
        # Change size of legend
        legend.key.height = unit(0.5, "cm"),
        # Add legend background
        legend.background = element_rect(fill = "white", colour = "black"),
        # Change position of legend
        legend.position = c(0.9, 0.5) 
  )
final_map

####Save maps####

ggsave(plot = final_map, "figures/map_complete.pdf", height = 6, width = 9)

# Exercise 1 --------------------------------------------------------------

# Choose a coastal region somewhere within 30°N/S of the equator

# Download bathymetry data and another data layer

# Plot them


# Exercise 2 --------------------------------------------------------------

# Chose a different region

# Download two different data layers

# Plot and combine the data


# Exercise 3 --------------------------------------------------------------

# Change the themes and minutia of the previous two plots and combine them


# BONUS -------------------------------------------------------------------

# Overlay data layers on a Google map image

