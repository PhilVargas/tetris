React = require 'react'
PieceMap = require 'helpers/piece-map'
cx = require 'classnames'

assign = require 'object-assign'

DisplayPiece = React.createClass
  displayName: 'DisplayerPiece'

  propTypes:
    cellEdgeLength: React.PropTypes.number.isRequired
    cellClass: React.PropTypes.string
    containerClass: React.PropTypes.string
    id: React.PropTypes.string
    isColorblindActive: React.PropTypes.bool.isRequired
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    isDisabled: React.PropTypes.bool.isRequired
    pieceTitle: React.PropTypes.string.isRequired
    pieceType: React.PropTypes.string.isRequired

  getDefaultProps: ->
    cellEdgeLength: 20
    initialY: 40
    initialX: 40

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[0][cellNumber]
    initialCoords = PieceMap[@props.pieceType].displayPieceCoords
    left: (offset.x * @props.cellEdgeLength) + initialCoords.left + @props.initialX
    top: (offset.y * @props.cellEdgeLength) + initialCoords.top + @props.initialY

  renderCells: ->
    for i in [0..3]
      <div key={ i } style={ assign {}, @getCoords(i), backgroundColor: PieceMap[@props.pieceType].color(@props.isColorblindActive) } className={ @props.cellClass }></div>

  render: ->
    <div id={ @props.id } className={ @props.containerClass }>
      <div className="pieces-title">{ @props.pieceTitle }</div>
      <div className={ cx "pieces-container", disabled: !@props.pieceType || @props.isDisabled }>
        { @renderCells() if @props.pieceType }
      </div>
    </div>

module.exports = DisplayPiece
