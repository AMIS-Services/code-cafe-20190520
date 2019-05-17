import React from "react";
import "./App.css";
import Piechart from "./charts/PieChart/PieChart";
import BarChart from "./charts/BarChart/BarChart";
import AreaChart from "./charts/AreaChart/AreaChart";
import ComposedChart from "./charts/ComposedChart/ComposedChart";
import LineChart from "./charts/LineChart/LineChart";
import RadarChart from "./charts/RadarChart/RadarChart";
import ScatterChart from "./charts/ScatterChart/ScatterChart";

function App() {
  return (
    <div className="App">
      <h1>Recharts</h1>
      <Piechart />
      <BarChart />
      <AreaChart />
      <ComposedChart />
      <LineChart />
      <RadarChart />
      <ScatterChart />
    </div>
  );
}

export default App;
