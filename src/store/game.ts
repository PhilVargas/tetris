import { Subject } from 'rxjs'
import { Dispatch, SetStateAction } from 'react'

import GameUtil from '../utils/GameUtil'
import { CellType, IGameState } from '../typings'

const subject = new Subject<IGameState>()

let state = GameUtil.generateInitialState()

const gameStore = {
  generateInitialState: GameUtil.generateInitialState,
  init: () => subject.next(state),
  subscribe: (setState: Dispatch<SetStateAction<IGameState>>) => subject.subscribe(setState),
  onHover: (cellId: number) => {
    let cells = state.cells.map((cell) => {
      if (cell.id === cellId) { cell.cellType = CellType.I }
      return cell
    })
    subject.next({ ...state, cells })
  }
}

export default gameStore
