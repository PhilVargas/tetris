import React, { FC } from 'react'
import cn from 'classnames'

import styles from './DisplayPiece.module.scss'
import { PieceType, CellType } from '../../typings'

interface IDisplayPieceProps {
  nextPieceType: PieceType
}

const DisplayPiece: FC<IDisplayPieceProps> = ({ nextPieceType }) => {
  const fakeType = CellType.L
  const className = `pieceType${fakeType}`
  return (
    <div className={cn(styles.wrapper)}>
      <div className={cn(styles.pieceCell, styles[className])}></div>
      <div className={cn(styles.pieceCell, styles[className])}></div>
      <div className={cn(styles.pieceCell, styles[className])}></div>
      <div className={cn(styles.pieceCell, styles[className])}></div>
    </div>
  )
}

export default DisplayPiece
