import React, { FC, useState, useLayoutEffect } from 'react';
import './App.scss';
import Board from './components/Board'
import gameStore from './store/game';
import { IBoardProps } from './typings';

const App: FC = () => {
  const [gameState, setgameState] = useState(gameStore.generateInitialState())

  useLayoutEffect(() => {
    gameStore.subscribe(setgameState)
    gameStore.init()

    window.addEventListener('keydown', (e) => {
      switch (e.key) {
        case 'Enter':
          gameStore.onGenerateRandomPiece()
          break
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
          // todo
          break
      }
    })

    return () => { gameStore.unsubcribe() }
  }, [setgameState])

  const { cells } = gameState
  const boardProps: IBoardProps = { cells }
  return (
    <div className="App">
      <div className="flex">
        <div>
          <button className="btn" onClick={gameStore.onGenerateRandomPiece}>Start</button>
        </div>
      </div>
      <Board {...boardProps} />
      <div className="flex"></div>
    </div>
  );
}

export default App;
