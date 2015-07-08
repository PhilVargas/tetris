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

  getInitialState: ->
    xIndex: @props.xIndex
    yIndex: @props.yIndex

  generatePiece: ->
    <Piece
      yIndex={ @state.yIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType='line'
      setIndeces={ Action.setPieceIndeces }
    />

  # Render functions #
  componentDidMount: ->
    Store.bindChange @boardChanged

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
    for i in [0..22]
      <div
        style={ { top: @props.initialY + @props.cellHeight*i, left: @props.initialX } }
        key={ i }
        className={ cx "row collapse cell-container", { invisible: i < @props.hiddenRows } }
      >
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->
    for xCoord in [0..10]
      <Cell key={ xCoord } xIndex={ xCoord } yIndex={ yCoord } />

module.exports = Board
