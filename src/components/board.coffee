React = require 'react'
Action = require 'actions/game'
Cell = require 'components/cell'
BoardPiece = require 'containers/board-piece'
GhostPiece = require 'containers/ghost-piece'
Overlay = require 'components/board-overlay'
Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'
PieceMap = require 'helpers/piece-map'

cx = require 'classnames'
Board = React.createClass
  displayName: 'Board'

  propTypes:
    cellEdgeLength: React.PropTypes.number.isRequired
    cells: React.PropTypes.array.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired
    isColorblindActive: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    level: React.PropTypes.number.isRequired
    nextTurn: React.PropTypes.func.isRequired
    restartGame: React.PropTypes.func.isRequired
    score: React.PropTypes.number.isRequired
    startGame: React.PropTypes.func.isRequired

  startGame: ->
    unless @props.hasGameBegun
      @props.startGame()
    setTimeout(@nextTick, Settings.initialTurnDelay)

  nextTick: ->
    delay = Calculate.turnDelay(@props.level)
    unless @props.isGameOver
      @props.nextTurn()
      setTimeout(@nextTick, delay)

  restartGame: ->
    @props.restartGame()
    setTimeout(@nextTick, Settings.initialTurnDelay)

  render: ->
    <div id='board' className='columns large-6'>
      <div className='row'>
        <div className='columns board-pieces-container' style={ @innerBoardStyles() }>
          <div id='board-rows'>
            { @generateRows() }
          </div>
          <BoardPiece />
          <GhostPiece />
          <Overlay {...@overlayProps()} />
        </div>
      </div>
    </div>

  innerBoardStyles: ->
    width: @props.cellEdgeLength * Settings.boardWidth + 2*Settings.innerBoardBorderWidth
    border: "#{Settings.innerBoardBorderWidth}px solid black"

  overlayProps: ->
    isPaused: @props.isPaused
    isMuted: @props.isMuted
    hasGameBegun: @props.hasGameBegun
    startGame: @startGame
    restartGame: @restartGame
    score: @props.score
    isGameOver: @props.isGameOver

  rowClass: (i) ->
    cx "row collapse cell-container", { 'hidden-row': i < Settings.hiddenRows }

  generateRows: ->
    for i in [0...Settings.boardHeight]
      <div key={ i } className={ @rowClass(i) } style={ maxHeight: @props.cellEdgeLength }>
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->
    for xCoord in [0...Settings.boardWidth]
      cell = @props.cells[Calculate.cellIndexFromCoords(xCoord, yCoord)]
      <Cell key={ cell.id } color={ PieceMap[cell.cellPieceType].color(@props.isColorblindActive) } cellEdgeLength={ @props.cellEdgeLength } />



module.exports = Board
