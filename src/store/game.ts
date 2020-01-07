import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { IGameState, IBoardCell, PieceOffset, BoardCells, PieceType, Coordinate, RotationDirection } from '../typings'
import Calculate from '../utils/Calculator'
import { BoardSettings } from '../constants/Settings'

const subject = new Subject<IGameState>()

let state = GameUtil.generateInitialState()

const updateCells = (cells: BoardCells, currentPieceType: PieceType, pieceIds: Array<number>, ghostPieceIds: Array<number>): BoardCells => {
  return cells.map((boardCell: IBoardCell) => {
    if (pieceIds.includes(boardCell.id)) {
      boardCell.pieceType = currentPieceType
    } else {
      boardCell.pieceType = undefined
    }

    if (ghostPieceIds.includes(boardCell.id)) {
      boardCell.ghostType = currentPieceType
    } else {
      boardCell.ghostType = undefined
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

  const pieceIds = Calculate.getCellIdsForPiece({ xCoord: nextXCoord, yCoord: nextYCoord }, rotation, currentPieceType)
  const ghostPieceIds = Calculate.getCellIdsForGhost(state.cells, rotation, currentPieceType, nextCoord)
  const cells = updateCells(state.cells, currentPieceType, pieceIds, ghostPieceIds)
  state = { ...state, xCoord: nextXCoord, yCoord: nextYCoord, cells }
  subject.next(state)
}

const startGame = () => {
  state = GameUtil.generateInitialState()
  const { xCoord, yCoord, rotation } = state
  const currentPieceType = GameUtil.generateRandomPieceType()
  const pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord }, rotation, currentPieceType)
  const ghostPieceIds = Calculate.getCellIdsForGhost(state.cells, rotation, currentPieceType, { xCoord, yCoord })
  const cells = updateCells(state.cells, currentPieceType, pieceIds, ghostPieceIds)
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
    const pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord: nextYCoord }, rotation, currentPieceType)
    const ghostPieceIds = Calculate.getCellIdsForGhost(state.cells, rotation, currentPieceType, { xCoord, yCoord: nextYCoord })
    const cells = updateCells(state.cells, currentPieceType, pieceIds, ghostPieceIds)
    state = { ...state, xCoord: xCoord, yCoord: nextYCoord, cells }
    subject.next(state)
  } else {
    let boardCells = freezeCells(state.cells)
    // TODO check if player will lose
    while (Calculate.isAnyRowFrozen(boardCells)) {
      let lowestFrozenRowIndex = Calculate.getFrozenRowIndices(boardCells).pop()
      if (lowestFrozenRowIndex == null) { break }
      boardCells = GameUtil.generateShiftedCells(lowestFrozenRowIndex, boardCells)
    }

    const randomPieceType = GameUtil.generateRandomPieceType()
    const { xCoord: defaultXCoord, yCoord: defaultYCoord, rotation: defaultRotation } = BoardSettings
    const pieceIds = Calculate.getCellIdsForPiece({ xCoord: defaultXCoord, yCoord: defaultYCoord }, defaultRotation, randomPieceType)
    const ghostPieceIds = Calculate.getCellIdsForGhost(boardCells, defaultRotation, randomPieceType, { xCoord: defaultXCoord, yCoord: defaultYCoord })
    const cells = updateCells(boardCells, randomPieceType, pieceIds, ghostPieceIds)
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
    const { yCoord: finalYCoord } = Calculate.dropCoordinate(state.cells, rotation, currentPieceType, { xCoord, yCoord })
    let pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord: finalYCoord }, rotation, currentPieceType)
    let cells = updateCells(state.cells, currentPieceType, pieceIds, pieceIds)
    state = { ...state, yCoord: finalYCoord, cells }
    subject.next(state)
  },
  rotatePiece: (rotationDirection: RotationDirection) => {
    const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun } = state
    if (!hasGameBegun || isPaused) { return }
    const nextRotation = Calculate.rotation(rotation, rotationDirection)
    const nextCoord = { xCoord, yCoord }
    const hasCollision = Calculate.hasCollision(nextCoord, nextRotation, currentPieceType, state.cells)

    if (hasCollision) { return }

    const pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord }, nextRotation, currentPieceType)
    const ghostPieceIds = Calculate.getCellIdsForGhost(state.cells, nextRotation, currentPieceType, { xCoord, yCoord })
    const cells = updateCells(state.cells, currentPieceType, pieceIds, ghostPieceIds)
    state = { ...state, rotation: nextRotation, cells }
    subject.next(state)
  },
}

export default gameStore
