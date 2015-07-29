React = require 'react'
Action = require 'actions/game'
Cell = require 'components/cell'
Piece = require 'components/piece'
Ghost = require 'components/ghost'
Overlay = require 'components/board-overlay'
Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'

cx = require 'classnames'
Board = React.createClass
  displayName: 'Board'

  propTypes:
    cells: React.PropTypes.array.isRequired
    currentPieceType: React.PropTypes.string.isRequired
    ghostYIndex: React.PropTypes.number.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isGhostVisible: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    restartGame: React.PropTypes.func.isRequired
    rotation: React.PropTypes.number.isRequired
    score: React.PropTypes.number.isRequired
    startGame: React.PropTypes.func.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired

  render: ->
    <div id='board' className='columns large-6'>
      <div className='row'>
        <div className='columns board-pieces-container' style={ @innerBoardStyles }>
          <div id='board-rows'>
            { @generateRows() }
          </div>
          <Piece {...@pieceProps()} />
          <Ghost {...@ghostProps()} />
          <Overlay {...@overlayProps()} />
        </div>
      </div>
    </div>

  innerBoardStyles:
    width: Settings.cellEdgeLength * Settings.boardWidth + 2*Settings.innerBoardBorderWidth
    border: "#{Settings.innerBoardBorderWidth}px solid black"

  overlayProps: ->
    isPaused: @props.isPaused
    hasGameBegun: @props.hasGameBegun
    startGame: @props.startGame
    restartGame: @props.restartGame
    score: @props.score
    isGameOver: @props.isGameOver

  pieceProps: ->
    dropPiece: Action.dropPiece
    hasGameBegun: @props.hasGameBegun
    isPaused: @props.isPaused
    pieceType: @props.currentPieceType
    queuePiece: Action.queuePiece
    rotateClockwise: Action.rotateClockwise
    rotateCounterClockwise: Action.rotateCounterClockwise
    rotation: @props.rotation
    setIndeces: Action.setPieceIndeces
    xIndex: @props.xIndex
    yIndex: @props.yIndex

  ghostProps: ->
    isVisible: @props.isGhostVisible && @props.hasGameBegun
    pieceType: @props.currentPieceType
    rotation: @props.rotation
    xIndex: @props.xIndex
    yIndex: @props.ghostYIndex

  rowClass: (i) ->
    cx "row collapse cell-container", { 'hidden-row': i < Settings.hiddenRows }

  generateRows: ->
    for i in [0...Settings.boardHeight]
      <div key={ i } className={ @rowClass(i) } style={ maxHeight: Settings.cellEdgeLength }>
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->
    for xCoord in [0...Settings.boardWidth]
      cell = @props.cells[Calculate.cellIndexFromCoords(xCoord, yCoord)]
      <Cell key={ cell.id } xIndex={ cell.xIndex } yIndex={ cell.yIndex } isFrozen={ cell.isFrozen } color={ cell.color } />

module.exports = Board
