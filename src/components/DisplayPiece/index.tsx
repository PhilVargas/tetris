import React, { FC } from 'react'
import cn from 'classnames'

import styles from './DisplayPiece.module.scss'
import { PieceType, CellType } from '../../typings'

interface IDisplayPieceProps {
  nextPieceType: PieceType
  hasGameBegun: boolean
}

const DisplayPiece: FC<IDisplayPieceProps> = ({ nextPieceType, hasGameBegun }) => {
  const className = `pieceType${nextPieceType}`
  return (
    <div className={cn(styles.wrapper, { [styles.disabled]: !hasGameBegun })}>
      {hasGameBegun &&
        [
          <div className={cn(styles.pieceCell, styles[className])}></div>,
          <div className={cn(styles.pieceCell, styles[className])}></div>,
          <div className={cn(styles.pieceCell, styles[className])}></div>,
          <div className={cn(styles.pieceCell, styles[className])}></div>
        ]
      }
    </div>
  )
}

export default DisplayPiece
