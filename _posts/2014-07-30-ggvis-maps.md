---
layout: post
title: Maps with ggvis
description: "small example of maps with ggis"
modified: 2014-07-30
---


Small example of maps with ggvis.  Couldn't figure out how to render ggvis to png without export_png; I don't have vg2png installed.

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
{% endhighlight %}
