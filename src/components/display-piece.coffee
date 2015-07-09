React = require 'react'
PieceMap = require 'helpers/piece-map'
cx = require 'classnames'

assign = require 'object-assign'

DisplayPiece = React.createClass
  displayName: 'DisplayerPiece'

  propTypes:
    pieceType: React.PropTypes.string.isRequired
    pieceTitle: React.PropTypes.string.isRequired
    cellEdgeLength: React.PropTypes.number.isRequired
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    isDisabled: React.PropTypes.bool

  getDefaultProps: ->
    cellEdgeLength: 20
    initialY: 40
    initialX: 40
    isDisabled: false

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[0][cellNumber]
    initialCoords = PieceMap[@props.pieceType].displayPieceCoords
    left: (offset.x * @props.cellEdgeLength) + initialCoords.left + @props.initialX
    top: (offset.y * @props.cellEdgeLength) + initialCoords.top + @props.initialY

  renderCells: ->
    for i in [0..3] when @props.pieceType
      <div key={ i } style={ assign {}, @getCoords(i), backgroundColor: PieceMap[@props.pieceType].color } className={ @props.cellClass }></div>

  render: ->
    <div id={ @props.id } className={ @props.containerClass }>
      <div className="pieces-title">{ @props.pieceTitle }</div>
      <div className={ cx "pieces-container", disabled: !@props.pieceType || @props.isDisabled }>
        { @renderCells() }
      </div>
    </div>

module.exports = DisplayPiece