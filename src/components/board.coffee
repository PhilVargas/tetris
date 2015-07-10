React = require 'react'
Cell = require 'components/cell'
Piece = require 'components/piece'
Ghost = require 'components/ghost'
DisplayPiece = require 'components/display-piece'
Store = require 'stores/board'
Action = require 'actions/board'
Settings = require 'helpers/settings'
$ = require('jquery')
cx = require 'classnames'

Board = React.createClass
  displayName: 'Board'

  propTypes:
    width: React.PropTypes.number.isRequired
    height: React.PropTypes.number.isRequired
    cellEdgeLength: React.PropTypes.number.isRequired
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    hiddenRows: React.PropTypes.number.isRequired
    turnCount: React.PropTypes.number.isRequired
    currentPieceType: React.PropTypes.string.isRequired
    nextPieceType: React.PropTypes.string.isRequired
    queuePieceType: React.PropTypes.string.isRequired
    cells: React.PropTypes.array.isRequired
    rotation: React.PropTypes.number.isRequired
    score: React.PropTypes.number.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    cellEdgeLength: Settings.cellEdgeLength
    initialX: Settings.boardXOffset
    initialY: Settings.boardYOffest
    hiddenRows: Settings.hiddenRows
    width: Settings.boardWidth
    height: Settings.boardHeight

  getInitialState: ->
    turnCount: @props.turnCount
    xIndex: @props.xIndex
    yIndex: @props.yIndex
    ghostYIndex: @props.ghostYIndex
    currentPieceType: @props.currentPieceType
    queuePieceType: @props.queuePieceType
    nextPieceType: @props.nextPieceType
    cells: @props.cells
    rotation: @props.rotation
    isGameOver: @props.isGameOver
    isPaused: @props.isPaused
    score: @props.score

  generatePiece: ->
    <Piece
      yIndex={ @state.yIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType={ @state.currentPieceType }
      setIndeces={ Action.setPieceIndeces }
      rotateClockwise={ Action.rotateClockwise }
      dropPiece={ Action.dropPiece }
      queuePiece={ Action.queuePiece }
      rotateCounterClockwise={ Action.rotateCounterClockwise }
      rotation={ @state.rotation }
      isPaused={ @state.isPaused }
    />

  generateGhost: ->
    <Ghost
      yIndex={ @state.ghostYIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType={ @state.currentPieceType }
      rotation={ @state.rotation }
    />

  generateNextPiece: ->
    <DisplayPiece
      pieceType={ @state.nextPieceType }
      cellClass='next-cell'
      id="next-piece-container"
      pieceTitle='Next Piece'
    />

  generateQueuePiece: ->
    <DisplayPiece
      pieceType={ @state.queuePieceType }
      cellClass='queue-cell'
      id='queue-piece-container'
      pieceTitle='Queued Piece'
      isDisabled={ !@state.canQueuePiece }
    />

  # Render functions #
  componentDidMount: ->
    Store.bindChange @boardChanged
    $(document).on 'keyup', (e) ->
      Action.togglePause() if e.which == 32
    @startGame()

  startGame: ->
    nextTurn = =>
      delay = Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - @state.turnCount)
      if @state.isGameOver
        alert('Game Over!')
      else
        Action.nextTurn()
        setTimeout(nextTurn, delay)
    setTimeout(nextTurn, Settings.initialTurnDelay)

  boardChanged: ->
    @setState Store.getAll()

  componentWillUnmount: ->
    Store.unbindChange @boardChanged

  render: ->
    <div className="board">
      { @state.score }
      { @generateRows() }
      { @generatePiece() }
      { @generateGhost() }
      { @generateNextPiece() }
      { @generateQueuePiece() }
    </div>

  generateRows: ->
    for i in [0...22]
      <div
        style={ { top: @props.initialY + @props.cellEdgeLength*i, left: @props.initialX } }
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
