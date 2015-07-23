React = require 'react'

Settings = React.createClass
  displayName: 'Settings'

  propTypes:
    isMuted: React.PropTypes.bool.isRequired
    isGhostVisible: React.PropTypes.bool.isRequired
    shouldAllowQueue: React.PropTypes.bool.isRequired
    toggleQueue: React.PropTypes.func.isRequired
    toggleGhost: React.PropTypes.func.isRequired
    toggleMute: React.PropTypes.func.isRequired

  render: ->
    <div id='settings' className='row' >
      <div className="columns panel radius">
        <div className='row' >
          <div className="columns">
            Settings
          </div>
        </div>
        <div className="row switch radius tiny">
          <div className="columns large-4">Music</div>
          <input id="mute-button" type="checkbox" checked={ !@props.isMuted  } onChange={ @handleAudioChange } />
          <label onClick={ @handleAudioChange }></label>
        </div>
        <div className="row switch radius tiny">
          <div className="columns large-4">Ghost</div>
          <input id="ghost-button" type="checkbox" checked={ @props.isGhostVisible  } onChange={ @handleGhostChange } />
          <label onClick={ @handleGhostChange }></label>
        </div>
        <div className="row switch radius tiny">
          <div className="columns large-4">Queue</div>
          <input id="ghost-button" type="checkbox" checked={ @props.shouldAllowQueue  } onChange={ @handleQueueChange } />
          <label onClick={ @handleQueueChange }></label>
        </div>
      </div>
    </div>

  handleQueueChange: ->
    @props.toggleQueue()

  handleGhostChange: ->
    @props.toggleGhost()

  handleAudioChange: ->
    @props.toggleMute()

module.exports = Settings
