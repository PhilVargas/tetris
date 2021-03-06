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

export interface IPieceOffset {
  readonly x: -1 | 0 | 1 | 2
  readonly y: -1 | 0 | 1 | 2
}

export type Rotation = 0 | 1 | 2 | 3
export type RotationDirection = -1 | 1

export interface ICoordinate {
  readonly xCoord: number
  readonly yCoord: number
}

export type PieceShape = ReadonlyArray<IPieceOffset>
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

export interface ICellSettings {
  edgeLength: number
}
export interface ICellProps {
  className?: string
  isHidden: boolean
  isGhost: boolean
  isPiece: boolean
  width: number
  height: number
  cellType: CellType
  isColorblindModeEnabled: boolean
  isGhostEnabled: boolean
}

export interface IGameSettings {
  hasGameBegun: boolean
  isPaused: boolean
  initialTurnDelay: number
  totalLinesCleared: number
  score: number
  scoreThisTurn: number
  minimumTurnDelay: number
  isGameOver: boolean
  isColorblindModeEnabled: boolean
  isGhostEnabled: boolean
  isQueuePieceEnabled: boolean
  canQueuePiece: boolean
  isAudioMuted: boolean
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
  isColorblindModeEnabled: boolean
  isGhostEnabled: boolean
}

export interface IGameState {
  xCoord: number
  yCoord: number
  cells: BoardCells
  currentPieceType: PieceType
  nextPieceType: PieceType
  queuePieceType?: PieceType
  pieceIds: Array<number>
  rotation: Rotation
  turnDelay: number
  isPaused: boolean
  hasGameBegun: boolean
  totalLinesCleared: number
  score: number
  scoreThisTurn: number
  isGameOver: boolean
  isColorblindModeEnabled: boolean
  isGhostEnabled: boolean
  isQueuePieceEnabled: boolean
  canQueuePiece: boolean
  isAudioMuted: boolean
}

export interface IOverlayProps {
  isGameOver: boolean
  isPaused: boolean
  hasGameBegun: boolean
  score: number
  isAudioMuted: boolean
  startGame: () => void
}

export interface ILegendProps {
  score: number
  scoreThisTurn: number
  level: Level
}
export interface IDisplayPieceProps {
  pieceType?: PieceType
  isEnabled: boolean
  isActive: boolean
  title: string
  isColorblindModeEnabled: boolean
}

export interface IPersistentSettings {
  isColorblindModeEnabled: boolean
  isGhostEnabled: boolean
  isQueuePieceEnabled: boolean
  isAudioMuted: boolean
}

export interface IDashboardProps extends IPersistentSettings {
  onColorblindChange: () => void
  onGhostChange: () => void
  onQueueChange: () => void
  onAudioChange: () => void
}

export interface ISwitchProps {
  className?: string
  labelText?: string
  isChecked: boolean
  onChange: () => void
}

export interface IThemeSongProps {
  isAudioMuted: boolean
  isPaused: boolean
  hasGameBegun: boolean
}
