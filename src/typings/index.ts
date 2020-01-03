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

export interface IBoardSettings {
  height: number
  width: number
  hiddenRows: number
  yCoord: number
  xCoord: number
}

export interface ICellSettings {
  color: (cellType: CellType, isColorBlindActive: boolean) => string
  edgeLength: number
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
}

export type BoardCells = Array<IBoardCell>

export interface IBoardProps {
  cells: BoardCells
  xCoord: number
  yCoord: number
}

export interface IGameState extends IGameSettings, IBoardProps {
  cells: BoardCells
}
