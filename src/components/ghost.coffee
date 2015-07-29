React = require 'react'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'

assign = require 'object-assign'
cx = require 'classnames'

Ghost = React.createClass
  displayName: 'Ghost'

  propTypes:
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired
    rotation: React.PropTypes.number.isRequired
    pieceType: React.PropTypes.string.isRequired
    cellEdgeLength: React.PropTypes.number.isRequired
    isVisible: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    cellEdgeLength: Settings.cellEdgeLength

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x )*@props.cellEdgeLength) + Settings.boardXOffset
    top: (( @props.yIndex + offset.y )*@props.cellEdgeLength) + Settings.boardYOffset

  containerClass: ->
    cx 'ghost-container',
      hide: !@props.isVisible

  render: ->
    <div className={ @containerClass() }>
      <div style={ @pieceCellPosition(0) } className="ghost-cell"></div>
      <div style={ @pieceCellPosition(1) } className="ghost-cell"></div>
      <div style={ @pieceCellPosition(2) } className="ghost-cell"></div>
      <div style={ @pieceCellPosition(3) } className="ghost-cell"></div>
    </div>

  pieceCellPosition: (cellIndex) ->
    assign {}, @getCoords(cellIndex),
      backgroundColor: PieceMap[@props.pieceType].color
      maxWidth: Settings.cellEdgeLength
      height: Settings.cellEdgeLength

module.exports = Ghost
