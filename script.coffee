class GameOfLife
    constructor: (@rows, @columns) ->
        @board = ($ '.board')
        @max_dim = 500 #px
        @toUpdate = [] # cache cells which need to update during tick
        @cells = []
        @running = false
        @timeout = 1

    initialize: ->
        @populateBoard()
        @scaleCells()
        @configHover()
        @configClick()
        @configMousedown()
        @setRandomPattern()
        # @createGlider(150)

    scaleCells: ->
        bigger = if @rows > @columns then @rows else @columns
        cell_dim = Math.floor(@max_dim / bigger)
        cell_dim = 4
        cell_dim = "#{cell_dim}px"
        ($ 'td').css('height', cell_dim).css('width', cell_dim)

    populateBoard: =>
        for row in [1..@rows]
            $row = ($ '<tr>')
            $row.appendTo @board
            for column in [1..@columns]
                cell = new Cell(this, row, column)
                $row.append cell.element
                @cells.push cell

    setRandomPattern: =>
        for cell in @cells
            cell.element.addClass('alive') if Math.random() > 0.499999

    indexForRowCol: (row, column) => (row-1)*@rows+column-1

    configHover: ->
        ($ 'td').hover ->
            $this = ($ this)
            $this.addClass('hover')
            if game.board.data 'mousedown'
                $this.toggleClass 'alive'
        , ->
            ($ this).removeClass('hover')

    configClick: ->
        ($ 'td').click ->
            ($ this).toggleClass('alive')

    configMousedown: ->
        @board.mousedown =>
            @board.data 'mousedown', true
        @board.mouseup =>
            @board.data 'mousedown', false

    tick: =>
        cell.evolve() for cell in @cells
        cell.element.toggleClass('alive') for cell in @toUpdate
        @toUpdate.length = 0
        setTimeout(@tick, @timeout) if @running

    createGlider: (index) =>
        seed = @cells[index]
        glider_cells = [seed]
        glider_cells.push(@cells[@indexForRowCol(seed.row-1, seed.column)])
        glider_cells.push(@cells[@indexForRowCol(seed.row-2, seed.column)])
        glider_cells.push(@cells[@indexForRowCol(seed.row, seed.column-1)])
        glider_cells.push(@cells[@indexForRowCol(seed.row-1, seed.column-2)])
        cell.element.addClass('alive') for cell in glider_cells

class Cell
    constructor: (@board, @row, @column) ->
        @element = ($ "<td>")
        @index = @board.indexForRowCol @row, @column
        @update = false # Cache need to update during tick

    neighboringCells: =>
        row_above = if @row > 1 then @row-1 else @board.rows
        row_below = if @row < @board.rows then @row+1 else 1
        rows = [@row, row_above, row_below]

        column_above = if @column > 1 then @column-1 else @board.columns
        column_below = if @column < @board.columns then @column+1 else 1
        columns = [@column, column_above, column_below]

        neighbors = []
        for row in rows
            for column in columns
                neighbor = @board.cells[@board.indexForRowCol(row, column)]
                neighbors.push neighbor if neighbor isnt this
        return neighbors

    isAlive: => @element.hasClass('alive')

    evolve: =>
        neighbors = @neighboringCells()
        living = (neighbor for neighbor in neighbors when neighbor.isAlive())
        if this.isAlive()
            @stageUpdate() if living.length < 2 # Underpopulation
            @stageUpdate() if living.length > 3 # Overpopulation
        else
            @stageUpdate() if living.length == 3 # Reproduction

    stageUpdate: =>
        @board.toUpdate.push this

size = 120
window.game = new GameOfLife size, size
game.initialize()

($ '#ticker').click -> game.tick()
($ '#runner').click ->
    game.running = true
    game.tick()

($ '#stopper').click -> game.running = false

