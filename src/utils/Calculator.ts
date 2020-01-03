import { PieceType, PieceShape, PieceOffset } from '../typings'
import { BoardSettings } from '../constants/Settings'
import { PieceShapeMap } from '../constants/Settings'

const cellIndexFromCoords = (xIndex: number, yIndex: number): number => {
  return xIndex + (BoardSettings.width * yIndex)
}

const getCellIdsForPiece = (xCoord: number, yCoord: number, currentPieceType: PieceType): Array<number> => {
  const shape: PieceShape = PieceShapeMap[currentPieceType]
  return shape.reduce((cellIds: Array<number>, pieceOffset: PieceOffset): Array<number> => {
    let offsetXCoord = xCoord + pieceOffset.x
    let offsetYCoord = yCoord + pieceOffset.y
    cellIds.push(cellIndexFromCoords(offsetXCoord, offsetYCoord))
    return cellIds
  }, [])
}

const Calculate = {
  cellIndexFromCoords,
  getCellIdsForPiece
}

export default Calculate
