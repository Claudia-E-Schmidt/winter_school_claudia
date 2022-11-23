# Script name: Last Exercise Monday
# Author: Claudia Schmidt
# Date: 21.11.2022


# Libraries ---------------------------------------------------------------
# Remember to install packages!
library(tidyverse) # Contains ggplot2
library(ggpubr) # Helps us to combine figures
library(palmerpenguins) # Contains the dataset
library(RColorBrewer)
library(ggplot2)
library(dplyr)
library(hrbrthemes)

# Data --------------------------------------------------------------------

# Load the dataset into the local environment
penguins <- penguins


# Plots -------------------------------------------------------------------

####Histogram Body mass corr. Species####

histogram_2 <- ggplot(data = penguins, 
                      # NB: There is no y-axis value for histograms
                      aes(x = body_mass_g, fill = species)) + 
  geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#404080", "#C8F670")) +
  theme_ipsum() +
  labs(fill="") +
  labs(colour = "Species") +
  labs(x = "Body mass (g)", y = "Count",)
histogram_2

####Histogram Body mass corr. Sex####

histogram_3 <- ggplot(data = na.omit(penguins), 
                      # NB: There is no y-axis value for histograms
                      aes(x = body_mass_g, fill = sex)) + 
  geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_ipsum() +
  labs(fill="") +
  labs(colour = "Sex") +
  labs(x = "Body mass (g)", y = "Count",)
histogram_3

####Combine Plots####

grid_3 <- ggarrange(histogram_2, histogram_3,
                    # Set number of rows and columns
                    ncol = 1, nrow = 2,
                    # Label each figure
                    labels = c("a)", "b)"),
                    # Create common legend
                    common.legend = FALSE,
                    # Set legend position
                    legend = "bottom")
grid_3

####Save plots####
# Different file types
ggsave(plot = grid_3, filename = "figures/grid_3.png")


# Change DPI
ggsave(plot = grid_3, filename = "figures/grid_3.png", dpi = 600)