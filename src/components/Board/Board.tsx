import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Board.module.scss'

import { CellSettings, BoardSettings } from '../../constants/Settings'
import Cell from '../Cell'
import { BoardCells, IBoardProps, CellType } from '../../typings'
import Calculate from '../../utils/Calculator'

// const generateCells = (yCoord: number, cells: BoardCells, isColorblindModeEnabled: boolean) => {
//   return [...Array(BoardSettings.width)].map((_, xCoord: number) => {
//     const cellId = Calculate.cellIndexFromCoords({ xCoord, yCoord })
//     const cell = cells[cellId]
//     const cellType: CellType = cell.pieceType || cell.ghostType || cell.cellType
//     const isHidden = yCoord < BoardSettings.hiddenRows
//     const isGhost = cell.ghostType != null && cell.pieceType == null
//     const isPiece = cell.pieceType != null

//     return <Cell key={cell.id}
//       isHidden={isHidden}
//       isGhost={isGhost}
//       isPiece={isPiece}
//       cellType={cellType}
//       width={CellSettings.edgeLength}
//       height={CellSettings.edgeLength}
//       isColorblindModeEnabled={isColorblindModeEnabled}
//     />
//   })
// }

// const generateRows = (cells: BoardCells, isColorblindModeEnabled: boolean) => {
//   return [...Array(BoardSettings.height)].map((_, yCoord: number) => {
//     return (
//       <div key={yCoord} className={cn(styles.rows, {})} style={{ maxHeight: CellSettings.edgeLength }}>
//         {generateCells(yCoord, cells, isColorblindModeEnabled)}
//       </div>
//     )
//   })
// }

const Board: FC<IBoardProps> = ({ cells, isColorblindModeEnabled, isGhostEnabled }) => {
  const generateCells = (yCoord: number) => {
    return [...Array(BoardSettings.width)].map((_, xCoord: number) => {
      const cellId = Calculate.cellIndexFromCoords({ xCoord, yCoord })
      const cell = cells[cellId]
      const cellType: CellType = cell.pieceType || (isGhostEnabled && cell.ghostType) || cell.cellType
      const isHidden = yCoord < BoardSettings.hiddenRows
      const isGhost = cell.ghostType != null && cell.pieceType == null
      const isPiece = cell.pieceType != null

      return <Cell key={cell.id}
        isHidden={isHidden}
        isGhost={isGhost}
        isPiece={isPiece}
        cellType={cellType}
        width={CellSettings.edgeLength}
        height={CellSettings.edgeLength}
        isColorblindModeEnabled={isColorblindModeEnabled}
        isGhostEnabled={isGhostEnabled}
      />
    })
  }

  const generateRows = () => {
    return [...Array(BoardSettings.height)].map((_, yCoord: number) => {
      return (
        <div key={yCoord} className={cn(styles.rows, {})} style={{ maxHeight: CellSettings.edgeLength }}>
          {generateCells(yCoord)}
        </div>
      )
    })
  }

  return (
    <div className={cn(styles.wrapper)}>
      {generateRows()}
    </div>)
}

export default Board
