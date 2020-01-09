import { IGameSettings, CellType, PieceTypes, PieceMap, BaseScorePerTurn } from '../../../typings'

export const Pieces: PieceTypes = [
  CellType.I,
  CellType.O,
  CellType.Z,
  CellType.S,
  CellType.T,
  CellType.J,
  CellType.L,
]

export const PieceShapeMap: PieceMap = {
  [CellType.I]: [
    [
      { x: -1, y: 0 },
      { x: 0, y: 0 },
      { x: 1, y: 0 },
      { x: 2, y: 0 }
    ],
    [
      { x: 1, y: -1 },
      { x: 1, y: 0 },
      { x: 1, y: 1 },
      { x: 1, y: 2 }
    ],
    [
      { x: -1, y: 1 },
      { x: 0, y: 1 },
      { x: 1, y: 1 },
      { x: 2, y: 1 }
    ],
    [
      { x: 0, y: -1 },
      { x: 0, y: 0 },
      { x: 0, y: 1 },
      { x: 0, y: 2 }
    ],
  ],
  [CellType.O]: [
    [
      { x: 0, y: 0 },
      { x: -1, y: 0 },
      { x: -1, y: -1 },
      { x: 0, y: -1 }
    ],
    [
      { x: 0, y: 0 },
      { x: -1, y: 0 },
      { x: -1, y: -1 },
      { x: 0, y: -1 }
    ],
    [
      { x: 0, y: 0 },
      { x: -1, y: 0 },
      { x: -1, y: -1 },
      { x: 0, y: -1 }
    ],
    [
      { x: 0, y: 0 },
      { x: -1, y: 0 },
      { x: -1, y: -1 },
      { x: 0, y: -1 }
    ]
  ],
  [CellType.Z]: [
    [
      { x: 0, y: 1 },
      { x: 1, y: 1 },
      { x: 0, y: 0 },
      { x: -1, y: 0 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 2 },
      { x: 1, y: 1 },
      { x: 1, y: 0 }
    ],
    [
      { x: 0, y: 1 },
      { x: -1, y: 1 },
      { x: 0, y: 2 },
      { x: 1, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 0 },
      { x: -1, y: 1 },
      { x: -1, y: 2 }
    ],
  ],
  [CellType.S]: [
    [
      { x: 0, y: 1 },
      { x: -1, y: 1 },
      { x: 0, y: 0 },
      { x: 1, y: 0 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 0 },
      { x: 1, y: 1 },
      { x: 1, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: 1, y: 1 },
      { x: 0, y: 2 },
      { x: -1, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 2 },
      { x: -1, y: 1 },
      { x: -1, y: 0 }
    ],
  ],
  [CellType.T]: [
    [
      { x: 0, y: 1 },
      { x: -1, y: 1 },
      { x: 0, y: 0 },
      { x: 1, y: 1 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 0 },
      { x: 1, y: 1 },
      { x: 0, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: -1, y: 1 },
      { x: 1, y: 1 },
      { x: 0, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: -1, y: 1 },
      { x: 0, y: 0 },
      { x: 0, y: 2 }
    ],
  ],
  [CellType.J]: [
    [
      { x: 0, y: 1 },
      { x: 1, y: 1 },
      { x: -1, y: 1 },
      { x: -1, y: 0 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 2 },
      { x: 0, y: 0 },
      { x: 1, y: 0 }
    ],
    [
      { x: 0, y: 1 },
      { x: 1, y: 1 },
      { x: -1, y: 1 },
      { x: 1, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 2 },
      { x: 0, y: 0 },
      { x: -1, y: 2 }
    ],
  ],
  [CellType.L]: [
    [
      { x: 0, y: 1 },
      { x: -1, y: 1 },
      { x: 1, y: 1 },
      { x: 1, y: 0 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 0 },
      { x: 0, y: 2 },
      { x: 1, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: 1, y: 1 },
      { x: -1, y: 1 },
      { x: -1, y: 2 }
    ],
    [
      { x: 0, y: 1 },
      { x: 0, y: 2 },
      { x: 0, y: 0 },
      { x: -1, y: 0 }
    ],
  ],
}

export const PossibleBaseScorePerTurn: Array<BaseScorePerTurn> = [0, 40, 100, 300, 1200]

export const ThemeSongUrl = "https://raw.githubusercontent.com/PhilVargas/tetris/master/public/assets/music/Tetris%20Theme%20-%20Long.ogg"

const GameSettings: IGameSettings = {
  hasGameBegun: false,
  isPaused: false,
  initialTurnDelay: 500,
  totalLinesCleared: 0,
  score: 0,
  minimumTurnDelay: 50,
  isGameOver: false,
  isColorblindModeEnabled: false,
  isGhostEnabled: true,
  isQueuePieceEnabled: true,
  canQueuePiece: true,
  isAudioMuted: false,
}

export default GameSettings
