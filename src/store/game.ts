import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { IGameState, IBoardCell, PieceOffset, BoardCells, PieceType, Coordinate, RotationDirection, IPersistentSettings } from '../typings'
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
  const { isAudioMuted, isGhostEnabled, isQueuePieceEnabled, isColorblindModeEnabled } = state
  const staticSettings: IPersistentSettings = { isAudioMuted, isGhostEnabled, isQueuePieceEnabled, isColorblindModeEnabled }
  const initialState = GameUtil.generateInitialState()
  const { xCoord, yCoord, rotation } = initialState
  const currentPieceType = GameUtil.generateRandomPieceType()
  const pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord }, rotation, currentPieceType)
  const ghostPieceIds = Calculate.getCellIdsForGhost(initialState.cells, rotation, currentPieceType, { xCoord, yCoord })
  const cells = updateCells(initialState.cells, currentPieceType, pieceIds, ghostPieceIds)
  state = {
    ...initialState,
    ...staticSettings,
    cells,
    currentPieceType,
    xCoord: xCoord,
    yCoord: yCoord,
    hasGameBegun: true,
    isPaused: false,
  }


  subject.next(state)
}

const togglePause = () => {
  if (!state.hasGameBegun) { return }
  state = { ...state, isPaused: !state.isPaused }
  subject.next(state)
}

const nextTurn = () => {
  const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun, nextPieceType } = state
  if (!hasGameBegun || isPaused) { return }
  const nextYCoord = yCoord + 1

  if (Calculate.isCollisionFree({ xCoord, yCoord: nextYCoord }, rotation, currentPieceType, state.cells)) {
    const pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord: nextYCoord }, rotation, currentPieceType)
    const ghostPieceIds = Calculate.getCellIdsForGhost(state.cells, rotation, currentPieceType, { xCoord, yCoord: nextYCoord })
    const cells = updateCells(state.cells, currentPieceType, pieceIds, ghostPieceIds)
    state = { ...state, xCoord: xCoord, yCoord: nextYCoord, cells }
    subject.next(state)
  } else {
    const frozenCells = freezeCells(state.cells)
    if (Calculate.didPlayerLose(frozenCells)) {
      state = { ...state, isGameOver: true, cells: frozenCells }
      subject.next(state)
    } else {
      const { cells: boardCells, scoreThisTurn, linesClearedThisTurn } = GameUtil.scoreRowsForTurn(frozenCells, state.totalLinesCleared)
      const randomPieceType = GameUtil.generateRandomPieceType()
      const { xCoord: defaultXCoord, yCoord: defaultYCoord, rotation: defaultRotation } = BoardSettings
      const pieceIds = Calculate.getCellIdsForPiece({ xCoord: defaultXCoord, yCoord: defaultYCoord }, defaultRotation, nextPieceType)
      const ghostPieceIds = Calculate.getCellIdsForGhost(boardCells, defaultRotation, nextPieceType, { xCoord: defaultXCoord, yCoord: defaultYCoord })
      const cells = updateCells(boardCells, nextPieceType, pieceIds, ghostPieceIds)
      const totalLinesCleared = state.totalLinesCleared + linesClearedThisTurn
      state = {
        ...state,
        xCoord: defaultXCoord,
        yCoord: defaultYCoord,
        currentPieceType: nextPieceType,
        nextPieceType: randomPieceType,
        cells,
        rotation: defaultRotation,
        totalLinesCleared: totalLinesCleared,
        turnDelay: Calculate.turnDelay(Calculate.level(totalLinesCleared)),
        canQueuePiece: true,
        score: state.score + scoreThisTurn
      }
      subject.next(state)
    }
  }
}

const toggleColorblindMode = () => {
  state = { ...state, isColorblindModeEnabled: !state.isColorblindModeEnabled }
  subject.next(state)
}

const toggleGhost = () => {
  state = { ...state, isGhostEnabled: !state.isGhostEnabled }
  subject.next(state)
}

const toggleQueuePiece = () => {
  state = { ...state, isQueuePieceEnabled: !state.isQueuePieceEnabled }
  subject.next(state)
}

const toggleAudio = () => {
  state = { ...state, isAudioMuted: !state.isAudioMuted }
  subject.next(state)
}

const swapQueuePiece = () => {
  const { isQueuePieceEnabled, canQueuePiece, currentPieceType, nextPieceType, queuePieceType } = state
  if (isQueuePieceEnabled && canQueuePiece) {
    let newPieceType: PieceType
    let newNextPieceType: PieceType
    const newQueuePieceType = currentPieceType
    if (queuePieceType != null) {
      newPieceType = queuePieceType
      newNextPieceType = nextPieceType
    } else {
      newPieceType = nextPieceType
      newNextPieceType = GameUtil.generateRandomPieceType()
    }
    const { xCoord, yCoord, rotation } = BoardSettings
    const pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord }, rotation, newPieceType)
    const ghostPieceIds = Calculate.getCellIdsForGhost(state.cells, rotation, newPieceType, { xCoord, yCoord })
    const cells = updateCells(state.cells, newPieceType, pieceIds, ghostPieceIds)
    state = { ...state, currentPieceType: newPieceType, nextPieceType: newNextPieceType, queuePieceType: newQueuePieceType, canQueuePiece: false, xCoord, yCoord, rotation, cells }
    subject.next(state)
  }
}

const dropPiece = () => {
  const { xCoord, yCoord, currentPieceType, rotation, isPaused, hasGameBegun } = state
  if (!hasGameBegun || isPaused) { return }
  const { yCoord: finalYCoord } = Calculate.dropCoordinate(state.cells, rotation, currentPieceType, { xCoord, yCoord })
  let pieceIds = Calculate.getCellIdsForPiece({ xCoord, yCoord: finalYCoord }, rotation, currentPieceType)
  let cells = updateCells(state.cells, currentPieceType, pieceIds, pieceIds)
  state = { ...state, yCoord: finalYCoord, cells }
  subject.next(state)
}

const rotatePiece = (rotationDirection: RotationDirection) => {
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
  toggleColorblindMode,
  toggleGhost,
  toggleQueuePiece,
  toggleAudio,
  swapQueuePiece,
  dropPiece,
  rotatePiece,
}

export default gameStore
