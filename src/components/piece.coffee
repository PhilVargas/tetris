React = require 'react'
PieceMap = require 'helpers/piece-map'

Piece = React.createClass
  displayName: 'Piece'

  propTypes:
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired
    pieceType: React.PropTypes.string.isRequired
    cellHeight: React.PropTypes.number.isRequired
    cellWidth: React.PropTypes.number.isRequired
    setIndeces: React.PropTypes.func.isRequired
    rotateClockwise: React.PropTypes.func.isRequired
    rotateCounterClockwise: React.PropTypes.func.isRequired
    setIndeces: React.PropTypes.func.isRequired
    rotation: React.PropTypes.number.isRequired

  getDefaultProps: ->
    cellHeight: 20
    cellWidth: 20

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType][@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x )*@props.cellWidth) + @props.initialX
    top: (( @props.yIndex + offset.y )*@props.cellHeight) + @props.initialY

  componentDidMount: ->
    $(document).on 'keyup', @handleKeyUp

  render: ->
    <div className='piece-container'>
      <div style={ @getCoords(0) } className="piece-cell"></div>
      <div style={ @getCoords(1) } className="piece-cell"></div>
      <div style={ @getCoords(2) } className="piece-cell"></div>
      <div style={ @getCoords(3) } className="piece-cell"></div>
    </div>

  # 37 left
  # 39 right
  # 40 down
  handleKeyUp: (e) ->
    switch e.which
      when 37,65 then @props.setIndeces(xIndex: @props.xIndex - 1, yIndex: @props.yIndex)
      when 39,68 then @props.setIndeces(xIndex: @props.xIndex + 1, yIndex: @props.yIndex)
      when 40,83 then @props.setIndeces(yIndex: @props.yIndex + 1, xIndex: @props.xIndex)
      when 69 then @props.rotateClockwise()
      when 81 then @props.rotateCounterClockwise()

module.exports = Piece
