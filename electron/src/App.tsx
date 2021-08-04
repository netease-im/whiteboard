import React from "react";
import {
    HashRouter as Router,
  Switch,
  Route
} from "react-router-dom";

import Config from "./Config";
import Room from "./Room";

export default function App() {
  return (
    <Router>
      <div>
        <Switch>
          <Route exact path="/" component={Config} />
          <Route path="/room" component={Room} />
        </Switch>
      </div>
    </Router>
  );
}