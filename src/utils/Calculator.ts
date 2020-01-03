import { PieceType, PieceShape, PieceOffset, Coordinate, Rotation, RotationDirection } from '../typings'
import { BoardSettings } from '../constants/Settings'
import { PieceShapeMap } from '../constants/Settings'

const cellIndexFromCoords = (xIndex: number, yIndex: number): number => {
  return xIndex + (BoardSettings.width * yIndex)
}

const getCellIdsForPiece = (xCoord: number, yCoord: number, rotation: Rotation, currentPieceType?: PieceType): Array<number> => {
  if (currentPieceType == null) { return [] }
  const shape: PieceShape = PieceShapeMap[currentPieceType][rotation]
  return shape.reduce((cellIds: Array<number>, pieceOffset: PieceOffset): Array<number> => {
    let offsetXCoord = xCoord + pieceOffset.x
    let offsetYCoord = yCoord + pieceOffset.y
    cellIds.push(cellIndexFromCoords(offsetXCoord, offsetYCoord))
    return cellIds
  }, [])
}

const hasCollision = (nextPieceCoordinate: Coordinate, rotation: Rotation, currentPieceType: PieceType): boolean => {
  const shape = PieceShapeMap[currentPieceType][rotation]
  const { xCoord: nextXCoordinate, yCoord: nextYCoordinate } = nextPieceCoordinate
  return shape.some((pieceOffset: PieceOffset) => {
    const { x: xOffset, y: yOffset } = pieceOffset
    const nextCellCoordinate: Coordinate = { xCoord: nextXCoordinate + xOffset, yCoord: nextYCoordinate + yOffset }
    return hasCellCollision(nextCellCoordinate)
  })
}

const hasCellCollision = (nextPieceCoordinate: Coordinate): boolean => {
  const { xCoord: nextXCoordinate, yCoord: nextYCoordinate } = nextPieceCoordinate
  const willEncounterXBoundary = nextXCoordinate < 0 || nextXCoordinate >= BoardSettings.width
  const willEncounterYBoundary = nextYCoordinate >= BoardSettings.height
  return willEncounterXBoundary || willEncounterYBoundary
}

const rotation = (currentRotation: Rotation, rotationDirection: RotationDirection): Rotation => {
  return Math.abs((4 + currentRotation + rotationDirection) % 4) as Rotation
}

const Calculate = {
  cellIndexFromCoords,
  getCellIdsForPiece,
  hasCollision,
  rotation,
}

export default Calculate
