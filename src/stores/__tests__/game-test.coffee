describe 'Store', ->
  Dispatcher = Store = callback = null

  beforeEach ->
    Dispatcher = require('dispatcher')
    Store = require.requireActual('stores/game')
    callback = Dispatcher.register.mock.calls[0][0]
    Store.triggerChange = jest.genMockFunction()

  it 'registers a call with the dispatcher', ->
    expect(Dispatcher.register.mock.calls.length).toBe(1)

  describe '#drawGhost', ->
    initialPayload = eventName: 'game:init'
    beforeEach -> callback initialPayload

    it 'sets the state.ghostYIndex to the bottom cells', ->
      expect([18,19,20]).toContain Store.get('ghostYIndex')

  describe 'dispatcher actions', ->
    initialValue = null
    initialPayload = eventName: 'game:init'
    beforeEach ->
      callback initialPayload
      Store.triggerChange.mockClear()

    describe 'game:init', ->
      it 'initializes the store', ->
        expect(Store.get('turnCount')).toBe 0
        expect(Store.get('hasGameBegun')).toBe false

      it 'calls Store.triggerChange', ->
        callback initialPayload
        expect(Store.triggerChange).toBeCalled()

    describe 'game:startGame', ->
      payload = eventName: 'game:startGame'
      beforeEach ->
        initialValue = Store.get('hasGameBegun')
        callback payload

      it 'sets the `state.hasGameBegun` to true', ->
        expect(initialValue).toBe false
        expect(Store.get('hasGameBegun')).toBe true

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'game:setPieceIndeces', ->
      beforeEach ->
        initialValue = {x: Store.get('xIndex'), y: Store.get('yIndex')}

      describe 'when there is no collision', ->
        payload =
          eventName: 'game:setPieceIndeces'
          value:
            xIndex: 3
            yIndex: 9

        beforeEach ->
          callback payload

        it 'sets the `state.xIndex` and `state.yIndex`', ->
          expect(Store.get('xIndex')).not.toBe initialValue.x
          expect(Store.get('yIndex')).not.toBe initialValue.y
          expect(Store.get('xIndex')).toBe payload.value.xIndex
          expect(Store.get('yIndex')).toBe payload.value.yIndex

        it 'calls Store.triggerChange', ->
          expect(Store.triggerChange).toBeCalled()

      describe 'when there is a collision', ->
        payload =
          eventName: 'game:setPieceIndeces'
          value:
            xIndex: 12
            yIndex: 10

        beforeEach ->
          callback payload

        it 'does not change the `state.xIndex` and `state.yIndex`', ->
          expect(Store.get('xIndex')).toBe initialValue.x
          expect(Store.get('yIndex')).toBe initialValue.y

        it 'calls Store.triggerChange', ->
          expect(Store.triggerChange).toBeCalled()

    describe 'game:dropPiece', ->
      payload = eventName: 'game:dropPiece'
      describe 'when there is a collision', ->
        beforeEach ->
          initialValue =
            score: Store.get('score')
            scoreThisTurn: Store.get('scoreThisTurn')
            yIndex: Store.get('yIndex')
          Store.isCollisionFree = jest.genMockFn().mockReturnValue(false)
          callback payload

        it 'does not modify the `state.yIndex`', ->
          expect(Store.get('yIndex')).toBe initialValue.yIndex

        it 'does not modify the `state.scoreThisTurn`', ->
          expect(Store.get('scoreThisTurn')).toBe initialValue.scoreThisTurn

        it 'does not modify the `state.score`', ->
          expect(Store.get('score')).toBe initialValue.score

        it 'calls Store.triggerChange', ->
          expect(Store.triggerChange).toBeCalled()

      describe 'when there is no collision', ->
        beforeEach ->
          initialValue =
            score: Store.get('score')
            scoreThisTurn: Store.get('scoreThisTurn')
            yIndex: Store.get('yIndex')
          callback payload

        it 'drops the `state.yIndex` to the bottom of the board', ->
          expect([18,19,20]).toContain Store.get('yIndex')

        it 'sets the `state.scoreThisTurn` to be > 0', ->
          expect(Store.get('scoreThisTurn')).toBeGreaterThan 0

        it 'sets the `state.score` to be > 0', ->
          expect(Store.get('score')).toBeGreaterThan 0

        it 'calls Store.triggerChange', ->
          expect(Store.triggerChange).toBeCalled()

    describe 'game:togglePause', ->
      payload = eventName: 'game:togglePause'
      actual = null

      describe 'when the game is not over (`@state.isGameOver = false`)', ->
        beforeEach ->
          actual = Store.get
          Store.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isGameOver' then false
              else return actual(attr)
          initialValue = actual('isPaused')
          callback payload

        it 'toggles the `state.isPaused`', ->
          expect(actual('isPaused')).toBe !initialValue

        it 'calls Store.triggerChange', ->
          expect(Store.triggerChange).toBeCalled()

      describe 'when the game is over (`@state.isGameOver = true`)', ->
        beforeEach ->
          actual = Store.get
          Store.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isGameOver' then true
              else return actual(attr)
          initialValue = actual('isPaused')
          callback payload

        it 'does not toggle the `state.isPaused`', ->
          expect(actual('isPaused')).toBe initialValue

        it 'does not call Store.triggerChange', ->
          expect(Store.triggerChange).not.toBeCalled()

    describe 'game:rotatePiece', ->
      beforeEach ->
        initialValue = Store.get('rotation')

      describe 'counter-clockwise (decreases rotation)', ->
        payload =
          eventName: 'game:rotatePiece'
          value: -1

        describe 'when there is a collision', ->
          beforeEach ->
            Store.isCollisionFree = jest.genMockFn().mockReturnValue(false)
            callback payload

          it 'does not change the `state.rotation`', ->
            expect(Store.get('rotation')).toBe initialValue

          it 'does not call Store.triggerChange', ->
            expect(Store.triggerChange).not.toBeCalled()

        describe 'when there is no collision', ->
          beforeEach ->
            callback payload

          it 'decreases the `state.rotation`', ->
            expect(Store.get('rotation')).toBe (4 + initialValue + payload.value) % 4

          it 'calls Store.triggerChange', ->
            expect(Store.triggerChange).toBeCalled()

      describe 'clockwise (increasing rotation)', ->
        payload =
          eventName: 'game:rotatePiece'
          value: 1

        describe 'when there is a collision', ->
          beforeEach ->
            Store.isCollisionFree = jest.genMockFn().mockReturnValue(false)
            callback payload

          it 'does not change the `state.rotation`', ->
            expect(Store.get('rotation')).toBe initialValue

          it 'does not call Store.triggerChange', ->
            expect(Store.triggerChange).not.toBeCalled()

        describe 'when there is no collision', ->
          beforeEach ->
            callback payload

          it 'increases the state.rotation', ->
            expect(Store.get('rotation')).toBe (4 + initialValue + payload.value) % 4

          it 'calls Store.triggerChange', ->
            expect(Store.triggerChange).toBeCalled()

    describe 'game:queuePiece', ->
      payload = eventName: 'game:queuePiece'
      actual = null

      beforeEach ->
        actual = Store.get

      describe 'when unable to queue a piece (`shouldAllowQueue` is false)', ->
        beforeEach ->
          Store.get = jest.genMockFn().mockImplementation (attr) ->
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

        it 'does not call Store.triggerChange', ->
          expect(Store.triggerChange).not.toBeCalled()

      describe 'when unable to queue a piece (`canQueuePiece` is false)', ->
        beforeEach ->
          Store.get = jest.genMockFn().mockImplementation (attr) ->
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

        it 'does not call Store.triggerChange', ->
          expect(Store.triggerChange).not.toBeCalled()

      describe 'when able to queue a piece', ->
        describe 'when a piece is not already in the queue', ->
          beforeEach ->
            Store.get = jest.genMockFn().mockImplementation (attr) ->
              switch attr
                when 'canQueuePiece' then true
                when 'shouldAllowQueue' then true
                when 'queuePieceType' then ''
                else return actual(attr)
            initialValue =
              currentPieceType: Store.get('currentPieceType')
              queuePieceType: actual('queuePieceType')
            callback payload

          it 'sets the `state.queuePieceType` to the initial `currentPieceType`', ->
            expect(actual('queuePieceType')).not.toBe initialValue.queuePieceType
            expect(actual('queuePieceType')).toBe initialValue.currentPieceType

          it 'calls Store.triggerChange', ->
            expect(Store.triggerChange).toBeCalled()

        describe 'when a piece is already in the queue', ->
          beforeEach ->
            Store.get = jest.genMockFn().mockImplementation (attr) ->
              switch attr
                when 'canQueuePiece' then true
                when 'shouldAllowQueue' then true
                when 'queuePieceType' then 'T'
                else actual(attr)
            initialValue =
              currentPieceType: Store.get('currentPieceType')
              queuePieceType: Store.get('queuePieceType')
            callback payload

          it 'sets the `state.queuePieceType` to the initial `currentPieceType`', ->
            expect(actual('queuePieceType')).toBe initialValue.currentPieceType

          it 'sets the `state.currentPieceType` to the initial `queuePieceType`', ->
            expect(initialValue.queuePieceType).toBeTruthy()
            expect(Store.get('currentPieceType')).toBe initialValue.queuePieceType

          it 'calls Store.triggerChange', ->
            expect(Store.triggerChange).toBeCalled()

    describe 'game:toggleQueue', ->
      payload = eventName: 'game:toggleQueue'

      beforeEach ->
        initialValue =
          shouldAllowQueue: Store.get('shouldAllowQueue')
        callback payload

      it 'toggles the `state.shouldAllowQueue`', ->
        expect(Store.get('shouldAllowQueue')).toBe !initialValue.shouldAllowQueue

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'game:toggleGhost', ->
      payload = eventName: 'game:toggleGhost'

      beforeEach ->
        initialValue =
          isGhostVisible: Store.get('isGhostVisible')
        callback payload

      it 'toggles the `state.isGhostVisible`', ->
        expect(Store.get('isGhostVisible')).toBe !initialValue.isGhostVisible

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'game:nextTurn', ->
      actual = null
      beforeEach ->
        actual = Store.get
      payload = eventName: 'game:nextTurn'

      describe 'when the game is paused (`state.isPaused` = true)', ->
        beforeEach ->
          Store.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isPaused' then true
              else return actual(attr)

          initialValue =
            turnCount: actual('turnCount')
          callback payload

        it 'does not increment the `state.turnCount`', ->
          expect(actual('turnCount')).toBe initialValue.turnCount

        it 'does not call Store.triggerChange', ->
          expect(Store.triggerChange).not.toBeCalled()

      describe 'when the game is not paused (`state.isPaused` = false)', ->
        beforeEach ->
          Store.get = jest.genMockFn().mockImplementation (attr) ->
            switch attr
              when 'isPaused' then false
              else return actual(attr)

        describe 'when the piece has a collision', ->
          beforeEach ->
            Store.isCollisionFree = jest.genMockFn().mockReturnValue(false)

          describe 'when the player does not lose the game', ->
            beforeEach ->
              Store.didPlayerLose = jest.genMockFn().mockReturnValue(false)

            describe 'when the player does not score / clear a row', ->
              mockValue = null
              beforeEach ->
                mockValue =
                  scoreThisTurn: 0
                  linesClearedThisTurn: 0
                Store.scoreRows = jest.genMockFn().mockReturnValue(mockValue)

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

              it 'calls Store.triggerChange', ->
                expect(Store.triggerChange).toBeCalled()

            describe 'when the player scores / clears a row', ->
              mockValue = null
              beforeEach ->
                mockValue =
                  scoreThisTurn: 40
                  linesClearedThisTurn: 1
                Store.scoreRows = jest.genMockFn().mockReturnValue(mockValue)

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

              it 'calls Store.triggerChange', ->
                expect(Store.triggerChange).toBeCalled()


          describe 'when the player loses the game', ->
            beforeEach ->
              Store.didPlayerLose = jest.genMockFn().mockReturnValue(true)

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

            it 'calls Store.triggerChange', ->
              expect(Store.triggerChange).toBeCalled()

        describe 'when the piece has no collision', ->
          beforeEach ->
            Store.isCollisionFree = jest.genMockFn().mockReturnValue(true)

            initialValue =
              yIndex: actual('yIndex')
              turnCount: actual('turnCount')
            callback payload

          it 'increments the `state.yIndex`', ->
            expect(actual('yIndex')).toBe initialValue.yIndex + 1

          it 'increments the `state.turnCount`', ->
            expect(actual('turnCount')).toBe initialValue.turnCount + 1

          it 'calls Store.triggerChange', ->
            expect(Store.triggerChange).toBeCalled()

    describe 'game:setBoardDisplaySize', ->
      payload =
        eventName: 'game:setBoardDisplaySize'
        value: 5

      beforeEach ->
        initialValue = Store.get('boardDisplaySize')
        callback payload

      it 'changes the board display size', ->
        expect(initialValue).toBe 0
        expect(Store.get('boardDisplaySize')).toBe 5

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()



