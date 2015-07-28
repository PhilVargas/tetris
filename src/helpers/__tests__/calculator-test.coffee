Calc = require.requireActual 'helpers/calculator'
Settings = require.requireActual 'helpers/settings'

describe 'Calculator', ->
  describe '#turnDelay', ->
    it 'returns a floor of `Settings.minTurnDelay`', ->
      expect(Calc.turnDelay(Number.POSITIVE_INFINITY)).toBe Settings.minTurnDelay

    it 'calculates the turnDelay', ->
      expect(Calc.turnDelay(0)).toBe 500
      expect(Calc.turnDelay(1)).toBe 450
      expect(Calc.turnDelay(2)).toBe 400
      expect(Calc.turnDelay(3)).toBe 350
      expect(Calc.turnDelay(4)).toBe 300
      expect(Calc.turnDelay(5)).toBe 250

  describe '#level', ->
    it 'returns a ceiling of `Settings.maxLevel`', ->
      expect(Calc.level(Number.POSITIVE_INFINITY)).toBe Settings.maxLevel

    it 'calculates the level', ->
      expect(Calc.level(0)).toBe 0
      expect(Calc.level(10)).toBe 1
      expect(Calc.level(20)).toBe 2
      expect(Calc.level(30)).toBe 3
      expect(Calc.level(40)).toBe 4

  describe '#scoreThisTurn', ->
    describe 'calculates the score', ->
      it 'gives a higher score based on the `totalLinesCleared`', ->
        expect(Calc.scoreThisTurn(0, 0)).toBe 0
        expect(Calc.scoreThisTurn(1, 0)).toBe 40
        expect(Calc.scoreThisTurn(2, 0)).toBe 100
        expect(Calc.scoreThisTurn(3, 0)).toBe 300
        expect(Calc.scoreThisTurn(4, 0)).toBe 1200

      it 'gives a higher score based on the `scoreMultiplier` (level)', ->
        expect(Calc.scoreThisTurn(1, 0)).toBe 40
        expect(Calc.scoreThisTurn(1, 1)).toBe 80
        expect(Calc.scoreThisTurn(1, 2)).toBe 120
        expect(Calc.scoreThisTurn(1, 3)).toBe 160

  describe '#rotation', ->
    it 'increments the rotation by +/- 1', ->
      expect(Calc.rotation(1,1)).toBe 2
      expect(Calc.rotation(1,-1)).toBe 0

    it 'has bounds [0,4)', ->
      expect(0 <= Calc.rotation(1000,1) < 4).toBe true
      expect(0 <= Calc.rotation(-1000,1) < 4).toBe true
      expect(Calc.rotation(3,1)).toBe 0
      expect(Calc.rotation(0,-1)).toBe 3
