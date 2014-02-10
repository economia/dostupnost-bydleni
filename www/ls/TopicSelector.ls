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
                tooltip: """Jakou část měsíčního příjmu domácnosti zkonzumuje hypotéka v závislosti na spoluúčasti (penězích zaplacených "z vlastní kapsy")"""
                byty: [4]
                fields: <[fdbi70 fdbi85 fdbi100]>
            *   name: "Dostupnost bydlení"
                tooltip: "Počet celoročních příjmů domácnosti nutných k zakoupení bytu"
                byty: [4]
                fields: <[pdb]>
        ul = d3.select @parentSelector .append \ul
            ..attr \class \TopicSelector
        tooltip = d3.select @parentSelector .append \div
            ..attr \class \selector-tooltip
        @items = ul.selectAll \li .data topics .enter!append \li
                ..classed \active (.active)
                ..append \a
                    ..html (.name)
                    ..on \mouseover ->
                        tooltip.html it.tooltip
                    ..on \mouseout -> tooltip.html ""
