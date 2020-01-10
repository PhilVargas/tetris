import React, { FC } from 'react'
import ReactCSSTransitionGroup from 'react-addons-css-transition-group'
import cn from 'classnames'

import styles from './Legend.module.scss'
import './LegendTransition.scss'

import { ILegendProps } from '../../typings'

const Legend: FC<ILegendProps> = ({ level, score, scoreThisTurn }) => {
  return (
    <div className={cn(styles.wrapper)}>
      <div className={cn(styles.scoreRow)}>
        <span className={cn(styles.scoreItem)}>score: {score}</span>
        <ReactCSSTransitionGroup transitionLeave={false} transitionName="incremented-score" transitionEnterTimeout={500}>
          <span key={score} className={cn('incremented-score', styles.scoreThisTurn)}>+{scoreThisTurn}</span>
        </ReactCSSTransitionGroup>
      </div>
      <div>level: {level}</div>
      <div>move with <pre className={cn(styles.code)}>ASD</pre></div>
      <div>drop with <pre className={cn(styles.code)}>ASD</pre></div>
      <div>rotate with <pre className={cn(styles.code)}>q</pre> & <pre className={cn(styles.code)}>e</pre></div>
      <div><pre className={cn(styles.code)}>space</pre> to pause</div>
      <div><pre className={cn(styles.code)}>enter</pre> to queue a piece</div>
    </div>
  )
}

export default Legend
