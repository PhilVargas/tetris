import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Cell.module.scss'
import { ICellProps } from '../../typings'

const Cell: FC<ICellProps> = ({ className, isHidden, isGhost, ...styleProps }) => {
  const computedClassName = cn(className, styles.wrapper, {
    [styles.hiddenRow]: isHidden,
    [styles.ghost]: isGhost
  })
  return (
    <div style={{ ...styleProps }} className={computedClassName}></div>
  )
}

export default Cell
