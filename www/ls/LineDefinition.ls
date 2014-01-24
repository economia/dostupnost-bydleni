window.LineDefinition =
    getLineDefinition: ->
        d3.svg.line!
            ..x (point, index) ~> @x point.x.getTime!
            ..y (point, index) ~> @y point.y
