import React, { FC, MouseEvent } from 'react'

import styles from './Overlay.module.scss'
import { IOverlayProps } from '../../typings'


const Overlay: FC<IOverlayProps> = ({ isPaused, hasGameBegun, startGame, resumeGame, score }) => {
  if (hasGameBegun && !isPaused) { return null }
  const buttonText = hasGameBegun ? 'Resume' : 'Start'

  const onClick = (e: MouseEvent<HTMLButtonElement, any>) => {
    e.preventDefault()
    hasGameBegun ? resumeGame() : startGame()
  }

  const text = `Current score is a ${score}`

  return (
    <div className={styles.wrapper}>
      <div className={styles.container}>
        <button className="btn" onClick={onClick}>{buttonText}</button>
        <p className={styles.overlayText}>{text}</p>
      </div>
    </div>
  )
}

export default Overlay
