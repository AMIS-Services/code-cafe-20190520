import React from "react";
import { ResponsiveContainer, Pie, PieChart, Cell, Tooltip } from "recharts";
import { colorsHelper } from "../../helpers/colors";

const RechartsPie = () => {
  const data = [
    { percentage: 10, bar: "ACU" },
    { percentage: 25, bar: "Biton" },
    { percentage: 5, bar: "Weerbericht" },
    { percentage: 60, bar: "Stichtse Taveerne" }
  ];

  return (
    <div className="chart-container">
      <h2>Pie Chart</h2>
      <ResponsiveContainer width={400} height={400}>
        <PieChart>
          <Pie data={data} dataKey="percentage" nameKey="bar" label={({ index }) => data[index]["bar"]}>
            {data.map((dataPoint, index) => (
              <Cell key={dataPoint.bar} fill={colorsHelper(index)} />
            ))}
          </Pie>
          <Tooltip formatter={value => `${value}%`} />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
};

export default RechartsPie;
