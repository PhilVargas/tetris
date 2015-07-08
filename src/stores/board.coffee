Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'

assign = require 'object-assign'

boardData = null
BoardStore =
  get: (attr) ->
    boardData[attr]

  getAll: ->
    frozenCells: boardData.frozenCells
    xIndex: boardData.xIndex
    yIndex: boardData.yIndex
    initialX: boardData.initialX
    initialY: boardData.initialY
    width: boardData.width
    height: boardData.height
    cellWidth: boardData.cellWidth
    cellHeight: boardData.cellHeight
    hiddenRows: boardData.hiddenRows

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

class BoardData
  constructor: ->
    @frozenCells = {}
    @xIndex = 5
    @yIndex = 0
    @initialX = 200
    @initialY = 0
    @width = 10
    @height = 22
    @cellWidth = 20
    @cellHeight = 20
    @hiddenRows = 2

  updateAttribs: (attribs) ->
    assign(this, attribs)

Dispatcher.register (payload) ->
  switch payload.eventName
    when 'board:init'
      boardData = new BoardData()
    when 'board:setPieceIndeces'
      boardData.updateAttribs(xIndex: payload.value.xIndex, yIndex: payload.value.yIndex)
      BoardStore.triggerChange()


MicroEvent.mixin( BoardStore )
module.exports = BoardStore
