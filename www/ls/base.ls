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
    {width: window.innerWidth, height: window.innerHeight}
graph.draw do
    <[0-2 0-1 0-0 2-2 2-1 2-0]>
    <[cena]>
