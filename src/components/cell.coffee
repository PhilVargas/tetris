React = require 'react'
cx = require 'classnames'

Cell = React.createClass
  displayName: 'Cell'

  propTypes:
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired
    height: React.PropTypes.number.isRequired
    width: React.PropTypes.number.isRequired
    color: React.PropTypes.string.isRequired

  getDefaultProps: ->
    height: 20
    width: 20
    color: 'white'

  render: ->
    <div style={ { backgroundColor: @props.color } } className="cell"></div>

module.exports = Cell
