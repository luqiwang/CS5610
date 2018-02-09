import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function init_form(root) {
  ReactDOM.render(<Form />, root);
}

class Form extends Component {
  constructor(props) {
    super(props);
    this.state = {
      inputValue: '',
      url: ''
    };
  }

  render() {
    return(
      <div id="mid">
        <p>Input Your Game Name</p>
        <input value={this.state.inputValue}
          onChange={e => this.onInputChange(e)}/>
        <br/>
        <a href={this.state.url}>Start Game</a>
      </div>
    )
  }

  onInputChange(e) {
    this.setState({
      inputValue: e.target.value,
      url:  "/game/" + e.target.value
    })
  }
}
