window.Dimensionable =
    margin:
        top: 0
        right: 0
        bottom: 0
        left: 85

    computeDimensions: (@fullWidth, @fullHeight) ->
        @recomputeDimensions!

    recomputeDimensions: ->
        @width = @fullWidth - @margin.left - @margin.right
        @height = @fullHeight - @margin.top - @margin.bottom
        @drawing.attr \transform "translate(#{@margin.left}, #{@margin.top})"
