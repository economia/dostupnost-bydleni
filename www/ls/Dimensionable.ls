window.Dimensionable =
    margin:
        top: 4
        right: 240
        bottom: 22
        left: 65

    computeDimensions: (@fullWidth, @fullHeight) ->
        @recomputeDimensions!

    recomputeDimensions: ->
        @width = @fullWidth - @margin.left - @margin.right
        @height = @fullHeight - @margin.top - @margin.bottom
        @drawing.attr \transform "translate(#{@margin.left}, #{@margin.top})"
