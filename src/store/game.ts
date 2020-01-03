import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { IGameState, IBoardCell, PieceOffset, BoardCells, PieceType, Coordinate, RotationDirection } from '../typings'
import Calculate from '../utils/Calculator'

const subject = new Subject<IGameState>()

let state = GameUtil.generateInitialState()

const updateCells = (cells: BoardCells, pieceIds: Array<number>, currentPieceType?: PieceType): BoardCells => {
  if (currentPieceType == null) { return cells }
  return cells.map((boardCell: IBoardCell) => {
    if (pieceIds.includes(boardCell.id)) {
      boardCell.pieceType = currentPieceType
    } else {
      boardCell.pieceType = undefined
    }
    return boardCell
  })
}


const gameStore = {
  generateInitialState: GameUtil.generateInitialState,
  init: () => subject.next(state),
  subscribe: (setState: Dispatch<SetStateAction<IGameState>>) => subject.subscribe(setState),
  unsubcribe: () => { subject.unsubscribe() },
  onGenerateRandomPiece: () => {
    const { xCoord, yCoord, rotation } = state
    const currentPieceType = GameUtil.generateRandomPieceType()
    const pieceIds = Calculate.getCellIdsForPiece(xCoord, yCoord, rotation, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, cells, currentPieceType, xCoord: xCoord, yCoord: yCoord }
    subject.next(state)
  },
  updatePieceCoordinates: (offset: PieceOffset) => {
    const { x: xOffset, y: yOffset } = offset
    const { xCoord, yCoord, currentPieceType, rotation } = state
    if (currentPieceType == null) { return }
    const nextXCoord = xOffset + xCoord
    const nextYCoord = yOffset + yCoord

    const nextCoord: Coordinate = { xCoord: nextXCoord, yCoord: nextYCoord }
    const hasCollision = Calculate.hasCollision(nextCoord, rotation, currentPieceType)

    if (hasCollision) { return }

    const pieceIds = Calculate.getCellIdsForPiece(nextXCoord, nextYCoord, rotation, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, xCoord: nextXCoord, yCoord: nextYCoord, cells }
    subject.next(state)
  },
  rotatePiece: (rotationDirection: RotationDirection) => {
    const { xCoord, yCoord, currentPieceType, rotation } = state
    if (currentPieceType == null) { return }
    const nextRotation = Calculate.rotation(rotation, rotationDirection)
    const nextCoord = { xCoord, yCoord }
    const hasCollision = Calculate.hasCollision(nextCoord, nextRotation, currentPieceType)

    if (hasCollision) { return }

    const pieceIds = Calculate.getCellIdsForPiece(xCoord, yCoord, nextRotation, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, rotation: nextRotation, cells }
    subject.next(state)
  }
}

export default gameStore
