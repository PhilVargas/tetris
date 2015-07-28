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
