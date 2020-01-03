import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { IGameState, IBoardCell, PieceOffset, BoardCells, PieceType } from '../typings'
import Calculate from '../utils/Calculator'
import { BoardSettings } from '../constants/Settings'

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
    const { xCoord, yCoord } = BoardSettings
    const currentPieceType = GameUtil.generateRandomPieceType()
    const pieceIds = Calculate.getCellIdsForPiece(xCoord, yCoord, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, cells, currentPieceType, xCoord: xCoord, yCoord: yCoord }
    subject.next(state)
  },
  updatePieceCoordinates: (offset: PieceOffset) => {
    const { x: xOffset, y: yOffset } = offset
    const { xCoord, yCoord, currentPieceType } = state
    const nextXCoord = xOffset + xCoord
    const nextYCoord = yOffset + yCoord
    const pieceIds = Calculate.getCellIdsForPiece(nextXCoord, nextYCoord, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, xCoord: nextXCoord, yCoord: nextYCoord, cells }
    subject.next(state)
  }
}

export default gameStore
