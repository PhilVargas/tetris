import { IGameSettings, CellType, PieceTypes, PieceMap } from '../../../typings'

export const Pieces: PieceTypes = [
  CellType.I,
  CellType.O,
  CellType.Z,
  CellType.S,
  CellType.T,
  CellType.J,
  CellType.L
]

export const PieceShapeMap: PieceMap = {
  [CellType.I]: [
    { x: 0, y: 0 },
    { x: 0, y: 1 },
    { x: 0, y: 2 },
    { x: 0, y: 3 }
  ],
  [CellType.O]: [
    { x: 0, y: 1 },
    { x: -1, y: 1 },
    { x: -1, y: 0 },
    { x: 0, y: 0 }
  ],
  [CellType.Z]: [
    { x: 0, y: 1 },
    { x: 1, y: 1 },
    { x: 0, y: 0 },
    { x: -1, y: 0 }
  ],
  [CellType.S]: [
    { x: 0, y: 1 },
    { x: -1, y: 1 },
    { x: 0, y: 0 },
    { x: 1, y: 0 }
  ],
  [CellType.T]: [
    { x: 0, y: 0 },
    { x: -1, y: 0 },
    { x: 0, y: 1 },
    { x: 1, y: 0 }
  ],
  [CellType.J]: [
    { x: 0, y: 1 },
    { x: 1, y: 1 },
    { x: -1, y: 1 },
    { x: -1, y: 0 }
  ],
  [CellType.L]: [
    { x: 0, y: 1 },
    { x: -1, y: 1 },
    { x: 1, y: 1 },
    { x: 1, y: 0 }
  ],
}

const GameSettings: IGameSettings = {
  hasGameBegun: false,
}

export default GameSettings
