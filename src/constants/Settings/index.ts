import { ISettings } from '../../typings'
import BoardSettings from './BoardSettings'
import CellSettings from './CellSettings'
import GameSettings from './GameSettings'

const Settings: ISettings = {
  BoardSettings,
  CellSettings,
  GameSettings
}

export { BoardSettings, CellSettings, GameSettings }
export default Settings
