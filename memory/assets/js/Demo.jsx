import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import _ from 'lodash';

export default function run_demo(root) {
  ReactDOM.render(<Demo />, root);
}

const initChars = ['A','B','C','D','F','E','D','C','B','E','F','G','H','H','G','A'];
const initState = {chars: initChars,
                  tileContents: [],
                  lockTiles: [],
                  firstClick: -1,
                  count: 0,
                  pair: 0,
                  inShowTime: false
                  };

class Demo extends Component {
  constructor(props) {
    super(props);
    this.state = initState;
  }

  restart() {
    this.setState({chars: initChars,
                  tileContents: [],
                  lockTiles: [],
                  firstClick: -1,
                  count: 0,
                  pair: 0,
                  inShowTime: false
                  });
  }

  clickHandler(index) {
    if (this.state.lockTiles[index] == true || this.state.inShowTime) return;
    let chars = this.state.chars;
    let firstClick = this.state.firstClick;
    let tileContents = this.state.tileContents;
    let newcount = this.state.count + 1;
    tileContents[index] = chars[index];
    this.setState({count: newcount})
    if (firstClick == -1) {
      this.setState({firstClick: index, tileContents: tileContents})
    } else {
      if (index == firstClick) return;
      if (chars[index] == chars[firstClick]) {
        let newlockTiles = this.state.lockTiles;
        newlockTiles[firstClick] = true;
        newlockTiles[index] = true;
        let newpair = this.state.pair + 1;
        this.setState({lockTiles: newlockTiles, pair: newpair});
      }
      this.setState({firstClick: index, tileContents: tileContents, inShowTime: true});
      setTimeout(() => {
        this.setState({firstClick: -1, tileContents: [], inShowTime: false});
      }, 1000)
    }
  }

  showContent(index) {
    if (this.state.lockTiles[index] == true) return (<div>Done</div>);
    return this.state.tileContents[index];
  }

  showScore() {
    if (this.state.pair == 8) {
      let score = 100 - this.state.count
      //alert("Success! Your Score is " + score);
      return (<div><h3>Success!</h3><p>Your Score is {score}</p></div>)
    }
  }

  renderTile(chars) {
    return(
      <div>
        {_.map(chars, (char,index) =>
          <button className="tile" key={index}
             onClick={() => this.clickHandler(index)}>
             {this.showContent(index)}
           </button>
        )}
      </div>
    )
  }

  render() {
    return (
      <div>
        <div id="game">
        <div>{this.renderTile(this.state.chars)}</div>
        <h3>Clicks: {this.state.count}</h3>
        <Button color="primary" size="lg" onClick={() => this.restart()}>Restart</Button>
        <p>Rule: Score =<br />100 - Clicks</p>
        <div>{this.showScore()}</div>
        </div>
      </div>
    )
  }
}
