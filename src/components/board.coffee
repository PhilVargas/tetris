React = require 'react'
Cell = require 'components/cell'
Piece = require 'components/piece'
Store = require 'stores/board'
Action = require 'actions/board'
cx = require 'classnames'

Board = React.createClass
  displayName: 'Board'

  propTypes:
    cellWidth: React.PropTypes.number.isRequired
    cellHeight: React.PropTypes.number.isRequired
    width: React.PropTypes.number.isRequired
    height: React.PropTypes.number.isRequired
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    hiddenRows: React.PropTypes.number.isRequired
    turnCount: React.PropTypes.number.isRequired
    currentPieceType: React.PropTypes.string.isRequired
    cells: React.PropTypes.array.isRequired
    rotation: React.PropTypes.number.isRequired

  getInitialState: ->
    turnCount: @props.turnCount
    xIndex: @props.xIndex
    yIndex: @props.yIndex
    currentPieceType: @props.currentPieceType
    cells: @props.cells
    rotation: @props.rotation

  generatePiece: ->
    <Piece
      yIndex={ @state.yIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType={ @state.currentPieceType }
      setIndeces={ Action.setPieceIndeces }
      rotateClockwise={ Action.rotateClockwise }
      rotateCounterClockwise={ Action.rotateCounterClockwise }
      rotation={ @state.rotation }
    />

  # Render functions #
  componentDidMount: ->
    Store.bindChange @boardChanged
    @startGame()

  startGame: ->
    nextTurn = =>
      if @state.turnCount < 20
        Action.nextTurn()
        setTimeout(nextTurn, 750)
      else
        alert('Game Over!')
    setTimeout(nextTurn, 750)

  boardChanged: ->
    @setState Store.getAll()

  componentWillUnmount: ->
    Store.unbindChange @boardChanged

  render: ->
    <div className="board">
      { @generateRows() }
      <div id="piece-container">{ @generatePiece() }</div>
    </div>

  generateRows: ->
    for i in [0...22]
      <div
        style={ { top: @props.initialY + @props.cellHeight*i, left: @props.initialX } }
        key={ i }
        className={ cx "row collapse cell-container", { invisible: i < @props.hiddenRows } }
      >
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->

    for xCoord in [0...10]
      cell = @state.cells[yCoord*10+xCoord]
      <Cell key={ cell.id } xIndex={ cell.xIndex } yIndex={ cell.yIndex } isFrozen={ cell.isFrozen } color={ cell.color } />

module.exports = Board
