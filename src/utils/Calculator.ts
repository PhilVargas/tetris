import { PieceType, PieceShape, IPieceOffset, ICoordinate, Rotation, RotationDirection, BoardCells, CellType, IBoardCell, LinesCleared, Level } from '../typings'
import { GameSettings, BoardSettings, PieceShapeMap, PossibleBaseScorePerTurn } from '../constants/Settings'

const cellIndexFromCoords = (coordinate: ICoordinate): number => {
  const { xCoord, yCoord } = coordinate
  return xCoord + (BoardSettings.width * yCoord)
}

const getCellIdsForPiece = (coordinate: ICoordinate, rotation: Rotation, currentPieceType: PieceType): Array<number> => {
  const { xCoord, yCoord } = coordinate
  const shape: PieceShape = PieceShapeMap[currentPieceType][rotation]
  return shape.reduce((cellIds: Array<number>, pieceOffset: IPieceOffset): Array<number> => {
    const offsetXCoord = xCoord + pieceOffset.x
    const offsetYCoord = yCoord + pieceOffset.y
    const coordinate: ICoordinate = { xCoord: offsetXCoord, yCoord: offsetYCoord }
    cellIds.push(cellIndexFromCoords(coordinate))
    return cellIds
  }, [])
}

const getCellRows = (cells: BoardCells): Array<BoardCells> => {
  return [...Array(BoardSettings.height)].reduce((rows: Array<BoardCells>, _, rowStart: number) => {
    rows.push(cells.slice(rowStart * BoardSettings.width, (rowStart + 1) * BoardSettings.width))
    return rows
  }, [])
}

const isRowFrozen = (row: BoardCells): boolean => {
  return row.every((cell: IBoardCell) => {
    return cell.cellType !== CellType.E
  })
}

const isAnyRowFrozen = (cells: BoardCells): boolean => {
  return getCellRows(cells).some(isRowFrozen)
}

const getFrozenRowIndices = (cells: BoardCells): Array<number> => {
  return getCellRows(cells).map((cellRow: BoardCells, index: number): number => {
    return isRowFrozen(cellRow) ? index : -1
  }).filter((rowIndex: number) => rowIndex >= 0)
}

const hasCellCollision = (nextPieceCoordinate: ICoordinate, cells: BoardCells): boolean => {
  const { xCoord: nextXCoordinate, yCoord: nextYCoordinate } = nextPieceCoordinate
  const willEncounterXBoundary = nextXCoordinate < 0 || nextXCoordinate >= BoardSettings.width
  const willEncounterYBoundary = nextYCoordinate >= BoardSettings.height
  // const nextPieceCell = cells[cellIndexFromCoords(nextPieceCoordinate)] as IBoardCell?
  const nextPieceCell = cells[cellIndexFromCoords(nextPieceCoordinate)] as IBoardCell | null
  const willEncounterFrozenPiece = nextPieceCell != null && nextPieceCell.cellType !== CellType.E
  return willEncounterXBoundary || willEncounterYBoundary || willEncounterFrozenPiece
}

const hasCollision = (nextPieceCoordinate: ICoordinate, rotation: Rotation, currentPieceType: PieceType, cells: BoardCells): boolean => {
  const shape = PieceShapeMap[currentPieceType][rotation]
  const { xCoord: nextXCoordinate, yCoord: nextYCoordinate } = nextPieceCoordinate
  return shape.some((pieceOffset: IPieceOffset) => {
    const { x: xOffset, y: yOffset } = pieceOffset
    const nextCellCoordinate: ICoordinate = { xCoord: nextXCoordinate + xOffset, yCoord: nextYCoordinate + yOffset }
    return hasCellCollision(nextCellCoordinate, cells)
  })
}

const isCollisionFree = (nextPieceCoordinate: ICoordinate, rotation: Rotation, currentPieceType: PieceType, cells: BoardCells): boolean => {
  return !hasCollision(nextPieceCoordinate, rotation, currentPieceType, cells)
}


const rotation = (currentRotation: Rotation, rotationDirection: RotationDirection): Rotation => {
  return Math.abs((4 + currentRotation + rotationDirection) % 4) as Rotation
}

const dropCoordinate = (cells: BoardCells, rotation: Rotation, currentPieceType: PieceType, currentCoordinate: ICoordinate): ICoordinate => {
  const { xCoord, yCoord } = currentCoordinate
  let nextYCoord = yCoord
  while (!hasCollision({ xCoord, yCoord: nextYCoord + 1 }, rotation, currentPieceType, cells)) {
    nextYCoord++
  }
  return { xCoord, yCoord: nextYCoord }
}

const getCellIdsForGhost = (cells: BoardCells, rotation: Rotation, currentPieceType: PieceType, currentCoordinate: ICoordinate): Array<number> => {
  const { xCoord } = currentCoordinate
  const { yCoord } = dropCoordinate(cells, rotation, currentPieceType, currentCoordinate)
  return getCellIdsForPiece({ xCoord, yCoord }, rotation, currentPieceType)
}

const level = (totalLinesCleared: number): Level => {
  return Math.min(10, Math.floor(totalLinesCleared / 10)) as Level
}

const scoreThisTurn = (linesClearedThisTurn: LinesCleared, scoreMultiplier: Level): number => {
  return PossibleBaseScorePerTurn[linesClearedThisTurn] * (1 + scoreMultiplier)
}

const turnDelay = (level: Level) => {
  return Math.max(GameSettings.minimumTurnDelay, GameSettings.initialTurnDelay - (50 * level))
}

const didPlayerLose = (cells: BoardCells): boolean => {
  return cells.some((cell: IBoardCell) => {
    return cell.pieceType != null && cell.id < BoardSettings.width * BoardSettings.hiddenRows
  })
}

const Calculate = {
  didPlayerLose,
  turnDelay,
  level,
  scoreThisTurn,
  cellIndexFromCoords,
  dropCoordinate,
  getCellIdsForPiece,
  getCellIdsForGhost,
  hasCollision,
  isCollisionFree,
  rotation,
  getCellRows,
  isAnyRowFrozen,
  getFrozenRowIndices,
}

export default Calculate
