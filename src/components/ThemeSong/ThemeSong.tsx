import React, { FC, useRef, useEffect } from 'react'
import cn from 'classnames'

import { IThemeSongProps } from '../../typings'
import { ThemeSongUrl } from '../../constants/Settings'

import styles from './ThemeSong.module.scss'

const ThemeSong: FC<IThemeSongProps> = ({ isAudioMuted, isPaused, hasGameBegun }) => {
  const audioEl = useRef<HTMLAudioElement>(null)

  useEffect(() => {
    if (audioEl.current == null) { return }
    if (isAudioMuted || isPaused || !hasGameBegun) {
      audioEl.current.pause()
    } else {
      audioEl.current.play()
    }
  })

  return (
    <div className={cn(styles.wrapper)}>
      <audio ref={audioEl} src={ThemeSongUrl} loop />
    </div>
  )
}

export default ThemeSong
