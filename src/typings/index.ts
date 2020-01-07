export enum CellType {
  E = "E",
  I = "I",
  O = "O",
  Z = "Z",
  S = "S",
  T = "T",
  J = "J",
  L = "L"
}

export type PieceType = CellType.I | CellType.O | CellType.Z | CellType.S | CellType.T | CellType.J | CellType.L
export type PieceTypes = ReadonlyArray<PieceType>

export interface PieceOffset {
  readonly x: -2 | -1 | 0 | 1
  readonly y: -1 | 0 | 1 | 2
}

export type Rotation = 0 | 1 | 2 | 3
export type RotationDirection = -1 | 1

export interface Coordinate {
  readonly xCoord: number
  readonly yCoord: number
}

export type PieceShape = ReadonlyArray<PieceOffset>
export type PieceRotations = ReadonlyArray<PieceShape>
export type PieceMap = {
  [key in PieceType]: PieceRotations
}

export type LinesCleared = 0 | 1 | 2 | 3 | 4
export type BaseScorePerTurn = 0 | 40 | 100 | 300 | 1200
export type Level = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10
export interface IScoredBoardCells {
  cells: BoardCells
  scoreThisTurn: number
  linesClearedThisTurn: LinesCleared
}

export interface IBoardSettings {
  height: number
  width: number
  hiddenRows: number
  yCoord: number
  xCoord: number
  pieceIds: Array<number>
  rotation: Rotation
}

// Depracated
export interface ICellSettings {
  color: (cellType: CellType, isColorBlindActive: boolean) => string
  edgeLength: number
  displayEdgeLength: number
}
export interface ICellProps {
  className?: string
  isHidden: boolean
  isGhost: boolean
  isPiece: boolean
  backgroundColor: string
  width: number
  height: number
}

export interface IGameSettings {
  hasGameBegun: boolean
  isPaused: boolean
  initialTurnDelay: number
  totalLinesCleared: number
  score: number
  minimumTurnDelay: number
  isGameOver: boolean
}

export interface ISettings {
  BoardSettings: IBoardSettings
  CellSettings: ICellSettings
  GameSettings: IGameSettings
}

export interface IBoardCell {
  id: number
  yCoord: number
  xCoord: number
  isFrozen: boolean
  cellType: CellType
  pieceType?: PieceType
  ghostType?: PieceType
}

export type BoardCells = Array<IBoardCell>

export interface IBoardProps {
  cells: BoardCells
}

export interface IGameState {
  xCoord: number
  yCoord: number
  cells: BoardCells
  currentPieceType: PieceType
  nextPieceType: PieceType
  pieceIds: Array<number>
  rotation: Rotation
  turnDelay: number
  isPaused: boolean
  hasGameBegun: boolean
  totalLinesCleared: number
  score: number
  isGameOver: boolean
}

export interface IOverlayProps {
  isGameOver: boolean
  isPaused: boolean
  hasGameBegun: boolean
  score: number
  startGame: () => void
  resumeGame: () => void
}
