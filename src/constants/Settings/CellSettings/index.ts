import { CellType, ICellSettings } from '../../../typings'

const color = (cellType: CellType, isColorBlindActive = false): string => {
  switch (cellType) {
    case CellType.E:
      return 'lightgrey';
    case CellType.I:
      return 'turquoise';
    case CellType.O:
      return 'yellow';
    case CellType.Z:
      return 'red';
    case CellType.S:
      return 'lime';
    case CellType.T:
      return 'purple';
    case CellType.J:
      return 'blue';
    case CellType.L:
      return 'orange';
  }
}

const CellSettings: ICellSettings = {
  color,
  edgeLength: 25
}

export default CellSettings
