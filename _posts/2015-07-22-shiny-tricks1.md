---
layout: post
title: "Useful Shiny Tips"
description: "Shiny functionality with action buttons, dynamic UI and cleanup"
author: "alex shum"
modified: 2015-02-03
---

# Some Basic R Shiny Tasks

## Action Button Triggers
It's not always helpful to have your reactive functions update right away.  Sometimes the function may depend on user input, an API call, or the function just might be slow.  In those cases it might be helpful to delay updating a reactive until an `actionButton` is pressed.


```r
#app.r

server = function(input, output) {
	#controls button actions
	wait_for_button = eventReactive(input$button1, {
		print("Button was pressed!")
	})

	#output to UI
	output$button_status = renderPrint({
		wait_for_button()
	})
}

ui = fluidPage(
	actionButton("button1", "Press this button!"),
	verbatimTextOutput("button_status")
)

shinyApp(ui = ui, server = server)
```



Sometimes an `actionButton` is used in conjunction with internal storage:


```r
#app.r

server = function(input, output) {
	#Storage
	rv_storage = reactiveValues(rand = c())

	#controls button actions
	gen_numbers = eventReactive(input$button1, {
		rv_storage$rand = rnorm(100, 0, 1)		
	})

	#output to UI
	output$print_random = renderPrint({
		gen_numbers()
		print(rv_storage$rand)
	})
}

ui = fluidPage(
	actionButton("button1", "Generate Some Random Numbers!"),
	verbatimTextOutput("print_random")
)

shinyApp(ui = ui, server = server)
```

One possible use case is when using a Shiny app in communicating with an external API server.  In cases where requests may be rate limited, it is useful to control when requests are sent out.


## Dynamic UI
Reactive UI elements built from Shiny input or data.


```r
#app.r

server = function(input, output) {
	#controls button actions
	wait_for_button = eventReactive(input$button1, {
		print("Button was pressed!")
	})

	#output to UI
	output$button_status = renderPrint({
		wait_for_button()
	})
}

ui = fluidPage(
	actionButton("button1", "Press this button!"),
	verbatimTextOutput("button_status")
)

shinyApp(ui = ui, server = server)
```

## Cleanup Code after shutdown
In case you need to close connections or other cleanup tasks after Shiny app shutsdown.


```r
#add this to your server function
session$onSessionEnded(function() {
	cleanup()
})
```
