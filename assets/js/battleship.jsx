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
    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp) });

    this.channel.on("update", this.gotView.bind(this))
  }
  
  gotView(view) {
    console.log("new view", view);
    this.setState(view.game);
  }

  render() {
    console.log("render");

    let squares = _.map(this.state.player_board, (square) => {
      return <SquareItem square={square}/>
    });

    return <div>
      <h1>ToDo</h1>
      <div className="Board1">{squares}</div>
    </div>
  }

}

function SquareItem(props) {
  let square = props.square;
  return <button className="Square">{square.symbol}</button>
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
