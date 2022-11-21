# Script name: Exersice 1
# Author: CS
# Date: 21.11.22


# Libraries ---------------------------------------------------------------

library(tidyverse)
library(palmerpenguins)


# Data --------------------------------------------------------------------

# Load the dataset into the local environment
penguins <- penguins


# Example -----------------------------------------------------------------

# The basic plot
ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = species))


# Exercise 1 --------------------------------------------------------------

# Create a basic plot with different x and y axes
ggplot(data = penguins,
       aes(x = bill_length_mm, y = flipper_length_mm)) +
  geom_point(aes(colour = species))

# Exercise 2 --------------------------------------------------------------

# Change the aes() arguments
ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(size = island, shape = sex, colour = sex))

# Exercise 3 --------------------------------------------------------------

# Change the labels
ggplot(data = na.omit(penguins),
       #na.omit exludes NA values, must be written as NA in data sheet
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(shape = sex, colour = sex)) +
  labs(x = "Body mass (g)", y = "Bill length (mm)", colour = "Sex", shape = "Sex") +
  # Change legend position
  theme(legend.position = "bottom")

# BONUS -------------------------------------------------------------------

# Create a ridgeplot
