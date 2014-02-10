(err, kraje) <~ d3.json "../data/kraje.topo.json"
{features} = topojson.feature kraje, kraje.objects.kraje
(err, data) <~ d3.csv "../data/byty_normalized.csv", (line) ->
    line.byt = indices.byty[line.byt_index]
    line.kraj = indices.kraje[line.kraj_index]
    <[cena byt_index kraj_index]>.forEach ->
        line[it] = parseInt line[it], 10
    <[fdbi70 fdbi85 fdbi100 pdb]>.forEach ->
        line[it] = parseFloat line[it]
    line.date = new Date line.datum
    line

grouped = {}
for datum in data
    id = [datum.kraj_index, datum.byt_index].join '-'
    grouped[id] ?= []
        ..push datum

graph = new LineGraph do
    \.bydleni
    grouped
    {width: window.innerWidth - 240, height: window.innerHeight}

czMaps = []
currentKraje = [0 2]
currentByty = [2 1 0]
currentFields = ["cena"]
topoToIndices = [0 1 10 5 4 3 6 12 11 2 7 8 9 13]
czMaps[0] = new CZMap width: 220, parentSelector: \.bydleni
    ..draw features
    ..svg.classed \first yes
    ..paths.on \click (d, i) ->
        console.log i, indices.kraje[topoToIndices[i]]

czMaps[1] = new CZMap width: 220, parentSelector: \.bydleni
    ..draw features
    ..svg.classed \second yes

refreshMapActiveness = ->
    czMaps.forEach (map, index) ->
        map.paths.classed \active (d, i) -> topoToIndices[i] == currentKraje[index]
redrawGraph = ->
    datalines = []
    currentKraje.forEach (kraj) ->
        currentByty.forEach (byt) ->
            datalines.push "#kraj-#byt"
    graph.draw do
        datalines
        currentFields

refreshMapActiveness!
redrawGraph!
