---
title: "UK_population_animation"
author: "Pankaj Shah"
date: "6/16/2019"
output:
  html_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
library(dplyr)
library(readxl)
library(tidyverse)
library(ggthemes)
library(magick)
```



```{r warning= FALSE, error=FALSE}
data <- 
  ## Read the excel data in, skipping the "All Ages" data completely
  read_excel("~/Desktop/UK Population Estimates 1838-2015.xls", sheet = 4, skip = 96) %>%
  ## Filter away unnecessary data 
  filter(!is.na(Name)) %>%
  filter(Code != "Code") %>%
  filter(Age != "All Ages") %>%
  ## We want a numeric column, so replaced 85 / 85+ with 85
  mutate(Age = ifelse(Age == "85 / 85+", 85, Age)) %>%
  ## We group by age, as it is replicated across the two genders, and we can use this to distinguish one from the other
  group_by(Age) %>%
  mutate(gender = 1:n()) %>%
  mutate(gender = ifelse(gender == 1, "Male", "Female")) %>%
  ungroup() %>%
  ## Gather all the variable columns into one year variable to make this a tidy dataset
  gather(year, pop, 4:48) %>%
  ## Only keep the last 4 characters to give us a year, which we can convert to numeric
  mutate(year = as.numeric(str_sub(year, -4))) %>%
  mutate(age = as.numeric(Age), Age = NULL) %>%
  mutate(pop = as.numeric(pop)) %>%
  ## Make the Male population negative so we can use this in our ggplot
  mutate(pop = ifelse(gender == "Male", 0-pop, pop)) %>%
  mutate(pop_m = pop/10^6)
```



```{r}
head(data)
```

```{r, warning= FALSE}

x = data$year

data %>%
    filter(year == 1971) %>%
    ggplot(aes(x = age, y = pop_m, fill = gender)) +   
    geom_col(width = .85) +   
    scale_y_continuous(breaks = seq(-1,1,0.1),labels = c(10:0, 1:10)) +
    coord_flip() + 
    scale_x_continuous(breaks = seq(0, 100, 10), labels = seq(0, 100, 10)) +
    labs(title=paste0("UK Population in ", x), y = "Population (100,000s)", x = "Age") +
    theme(plot.title = element_text(hjust = .5),
          axis.ticks = element_blank()) +   
    scale_fill_manual(values=c("red", "navy")) +
    theme_tufte(base_size = 12, base_family="Avenir") 
```

```{r}
img <- image_graph(800, 600, res = 96)

pyramid_plot<- function(x){
  p <- data %>%
    filter(year == x) %>%
    ggplot(aes(x = age, y = pop_m, fill = gender)) +   # Fill column
    geom_col(width = .85) +   # draw the bars
    scale_y_continuous(breaks = seq(-1,1,0.1),labels = c(10:0, 1:10)) +
    
    coord_flip() +  # Flip axes
    scale_x_continuous(breaks = seq(0, 100, 10), labels = seq(0, 100, 10)) +
    labs(title=paste0("UK Population in ", x), y = "Population (100,000s)", x = "Age") +
    theme(plot.title = element_text(hjust = .5),
          axis.ticks = element_blank()) +   # Centre plot title
    scale_fill_manual(values=c("red", "navy")) +
    theme_tufte(base_size = 12, base_family="Avenir") #+ transition_manual(year)#
  p
}
map(1971:2015, pyramid_plot)
dev.off()
animation <- image_animate(img, fps = 5)
image_write(animation, "Uk_pyramid.gif")
```



```{r}

```



