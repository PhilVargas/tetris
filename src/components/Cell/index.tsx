import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Cell.module.scss'
import { ICellProps } from '../../typings'

const Cell: FC<ICellProps> = ({ className, ...styleProps }) => {
  return (
    <div style={{ ...styleProps }} className={cn(className, styles.wrapper)}></div>
  )
}

export default Cell
