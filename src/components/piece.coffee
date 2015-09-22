React = require 'react'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'

cx = require 'classnames'
assign = require 'object-assign'

Piece = React.createClass
  displayName: 'Piece'

  propTypes:
    cellClass: React.PropTypes.string.isRequired
    cellEdgeLength: React.PropTypes.number.isRequired
    containerClass: React.PropTypes.string.isRequired
    isColorblindActive: React.PropTypes.bool.isRequired
    isVisible: React.PropTypes.bool.isRequired
    pieceType: React.PropTypes.string.isRequired
    rotation: React.PropTypes.number.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x) * @props.cellEdgeLength) + Settings.boardXOffset
    top: (( @props.yIndex + offset.y ) * @props.cellEdgeLength) + Settings.boardYOffset

  containerClass: ->
    cx @props.containerClass,
      hide: !@props.isVisible

  render: ->
    <div className={ @containerClass() }>
      <div style={ @pieceCellStyle(0) } className={ @props.cellClass }></div>
      <div style={ @pieceCellStyle(1) } className={ @props.cellClass }></div>
      <div style={ @pieceCellStyle(2) } className={ @props.cellClass }></div>
      <div style={ @pieceCellStyle(3) } className={ @props.cellClass }></div>
    </div>

  pieceCellStyle: (cellIndex) ->
    assign {}, @getCoords(cellIndex),
      backgroundColor: PieceMap[@props.pieceType].color(@props.isColorblindActive)
      maxWidth: @props.cellEdgeLength
      height: @props.cellEdgeLength

module.exports = Piece
