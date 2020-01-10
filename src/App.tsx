import React, { FC, useState, useLayoutEffect, useEffect } from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEnvelope } from '@fortawesome/free-solid-svg-icons'
import { faLinkedin, faGithub, faStackOverflow } from '@fortawesome/free-brands-svg-icons'
import './App.scss'

import { IBoardProps, IDashboardProps, IDisplayPieceProps, IThemeSongProps, IOverlayProps, ILegendProps } from './typings'
import gameStore from './store/game'
import Board from './components/Board'
import Overlay from './components/Overlay'
import DisplayPiece from './components/DisplayPiece'
import Legend from './components/Legend'
import Calculate from './utils/Calculator'
import Dashboard from './components/Dashboard'
import ThemeSong from './components/ThemeSong'

const App: FC = () => {
  const [gameState, setgameState] = useState(gameStore.generateInitialState())

  useEffect(() => {
    let id: NodeJS.Timeout

    function tick() {
      id = setTimeout(tick, gameState.turnDelay)
      if (gameState.hasGameBegun && !gameState.isGameOver) {
        gameStore.nextTurn()
      }
    }
    id = setTimeout(tick, gameState.turnDelay)
    return () => {
      clearTimeout(id)
    }
  }, [gameState.turnDelay, gameState.hasGameBegun, gameState.isGameOver])

  useLayoutEffect(() => {
    gameStore.subscribe(setgameState)
    gameStore.init()

    window.addEventListener('keyup', (e) => {
      e.preventDefault()

      switch (e.key) {
        case ' ':
          gameStore.togglePause()
          break
        case 'Enter':
          gameStore.swapQueuePiece()
          break
        case 'ArrowUp':
        case 'w':
          gameStore.dropPiece()
          break
      }
    })

    window.addEventListener('keydown', (e) => {
      switch (e.key) {
        case 'ArrowDown':
        case 's':
          gameStore.updatePieceCoordinates({ x: 0, y: 1 })
          break
        case 'ArrowRight':
        case 'd':
          gameStore.updatePieceCoordinates({ x: 1, y: 0 })
          break
        case 'ArrowLeft':
        case 'a':
          gameStore.updatePieceCoordinates({ x: -1, y: 0 })
          break
        case 'q':
          gameStore.rotatePiece(-1)
          break
        case 'e':
          gameStore.rotatePiece(1)
          break
      }
    })

    return () => {
      gameStore.unsubcribe()
    }
  }, [setgameState])

  const {
    cells,
    isPaused,
    hasGameBegun,
    score,
    scoreThisTurn,
    isGameOver,
    nextPieceType,
    totalLinesCleared,
    isColorblindModeEnabled,
    isGhostEnabled,
    queuePieceType,
    isQueuePieceEnabled,
    canQueuePiece,
    isAudioMuted,
  } = gameState

  const {
    toggleColorblindMode: onColorblindChange,
    toggleGhost: onGhostChange,
    toggleQueuePiece: onQueueChange,
    toggleAudio: onAudioChange,
    startGame,
  } = gameStore

  const overlayProps: IOverlayProps = {
    score,
    isAudioMuted,
    isGameOver,
    isPaused,
    hasGameBegun,
    startGame,
  }

  const boardProps: IBoardProps = {
    cells,
    isColorblindModeEnabled,
    isGhostEnabled,
  }

  const dashBoardProps: IDashboardProps = {
    isColorblindModeEnabled,
    isGhostEnabled,
    onColorblindChange,
    onGhostChange,
    isQueuePieceEnabled,
    onQueueChange,
    isAudioMuted,
    onAudioChange,
  }

  const queuePieceProps: IDisplayPieceProps = {
    pieceType: queuePieceType,
    isEnabled: hasGameBegun && isQueuePieceEnabled,
    isActive: canQueuePiece,
    isColorblindModeEnabled,
    title: "Queue Piece"
  }

  const nextPieceProps: IDisplayPieceProps = {
    pieceType: nextPieceType,
    isEnabled: hasGameBegun,
    isActive: true,
    isColorblindModeEnabled,
    title: "Next Piece"
  }

  const themeSongProps: IThemeSongProps = { isAudioMuted, isPaused, hasGameBegun }

  const legendProps: ILegendProps = { score, scoreThisTurn, level: Calculate.level(totalLinesCleared) }

  return (
    <div className="App">
      <ThemeSong {...themeSongProps} />
      <div className="left-panel">
        <div className="flex flex-stretch">
          <div className="panel legend-container">
            <Legend {...legendProps} />
          </div>
          <div className="panel">
            <Dashboard {...dashBoardProps} />
          </div>
        </div>
      </div>
      <div className="board-anchor">
        <Overlay {...overlayProps} />
        <Board {...boardProps} />
      </div>
      <div className="right-panel">
        <div className="flex flex-stretch">
          <div className="panel callout display-piece-container">
            <DisplayPiece {...nextPieceProps} />
            <DisplayPiece {...queuePieceProps} />
          </div>
          <div className="attributions panel">
            <h4>Tetris by Philip A Vargas</h4>
            <a target="_blank" rel="noopener noreferrer" href="https://www.linkedin.com/in/philipavargas">
              <FontAwesomeIcon icon={faLinkedin} />
              <span>philipavargas</span>
            </a>
            <a target="_blank" rel="noopener noreferrer" href="https://github.com/PhilVargas">
              <FontAwesomeIcon icon={faGithub} />
              <span>@PhilVargas</span>
            </a>
            <div>
              <FontAwesomeIcon icon={faEnvelope} />
              <span>philipavargas@gmail.com</span>
            </div>
            <a target="_blank" rel="noopener noreferrer" href="http://stackoverflow.com/users/3213605/philvarg?tab=profile">
              <FontAwesomeIcon icon={faStackOverflow} />
              <span>@philvarg</span>
            </a>
            <a target="_blank" rel="noopener noreferrer" href="https://github.com/PhilVargas/tetris">
              <FontAwesomeIcon icon={faGithub} />
              <span>View Source Code</span>
            </a>
          </div>
        </div>
      </div>
    </div>
  )
}

export default App
