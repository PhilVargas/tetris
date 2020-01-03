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
  readonly y: 0 | 1 | 2 | 3
}

export type PieceShape = ReadonlyArray<PieceOffset>
export type PieceRotations = ReadonlyArray<PieceShape>
export type PieceMap = {
  [key in PieceType]: PieceShape
}

export interface IBoardSettings {
  height: number
  width: number
  hiddenRows: number
  yCoord: number
  xCoord: number
  pieceIds: ReadonlyArray<number>
}

export interface ICellSettings {
  color: (cellType: CellType, isColorBlindActive: boolean) => string
  edgeLength: number
}
export interface ICellProps {
  className?: string
  backgroundColor: string
  width: number
  height: number
}

export interface IGameSettings {
  hasGameBegun: boolean
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
}

export type BoardCells = Array<IBoardCell>

export interface IBoardProps {
  currentPieceType: PieceType
  cells: BoardCells
  xCoord: number
  yCoord: number
  pieceIds: ReadonlyArray<number>
}

export interface IGameState extends IGameSettings, IBoardProps {
  currentPieceType: PieceType
  cells: BoardCells
}
