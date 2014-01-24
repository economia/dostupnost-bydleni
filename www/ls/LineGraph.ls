window.LineGraph = class LineGraph implements Dimensionable, XScale, YScale, YAxis, LineDefinition, BackgroundHighligher
    (parentSelector, @fulldata, @colorScale, {width, height}:options) ->
        @data = @fulldata
        @computeDimensions width, height
        @svg = d3.select parentSelector .append \svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        @drawing = @svg.append \g
            ..attr \class \drawing
            ..attr \transform "translate(#{@margin.left}, #{@margin.top})"

        @computeScales!
        @initBackgroundHighlighter @drawing
        @drawYAxis!

    computeScales: ->
        @recomputeXScale!
        @recomputeYScale!
        @line = @getLineDefinition!
        @area = @getLineAreaDefinition!

    draw: ->
        @data =
            | @dataFilter => @fulldata.filter @dataFilter
            | otherwise   => @fulldata.slice 0
        if @dataSorter then @data.sort @dataSorter
        @drawing.selectAll \g.country.active .data @data, (.id)
            ..enter!
                ..append \g
                    ..attr \class "country active"
                    ..attr \transform "translate(0, #{@height})"
                    ..transition!
                        ..duration 600
                        ..delay 400
                        ..attr \transform "translate(0, 0)"
                    ..append \path
                        ..attr \d ~> @area it.data
                        ..attr \fill ~> @colorScale it.id
                        ..attr \data-tooltip ({id, name}) ~> name
                        ..attr \class \area
                    ..append \path
                        ..attr \d ~> @line it.data
                        ..attr \stroke ~> @colorScale it.id
                        ..attr \class \line
            ..exit!
                ..classed \active no
                ..transition!
                    ..duration 600
                    ..attr \transform "translate(0, #{@height})"
                    ..remove!




