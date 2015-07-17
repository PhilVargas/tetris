React = require 'react'
PieceMap = require 'helpers/piece-map'

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
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    isVisible: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    cellEdgeLength: 20

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x )*@props.cellEdgeLength) + @props.initialX
    top: (( @props.yIndex + offset.y )*@props.cellEdgeLength) + @props.initialY

  containerClass: ->
    cx 'ghost-container',
      hidden: !@props.isVisible

  render: ->
    <div className={ @containerClass() }>
      <div style={ assign {}, @getCoords(0), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
      <div style={ assign {}, @getCoords(1), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
      <div style={ assign {}, @getCoords(2), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
      <div style={ assign {}, @getCoords(3), backgroundColor: PieceMap[@props.pieceType].color } className="ghost-cell"></div>
    </div>

module.exports = Ghost
