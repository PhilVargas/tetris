React = require 'react'
ReactCSSTransitionGroup = require 'react-addons-css-transition-group'

Legend = React.createClass
  displayName: 'Legend'

  propTypes:
    level: React.PropTypes.number.isRequired
    score: React.PropTypes.number.isRequired
    scoreThisTurn: React.PropTypes.number.isRequired

  render: ->
    <div id='legend' className='row'>
      <div className="columns panel radius">
        <div className='row collapse' >
          <div className="columns large-3">
            score:
          </div>
          <div className="score-container columns large-4">
            { " #{@props.score}" }
          </div>
          <div className="columns large-4">
            <ReactCSSTransitionGroup transitionLeave={ false } transitionName="incremented-score" transitionEnterTimeout={ 500 }>
              <span key={ @props.score } className='incremented-score'>{ "+#{@props.scoreThisTurn}" }</span>
            </ReactCSSTransitionGroup>
          </div>
        </div>
        <div className='row collapse' >
          <div className="columns large-3">
            level:
          </div>
          <div className="level-container columns large-4">
            { " #{@props.level}" }
          </div>
          <div className="columns large-4">
          </div>
        </div>
        <div className='row'>
          <div className="columns">
            move with <pre className='code'>ASD</pre>
          </div>
        </div>
        <div className='row'>
          <div className="columns">
            drop with <pre className='code' >W</pre>
          </div>
        </div>
        <div className='row'>
          <div className="columns">
            rotate with <pre className='code'>Q</pre> & <pre className='code'>E</pre>
          </div>
        </div>
        <div className='row'>
          <div className="columns">
          <pre className='code'>Space</pre> to pause
          </div>
        </div>
        <div className='row'>
          <div className="columns queue-legend">
            <pre className='code'>Enter</pre>
            <span className='legend-text'> to queue a piece</span>
          </div>
        </div>
      </div>
    </div>

module.exports = Legend
