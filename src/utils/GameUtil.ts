import { IBoardCell, CellType, IGameState, PieceType, BoardCells, IScoredBoardCells, LinesCleared } from '../typings'
import { BoardSettings, GameSettings } from '../constants/Settings'
import Calculator from './Calculator'
import { Pieces } from '../constants/Settings/GameSettings'

const generateDefaultCells = (rows = BoardSettings.height): Array<IBoardCell> => {
  return [...Array(rows)].reduce((cells: Array<IBoardCell>, _, yCoord: number) => {
    return [...Array(BoardSettings.width)].reduce((cells: Array<IBoardCell>, _, xCoord: number) => {
      cells.push({
        id: Calculator.cellIndexFromCoords({ xCoord, yCoord }),
        yCoord,
        xCoord,
        isFrozen: false,
        cellType: CellType.E
      })
      return cells
    }, cells)
  }, [])
}

const generateShiftedCells = (atRowIndex: number, cells: BoardCells): BoardCells => {
  const shiftedId = (atRowIndex + 1) * BoardSettings.width
  const shiftedCells = cells.map((shiftedCell: IBoardCell): IBoardCell => {
    if (shiftedCell.id < shiftedId) {
      const cell = cells[shiftedCell.id - BoardSettings.width]
      return { ...cell, id: shiftedCell.id }
    } else {
      return shiftedCell
    }
  }).slice(BoardSettings.width, BoardSettings.height * BoardSettings.width)
  const emptyCells = generateDefaultCells(1)
  return emptyCells.concat(shiftedCells)
}

const scoreRowsForTurn = (boardCells: BoardCells, totalLinesCleared: number): IScoredBoardCells => {
  let linesClearedThisTurn: LinesCleared = 0
  let cells = [...boardCells]
  while (Calculator.isAnyRowFrozen(cells)) {
    linesClearedThisTurn = linesClearedThisTurn + 1 as LinesCleared
    let lowestFrozenRowIndex = Calculator.getFrozenRowIndices(cells).pop()
    if (lowestFrozenRowIndex == null) { break }
    cells = generateShiftedCells(lowestFrozenRowIndex, cells)
  }
  const scoreThisTurn = Calculator.scoreThisTurn(linesClearedThisTurn, Calculator.level(totalLinesCleared))
  return { cells, scoreThisTurn, linesClearedThisTurn }
}
const generateRandomPieceType = (): PieceType => {
  const randomIndex = Math.floor(Math.random() * Pieces.length)
  return Pieces[randomIndex]
}

const freezeCells = (cells: BoardCells, pieceIds: Array<number>, currentPieceType: PieceType): BoardCells => {
  return cells.map((cell: IBoardCell) => {
    if (pieceIds.includes(cell.id)) {
      cell.cellType = currentPieceType
    }
    return cell
  })
}

const GameUtil = {
  generateDefaultCells,
  generateRandomPieceType,
  generateShiftedCells,
  freezeCells,
  scoreRowsForTurn,
  generateInitialState: (): IGameState => {
    return {
      ...GameSettings,
      ...BoardSettings,
      cells: generateDefaultCells(),
      currentPieceType: generateRandomPieceType()
    }
  }
}

export default GameUtil
