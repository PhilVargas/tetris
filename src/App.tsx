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
  }, [setgameState])

  const { yCoord, xCoord, cells, currentPieceType, pieceIds } = gameState
  const boardProps: IBoardProps = { yCoord, xCoord, cells, currentPieceType, pieceIds }
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
