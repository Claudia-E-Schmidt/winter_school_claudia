# Script name: Exercise 3
# Author: Claudia Schmidt
# Date: 21.11.22


# Libraries ---------------------------------------------------------------

library(tidyverse)
library(ggpubr) # for statistics
library(RColorBrewer)
library(palmerpenguins)


# Data --------------------------------------------------------------------

# Load the dataset into the local environment
penguins <- penguins

# Load sst file 
sst_NOAA <- read_csv("course_material/data/sst_NOAA.csv") #read_csv commes from tidyverse
#use .csv2 if Semicolon is used as separator
#or use read_delim(file, delim = "\t") if separator is a tab stop

# Analyses ----------------------------------------------------------------

head(sst_NOAA) #prints first 6 digits of the table
tail(sst_NOAA) #prints last 6 digits as a table
glimpse(sst_NOAA) #quick summary
summary(sst_NOAA) #QUantiles, Median, Mean

# Example -----------------------------------------------------------------

####Continuous colour scale####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = bill_depth_mm))

####Continuous colour scales####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = bill_depth_mm)) +
  # Change the continuous variable colour palette
  scale_colour_distiller() 

####Continuous colour scales with different colours####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = bill_depth_mm)) +
  # Choose a pre-set palette
  scale_colour_distiller(palette = "Spectral")

####Continuous colour scales####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = bill_depth_mm)) +
  # Viridis colour palette
  # c changes to continious
  # Different options available for colours
  scale_colour_viridis_c(option = "D")

####Discrete colour scales####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(year))) +
  # as.function changes values into discrete values
  # The discrete colour palette function
  scale_colour_brewer()

####Discrete colour scales with different colours####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(year))) +
  # Choose a colour palette
  scale_colour_brewer(palette = "Set1")

####Discrete colour scales with different colours 2####

ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(year))) +
  # Discrete viridis colour palette
  scale_colour_viridis_d(option = "A")
  #this option is not easy to see

#####Compare species####
ggplot(data = penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot(aes(fill = species), show.legend = F) +
  stat_compare_means(method = "anova")

####Statistics t-Test####
compare_means(bill_length_mm~sex, data = penguins, method = "t.test")

####Statistics ANOVA####
compare_means(bill_length_mm~species, data = penguins, method = "anova")

####Plot Statistics ANOVA####
# basic boxplot with Anova value
ggplot(data = penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot(aes(fill = species), show.legend = F) + # show legend FALSE
  stat_compare_means(method = "anova")

# basic boxplot with ANOVA result in middle of plot

ggplot(data = penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot(aes(fill = species), show.legend = F) +
  stat_compare_means(method = "anova", 
                     aes(label = paste0("p ", ..p.format..)), #display only the formatted p-value (without the method name)
                     label.x = 2) +
  theme_bw()

#### Multiple Means####

# First create a list of comparisons to feed into our figure
penguins_levels <- levels(penguins$species)
my_comparisons <- list(c(penguins_levels[1], penguins_levels[2]), 
                       c(penguins_levels[2], penguins_levels[3]),
                       c(penguins_levels[1], penguins_levels[3]))

# Then we stack it all together
ggplot(data = penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot(aes(fill  = species), colour = "grey40", show.legend = F) +
  stat_compare_means(method = "anova", colour = "grey50",
                     label.x = 1.8, label.y = 32) +
  # Add pairwise comparisons p-value
  stat_compare_means(comparisons = my_comparisons,
                     label.y = c(62, 64, 66)) +
  # Perform t-tests between each group and the overall mean
  stat_compare_means(label = "p.signif", 
                     method = "t.test",
                     ref.group = ".all.") + 
  # Add horizontal line at base mean
  geom_hline(yintercept = mean(penguins$bill_length_mm, na.rm = T), 
             linetype = 2) + 
  labs(y = "Bill length (mm)", x = NULL) +
  theme_bw()


# Exercise 1 --------------------------------------------------------------

# Create your own continuous and discrete colour palettes

#continuous palette
ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = bill_depth_mm)) +
  #continous scale with 4 personalized colours
  scale_colour_gradientn(colours = c("#1C1F4A", "#54337D", "#9B3FAA", "#EF3CCE"))

#discrete palette
ggplot(data = na.omit(penguins),
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(sex))) +
  # How to use custom palette
  scale_colour_manual(values = c("#1C1F4A", "#EF3CCE"),
                      # How to change the legend text
                      labels = c("female", "male")) + 
  # How to change the legend title
  labs(colour = "Sex") +
  labs(x = "Body mass (g)", fill = "Bill lenght (mm)")

# Create and combine two figures, each using a different palette

point_1 <- ggplot(data = na.omit(penguins),
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(species))) +
  # How to use custom palette
  scale_colour_manual(values = c("#1E3140", "#1B9580", "#C8F670"),
                      # How to change the legend text
                      labels = c("Adelie", "Chinstrap", "Gentoo")) + 
  # How to change the legend title
  labs(colour = "Species") +
  labs(x = "Body mass (g)", fill = "Bill lenght (mm)")
point_1

point_2 <-ggplot(data = penguins,
       aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = bill_depth_mm)) +
  labs(colour = "Bill depth (mm)") +
  labs(x = "Body mass (g)", fill = "Bill lenght (mm)")+
  #continous scale with 4 personalized colours
  scale_colour_gradientn(colours = c("#1C1F4A", "#54337D", "#9B3FAA", "#EF3CCE"))
point_2

grid_1 <- ggarrange(point_1, point_2,
                    # Set number of rows and columns
                    ncol = 1, nrow = 2,
                    # Label each figure
                    labels = c("a)", "b)"),
                    # Create common legend
                    common.legend = FALSE,
                    # Set legend position
                    legend = "bottom")
grid_1

# Exercise 2 --------------------------------------------------------------
# Create two versions of the same figure and combine
# Use a viridis colour palette against a default palette in a way that 
# allows features in the data to be more pronounced

point_3 <- ggplot(data = na.omit(penguins),
                  aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(species))) +
  # How to use custom palette
  scale_colour_viridis_d(option = "D") +
  # How to change the legend title
  labs(colour = "Species") +
  labs(x = "Body mass (g)", y = "Bill lenght (mm)")
point_3

point_4 <- ggplot(data = na.omit(penguins),
                  aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(aes(colour = as.factor(sex))) +
  # How to change the legend title
  labs(colour = "Sex") +
  labs(x = "Body mass (g)", y = "Bill lenght (mm)")
point_4

grid_2 <- ggarrange(point_3, point_4,
                    # Set number of rows and columns
                    ncol = 1, nrow = 2,
                    # Label each figure
                    labels = c("a)", "b)"),
                    # Create common legend
                    common.legend = FALSE,
                    # Set legend position
                    legend = "bottom")
grid_2

# Exercise 3 --------------------------------------------------------------

# Plot and combine t-test and ANOVA stats using sst_NOAA
# See this site for more info on plotting stats:
# http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/76-add-p-values-and-significance-levels-to-ggplots/




# BONUS -------------------------------------------------------------------

# Create a correlogram

