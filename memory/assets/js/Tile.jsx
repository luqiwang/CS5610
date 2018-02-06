import React, { Component } from 'react';
import { Col } from 'reactstrap';

export default function(props) {
  return (
    <Col xs="3">
      <button className="tile"
         onClick={() => props.clickHandler(props.index)}>
         {props.showContent(props.index)}
       </button>
    </Col>
  )
}
