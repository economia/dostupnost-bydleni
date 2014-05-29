require! {
    fs
    csv
}
out = "kraj_index,byt_index,datum,cena,pdb,fdbi70,fdbi85,fdbi100"
kraje = []
byty = []
c = csv!.from.stream fs.createReadStream "#__dirname/../data/bydleni_duben14.csv"
    ..on \record ([kraj-druh-R-M,kraj,rok,mesic,byt,cena,fdbi70,fdbi85,fdbi100,pdb], index) ->
        return if pdb == 'pdb'
        unless kraj in kraje => kraje.push kraj
        kraj_index = kraje.indexOf kraj
        unless byt in byty => byty.push byt
        byt_index = byty.indexOf byt
        while mesic.length < 2 => mesic = "0#mesic"
        datum = "#rok-#mesic-01"
        cena = Math.round parseInt cena, 10
        return unless cena
        fdbi70 = parseFloat fdbi70
        fdbi85 = parseFloat fdbi85
        fdbi100 = parseFloat fdbi100
        if fdbi70 > 1.5 => fdbi70 /= 100
        if fdbi85 > 1.5 => fdbi85 /= 100
        if fdbi100 > 1.5 => fdbi100 /= 100
        fdbi70 .= toFixed 2
        fdbi85 .= toFixed 2
        fdbi100 .= toFixed 2
        out += "\n"
        out += [kraj_index,byt_index,datum,cena,pdb,fdbi70,fdbi85,fdbi100].join ","

<~ c.on \end

aux = {kraje, byty}
# <~ fs.writeFile "#__dirname/../data/data.json", JSON.stringify aux
<~ fs.writeFile "#__dirname/../data/byty_normalized.csv", out
