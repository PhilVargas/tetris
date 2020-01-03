import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { IGameState, IBoardCell } from '../typings'
import Calculate from '../utils/Calculator'

const subject = new Subject<IGameState>()

let state = GameUtil.generateInitialState()

const gameStore = {
  generateInitialState: GameUtil.generateInitialState,
  init: () => subject.next(state),
  subscribe: (setState: Dispatch<SetStateAction<IGameState>>) => subject.subscribe(setState),
  onGenerateRandomPiece: () => {
    const pieceType = GameUtil.generateRandomPieceType()
    const pieceIds = Calculate.getCellIdsForPiece(5, 0, pieceType)
    const cells = state.cells.map((boardCell: IBoardCell) => {
      if (pieceIds.includes(boardCell.id)) {
        boardCell.pieceType = pieceType
      }
      return boardCell
    })
    subject.next({ ...state, cells, currentPieceType: pieceType, xCoord: 5, pieceIds })
  }
}

export default gameStore
