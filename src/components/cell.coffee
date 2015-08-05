React = require 'react'
Settings = require 'helpers/settings'
cx = require 'classnames'

Cell = React.createClass
  displayName: 'Cell'

  propTypes:
    cellEdgeLength: React.PropTypes.number.isRequired
    color: React.PropTypes.string.isRequired

  render: ->
    <div style={ { backgroundColor: @props.color, maxWidth: @props.cellEdgeLength, height: @props.cellEdgeLength } } className="cell"></div>

module.exports = Cell
