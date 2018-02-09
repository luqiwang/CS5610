import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { Button, Container, Col, Row } from 'reactstrap';
import _ from 'lodash';
import Tile from './Tile';
import Menu from './Menu';

export default function run_demo(root, channel) {
  ReactDOM.render(<Demo channel={channel} />, root);
}


class Demo extends Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {chars: [],
                  tileContents: [],
                  lockTiles: [],
                  firstClick: -1,
                  count: 0,
                  pair: 0,
                  inShowTime: false
                 };
   this.channel.join()
       // .receive("ok", resp => { console.log("Joined successfully", resp.game)})
       .receive("ok", this.gotView.bind(this))
       .receive("error", resp => { console.log("Unable to join", resp) });
  }


  gotView(view) {
    // console.log("New View", view.game)
    this.setState(view.game);
    if (view.game.inShowTime) {
      setTimeout(() => {
        this.flipBack(view.game)
     }, 1000)
    }
  }

  sendClick(index) {
    if (this.state.inShowTime) return;
    this.channel.push("click", {index: index})
        .receive("ok", this.gotView.bind(this))
  }

  flipBack(game) {
    this.channel.push("flip_back", {game: game})
        .receive("ok", this.gotView.bind(this))
  }

  restart() {
    this.channel.push("restart", {hi: "there"})
        .receive("ok", this.gotView.bind(this))
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
          sendClick={this.sendClick.bind(this)}
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
