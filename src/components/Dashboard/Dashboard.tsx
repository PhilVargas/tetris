import React, { FC } from 'react'
import cn from 'classnames'

import styles from './Dashboard.module.scss'
import { IDashboardProps } from '../../typings'

import Switch from '../Switch'

const Dashboard: FC<IDashboardProps> = ({ isColorblindModeEnabled, onColorblindChange, isGhostEnabled, onGhostChange, isQueuePieceEnabled, onQueueChange }) => {
  return (
    <div className={cn(styles.wrapper)}>
      <div className={cn(styles.header)}>settings</div>
      <Switch
        className={cn(styles.colorblindContainer)}
        labelText={"colorblind mode"}
        isChecked={isColorblindModeEnabled}
        onChange={onColorblindChange}
      />
      <Switch
        className={cn(styles.ghostContainer)}
        labelText={"ghost"}
        isChecked={isGhostEnabled}
        onChange={onGhostChange}
      />
      <Switch
        className={cn(styles.queueContainer)}
        labelText={"queue"}
        isChecked={isQueuePieceEnabled}
        onChange={onQueueChange}
      />
    </div>
  )
}

export default Dashboard
