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

  const { yCoord, xCoord, cells } = gameState
  const boardProps: IBoardProps = { yCoord, xCoord, cells }

  return (
    <div className="App">
      <div className="flex">
        <div>
          <button className="btn">Start</button>
        </div>
      </div>
      <Board {...boardProps} />
      <div className="flex"></div>
    </div>
  );
}

export default App;
