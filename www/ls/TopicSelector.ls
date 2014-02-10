window.TopicSelector = class TopicSelector
    (@parentSelector) ->
        topics =
            *   name: "Ceny běžných bytů"
                byty: [0, 1, 2]
                fields: <[cena]>
                active: yes
            *   name: "Ceny bytů 4+1"
                byty: [3]
                fields: <[cena]>
            *   name: "Dostupnost hypotéky"
                byty: [4]
                fields: <[fdbi70 fdbi85 fdbi100]>
            *   name: "Dostupnost bydlení"
                byty: [4]
                fields: <[pdb]>
        ul = d3.select @parentSelector .append \ul
            ..attr \class \TopicSelector
        @items = ul.selectAll \li .data topics .enter!append \li
                ..classed \active (.active)
                ..append \a
                    ..html (.name)
