import React, { FC } from 'react'
import cn from 'classnames'

import styles from './DisplayPiece.module.scss'
import colorStyles from '../Cell/Cell.module.scss'
import { PieceType } from '../../typings'

interface IDisplayPieceProps {
  nextPieceType: PieceType
  hasGameBegun: boolean
}

const DisplayPiece: FC<IDisplayPieceProps> = ({ nextPieceType, hasGameBegun }) => {
  const colorName = `cellType${nextPieceType}`
  const className = cn(styles.pieceCell, styles[colorName], colorStyles[colorName], { [colorStyles.colorBlind]: false })
  return (
    <div className={cn(styles.wrapper, { [styles.disabled]: !hasGameBegun })}>
      {hasGameBegun &&
        [
          <div key={0} className={className}></div>,
          <div key={1} className={className}></div>,
          <div key={2} className={className}></div>,
          <div key={3} className={className}></div>,
        ]
      }
    </div>
  )
}

export default DisplayPiece
