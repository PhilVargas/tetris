React = require 'react'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'

cx = require 'classnames'
assign = require 'object-assign'

Piece = React.createClass
  displayName: 'Piece'

  propTypes:
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired
    pieceType: React.PropTypes.string.isRequired
    setIndeces: React.PropTypes.func.isRequired
    dropPiece: React.PropTypes.func.isRequired
    queuePiece: React.PropTypes.func.isRequired
    rotateClockwise: React.PropTypes.func.isRequired
    rotateCounterClockwise: React.PropTypes.func.isRequired
    setIndeces: React.PropTypes.func.isRequired
    rotation: React.PropTypes.number.isRequired
    isPaused: React.PropTypes.bool.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x)*Settings.cellEdgeLength) + Settings.boardXOffset
    top: (( @props.yIndex + offset.y )*Settings.cellEdgeLength) + Settings.boardYOffset

  componentDidMount: ->
    $(document).on
      keydown: @handleKeyDown
      keyup: @handleKeyUp

  containerClass: ->
    cx 'piece-container',
      hide: !@props.hasGameBegun

  render: ->
    <div className={ @containerClass() }>
      <div style={ @pieceCellPosition(0) } className="piece-cell"></div>
      <div style={ @pieceCellPosition(1) } className="piece-cell"></div>
      <div style={ @pieceCellPosition(2) } className="piece-cell"></div>
      <div style={ @pieceCellPosition(3) } className="piece-cell"></div>
    </div>

  pieceCellPosition: (cellIndex) ->
    assign {}, @getCoords(cellIndex),
      backgroundColor: PieceMap[@props.pieceType].color
      maxWidth: Settings.cellEdgeLength
      height: Settings.cellEdgeLength

  # 37, 65 left
  # 39, 68 right
  # 40, 83 down
  handleKeyDown: (e) ->
    return if @props.isPaused || !@props.hasGameBegun
    switch e.which
      when 37,65 then @props.setIndeces(xIndex: @props.xIndex - 1, yIndex: @props.yIndex)
      when 39,68 then @props.setIndeces(xIndex: @props.xIndex + 1, yIndex: @props.yIndex)
      when 40,83 then @props.setIndeces(yIndex: @props.yIndex + 1, xIndex: @props.xIndex)

  # 38 87, up w
  # 69 q
  # 81 e
  # 13 enter
  handleKeyUp: (e) ->
    return if @props.isPaused || !@props.hasGameBegun
    switch e.which
      when 38,87 then @props.dropPiece()
      when 69 then @props.rotateClockwise()
      when 81 then @props.rotateCounterClockwise()
      when 13 then @props.queuePiece()

module.exports = Piece
