React = require 'react/addons'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

Legend = React.createClass
  displayName: 'Legend'

  propTypes:
    score: React.PropTypes.number.isRequired
    level: React.PropTypes.number.isRequired
    linesCleared: React.PropTypes.number.isRequired
    scoreThisTurn: React.PropTypes.number.isRequired

  render: ->
    <div id='legend' className='row'>
      <div className="columns panel radius">
        <div className='row collapse' >
          <div className="columns large-3">
            score:
          </div>
          <div className=" score-container columns large-4">
            { " #{@props.score}" }
          </div>
          <div className="columns large-4">
            <ReactCSSTransitionGroup transitionLeave={ false } transitionName="incremented-score">
              <span key={ @props.score } className='incremented-score'>{ "+#{@props.scoreThisTurn}" }</span>
            </ReactCSSTransitionGroup>
          </div>
        </div>
        <div className='row' >
          <div className="columns">
            { "level: #{@props.level}" }
          </div>
        </div>
        <div className='row' >
          <div className="columns">
            { "lines cleared: #{@props.linesCleared}" }
          </div>
        </div>
        <div className='row'>
          <div className="columns">
            Move with <pre className='code'>ASD</pre>
          </div>
        </div>
        <div className='row'>
          <div className="columns">
            Drop with <pre className='code' >W</pre>
          </div>
        </div>
        <div className='row'>
          <div className="columns">
            Rotate with <pre className='code'>Q</pre> & <pre className='code'>E</pre>
          </div>
        </div>
        <div className='row'>
          <div className="columns">
          <pre className='code'>Space</pre> to pause
          </div>
        </div>
        <div className='row'>
          <div className="columns queue-legend">
            <pre className='code'>Enter</pre> to queue a piece
          </div>
        </div>
      </div>
    </div>

module.exports = Legend
