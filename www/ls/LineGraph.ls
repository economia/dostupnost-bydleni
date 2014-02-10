window.LineGraph = class LineGraph implements Dimensionable, XScale, YScale, XAxis, YAxis, LineDefinition, ValueDrawer
    (parentSelector, @fulldata, {width, height}:options) ->
        @svg = d3.select parentSelector .append \svg
            ..attr \class \LineGraph
        @drawing = @svg.append \g
            ..attr \class \drawing
        @regionsGroup = @drawing.append \g
            ..attr \class \regions
        @computeDimensions width, height
        @svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
            ..on \mousemove ~>
                {x, y} = d3.event
                @drawValue x - @margin.left, y
            ..on \mouseout @~hideValueDrawer

        @line = @getLineDefinition!
        @initValueDrawer!


    draw: (ids, fields) ->
        lines = []
        regions_assoc = {}
        regions = []
        for id in ids
            [region_id, byt_id] = id.split "-"
            if not regions_assoc[region_id]
                regions_assoc[region_id] = []
                regions.push regions_assoc[region_id]
            region = regions_assoc[region_id]
            continue if region_id is \null
            for field in fields
                values = @fulldata[id].map ->
                    y = it[field]
                    x = it.date
                    {x, y, region_id, byt_id, field}
                values .= filter -> it.y
                max =
                    x: Math.max ...values.map (.x)
                    y: Math.max ...values.map (.y)
                min =
                    x: Math.min ...values.map (.x)
                    y: Math.min ...values.map (.y)
                line = {values, min, max, field}
                region.push line
                lines.push line
        {absMax, absMin} = @computeAbsoluteLimits lines
        @datalines = regions.reduce (prev, curr) -> (prev || []) ++ curr
        @recomputeDimensions!
        @recomputeXScale [absMin.x, absMax.x] if not @firstDrawn
        @recomputeYScale [0, absMax.y]
        @drawYAxis!
        @drawXAxis!
        @regionsGroup.selectAll \g.region.active .data regions
            ..enter!append \g
                ..attr \class "region active"
            ..exit!remove!

        region = @regionsGroup.selectAll \g.region
        region.selectAll \g.line.active .data ((regionLines) -> regionLines)
            ..enter!
                ..append \g
                    ..attr \class "line active"
                    ..attr \transform "translate(0, #{@height})"
                    ..transition!
                        ..duration if @firstDrawn then 800 else 0
                        ..attr \transform "translate(0, 0)"
                    ..append \path
                        ..attr \class \line
            ..exit!
                ..classed \active no
                ..transition!
                    ..duration 600
                    ..attr \transform "translate(0, #{@height})"
                    ..remove!
        region.selectAll \g.line.active
            ..select \path.line
                ..transition!
                    ..duration if @firstDrawn then 800 else 0
                    ..attr \d ~> @line it.values
        @firstDrawn = yes

    computeAbsoluteLimits: (lines) ->
        absMax =
            x: new Date Math.max ...lines.map (.max.x)
            y: Math.max ...lines.map (.max.y)
        absMin =
            x: new Date Math.min ...lines.map (.min.x)
            y: Math.min ...lines.map (.min.y)
        {absMax, absMin}
