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
      <div style={ assign {}, @getCoords(0), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
      <div style={ assign {}, @getCoords(1), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
      <div style={ assign {}, @getCoords(2), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
      <div style={ assign {}, @getCoords(3), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
    </div>

module.exports = Ghost
