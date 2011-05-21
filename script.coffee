class GameOfLife
    constructor: (@rows, @columns) ->
        @game = $('.game')

    createBoard: ->
        @createRow() for i in [1..@rows]

    createRow: ->
        $row = ($ '<tr>')
        $row.append('<td class="cell dead">') for i in [1..@columns]
        @game.append($row)

window.game = new GameOfLife(2,2)
game.createBoard()

