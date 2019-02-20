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
     };
     this.cahnnel
     .join()
  }

  render() {
    return <div>
      <h1>ToDo</h1>
    </div>
  }

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
