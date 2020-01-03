import React, { FC } from 'react'
import cn from 'classnames'

import { IBoardCell } from '../../typings'
import styles from './Cell.module.scss'

interface ICellProps {
  className?: string
  cell: IBoardCell
  backgroundColor: string
  width: number
  height: number
  onMouseOver: (cellId: number) => void
}

const Cell: FC<ICellProps> = ({ cell, onMouseOver, className, ...styleProps }) => {
  return (
    <div style={{ ...styleProps }} className={cn(className, styles.wrapper)} onMouseOver={() => { onMouseOver(cell.id) }}></div>
  )
}

export default Cell
