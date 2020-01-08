import React, { FC, useState, useLayoutEffect, useEffect } from 'react';
import './App.scss';
import Board from './components/Board'
import gameStore from './store/game';
import { IBoardProps } from './typings';
import Overlay from './components/Overlay';
import DisplayPiece from './components/DisplayPiece';
import Legend from './components/Legend'
import Calculate from './utils/Calculator';

const App: FC = () => {
  const [gameState, setgameState] = useState(gameStore.generateInitialState())

  useEffect(() => {
    let id: NodeJS.Timeout

    function tick() {
      if (gameState.hasGameBegun && !gameState.isGameOver) {
        gameStore.nextTurn()
      }
      id = setTimeout(tick, gameState.turnDelay)
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
        case 'ArrowUp':
        case 'w':
          gameStore.dropPiece()
          break
        case 'q':
          gameStore.rotatePiece(1)
          break
        case 'e':
          gameStore.rotatePiece(-1)
          break
      }
    })

    return () => {
      gameStore.unsubcribe()
    }
  }, [setgameState])

  const { cells, isPaused, hasGameBegun, score, isGameOver, nextPieceType, totalLinesCleared } = gameState
  const boardProps: IBoardProps = { cells }
  return (
    <div className="App">
      <div className="left-panel">
        <div className="flex flex-stretch">
          <div className="panel legend-container">
            <Legend score={score} level={Calculate.level(totalLinesCleared)} />
          </div>
          <div className="panel">
          </div>
        </div>
      </div>
      <div className="board-anchor">
        <Overlay
          isGameOver={isGameOver}
          isPaused={isPaused}
          hasGameBegun={hasGameBegun}
          startGame={gameStore.startGame}
          resumeGame={gameStore.togglePause}
          score={score}
        />
        <Board {...boardProps} />
      </div>
      <div className="right-panel">
        <div className="flex flex-stretch">
          <div className="panel callout display-piece-container">
            <DisplayPiece nextPieceType={nextPieceType} hasGameBegun={hasGameBegun} title={"Next Piece"} />
            <DisplayPiece nextPieceType={nextPieceType} hasGameBegun={hasGameBegun} title={"Hold Piece"} />
          </div>
          <div className="attributions panel">
            <h4>Tetris by Philip A Vargas</h4>
            <div>Tetris by Philip A Vargas</div>
            <div>Tetris by Philip A Vargas</div>
            <div>Tetris by Philip A Vargas</div>
            <div>Tetris by Philip A Vargas</div>
            <div>Tetris by Philip A Vargas</div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
