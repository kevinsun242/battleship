import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function battleship_init(root, channel) {
    ReactDOM.render(<Battleship channel={channel} />, root);
}


class Hangman extends React.Component {
  constructor(props) {
    super(props);


    }


  render() {
    return <div>
      <h1>ToDo</h1>
    </div>
  }
}