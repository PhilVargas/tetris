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
      actual = null

      describe 'when the game is not over (`@state.isGameOver = false`)', ->
        beforeEach ->
          actual = BoardStore.get
          BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isGameOver' then false
              else return actual(attr)
          initialValue = actual('isPaused')
          callback payload

        it 'toggles the `state.isPaused`', ->
          expect(actual('isPaused')).toBe !initialValue

        it 'calls BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).toBeCalled()

      describe 'when the game is over (`@state.isGameOver = true`)', ->
        beforeEach ->
          actual = BoardStore.get
          BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isGameOver' then true
              else return actual(attr)
          initialValue = actual('isPaused')
          callback payload

        it 'does not toggle the `state.isPaused`', ->
          expect(actual('isPaused')).toBe initialValue

        it 'does not call BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).not.toBeCalled()

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
            canQueuePiece: actual('canQueuePiece')
          callback payload

        it 'does not change `state.canQueuePiece`', ->
          expect(actual('canQueuePiece')).toBe actual('canQueuePiece')

        it 'does not change the `state.currentPieceType`', ->
          expect(actual('currentPieceType')).toBe initialValue.currentPieceType

        it 'does not change the `state.queuePieceType`', ->
          expect(actual('queuePieceType')).toBe initialValue.queuePieceType

        it 'does not call BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).not.toBeCalled()

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
            canQueuePiece: actual('canQueuePiece')
          callback payload

        it 'does not change `state.canQueuePiece`', ->
          expect(actual('canQueuePiece')).toBe actual('canQueuePiece')

        it 'does not change the `state.currentPieceType`', ->
          expect(actual('currentPieceType')).toBe initialValue.currentPieceType

        it 'does not change the `state.queuePieceType`', ->
          expect(actual('queuePieceType')).toBe initialValue.queuePieceType

        it 'does not call BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).not.toBeCalled()

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
    describe 'board:nextTurn', ->
      actual = null
      beforeEach ->
        actual = BoardStore.get
      payload = eventName: 'board:nextTurn'

      describe 'when the game is paused (`state.isPaused` = true)', ->
        beforeEach ->
          BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isPaused' then true
              else return actual(attr)

          initialValue =
            turnCount: actual('turnCount')
          callback payload

        it 'does not increment the `state.turnCount`', ->
          expect(actual('turnCount')).toBe initialValue.turnCount

        it 'does not call BoardStore.triggerChange', ->
          expect(BoardStore.triggerChange).not.toBeCalled()

      describe 'when the game is not paused (`state.isPaused` = false)', ->
        beforeEach ->
          BoardStore.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isPaused' then false
              else return actual(attr)

        describe 'when the piece has a collision', ->
          beforeEach ->
            BoardStore.isCollisionFree = jest.genMockFn().mockReturnValue(false)

          describe 'when the player does not lose the game', ->
            beforeEach ->
              BoardStore.didPlayerLose = jest.genMockFn().mockReturnValue(false)

            describe 'when the player does not score / clear a row', ->
              mockValue = null
              beforeEach ->
                mockValue =
                  scoreThisTurn: 0
                  linesClearedThisTurn: 0
                BoardStore.scoreRows = jest.genMockFn().mockReturnValue(mockValue)

                initialValue =
                  currentPieceType: actual('currentPieceType')
                  nextPieceType: actual('nextPieceType')
                  score: actual('score')
                  linesCleared: actual('linesCleared')
                callback payload

              it 'sets the `state.currentPieceType` to the `state.nextPieceType`', ->
                expect(actual('currentPieceType')).toBe initialValue.nextPieceType

              it 'does not increase the `state.score`', ->
                expect(actual('score')).toBe(initialValue.score + mockValue.scoreThisTurn)

              it 'does not increase the `state.linesCleared`', ->
                expect(actual('linesCleared')).toBe initialValue.linesCleared+ mockValue.linesClearedThisTurn

              it 'does not change the `state.didPlayerLose`', ->
                expect(actual('isGameOver')).toBe false

              it 'calls BoardStore.triggerChange', ->
                expect(BoardStore.triggerChange).toBeCalled()

            describe 'when the player scores / clears a row', ->
              mockValue = null
              beforeEach ->
                mockValue =
                  scoreThisTurn: 40
                  linesClearedThisTurn: 1
                BoardStore.scoreRows = jest.genMockFn().mockReturnValue(mockValue)

                initialValue =
                  currentPieceType: actual('currentPieceType')
                  nextPieceType: actual('nextPieceType')
                  score: actual('score')
                  linesCleared: actual('linesCleared')
                callback payload

              it 'sets the `state.currentPieceType` to the `state.nextPieceType`', ->
                expect(actual('currentPieceType')).toBe initialValue.nextPieceType

              it 'changes the `state.score`', ->
                expect(actual('score')).toBe(initialValue.score + mockValue.scoreThisTurn)

              it 'changes the `state.linesCleared`', ->
                expect(actual('linesCleared')).toBe initialValue.linesCleared+ mockValue.linesClearedThisTurn

              it 'does not change the `state.didPlayerLose`', ->
                expect(actual('isGameOver')).toBe false

              it 'calls BoardStore.triggerChange', ->
                expect(BoardStore.triggerChange).toBeCalled()


          describe 'when the player loses the game', ->
            beforeEach ->
              BoardStore.didPlayerLose = jest.genMockFn().mockReturnValue(true)

              initialValue =
                isGameOver: actual('isGameOver')
                score: actual('score')
                scoreThisTurn: actual('scoreThisTurn')
                yIndex: actual('yIndex')
                xIndex: actual('xIndex')
                turnCount: actual('turnCount')
              callback payload

            it 'changes the `state.didPlayerLose` to `true`', ->
              expect(initialValue.isGameOver).toBe false
              expect(actual('isGameOver')).toBe true

            it 'calls BoardStore.triggerChange', ->
              expect(BoardStore.triggerChange).toBeCalled()

        describe 'when the piece has no collision', ->
          beforeEach ->
            BoardStore.isCollisionFree = jest.genMockFn().mockReturnValue(true)

            initialValue =
              yIndex: actual('yIndex')
              turnCount: actual('turnCount')
            callback payload

          it 'increments the `state.yIndex`', ->
            expect(actual('yIndex')).toBe initialValue.yIndex + 1

          it 'increments the `state.turnCount`', ->
            expect(actual('turnCount')).toBe initialValue.turnCount + 1

          it 'calls BoardStore.triggerChange', ->
            expect(BoardStore.triggerChange).toBeCalled()

