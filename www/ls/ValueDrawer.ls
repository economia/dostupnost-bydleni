window.ValueDrawer =
    drawValue: (xPx, yPx) ->
        @valueDrawerGroup .classed \hidden xPx < 0
        xValue = @x.invert xPx
        lastD = -Infinity
        lastPoint = null
        highlightpoints = for dataline in @datalines
            for point in dataline.values
                d = point.x - xValue
                if d > 0
                    if d < Math.abs lastD
                        lastPoint = point
                    break
                lastD = d
                lastPoint = point
            lastPoint
        x = @x lastPoint.x
        return if x is @lastDrawnX
        @lastDrawnX = x
        @valueDrawerGroup
            ..classed \hidden xPx < 0
            ..attr \transform "translate(#x, 0)"
        @valueDrawerGroup.selectAll \g.text
            .data highlightpoints
            .enter!append \g
                ..attr \class \text
                ..append \rect
                    ..attr \x 1
                    ..attr \y -4
                    ..attr \height 27
                ..append \text
                    ..attr \class \y
                    ..attr \dy 14
                    ..attr \dx 5
        bboxes = []
        @valueDrawerGroup.selectAll \g.text
            ..attr \transform ~> "translate(0,#{@y it.y})"
            ..select \text.y
                ..text -> "#{window.utils.formatPrice it.y} Kč"
                ..each (d, i) -> bboxes[i] = @getBBox!
            ..select \rect
                ..attr \width (d, i) -> bboxes[i].width + 10



    initValueDrawer: ->
        @valueDrawerGroup = @drawing.append \g
            ..attr \class \valueDrawer
        @valueDrawerLine = @valueDrawerGroup.append \line
            ..attr \y1 0
            ..attr \y2 @height
            ..attr \x1 0
            ..attr \x2 0

