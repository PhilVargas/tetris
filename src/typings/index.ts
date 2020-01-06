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
}
export interface ICellProps {
  className?: string
  isHidden: boolean
  isGhost: boolean
  backgroundColor: string
  width: number
  height: number
}

export interface IGameSettings {
  hasGameBegun: boolean
  isPaused: boolean
  turnDelay: number
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
  pieceIds: Array<number>
  rotation: Rotation
  turnDelay: number
  isPaused: boolean
  hasGameBegun: boolean
}
