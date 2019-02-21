import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function battleship_init(root, channel) {
    ReactDOM.render(<Battleship channel={channel} />, root);
}


class Battleship extends React.Component {
  constructor(props) {
    super(props);

     this.channel = props.channel;
     this.state = {
        boards: [],
        player_board: [],
        opponent_board: [],
        score: 0,
        players: []
     };
     this.cahnnel
     .join()
  }

  render() {
    console.log("render");

    let squares = _.map(this.state.player_board, (square) => {
      return <SquareItem square={square}/>
    });

    return <div>
      <h1>ToDo</h1>
      <div className="Board">{squares}</div>
    </div>
  }

}

function SquareItem(props) {
  let square = props.square;
  return <button className="Square">Test</button>
}

function DisplayTile(props) {
   let {value, ii, tile_click} = props

   if (vlaue != "") {
      return <div className="column">
         <p><button>X</button></p>
         </div>
   }
   else {
      return <div className="column">
         <p><button>O</button></p>
         </div>
   }
}
