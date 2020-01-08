import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Cell.module.scss'
import { ICellProps } from '../../typings'

const Cell: FC<ICellProps> = ({ className, isHidden, isGhost, isPiece, cellType, isColorblindModeEnabled, isGhostEnabled, ...styleProps }) => {
  const computedClassName = cn(className, styles.wrapper, styles[`cellType${cellType}`], {
    [styles.colorBlind]: isColorblindModeEnabled,
    [styles.hiddenRow]: isHidden,
    [styles.ghost]: isGhost && isGhostEnabled,
    [styles.piece]: isPiece
  })
  return (
    <div style={{ ...styleProps }} className={computedClassName}></div>
  )
}

export default Cell
