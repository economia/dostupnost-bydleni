window.XScale =
    recomputeXScale: ->
        @x ?= d3.scale.linear!
            ..domain [0 @data.0.data.length + 2]
            ..range [0 @width]


window.YScale =
    recomputeYScale: ->
        @y ?= d3.scale.linear!
            ..domain [0 30]
            ..range [@height, 0]
