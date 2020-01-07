import { ISettings } from '../../typings'
import BoardSettings from './BoardSettings'
import CellSettings from './CellSettings'
import GameSettings, { PieceShapeMap, PossibleBaseScorePerTurn } from './GameSettings'

const Settings: ISettings = {
  BoardSettings,
  CellSettings,
  GameSettings
}

export { BoardSettings, CellSettings, GameSettings, PieceShapeMap, PossibleBaseScorePerTurn }
export default Settings
