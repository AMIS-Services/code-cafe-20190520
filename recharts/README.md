# Recharts

## What is Recharts?

Recharts is a charting library for React. It can be used to easily create a good looking charts with lots of rooom for personalization. It is a nice middleway between adding pre-defined library components and the flexibility of it's parent library, d3js. These charts can be used in other frameworks such as Angular or Vue through the use of iframes. Recharts uses SVG images making them quite lightweight.

Since Recharts is a React library, it follows the React pattern of composition over inheritance. Charts are built by combining the different building blocks, which each have their own responsibility. For example, a line chart could have are parent `<LineChart />` component, with a nested `<XAxis />`, `<YAxis />`, `<Line />`, `<ToolTip />` and `<Legend />`. This allows for easy, gradual building of complex graphs.

## Getting started

You can choose to run your server either in docker or on your own system.

### Docker

```
$ docker build -t recharts:dev .
$ docker run -v ${PWD}:/app -v /app/node_modules -p 3001:3000 --rm recharts:dev
```

### Local dev

```
npm install
npm start
```

of

```
yarn
yarn start
```

### React

In case you are not familiar with react, you need to know very little to work with Recharts. Information can be passed to nested components (compontents look like this: `<ComponentName >...children...</ComponentName>` or `<ComponentName />` when there are no children) by simply doing the following:

```
<ComponentName nameOfProperty={variableCointainingProperty} />
```

### Making changes

Go ahead and make some changes in to the files in `src/`, your browser will hot reload and show your changes.

## Exercises

An example of a Piechart of bars and a Barchart of Pies have been added to the `src/charts/` folder. Take a look at how they have been made. Check out the docs at [recharts.org](recharts.org).

### LineChart

Create a small dataset showing your desire for pizza over time and implement a simple linechart, with an X-axis and Y-axis.

- Try out some different `type` values for the `<Line />` component.
- Add a legend and tooltip.

### RadarChart

Create an dataset containing your skills in different fields, your desired skilllevels and the maximum skilllevels. Implement a radar chart with a fill (a fully colored area) for your current skill levels.

- Add a line for your desired skill level
- Make the `ResponsiveContainer` actually responsive

### AreaChart

Expand on the mountain dataset and make an areaChart.

- Add seperate Y-Axes for mountain height and snow height. You will need to set the `yAxisId` property.

### ComposedChart

Go to town! Think of a fun dataset, put it together, add different types of lines, bars, areas, whatever tickles your fancy.

### ResponsiveContainer

## Docs

[recharts.org](recharts.org)

[recharts api ](http://recharts.org/en-US/api)

[recharts examples](http://recharts.org/en-US/examples)

[react](reactjs.org)
