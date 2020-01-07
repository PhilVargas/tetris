import React, { FC, MouseEvent } from 'react'
import cn from 'classnames'

import styles from './Overlay.module.scss'
import { IOverlayProps } from '../../typings'


const Overlay: FC<IOverlayProps> = ({ isPaused, hasGameBegun, startGame, resumeGame, score, isGameOver }) => {
  if (hasGameBegun && !isPaused && !isGameOver) { return null }
  const buttonText = hasGameBegun && !isGameOver ? 'Resume' : 'Start'

  const onClick = (e: MouseEvent<HTMLButtonElement, any>) => {
    e.preventDefault()
    hasGameBegun && !isGameOver ? resumeGame() : startGame()
  }

  const text = cn({
    "Total Score:": isGameOver,
    "Current Score:": !isGameOver,
  },
    `${score}`
  )

  return (
    <div className={styles.wrapper}>
      <div className={styles.container}>
        {isGameOver &&
          <p className={styles.overlayText}>Game Over!</p>
        }
        <button className="btn" onClick={onClick}>{buttonText}</button>
        <p className={styles.overlayText}>{text}</p>
      </div>
    </div>
  )
}

export default Overlay
