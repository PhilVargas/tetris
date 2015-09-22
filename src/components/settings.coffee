React = require 'react'

SettingsCheckbox = require('components/settings-checkbox')

cx = require 'classnames'
Settings = React.createClass
  displayName: 'Settings'

  propTypes:
    isGhostVisible: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired
    setBoardDisplaySize: React.PropTypes.func.isRequired
    shouldAllowQueue: React.PropTypes.bool.isRequired
    isColorblindActive: React.PropTypes.bool.isRequired
    toggleGhost: React.PropTypes.func.isRequired
    toggleMute: React.PropTypes.func.isRequired
    toggleQueue: React.PropTypes.func.isRequired
    toggleColorBlindMode: React.PropTypes.func.isRequired

  render: ->
    <div id='settings' className='row' >
      <div className="columns panel radius">
        <div className='row' >
          <div id='settings-header' className="columns">
            Settings
          </div>
        </div>
        <SettingsCheckbox
          containerId='music-setting'
          inputId='mute-button'
          isChecked={ !@props.isMuted }
          onCheckboxChange={ @handleAudioChange }
          settingText='Music'
        />
        <SettingsCheckbox
          containerId='ghost-setting'
          inputId='ghosts-button'
          isChecked={ @props.isGhostVisible }
          onCheckboxChange={ @handleGhostChange }
          settingText='Ghost'
        />
        <SettingsCheckbox
          containerId='queue-setting'
          inputId='queue-button'
          isChecked={ @props.shouldAllowQueue }
          onCheckboxChange={ @handleQueueChange }
          settingText='Queue'
        />
        <SettingsCheckbox
          containerId='colorblind-setting'
          inputId='colorblind-button'
          isChecked={ @props.isColorblindActive }
          onCheckboxChange={ @handleColorBlindChange }
          settingText='Colorblind Mode'
        />
        <div id="display-size-setting" className='row'>
          <div className="columns">
            <div className="row">
              <div className="columns">
                Board Display Size
              </div>
            </div>
            <div className="row">
              <div className="columns large-12">
                <ul className='button-group stack'>
                  <li>
                    <a className="button radius tiny" onClick={ @handleBoardDisplayClick.bind(null, 'small') }>Small</a>
                  </li>
                  <li>
                    <a className="button radius tiny" onClick={ @handleBoardDisplayClick.bind(null, 'medium') }>Medium</a>
                  </li>
                  <li>
                    <a className="button radius tiny" onClick={ @handleBoardDisplayClick.bind(null, 'large') }>Large</a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

  handleBoardDisplayClick: (size) ->
    @props.setBoardDisplaySize(size)

  handleQueueChange: ->
    @props.toggleQueue()

  handleGhostChange: ->
    @props.toggleGhost()

  handleAudioChange: ->
    @props.toggleMute()

  handleColorBlindChange: ->
    @props.toggleColorBlindMode()

module.exports = Settings
