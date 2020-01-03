import { BoardSettings } from '../constants/Settings'

const Calculate = {
  cellIndexFromCoords: (xIndex: number, yIndex: number): number => {
    return xIndex + (BoardSettings.width * yIndex)
  }
}

export default Calculate
