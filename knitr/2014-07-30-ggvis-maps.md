---
layout: post
title: Maps with ggvis
description: "small example of maps with ggis"
modified: 2014-07-30
---


Small example of maps with ggvis.  Interactivity isn't enabled here on this static html page but if run thru R/shiny/Rmd document enables you to click states.  The clicking currently doesn't do much (just prints to console lat/long and state name).


{% highlight r %}
#interactive map with ggvis
library(ggvis)
library(dplyr)
map_data = ggplot2::map_data("state")
map_data %>% select(long, lat, group, order, region) %>% 
  group_by(group) %>% 
  ggvis(x = ~long, y = ~lat) %>% 
  layer_paths(fill = ~region) %>%
  hide_legend("fill") %>% 
  handle_click(on_click = function(data, ...) {print(data)}) 

#clicking on the map currently prints to console.  You can probably make something cooler.
{% endhighlight %}
