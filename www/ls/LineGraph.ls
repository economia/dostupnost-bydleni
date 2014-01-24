window.LineGraph = class LineGraph implements Dimensionable, XScale, YScale, YAxis, LineDefinition
    (parentSelector, @fulldata, {width, height}:options) ->
        @svg = d3.select parentSelector .append \svg
        @drawing = @svg.append \g
            ..attr \class \drawing
        @computeDimensions width, height
        @svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight

        @line = @getLineDefinition!


    draw: (ids, fields) ->
        lines = []
        for id in ids
            for field in fields
                values = @fulldata[id].map ->
                    y = it[field]
                    x = it.date
                    {x, y}
                max =
                    x: Math.max ...values.map (.x)
                    y: Math.max ...values.map (.y)
                min =
                    x: Math.min ...values.map (.x)
                    y: Math.min ...values.map (.y)
                lines.push {values, min, max, field}
        {absMax, absMin} = @computeAbsoluteLimits lines
        @recomputeDimensions!
        @recomputeXScale [absMin.x, absMax.x]
        @recomputeYScale [0, absMax.y]
        @drawYAxis!
        @drawing.selectAll \g.line.active .data lines
            ..enter!
                ..append \g
                    ..attr \class "line active"
                    ..attr \transform "translate(0, #{@height})"
                    ..transition!
                        ..duration 100
                        # ..delay 400
                        ..attr \transform "translate(0, 0)"
                    ..append \path
                        ..attr \d ~> @line it.values
                        ..attr \class \line
            ..exit!
                ..classed \active no
                ..transition!
                    ..duration 600
                    ..attr \transform "translate(0, #{@height})"
                    ..remove!

    computeAbsoluteLimits: (lines) ->
        absMax =
            x: Math.max ...lines.map (.max.x)
            y: Math.max ...lines.map (.max.y)
        absMin =
            x: Math.min ...lines.map (.min.x)
            y: Math.min ...lines.map (.min.y)
        {absMax, absMin}
