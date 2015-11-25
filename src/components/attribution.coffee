React = require 'react'

Attribution = React.createClass
  displayName: 'Attribution'

  propTypes: {}

  render: ->
    <div id="attribution">
      <h6 className='attribution-title'>Tetris By Philip A Vargas</h6>
      <div id="contact">
        <div id="linkedin-contact">
          <a target="_blank" href="https://www.linkedin.com/in/philipavargas">
            <i className="fa fa-linkedin"></i>
            {"\u0020"}
            <span>philipavargas</span>
          </a>
        </div>
        <div id="github-contact">
          <a target="_blank" href="https://github.com/PhilVargas">
            <i className="fa fa-github"></i>
            {"\u0020"}
            <span>@PhilVargas</span>
          </a>
        </div>
        <div id="email-contact">
          <i className="fa fa-envelope"></i>
          {"\u0020"}
          <span className='contact-text'>philipavargas@gmail.com</span>
        </div>
        <div id="stack-overflow-contact">
          <a target="_blank" href="http://stackoverflow.com/users/3213605/philvarg?tab=profile">
            <i className="fa fa-stack-overflow"></i>
            {"\u0020"}
            <span>@PhilVarg</span>
          </a>
        </div>
        <div id="github-source-container">
          <a target="_blank" href="https://github.com/PhilVargas/tetris">
            <i className='fa fa-github'></i>
            {"\u0020"}
            <span>View Source Code</span>
          </a>
        </div>
      </div>
    </div>


module.exports = Attribution
