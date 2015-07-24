React = require 'react'
Settings = require 'helpers/settings'
cx = require 'classnames'

Cell = React.createClass
  displayName: 'Cell'

  propTypes:
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired
    edgeLength: React.PropTypes.number.isRequired
    color: React.PropTypes.string.isRequired
    isFrozen: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    edgeLength: Settings.cellEdgeLength
    color: 'white'

  render: ->
    <div style={ { backgroundColor: @props.color } } className="cell"></div>

module.exports = Cell
