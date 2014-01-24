window.YAxis =
    drawYAxis: ->
        isPercent = 2 > @y.domain! .1
        yAxis = d3.svg.axis!
            ..scale @y
            ..ticks 9
            ..tickFormat ->
                | isPercent => "#{Math.round it * 100}%"
                | otherwise => utils.formatPrice it
            ..tickSize 3
            ..outerTickSize 0
            ..orient \left
        @yAxisGroup = @drawing.append \g
            ..attr \class "axis y"
            ..call yAxis
            ..selectAll "text"
                ..attr \x -7
                ..attr \dy 5

window.XAxis =
    drawXAxis: ->
        xAxis = d3.svg.axis!
            ..scale @x
            ..ticks d3.time.year
            ..tickSize 4
            ..outerTickSize 0
            ..orient \bottom
        @xAxisGroup = @drawing.append \g
            ..attr \class "axis x"
            ..attr \transform "translate(0, #{@height})"
            ..call xAxis
            ..selectAll "text"
                # ..attr \x -7
                ..attr \dy 13

