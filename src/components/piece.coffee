React = require 'react'
PieceMap = require 'helpers/piece-map'

assign = require 'object-assign'

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
    dropPiece: React.PropTypes.func.isRequired
    rotateClockwise: React.PropTypes.func.isRequired
    rotateCounterClockwise: React.PropTypes.func.isRequired
    setIndeces: React.PropTypes.func.isRequired
    rotation: React.PropTypes.number.isRequired
    isPaused: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    cellHeight: 20
    cellWidth: 20

  getCoords: (cellNumber = 0) ->
    offset = PieceMap[@props.pieceType].shapes[@props.rotation][cellNumber]
    left: (( @props.xIndex + offset.x )*@props.cellWidth) + @props.initialX
    top: (( @props.yIndex + offset.y )*@props.cellHeight) + @props.initialY

  componentDidMount: ->
    $(document).on 'keyup', @handleKeyUp

  render: ->
    <div className='piece-container'>
      <div style={ assign {}, @getCoords(0), backgroundColor: PieceMap[@props.pieceType].color } className="piece-cell"></div>
      <div style={ assign {}, @getCoords(1), backgroundColor: PieceMap[@props.pieceType].color } className="piece-cell"></div>
      <div style={ assign {}, @getCoords(2), backgroundColor: PieceMap[@props.pieceType].color } className="piece-cell"></div>
      <div style={ assign {}, @getCoords(3), backgroundColor: PieceMap[@props.pieceType].color } className="piece-cell"></div>
    </div>

  # 37, 65 left
  # 39, 68 right
  # 40, 83 down
  # 69 q
  # 81 e
  handleKeyUp: (e) ->
    return if @props.isPaused
    switch e.which
      when 37,65 then @props.setIndeces(xIndex: @props.xIndex - 1, yIndex: @props.yIndex)
      when 39,68 then @props.setIndeces(xIndex: @props.xIndex + 1, yIndex: @props.yIndex)
      when 40,83 then @props.setIndeces(yIndex: @props.yIndex + 1, xIndex: @props.xIndex)
      when 38,87 then @props.dropPiece()
      when 69 then @props.rotateClockwise()
      when 81 then @props.rotateCounterClockwise()

module.exports = Piece
