React = require 'react'
Settings = require 'helpers/settings'
cx = require 'classnames'

Cell = React.createClass
  displayName: 'Cell'

  propTypes:
    cellEdgeLength: React.PropTypes.number.isRequired
    color: React.PropTypes.string.isRequired
    isFrozen: React.PropTypes.bool.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired

  getDefaultProps: ->
    color: 'white'

  render: ->
    <div style={ { backgroundColor: @props.color, maxWidth: @props.cellEdgeLength, height: @props.cellEdgeLength } } className="cell"></div>

module.exports = Cell
