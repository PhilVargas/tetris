Calc = require.requireActual 'helpers/calculator'
Settings = require.requireActual 'helpers/settings'

describe 'Calculator', ->
  # Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - (50*level))
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

  # Math.min(10, totalLinesCleared // 10)
  # where // === integer division
  describe '#level', ->
    it 'returns a ceiling of `Settings.maxLevel`', ->
      expect(Calc.level(Number.POSITIVE_INFINITY)).toBe Settings.maxLevel

    it 'calculates the level', ->
      expect(Calc.level(0)).toBe 0
      expect(Calc.level(10)).toBe 1
      expect(Calc.level(20)).toBe 2
      expect(Calc.level(30)).toBe 3
      expect(Calc.level(40)).toBe 4

  # [0,40,100,300,1200][linesClearedThisTurn] * ( 1 + scoreMultiplier )
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

  # |(4 + increment + currentRotation) % 4|
  describe '#rotation', ->
    it 'increments the rotation by +/- 1', ->
      expect(Calc.rotation(1,1)).toBe 2
      expect(Calc.rotation(1,-1)).toBe 0

    it 'has bounds [0,4)', ->
      expect(0 <= Calc.rotation(1000,1) < 4).toBe true
      expect(0 <= Calc.rotation(-1000,1) < 4).toBe true
      expect(Calc.rotation(3,1)).toBe 0
      expect(Calc.rotation(0,-1)).toBe 3

  # (xCoord + boardWith*yCoord)
  describe '#cellIndexFromCoords', ->
    it 'calculates the flat index from a cells x/y coordinates', ->
      expect(Calc.cellIndexFromCoords(5,5)).toBe 55
      expect(Calc.cellIndexFromCoords(Settings.boardWidth,Settings.boardHeight)).toBe Settings.boardWidth * (1 + Settings.boardHeight)

  # (Settings.cellEdgeLength + boardDisplaySize)
  describe '#cellEdgeLength', ->
    it 'it calculates the cell `cellEdgeLength`', ->
      expect(Calc.cellEdgeLength(5)).toBe Settings.cellEdgeLength + 5

