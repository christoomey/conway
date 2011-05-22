class GameOfLife
    constructor: (@rows, @columns) ->
        @game = ($ '.game')
        @max_dim = 500 #px

    initialize: ->
        @createRow(row_id) for row_id in [1..@rows]
        @scaleCells()
        @configHover()
        @configClick()
        @configMousedown()

    scaleCells: ->
        bigger = if @rows > @columns then @rows else @columns
        cell_dim = Math.floor(@max_dim / bigger)
        cell_dim = "#{cell_dim}px"
        ($ 'td').css('height', cell_dim).css('width', cell_dim)

    createRow: (row_id) ->
        $row = ($ '<tr>')
        @createCell(row_id, col_id, $row) for col_id in [1..@columns]
        @game.append($row)

    createCell: (row_id, col_id, $row) ->
        cell_id = "#{row_id}-#{col_id}"
        console.log cell_id
        $row.append ($ "<td class='cell' id='#{cell_id}'>")

    configHover: ->
        ($ 'td').hover ->
            $this = ($ this)
            $this.addClass('hover')
            if game.game.data 'mousedown'
                $this.toggleClass 'alive'
        , ->
            ($ this).removeClass('hover')

    configClick: ->
        ($ 'td').click ->
            ($ this).toggleClass('alive')

    configMousedown: ->
        @game.mousedown =>
            @game.data 'mousedown', true
        @game.mouseup =>
            @game.data 'mousedown', false

window.game = new GameOfLife 5, 6
game.initialize()
