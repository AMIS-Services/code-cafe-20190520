import React from "react";
import { BarChart, XAxis, YAxis, Bar, Cell, CartesianGrid } from "recharts";
import { colorsHelper } from "../../helpers/colors";

const RechartsBar = () => {
  const data = [
    { percentage: 75, pie: "Red Velvet" },
    { percentage: 40, pie: "Appelkruimel" },
    { percentage: -25, pie: "Chocoladetaart" },
    { percentage: 100, pie: "Appeltaart" },
    { percentage: 30, pie: "Cheesecake" }
  ];
  return (
    <div className="chart-container">
      <h2>Bar Chart</h2>
      <BarChart width={800} height={400} data={data}>
        <CartesianGrid strokeDasharray="2 2" />
        <XAxis dataKey="pie" />
        <YAxis />
        <Bar dataKey="percentage">
          {data.map((_, index) => (
            <Cell fill={colorsHelper(index)} />
          ))}
        </Bar>
      </BarChart>
    </div>
  );
};

export default RechartsBar;
