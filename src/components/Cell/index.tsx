import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Cell.module.scss'
import { ICellProps } from '../../typings'

const Cell: FC<ICellProps> = ({ className, isHidden, isGhost, isPiece, cellType, ...styleProps }) => {
  const computedClassName = cn(className, styles.wrapper, styles[`cellType${cellType}`], {
    [styles.colorBlind]: false,
    [styles.hiddenRow]: isHidden,
    [styles.ghost]: isGhost,
    [styles.piece]: isPiece
  })
  return (
    <div style={{ ...styleProps }} className={computedClassName}></div>
  )
}

export default Cell
