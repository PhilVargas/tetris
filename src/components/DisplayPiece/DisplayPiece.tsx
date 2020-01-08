import React, { FC } from 'react'
import cn from 'classnames'

import styles from './DisplayPiece.module.scss'
import colorStyles from '../Cell/Cell.module.scss'
import { IDisplayPieceProps } from '../../typings'


const DisplayPiece: FC<IDisplayPieceProps> = ({ pieceType, isEnabled, title, isActive, isColorblindModeEnabled }) => {
  const colorName = `cellType${pieceType}`
  const className = cn(styles.pieceCell, styles[colorName], colorStyles[colorName], {
    [colorStyles.colorBlind]: isColorblindModeEnabled
  })
  return (
    <div className={cn(styles.wrapper)}>
      <div>{title}</div>
      <div className={cn(styles.displayWrapper, { [styles.disabled]: !isEnabled || pieceType == null || !isActive })}>
        {isEnabled && pieceType != null &&
          [
            <div key={0} className={className}></div>,
            <div key={1} className={className}></div>,
            <div key={2} className={className}></div>,
            <div key={3} className={className}></div>,
          ]
        }
      </div>
    </div>
  )
}

export default DisplayPiece
