React = require 'react'
Action = require 'actions/game'
Cell = require 'components/cell'
Piece = require 'components/piece'
Overlay = require 'components/board-overlay'
Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'

cx = require 'classnames'
Board = React.createClass
  displayName: 'Board'

  propTypes:
    cellEdgeLength: React.PropTypes.number.isRequired
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
        <div className='columns board-pieces-container' style={ @innerBoardStyles() }>
          <div id='board-rows'>
            { @generateRows() }
          </div>
          <Piece {...@pieceProps()} />
          <Piece {...@ghostProps()} />
          <Overlay {...@overlayProps()} />
        </div>
      </div>
    </div>

  innerBoardStyles: ->
    width: @props.cellEdgeLength * Settings.boardWidth + 2*Settings.innerBoardBorderWidth
    border: "#{Settings.innerBoardBorderWidth}px solid black"

  overlayProps: ->
    isPaused: @props.isPaused
    hasGameBegun: @props.hasGameBegun
    startGame: @props.startGame
    restartGame: @props.restartGame
    score: @props.score
    isGameOver: @props.isGameOver

  pieceProps: ->
    cellClass: 'piece-cell'
    cellEdgeLength: @props.cellEdgeLength
    containerClass: 'piece-container'
    isVisible: @props.hasGameBegun
    pieceType: @props.currentPieceType
    rotation: @props.rotation
    xIndex: @props.xIndex
    yIndex: @props.yIndex

  ghostProps: ->
    cellClass: 'ghost-cell'
    cellEdgeLength: @props.cellEdgeLength
    containerClass: 'ghost-container'
    isVisible: @props.isGhostVisible && @props.hasGameBegun
    pieceType: @props.currentPieceType
    rotation: @props.rotation
    xIndex: @props.xIndex
    yIndex: @props.ghostYIndex

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
      <Cell key={ cell.id } color={ cell.color } cellEdgeLength={ @props.cellEdgeLength } />



module.exports = Board
