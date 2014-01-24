window.LineDefinition =
    getLineDefinition: ->
        d3.svg.line!
            ..x (point, index) ~> @x index
            ..y @y
