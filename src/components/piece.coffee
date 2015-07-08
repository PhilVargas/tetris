React = require 'react'

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

  getDefaultProps: ->
    cellHeight: 20
    cellWidth: 20

  getCoords: (cellNumber = 0) ->
    offset = @pieceMap['line'][cellNumber]
    left: (( @props.xIndex + offset.x )*@props.cellWidth) + @props.initialX
    top: (( @props.yIndex + offset.y )*@props.cellHeight) + @props.initialY

  componentDidMount: ->
    $(document).on 'keyup', (e) =>
      @handleKeyUp(e)

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
    switch
      when e.which == 37 && @isCollisionFree(xIndex: @props.xIndex - 1, yIndex: @props.yIndex)
        @props.setIndeces(xIndex: @props.xIndex - 1, yIndex: @props.yIndex)
      when e.which == 39 && @isCollisionFree(xIndex: @props.xIndex + 1, yIndex: @props.yIndex)
        @props.setIndeces(xIndex: @props.xIndex + 1, yIndex: @props.yIndex)
      when e.which == 40 && @isCollisionFree(xIndex: @props.xIndex, yIndex: @props.yIndex + 1)
        @props.setIndeces(yIndex: @props.yIndex + 1, xIndex: @props.xIndex)

  isCollisionFree: (nextPosition) ->
    isCollisionFree = true
    for a in @pieceMap[@props.pieceType] when !(0 <= nextPosition.xIndex + a.x <= 10) || 22 < nextPosition.yIndex + a.y
      isCollisionFree = false
    isCollisionFree

  pieceMap:
    line: [
      { x: 0, y: 0 }
      { x: 0, y: 1 }
      { x: 0, y: 2 }
      { x: 0, y: 3 }
    ]

module.exports = Piece
