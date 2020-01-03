import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Board.module.scss'

import { CellSettings, BoardSettings } from '../../constants/Settings'
import Cell from '../../components/Cell'
import { BoardCells, IBoardProps, CellType } from '../../typings'
import Calculate from '../../utils/Calculator'

const generateCells = (yCoord: number, cells: BoardCells, pieceIds: ReadonlyArray<number>) => {
  return [...Array(BoardSettings.width)].map((_, xCoord: number) => {
    let cellId = Calculate.cellIndexFromCoords(xCoord, yCoord)
    let cell = cells[cellId]
    let className = yCoord < BoardSettings.hiddenRows ? styles.hiddenRow : undefined
    const cellColorType: CellType = cell.pieceType || cell.cellType

    return <Cell key={cell.id}
      className={className}
      backgroundColor={CellSettings.color(cellColorType, false)}
      width={CellSettings.edgeLength}
      height={CellSettings.edgeLength} />
  })
}

const generateRows = (cells: BoardCells, pieceIds: ReadonlyArray<number>) => {
  return [...Array(BoardSettings.height)].map((_, yCoord: number) => {
    return (
      <div key={yCoord} className={cn(styles.rows, {})} style={{ maxHeight: CellSettings.edgeLength }}>
        {generateCells(yCoord, cells, pieceIds)}
      </div>
    )
  })
}

const Board: FC<IBoardProps> = ({ cells, pieceIds }) => {
  return (
    <div className={cn(styles.wrapper)}>
      {generateRows(cells, pieceIds)}
    </div>)
}

export default Board
