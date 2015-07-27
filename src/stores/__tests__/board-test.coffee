describe 'BoardStore', ->
  Dispatcher = BoardStore = callback = null

  beforeEach ->
    Dispatcher = require('dispatcher')
    BoardStore = require.requireActual('stores/board')
    callback = Dispatcher.register.mock.calls[0][0]
    BoardStore.triggerChange = jest.genMockFunction()

  it 'registers a call with the dispatcher', ->
    expect(Dispatcher.register.mock.calls.length).toBe(1)

  describe '#drawGhost', ->
    initialPayload = eventName: 'board:init'
    beforeEach -> callback initialPayload

    it 'sets the state.ghostYIndex to the bottom cells', ->
      expect([18,19,20]).toContain BoardStore.get('ghostYIndex')

  describe 'dispatcher actions', ->
    initialValue = null
    initialPayload = eventName: 'board:init'
    beforeEach ->
      callback initialPayload

    describe 'board:init', ->
      it 'initializes the store', ->
        expect(BoardStore.get('turnCount')).toBe 0
        expect(BoardStore.get('hasGameBegun')).toBe false

    describe 'board:startGame', ->
      payload = eventName: 'board:startGame'
      beforeEach ->
        initialValue = BoardStore.get('hasGameBegun')
        callback payload

      it 'sets the `state.hasGameBegun` to true', ->
        expect(initialValue).toBe false
        expect(BoardStore.get('hasGameBegun')).toBe true

    describe 'board:setPieceIndeces', ->
      beforeEach ->
        initialValue = {x: BoardStore.get('xIndex'), y: BoardStore.get('yIndex')}

      describe 'when the piece will be collision free', ->
        payload =
          eventName: 'board:setPieceIndeces'
          value:
            xIndex: 3
            yIndex: 9

        beforeEach ->
          callback payload

        it 'sets the state.xIndex and state.yIndex', ->
          expect(BoardStore.get('xIndex')).not.toBe initialValue.x
          expect(BoardStore.get('yIndex')).not.toBe initialValue.y
          expect(BoardStore.get('xIndex')).toBe payload.value.xIndex
          expect(BoardStore.get('yIndex')).toBe payload.value.yIndex

      describe 'when the piece has a collision', ->
        payload =
          eventName: 'board:setPieceIndeces'
          value:
            xIndex: 12
            yIndex: 10

        beforeEach ->
          callback payload

        it 'does not change the state.xIndex and state.yIndex', ->
          expect(BoardStore.get('xIndex')).toBe initialValue.x
          expect(BoardStore.get('yIndex')).toBe initialValue.y

    describe 'board:dropPiece', ->
      payload = eventName: 'board:dropPiece'
      beforeEach ->
        initialValue =
          score: BoardStore.get('score')
          scoreThisTurn: BoardStore.get('scoreThisTurn')
          yIndex: BoardStore.get('yIndex')
        callback payload

      it 'drops the state.yIndex to the bottom off the board', ->
        expect([18,19,20]).toContain BoardStore.get('yIndex')

