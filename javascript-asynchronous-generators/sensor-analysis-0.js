const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, Math.floor(milliseconds)))
}

const lg = (msg) => {
    const d = new Date()
    console.log(`${d.getSeconds()}.${Math.round(d.getMilliseconds() / 100)}  - ${msg}`)
}

// each sensor has a slightly randomized timeput period, suggesting a different and somewhat varying production rate of measurements
// each sensor produces temperature measurements around an average value with a certain variation. 
const sensorOneTimeOut = 600
sensorOne = async function () {
    return sleep((0.7 + 0.6 * Math.random()) * sensorOneTimeOut).then(() => { return { sensor: 'sensor-one', temperature: 295 + 4.3 * (0.7 + 0.6 * (Math.random())) } })
}

const sensorTwoTimeOut = 750
sensorTwo = async function () {
    return sleep((0.4 + 0.6 * Math.random()) * sensorTwoTimeOut).then(() => { return { sensor: 'sensor-two', temperature: 293 + 3.3 * (0.7 + 0.6 * (Math.random())) } })
}

const sensorThreeTimeOut = 2250
sensorThree = async function () {
    return sleep((0.5 + 0.4 * Math.random()) * sensorThreeTimeOut).then(() => { return { sensor: 'sensor-three', temperature: 297 + 6.3 * (0.6 + 0.4 * (Math.random())) } })
}

// the sensor Promise to resolve sets its identification and value in lastestSensor an latestValue for processing in function sensorValues
var latestValue
var latestSensor
// the sensorPool contains the sensor promises for all sensors we are listening to. 
const sensorPool = new Set()

addSensor = function (s) {
    const sensorPromise = s()
    sensorPool.add(sensorPromise)
    sensorPromise.then(value => {
        latestValue = value;
        latestSensor = s
        sensorPool.delete(sensorPromise);
    });
} //addSensor



sensorValues = async function* () {
    addSensor(sensorOne)
    addSensor(sensorTwo)
    addSensor(sensorThree)

    // here we do a fan in - all sensor measurements streams are bundled into a single stream using the Promise.race() on a Pool of Promise returning functions 
    while (true) {
        await Promise.race([...sensorPool]);
        yield latestValue;
        // add a promise for the sensor that just fired back to the pool
        addSensor(latestSensor)
    }// neverending while    
}// sensorValues


// windowSize defines the number of values used for the calculation of the average
// period defines the number of values after which a new value should be produced
runningSensorAverages = async function* (sensorReadings, windowSize, period) {
    var sensors = {}
    // sensors are objects (mapped with sensor-id) with these properties:
    // ticks since last production, values (array) 
    for await (sensorReading of sensorReadings) {
        //lg(`Sensor Reading received ${JSON.stringify(sensorReading)}`)

        // retain latest sensor reading and calculate running aggregates whenever the period has passed
        if (!sensors[sensorReading.sensor]) sensors[sensorReading.sensor] = { ticks: 0, values: [] }
        var sensorRecord = sensors[sensorReading.sensor]
        sensorRecord.ticks++
        sensorRecord.values.push(sensorReading.temperature)
        // if it is time again to deliver the goods...
        if (sensorRecord.ticks == period) {
            sensorRecord.ticks = 0
            if (sensorRecord.values.length >= windowSize) {
                var windowValues = sensorRecord.values.slice(sensorRecord.values.length - windowSize)
                var sum = windowValues.reduce((a, b) => a + b, 0)
                var avg = sum / windowSize
                sensorRecord.values = sensorRecord.values.slice(sensorRecord.values.length - windowSize)
                yield { sensor: sensorReading.sensor, average: avg, max: Math.max(...windowValues) }
            }
        }
    }
}// runningSensorAverages    

filterOutliersFromSensorReadings = async function* (sensorReadings) {
    for await (sensorReading of sensorReadings) {
       if (sensorReading.temperature < 273 || sensorReading.sensor == 'sensor-x')
         lg(`Sensor Reading filtered ${JSON.stringify(sensorReading)}`); //filter this reading
       else  
         yield sensorReading
    }// for sensorReadings
}// filterOutliersFromSensorReadings    


// produce runningAverage over the sensorValues() once every 10 readings, using 15 readings to calculate the average 
doIt = async function () {
    for await (runningAverage of runningSensorAverages(filterOutliersFromSensorReadings( sensorValues()), 15, 10)) {
        lg(`Running Average for Sensor received ${JSON.stringify(runningAverage)}`)
    }
}

doIt()

