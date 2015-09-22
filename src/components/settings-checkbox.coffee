React = require 'react'

cx = require 'classnames'

SettingsCheckbox = React.createClass
  displayName: 'SettingsCheckbox'

  propTypes:
    containerClass: React.PropTypes.string
    containerId: React.PropTypes.string
    inputId: React.PropTypes.string
    isChecked: React.PropTypes.bool.isRequired
    onCheckboxChange: React.PropTypes.func.isRequired
    settingText: React.PropTypes.string.isRequired

  getDefaultProps: ->
    containerClass: ''
    containerId: ''
    inputId: ''

  containerClass: ->
    cx "row collapse", @props.containerClass

  render: ->
    <div id={ @props.containerId } className={ @containerClass() }>
      <div className="settings-text columns large-8">{ @props.settingText }</div>
      <div className="settings-switch columns large-4 switch radius tiny">
        <input id={ @props.inputId } type="checkbox" checked={ @props.isChecked } onChange={ @handleChange } />
        <label onClick={ @handleChange }></label>
      </div>
    </div>

  handleChange: ->
    @props.onCheckboxChange()

module.exports = SettingsCheckbox
