window.YAxis =
    drawYAxis: ->
        yAxis = d3.svg.axis!
            ..scale @y
            ..ticks 5
            ..tickFormat -> "#it%"
            ..tickSize @width - 60
            ..outerTickSize 0
            ..orient \right
        @yAxisGroup = @drawing.append \g
            ..attr \class "axis y"
            ..call yAxis
            ..selectAll "text"
                ..attr \x @width - 55
                ..attr \dy 5
            # ..selectAll "line"
            #     ..filter( -> it % 10)
            #         ..classed \minor yes
