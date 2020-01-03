import { ISettings } from '../../typings'
import BoardSettings from './BoardSettings'
import CellSettings from './CellSettings'
import GameSettings, { PieceShapeMap } from './GameSettings'

const Settings: ISettings = {
  BoardSettings,
  CellSettings,
  GameSettings
}

export { BoardSettings, CellSettings, GameSettings, PieceShapeMap }
export default Settings
