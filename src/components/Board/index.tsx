import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Board.module.scss'

import { CellSettings, BoardSettings } from '../../constants/Settings'
import Cell from '../../components/Cell'
import { BoardCells, IBoardProps } from '../../typings'
import Calculate from '../../utils/Calculator'
import gameStore from '../../store/game'

const generateCells = (yCoord: number, cells: BoardCells) => {
  return [...Array(BoardSettings.width)].map((_, xCoord: number) => {
    let cellId = Calculate.cellIndexFromCoords(xCoord, yCoord)
    let cell = cells[cellId]
    let className = yCoord < BoardSettings.hiddenRows ? styles.hiddenRow : undefined
    return <Cell key={cell.id}
      className={className}
      cell={cell}
      onMouseOver={gameStore.onHover}
      backgroundColor={CellSettings.color(cell.cellType, false)}
      width={CellSettings.edgeLength}
      height={CellSettings.edgeLength} />
  })
}

const generateRows = (cells: BoardCells) => {
  return [...Array(BoardSettings.height)].map((_, yCoord: number) => {
    return (
      <div key={yCoord} className={cn(styles.rows, {})} style={{ maxHeight: CellSettings.edgeLength }}>
        {generateCells(yCoord, cells)}
      </div>
    )
  })
}

const Board: FC<IBoardProps> = ({ cells }) => {
  return (
    <div className={cn(styles.wrapper)}>
      {generateRows(cells)}
    </div>)
}

export default Board
