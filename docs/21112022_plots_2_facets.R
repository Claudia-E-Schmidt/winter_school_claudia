# Script name: First Day Monday
# Author: Claudia Schmidt
# Date: 21.11.2022


# Libraries ---------------------------------------------------------------
# Remember to install packages!
library(tidyverse) # Contains ggplot2

library(ggpubr) # Helps us to combine figures

library(palmerpenguins) # Contains the dataset


# Data --------------------------------------------------------------------

# Load the dataset into the local environment
penguins <- penguins


# Example -----------------------------------------------------------------
#####Basic plot####
ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth(method = "lm")

####Facet wrap####
ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  # Can take one or two column names (e.g. island~species)
  facet_wrap(~species)

#####Facet grip####
ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  # Takes two or more column names (e.g. species+sex~island)
  facet_grid(species~island)

#####plot object####
# Assign the ggplot2 code to an object name
lm_1 <- ggplot(data = penguins,
               aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Body mass (g)", y = "Bill length (mm)", colour = "Species")

#Visualise the plot by calling the object
lm_1

####non-linear model####
nlm_1 <- ggplot(data = penguins,
                aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth() +
  labs(x = "Body mass (g)", y = "Bill length (mm)", colour = "Species")
nlm_1

####Histogramm####
histogram_1 <- ggplot(data = penguins, 
                      # NB: There is no y-axis value for histograms
                      aes(x = body_mass_g)) + 
  geom_histogram(aes(fill = species), position = "stack", binwidth = 250) +
  # NB: We use 'fill' here rather than 'colour'
  labs(x = "Body mass (g)", fill = "Species")
histogram_1

####Boxplot####
box_1 <- ggplot(data = penguins, 
                # Why 'as.factor()'?
                aes(x = as.factor(year),
                    y = body_mass_g)) + 
  geom_boxplot(aes(fill = species)) +
  labs(x = "Year", y = "Body mass (g)", fill = "Species") 
box_1

####Combine plots####
# List the names of the plot objects to combine 
grid_1 <- ggarrange(lm_1, nlm_1, histogram_1, box_1,
                    # Set number of rows and columns
                    ncol = 2, nrow = 2,
                    # Label each figure
                    labels = c("a)", "b)", "c)", "d)"),
                    # Create common legend
                    common.legend = TRUE,
                    # Set legend position
                    legend = "bottom")
grid_1

####Save plots####
# Different file types
ggsave(plot = grid_1, filename = "figures/grid_1.pdf")
ggsave(plot = grid_1, filename = "figures/grid_1.png")
ggsave(plot = grid_1, filename = "figures/grid_1.eps")

# Change dimensions
ggsave(plot = grid_1, filename = "figures/grid_1.png", 
       width = 10, height = 8)

# Change DPI
ggsave(plot = grid_1, filename = "figures/grid_1.png", dpi = 600)


# Exercise 1 --------------------------------------------------------------

# Create a new plot type and facet by gender
#Facet wrap
fw_1 <-  ggplot(data = na.omit(penguins),
                aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  labs(x = "Body mass (g)", y = "Bill length (mm)", colour = "Species")+
  # Can take one or two column names (e.g. island~species)
  facet_wrap(~sex)
fw_1

# Exercise 2 --------------------------------------------------------------

# Create a new plot type and facet by two categories
#Facet grip
fg_1 <- ggplot(data = na.omit(penguins),
               aes(x = body_mass_g, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth() +
  labs(x = "Body mass (g)", y = "Bill length (mm)", colour = "Species")+
  # Takes two or more column names (e.g. species+sex~island)
  facet_grid(species~sex)
fg_1

# Exercise 3 --------------------------------------------------------------

# Combine all of the plots you've created so far

grid_2 <- ggarrange(fw_1,fg_1,
                    # Set number of rows and columns
                    ncol = 1, nrow = 2,
                    # Label each figure
                    labels = c("a)", "b)"),
                    # Create common legend
                    common.legend = TRUE,
                    # Set legend position
                    legend = "bottom")
grid_2

# Save them as a high-res file larger than 2 MB
#Save plots
# Different file types
ggsave(plot = grid_2, filename = "figures/grid_2.pdf")
ggsave(plot = grid_2, filename = "figures/grid_2.png")
ggsave(plot = grid_2, filename = "figures/grid_2.eps")

# Change dimensions
ggsave(plot = grid_2, filename = "figures/grid_2.png", 
       width = 10, height = 8)

# Change DPI
ggsave(plot = grid_2, filename = "figures/grid_2.png", dpi = 2000)


# BONUS -------------------------------------------------------------------

# Use a different package to combine plots

