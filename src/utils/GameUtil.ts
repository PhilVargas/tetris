import { IBoardCell, CellType, IGameState, PieceType } from '../typings'
import { BoardSettings, GameSettings } from '../constants/Settings'
import Calculator from './Calculator'
import { Pieces } from '../constants/Settings/GameSettings'

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

const generateRandomPieceType = (): PieceType => {
  const randomIndex = Math.floor(Math.random() * Pieces.length)
  return Pieces[randomIndex]
}

const GameUtil = {
  generateDefaultCells,
  generateRandomPieceType,
  generateInitialState: (): IGameState => {
    return {
      ...GameSettings,
      ...BoardSettings,
      cells: generateDefaultCells(),

    }
  }
}

export default GameUtil
