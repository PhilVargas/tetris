React = require 'react'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'

cx = require 'classnames'
assign = require 'object-assign'

Piece = React.createClass
  displayName: 'Piece'

  propTypes:
    cellClass: React.PropTypes.string.isRequired
    containerClass: React.PropTypes.string.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired
    pieceType: React.PropTypes.string.isRequired
    rotation: React.PropTypes.number.isRequired
    isVisible: React.PropTypes.bool.isRequired

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x)*Settings.cellEdgeLength) + Settings.boardXOffset
    top: (( @props.yIndex + offset.y )*Settings.cellEdgeLength) + Settings.boardYOffset

  containerClass: ->
    cx @props.containerClass,
      hide: !@props.isVisible

  render: ->
    <div className={ @containerClass() }>
      <div style={ @pieceCellPosition(0) } className={ @props.cellClass }></div>
      <div style={ @pieceCellPosition(1) } className={ @props.cellClass }></div>
      <div style={ @pieceCellPosition(2) } className={ @props.cellClass }></div>
      <div style={ @pieceCellPosition(3) } className={ @props.cellClass }></div>
    </div>

  pieceCellPosition: (cellIndex) ->
    assign {}, @getCoords(cellIndex),
      backgroundColor: PieceMap[@props.pieceType].color
      maxWidth: Settings.cellEdgeLength
      height: Settings.cellEdgeLength

module.exports = Piece
