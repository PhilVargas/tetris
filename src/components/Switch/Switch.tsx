import React, { FC } from 'react'

import { ISwitchProps } from '../../typings'



const Switch: FC<ISwitchProps> = ({ className, labelText, isChecked, onChange }) => {
  return (
    <label className={className}>
      <span>{labelText}</span>
      <input type="checkbox" checked={isChecked} onChange={onChange}></input>
    </label>
  )
}

export default Switch
