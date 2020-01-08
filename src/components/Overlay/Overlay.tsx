import React, { FC, MouseEvent } from 'react'
import cn from 'classnames'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPause } from '@fortawesome/free-solid-svg-icons'

import styles from './Overlay.module.scss'
import { IOverlayProps } from '../../typings'


const Overlay: FC<IOverlayProps> = ({ isPaused, hasGameBegun, startGame, resumeGame, score, isGameOver }) => {
  if (hasGameBegun && !isPaused && !isGameOver) { return null }

  const buttonText = cn({
    "Start": !hasGameBegun,
    "Restart": hasGameBegun && isGameOver
  })

  const onClick = (e: MouseEvent<HTMLButtonElement, any>) => {
    e.preventDefault()
    startGame()
  }

  const text = cn({
    [`Game Over!\nScore: ${score}`]: isGameOver,
  })

  return (
    <div className={styles.wrapper}>
      <div className={styles.container}>
        <p className={styles.overlayText}>{text}</p>
        {(!hasGameBegun || isGameOver) &&
          <button className="btn" onClick={onClick}>{buttonText}</button>
        }
        {!hasGameBegun &&
          <p className={styles.overlayText}>(Audio is Enabled)</p>
        }
        {hasGameBegun && !isGameOver &&
          <div className={styles.overlayText}>
            <FontAwesomeIcon icon={faPause} size="4x" />
          </div>
        }
      </div>
    </div >
  )
}

export default Overlay
