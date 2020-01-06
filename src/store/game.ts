import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { IGameState, IBoardCell, PieceOffset, BoardCells, PieceType, Coordinate, RotationDirection } from '../typings'
import Calculate from '../utils/Calculator'
import { BoardSettings } from '../constants/Settings'

const subject = new Subject<IGameState>()

let state = GameUtil.generateInitialState()

const updateCells = (cells: BoardCells, pieceIds: Array<number>, currentPieceType: PieceType): BoardCells => {
  return cells.map((boardCell: IBoardCell) => {
    if (pieceIds.includes(boardCell.id)) {
      boardCell.pieceType = currentPieceType
    } else {
      boardCell.pieceType = undefined
    }
    return boardCell
  })
}

const freezeCells = (cells: BoardCells): BoardCells => {
  return cells.map((boardCell: IBoardCell) => {
    if (boardCell.pieceType != null) {
      boardCell.cellType = boardCell.pieceType
    }
    return boardCell
  })
}

const updatePieceCoordinates = (offset: PieceOffset) => {
  const { x: xOffset, y: yOffset } = offset
  const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun } = state
  if (!hasGameBegun || isPaused) { return }
  const nextXCoord = xOffset + xCoord
  const nextYCoord = yOffset + yCoord

  const nextCoord: Coordinate = { xCoord: nextXCoord, yCoord: nextYCoord }
  const hasCollision = Calculate.hasCollision(nextCoord, rotation, currentPieceType, state.cells)

  if (hasCollision) { return }

  const pieceIds = Calculate.getCellIdsForPiece(nextXCoord, nextYCoord, rotation, currentPieceType)
  const cells = updateCells(state.cells, pieceIds, currentPieceType)
  state = { ...state, xCoord: nextXCoord, yCoord: nextYCoord, cells }
  subject.next(state)
}

const startGame = () => {
  state = GameUtil.generateInitialState()
  const { xCoord, yCoord, rotation } = state
  const currentPieceType = GameUtil.generateRandomPieceType()
  const pieceIds = Calculate.getCellIdsForPiece(xCoord, yCoord, rotation, currentPieceType)
  const cells = updateCells(state.cells, pieceIds, currentPieceType)
  state = { ...state, cells, currentPieceType, xCoord: xCoord, yCoord: yCoord, hasGameBegun: true, isPaused: false }
  subject.next(state)
}

const togglePause = () => {
  if (!state.hasGameBegun) { return }
  state = { ...state, isPaused: !state.isPaused }
  subject.next(state)
}

const nextTurn = () => {
  const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun } = state
  if (!hasGameBegun || isPaused) { return }
  const nextYCoord = yCoord + 1

  if (!Calculate.hasCollision({ xCoord, yCoord: nextYCoord }, rotation, currentPieceType, state.cells)) {
    const pieceIds = Calculate.getCellIdsForPiece(xCoord, nextYCoord, rotation, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, xCoord: xCoord, yCoord: nextYCoord, cells }
    subject.next(state)
  } else {
    const frozenCells = freezeCells(state.cells)
    const randomPieceType = GameUtil.generateRandomPieceType()
    const { xCoord: defaultXCoord, yCoord: defaultYCoord, rotation: defaultRotation } = BoardSettings
    const pieceIds = Calculate.getCellIdsForPiece(defaultXCoord, defaultYCoord, defaultRotation, randomPieceType)
    // TODO check if player will lose
    const cells = updateCells(frozenCells, pieceIds, randomPieceType)
    state = { ...state, xCoord: defaultXCoord, yCoord: defaultYCoord, currentPieceType: randomPieceType, cells, rotation: defaultRotation }
    subject.next(state)
  }
}

const gameStore = {
  generateInitialState: GameUtil.generateInitialState,
  init: () => subject.next(state),
  subscribe: (setState: Dispatch<SetStateAction<IGameState>>) => subject.subscribe(setState),
  unsubcribe: () => { subject.unsubscribe() },
  startGame,
  updatePieceCoordinates,
  nextTurn,
  togglePause,
  dropPiece: () => {
    const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun } = state
    if (!hasGameBegun || isPaused) { return }
    let nextYCoord = yCoord + 1
    while (!Calculate.hasCollision({ xCoord, yCoord: nextYCoord }, rotation, currentPieceType, state.cells)) {
      let pieceIds = Calculate.getCellIdsForPiece(xCoord, nextYCoord, rotation, currentPieceType)
      let cells = updateCells(state.cells, pieceIds, currentPieceType)
      state = { ...state, yCoord: nextYCoord, cells }
      nextYCoord++
    }
    subject.next(state)
  },
  rotatePiece: (rotationDirection: RotationDirection) => {
    const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun } = state
    if (!hasGameBegun || isPaused) { return }
    const nextRotation = Calculate.rotation(rotation, rotationDirection)
    const nextCoord = { xCoord, yCoord }
    const hasCollision = Calculate.hasCollision(nextCoord, nextRotation, currentPieceType, state.cells)

    if (hasCollision) { return }

    const pieceIds = Calculate.getCellIdsForPiece(xCoord, yCoord, nextRotation, currentPieceType)
    const cells = updateCells(state.cells, pieceIds, currentPieceType)
    state = { ...state, rotation: nextRotation, cells }
    subject.next(state)
  },
}

export default gameStore
