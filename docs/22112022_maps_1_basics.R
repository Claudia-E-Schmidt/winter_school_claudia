# Script name
# Author
# Date


# Libraries ---------------------------------------------------------------

# Which libraries should be loaded?
library(tidyverse) # Contains most of what we need
library(ggpubr) # For combining figures
library(ggsn) # Contains code to make scale bars
library(palmerpenguins) # Data used in an example

# Data --------------------------------------------------------------------
# %<% is called a pipe, used similar to + in data analysis

# Call the global data to the environment
map_data_world <- map_data("world")

#create small data frame for adding twisted rectangle

rect_1 <- data.frame(long=c(-22,-17,-16,-21), 
                     lat=c(75,74,77,78), 
                     group=1)




# Example -----------------------------------------------------------------

#### Basic Map of the world####

earth_1 <- ggplot() +
  # The global shape file
  borders(fill = "grey70", colour = "black") +
  # Equal sizing for lon/lat 
  coord_equal() #forces R to have equal dimensions for x and y
earth_1


##### Cropping#### 
#crops the global map to the size of Greenland with surrounding countrys

green_1 <- ggplot() +
  borders(fill = "grey70", colour = "black") +
  # Force lon/lat extent
  coord_equal(xlim = c(-75, -10), ylim = c(58, 85)) # sets limits for x and y axis, put smaller number first
green_1

#### Basic map of Germany####
map_data_world %>% 
  filter(region == "Germany") %>% #select a region
  ggplot(aes(x = long, y = lat)) +
  geom_polygon(aes(group = group))

##### Extract a region####
map_data_green <- map_data('world') %>% 
  filter(region == "Greenland") # Why '==' and not '='? == "same as" logical argument 
  head(map_data_green)
  
#### Greenland coast dots####
  ggplot(data = map_data_green, #plots the data as points from one paragraph above
         aes(x = long, y = lat)) +
    geom_point() #not very useful but shows the concept for filteren data
  
#### Polygons####
#makes a polygon map out of the Greenland data
  
  green_2 <- ggplot(data = map_data_green, aes(x = long, y = lat)) +
    # What is this doing? -> Will give us a map
    geom_polygon(aes(group = group), #Tells R what is the group, "group" (landmasses) is the name of the column that is asked for in the data frame
                 # Note these are outside of aes() 
                 fill = "chartreuse4", colour = "black")
  green_2

#### Specific labels####
  #\n is enter

  green_3 <- green_2 +
    # Add Greenland text
    annotate("text", label = "Greenland", 
             x = -40, y = 75.0, size = 7.0, fontface = "bold.italic") +
    # Add North Atlantic Ocean text
    annotate("text", label = "North\nAtlantic\nOcean", 
             x = -20, y = 64.0, size = 5.0,  angle = 330, colour = "navy") +
    # Add Baffin Bay label
    annotate("label", label = "Baffin\nBay", 
             x = -62, y = 70, size = 5.0, fill = "springgreen") +
    # Add black line under Greenland text
    annotate("segment", 
             x = -50, xend = -30, y = 73, yend = 73)
  green_3

#### Scale bars####
green_4 <- green_3 +
    # Set location of bar, don't give R the figure, only the spreadsheet to figure out the scale
    scalebar(data = map_data_green, location = "bottomleft", 
             # Size of scale bar, 500 is for 500 km and will be twice the size (black/white)
             dist = 500, dist_unit = "km", transform = TRUE,
             # Set particulars
             st.size = 4, height = 0.03, st.dist = 0.04) 
green_4

#### Insetting####
#creates a red rectangle on top of the earth map

earth_2 <- earth_1 + 
  geom_rect(aes(xmin = -75, xmax = -10, ymin = 58, ymax = 85),
            fill = NA, colour = "red") + #not inside aesthetics
  # What does this do?
  theme_void() #removes background - transparent, no axis labels, no texts
earth_2

#### Insetting over Greenland map####
#adding the global map with the red rectangle on the Greenland map

green_5 <- green_4 +
  # Convert the earth plot to a grob
  annotation_custom(grob = ggplotGrob(earth_2), 
                    xmin = -30, xmax = -10,
                    ymin = 76, ymax = 84)
green_5

#### Adding units to lat/long coordinates####
#adds the proper axis labels to the figure

green_final <- green_5 +
  scale_x_continuous(breaks = seq(-60, -20, 20), #goes from -60 to -20 in steps of 20
                     labels = c("60°W", "40°W", "20°W"), #what will show up
                     position = "bottom") +
  scale_y_continuous(breaks = seq(60, 80, 10), #goes from 60 to 80 in steps of 10
                     labels = c("60°N", "70°N", "80°N"),
                     position = "right") +
  labs(x = "", y = "") + #NULL removes labels
  theme_bw()
green_final


# Exercise 1 --------------------------------------------------------------

# Create maps of four regions and combine
# Use a mix of cropping and direct access 

Ex1_green_1 <- ggplot() +
  borders(fill = "grey70", colour = "black") +
  # Force lon/lat extent
  coord_equal(xlim = c(-30, -10), ylim = c(62, 85)) # sets limits for x and y axis, put smaller number first
Ex1_green_1

Rect_1_box <- ggplot(data = rect_1, aes(x = long, y = lat)) +
  # What is this doing? -> Will give us a map
  geom_polygon(aes(group = group), #Tells R what is the group, "group" (landmasses) is the name of the column that is asked for in the data frame
               # Note these are outside of aes() 
               fill = NA, colour = "red", linewidth = 5)
Rect_1_box

Ex1_green_2 <- Ex1_green_1 + 
  ggplot(data = rect_1, aes(x = long, y = lat)) +
  # What is this doing? -> Will give us a map
  geom_polygon(aes(group = group), #Tells R what is the group, "group" (landmasses) is the name of the column that is asked for in the data frame
               # Note these are outside of aes() 
               fill = NA, colour = "red", linewidth = 5)+
  # theme_void() #removes background - transparent, no axis labels, no texts
Ex1_green_2




# Exercise 2 --------------------------------------------------------------

# Create a map that benefits from a scale bar and add a North arrow
# Hint: use annotate("segment", ...) to accomplish this


# Exercise 3 --------------------------------------------------------------

# Create a meaningful inset map


# BONUS -------------------------------------------------------------------

# Plot maps using Google Maps

