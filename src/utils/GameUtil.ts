import { IBoardCell, CellType, IGameState } from '../typings'
import { BoardSettings, GameSettings } from '../constants/Settings'
import Calculator from './Calculator'

const generateDefaultCells = (): Array<IBoardCell> => {
  return [...Array(BoardSettings.height)].reduce((cells: Array<IBoardCell>, _, yCoord: number) => {
    return [...Array(BoardSettings.width)].reduce((cells: Array<IBoardCell>, _, xCoord: number) => {
      cells.push({
        id: Calculator.cellIndexFromCoords(xCoord, yCoord),
        yCoord,
        xCoord,
        isFrozen: false,
        cellType: CellType.E
      })
      return cells
    }, cells)
  }, [])
}

const GameUtil = {
  generateDefaultCells,
  generateInitialState: (): IGameState => {
    return {
      ...GameSettings,
      ...BoardSettings,
      cells: generateDefaultCells()
    }
  }
}

export default GameUtil
