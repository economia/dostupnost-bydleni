require! {
    fs
    csv
}
out = "kraj_index,byt_index,datum,cena,pdb,fdbi70,fdbi85,fdbi100"
kraje = []
byty = []
c = csv!.from.stream fs.createReadStream "#__dirname/../data/bydleni.csv"
    ..on \record ([id,kraj-druh-R-M,id_kraj,rok,mesic,druh,cena,fdbi70,fdbi85,fdbi100,pdb,kraj,byt,datum], index) ->
        return if id == 'id'
        unless kraj in kraje => kraje.push kraj
        kraj_index = kraje.indexOf kraj
        unless byt in byty => byty.push byt
        byt_index = byty.indexOf byt
        datum = datum.substr 0 10
        cena = Math.round parseInt cena, 10
        fdbi70 = parseInt fdbi70, 10
        fdbi85 = parseInt fdbi85, 10
        fdbi100 = parseInt fdbi100, 10
        if fdbi70 > 1.5 => fdbi70 /= 100
        if fdbi85 > 1.5 => fdbi85 /= 100
        if fdbi100 > 1.5 => fdbi100 /= 100
        out += "\n"
        out += [kraj_index,byt_index,datum,cena,pdb,fdbi70,fdbi85,fdbi100].join ","

<~ c.on \end

aux = {kraje, byty}
<~ fs.writeFile "#__dirname/../data/data.json", JSON.stringify aux
<~ fs.writeFile "#__dirname/../data/byty_normalized.csv", out
