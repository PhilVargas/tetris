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
      BoardStore.triggerChange.mockClear()

    describe 'board:init', ->
      it 'initializes the store', ->
        expect(BoardStore.get('turnCount')).toBe 0
        expect(BoardStore.get('hasGameBegun')).toBe false

      it 'calls BoardStore.triggerChange', ->
        callback initialPayload
        expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:startGame', ->
      payload = eventName: 'board:startGame'
      beforeEach ->
        initialValue = BoardStore.get('hasGameBegun')
        callback payload

      it 'sets the `state.hasGameBegun` to true', ->
        expect(initialValue).toBe false
        expect(BoardStore.get('hasGameBegun')).toBe true

      it 'calls BoardStore.triggerChange', ->
        expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:setPieceIndeces', ->
      beforeEach ->
        initialValue = {x: BoardStore.get('xIndex'), y: BoardStore.get('yIndex')}

      describe 'when there is no collision', ->
        payload =
          eventName: 'board:setPieceIndeces'
          value:
            xIndex: 3
            yIndex: 9

        beforeEach ->
          callback payload

        it 'sets the `state.xIndex` and `state.yIndex`', ->
          expect(BoardStore.get('xIndex')).not.toBe initialValue.x
          expect(BoardStore.get('yIndex')).not.toBe initialValue.y
          expect(BoardStore.get('xIndex')).toBe payload.value.xIndex
          expect(BoardStore.get('yIndex')).toBe payload.value.yIndex

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

      describe 'when there is a collision', ->
        payload =
          eventName: 'board:setPieceIndeces'
          value:
            xIndex: 12
            yIndex: 10

        beforeEach ->
          callback payload

        it 'does not change the `state.xIndex` and `state.yIndex`', ->
          expect(BoardStore.get('xIndex')).toBe initialValue.x
          expect(BoardStore.get('yIndex')).toBe initialValue.y

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:dropPiece', ->
      payload = eventName: 'board:dropPiece'
      describe 'when there is a collision', ->
        beforeEach ->
          initialValue =
            score: BoardStore.get('score')
            scoreThisTurn: BoardStore.get('scoreThisTurn')
            yIndex: BoardStore.get('yIndex')
          BoardStore.isCollisionFree = jest.genMockFn().mockReturnValue(false)
          callback payload

        it 'does not modify the `state.yIndex`', ->
          expect(BoardStore.get('yIndex')).toBe initialValue.yIndex

        it 'does not modify the `state.scoreThisTurn`', ->
          expect(BoardStore.get('scoreThisTurn')).toBe initialValue.scoreThisTurn

        it 'does not modify the `state.score`', ->
          expect(BoardStore.get('score')).toBe initialValue.score

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

      describe 'when there is no collision', ->
        beforeEach ->
          initialValue =
            score: BoardStore.get('score')
            scoreThisTurn: BoardStore.get('scoreThisTurn')
            yIndex: BoardStore.get('yIndex')
          callback payload

        it 'drops the `state.yIndex` to the bottom of the board', ->
          expect([18,19,20]).toContain BoardStore.get('yIndex')

        it 'sets the `state.scoreThisTurn` to be > 0', ->
          expect(BoardStore.get('scoreThisTurn')).toBeGreaterThan 0

        it 'sets the `state.score` to be > 0', ->
          expect(BoardStore.get('score')).toBeGreaterThan 0

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:togglePause', ->
      payload = eventName: 'board:togglePause'

      beforeEach ->
        initialValue = BoardStore.get('isPaused')
        callback payload

      it 'toggles the state.isPaused', ->
        expect(BoardStore.get('isPaused')).toBe true

      it 'calls BoardStore.triggerChange', ->
        expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:rotatePiece', ->
      beforeEach ->
        initialValue = BoardStore.get('rotation')

      describe 'counter-clockwise (decreases rotation)', ->
        payload =
          eventName: 'board:rotatePiece'
          value: -1

        describe 'when there is a collision', ->
          beforeEach ->
            BoardStore.isCollisionFree = jest.genMockFn().mockReturnValue(false)
            callback payload

          it 'does not change the `state.rotation`', ->
            expect(BoardStore.get('rotation')).toBe initialValue

          it 'does not call BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).not.toBeCalled()

        describe 'when there is no collision', ->
          beforeEach ->
            callback payload

          it 'decreases the `state.rotation`', ->
            expect(BoardStore.get('rotation')).toBe (4 + initialValue + payload.value) % 4

          it 'calls BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).toBeCalled()

      describe 'clockwise (increasing rotation)', ->
        payload =
          eventName: 'board:rotatePiece'
          value: 1

        describe 'when there is a collision', ->
          beforeEach ->
            BoardStore.isCollisionFree = jest.genMockFn().mockReturnValue(false)
            callback payload

          it 'does not change the `state.rotation`', ->
            expect(BoardStore.get('rotation')).toBe initialValue

          it 'does not call BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).not.toBeCalled()

        describe 'when there is no collision', ->
          beforeEach ->
            callback payload

          it 'increases the state.rotation', ->
            expect(BoardStore.get('rotation')).toBe (4 + initialValue + payload.value) % 4

          it 'calls BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:queuePiece', ->
      payload = eventName: 'board:queuePiece'
      actual = null

      beforeEach ->
        actual = BoardStore.get

      describe 'when unable to queue a piece (`shouldAllowQueue` is false)', ->
        beforeEach ->
          BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'canQueuePiece' then true
              when 'shouldAllowQueue' then false
              else return actual(attr)

          initialValue =
            currentPieceType: actual('currentPieceType')
            queuePieceType: actual('queuePieceType')
          callback payload

        it 'sets `state.canQueuePiece` to false', ->
          expect(actual('canQueuePiece')).toBe false

        it 'does not change the `state.currentPieceType`', ->
          expect(actual('currentPieceType')).toBe initialValue.currentPieceType

        it 'does not change the `state.queuePieceType`', ->
          expect(actual('queuePieceType')).toBe initialValue.queuePieceType

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

      describe 'when unable to queue a piece (`canQueuePiece` is false)', ->
        beforeEach ->
          BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'canQueuePiece' then false
              when 'shouldAllowQueue' then true
              else return actual(attr)

          initialValue =
            currentPieceType: actual('currentPieceType')
            queuePieceType: actual('queuePieceType')
          callback payload

        it 'sets `state.canQueuePiece` to false', ->
          expect(actual('canQueuePiece')).toBe false

        it 'does not change the `state.currentPieceType`', ->
          expect(actual('currentPieceType')).toBe initialValue.currentPieceType

        it 'does not change the `state.queuePieceType`', ->
          expect(actual('queuePieceType')).toBe initialValue.queuePieceType

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

      describe 'when able to queue a piece', ->
        describe 'when a piece is not already in the queue', ->
          beforeEach ->
            BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
              switch attr
                when 'canQueuePiece' then true
                when 'shouldAllowQueue' then true
                when 'queuePieceType' then ''
                else return actual(attr)
            initialValue =
              currentPieceType: BoardStore.get('currentPieceType')
              queuePieceType: actual('queuePieceType')
            callback payload

          it 'sets the `state.queuePieceType` to the initial `currentPieceType`', ->
            expect(actual('queuePieceType')).not.toBe initialValue.queuePieceType
            expect(actual('queuePieceType')).toBe initialValue.currentPieceType

          it 'calls BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).toBeCalled()

        describe 'when a piece is already in the queue', ->
          beforeEach ->
            BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
              switch attr
                when 'canQueuePiece' then true
                when 'shouldAllowQueue' then true
                when 'queuePieceType' then 'T'
                else actual(attr)
            initialValue =
              currentPieceType: BoardStore.get('currentPieceType')
              queuePieceType: BoardStore.get('queuePieceType')
            callback payload

          it 'sets the `state.queuePieceType` to the initial `currentPieceType`', ->
            expect(actual('queuePieceType')).toBe initialValue.currentPieceType

          it 'sets the `state.currentPieceType` to the initial `queuePieceType`', ->
            expect(initialValue.queuePieceType).toBeTruthy()
            expect(BoardStore.get('currentPieceType')).toBe initialValue.queuePieceType

          it 'calls BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:toggleQueue', ->
      payload = eventName: 'board:toggleQueue'

      beforeEach ->
        initialValue =
          shouldAllowQueue: BoardStore.get('shouldAllowQueue')
        callback payload

      it 'toggles the `state.shouldAllowQueue`', ->
        expect(BoardStore.get('shouldAllowQueue')).toBe !initialValue.shouldAllowQueue

      it 'calls BoardStore.triggerChange', ->
        expect(BoardStore.triggerChange).toBeCalled()

    describe 'board:toggleGhost', ->
      payload = eventName: 'board:toggleGhost'

      beforeEach ->
        initialValue =
          isGhostVisible: BoardStore.get('isGhostVisible')
        callback payload

      it 'toggles the `state.isGhostVisible`', ->
        expect(BoardStore.get('isGhostVisible')).toBe !initialValue.isGhostVisible

      it 'calls BoardStore.triggerChange', ->
        expect(BoardStore.triggerChange).toBeCalled()


