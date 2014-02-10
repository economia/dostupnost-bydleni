window.CZMap = class CZMap
    ({@width, @height, parentSelector}) ->
        @projection = d3.geo.mercator!
            ..precision 0
        @svg = d3.select \body .append \svg
            ..attr \class \CZMap

    draw: (features) ->
        bounds = @getBounds features
        @project bounds
        @path = d3.geo.path!
            ..projection @projection
        @svg.selectAll \path.feature .data features
            ..enter!append \path
                ..attr \class \feature
            ..exit!remove!

        @paths = @svg.selectAll \path.feature
            ..attr \d @path

    getBounds: (features) ->
        north = -Infinity
        west  = +Infinity
        south = +Infinity
        east  = -Infinity
        features.forEach (feature) ->
            [[w,s],[e,n]] = d3.geo.bounds feature
            if n > north => north := n
            if w < west  => west  := w
            if s < south => south := s
            if e > east  => east  := e

        [[west, south], [east, north]]

    project: ([[west, south], [east, north]]:bounds) ->
        displayedPercent = (Math.abs west - east) / 360
        @projection
            ..scale @width / (Math.PI * 2 * displayedPercent)
            ..center [west, north]
            ..translate [0 0]

        [x0, y0] = @projection [west, north]
        [x1, y1] = @projection [east, south]
        @svg
            ..attr \width x1 - x0
            ..attr \height y1 - y0
        @projection
