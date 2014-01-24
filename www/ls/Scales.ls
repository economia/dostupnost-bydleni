window.XScale =
    recomputeXScale: (domain) ->
        @x ?= d3.scale.linear!
            ..domain domain
            ..range [0 @width]


window.YScale =
    recomputeYScale: (domain) ->
        @y ?= d3.scale.linear!
            ..domain domain
            ..range [@height, 0]
