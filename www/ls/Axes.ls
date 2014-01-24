window.YAxis =
    drawYAxis: ->
        isPercent = 2 > @y.domain! .1
        yAxis = d3.svg.axis!
            ..scale @y
            ..ticks 9
            ..tickFormat ->
                | isPercent => "#{Math.round it * 100}%"
                | otherwise => utils.formatPrice it
            ..tickSize 5
            ..outerTickSize 0
            ..orient \right
        @yAxisGroup = @drawing.append \g
            ..attr \class "axis y"
            ..call yAxis
            ..selectAll "text"
                ..attr \x -7
                ..attr \dy 5
                ..style \text-anchor \end
