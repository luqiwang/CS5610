import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { Button, Container, Col, Row } from 'reactstrap';
import _ from 'lodash';
import Tile from './Tile';
import Menu from './Menu';

export default function run_demo(root) {
  ReactDOM.render(<Demo />, root);
}

const initChars = ['A','B','C','D','F','E','D','C','B','E','F','G','H','H','G','A'];

class Demo extends Component {
  constructor(props) {
    super(props);
    this.state = {chars: this.shuffle(initChars),
                  tileContents: [],
                  lockTiles: [],
                  firstClick: -1,
                  count: 0,
                  pair: 0,
                  inShowTime: false
                 };
  }

  // the shuffle algorithme is based on stack overflow: https://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array
  shuffle(chars) {
    for (let i = chars.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [chars[i], chars[j]] = [chars[j], chars[i]];
    }
    return chars;
  }

  restart() {
    this.setState({chars: this.shuffle(initChars),
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
        <Row>
        {_.map(chars, (char,index) =>
          <Tile key = {index} index={index}
          clickHandler={this.clickHandler.bind(this)}
          showContent={this.showContent.bind(this)}/>
        )}
      </Row>
      </div>
    )
  }

  render() {
    return (
      <div>
        <Container><Row>{this.renderTile(this.state.chars)}</Row></Container>
        <Menu
        count={this.state.count}
        restart={this.restart.bind(this)}
        showScore={this.showScore.bind(this)} />
      </div>
    )
  }
}
