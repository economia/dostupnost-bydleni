window.ValueDrawer =
    drawValue: (xPx, yPx) ->
        @valueDrawerGroup .classed \hidden xPx < 0
        xValue = @x.invert xPx
        yValue = @y.invert yPx
        lastD = -Infinity
        lastPoint = null
        yReferencePoint = null
        highlightpoints = for dataline in @datalines
            for point in dataline.values
                d = point.x - xValue
                if d > 0
                    if d < Math.abs lastD
                        lastPoint = point
                    break
                lastD = d
                lastPoint = point
            lastPoint.yDistance = Math.abs yValue - lastPoint.y
            if not yReferencePoint or yReferencePoint.yDistance > lastPoint.yDistance
                yReferencePoint = lastPoint
            lastPoint

        highlightpoints.push do
            y: 0
            type: \xAxis
            x: lastPoint.x

        x = @x lastPoint.x
        return if x is @lastDrawnX and @lastDrawnY == yReferencePoint
        @lastDrawnX = x
        @lastDrawnY = yReferencePoint
        @valueDrawerGroup
            ..classed \hidden xPx < 0
            ..attr \transform "translate(#x, 0)"
        @valueDrawerGroup.selectAll \g.text
            .data highlightpoints
            .enter!append \g
                ..attr \class \text
                ..append \rect
                    ..attr \y -22
                    ..attr \height 27
                ..append \text
                    ..attr \class \y
                    ..attr \dy -5
        occupiedYPixels = []
        bboxes = []
        correctForOccupied = (desiredY) ->
            y = Math.round desiredY
            roundY = null
            roundCount = 0
            while roundY != y and roundCount < 5
                ++roundCount
                roundY = y
                while occupiedYPixels[y] => ++y
                while occupiedYPixels[y + 20] => --y
            for offset in [0 til 20] => occupiedYPixels[y + offset] = yes
            y

        textGroups = @valueDrawerGroup.selectAll \g.text
            ..attr \transform ~> "translate(0,#{correctForOccupied @y it.y})"
            ..select \text.y
                ..attr \text-anchor \start
                ..attr \dx 5
                ..text ->
                    | it.type == \xAxis
                        "#{ig.utils.czechMonth it.x} #{it.x.getFullYear!}"
                    | otherwise
                        "#{ig.utils.formatPrice it.y} Kč (
                        #{Math.round it.y / yReferencePoint.y * 100}%)
                        ; #{indices.byty[it.byt_id]} #{indices.kraje[it.region_id]}
                        "
                ..classed \reference -> it is yReferencePoint
                ..each (d, i) -> bboxes[i] = @getBBox!
            ..select \rect
                ..attr \x 1
                ..attr \width (d, i) -> bboxes[i].width + 10
        if @width - xPx < Math.max ...bboxes.map (.width)
            textGroups
                ..select \text.y
                    ..attr \text-anchor \end
                    ..attr \dx -5
                ..select \rect
                    ..attr \x (d, i) -> bboxes[i].width * -1 - 11

    hideValueDrawer: ->
        @valueDrawerGroup.classed \hidden yes

    initValueDrawer: ->
        @valueDrawerGroup = @drawing.append \g
            ..attr \class \valueDrawer
        @valueDrawerLine = @valueDrawerGroup.append \line
            ..attr \y1 0
            ..attr \y2 @height
            ..attr \x1 0
            ..attr \x2 0

