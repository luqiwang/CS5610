import React, { Component } from 'react';
import { Button, Container, Col, Row } from 'reactstrap';


export default function(props) {
  return (
    <Container id="menu">
      <Row>
        <Col lg="4"><h3>Clicks: {props.count}</h3></Col>
        <Col lg="4"><Button color="primary" size="lg" onClick={() => props.restart()}>Restart</Button></Col>
        <Col lg="4"><h3>Score: {100 - props.count}</h3></Col>
      </Row>
      <div>{props.showScore()}</div>
    </Container>
  )
}
