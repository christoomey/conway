class GameOfLife
    constructor: (@rows, @columns) ->
        @game = ($ '.game')
        @max_dim = 700 #px

    initialize: ->
        @createRow() for i in [1..@rows]
        @scaleCells()
        @configHover()
        @configClick()
        @configMousedown()

    scaleCells: ->
        bigger = if @rows > @columns then @rows else @columns
        cell_dim = Math.floor(@max_dim / bigger)
        cell_dim = "#{cell_dim}px"
        ($ 'td').css('height', cell_dim).css('width', cell_dim)

    createRow: ->
        $row = ($ '<tr>')
        $row.append('<td class="cell">') for i in [1..@columns]
        @game.append($row)

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

window.game = new GameOfLife 50, 60
game.initialize()
