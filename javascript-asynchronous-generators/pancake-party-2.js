// pancake party for my son's birthday
// I have promised him pancakes. Each pancake has to be baked, decorated (syrup, sugar, jam, ..) and sliced (in bite size sections)

// - the process is pipelined: from baking to decorating to slicing to eating is a pipelined serie of handovers
//   note however that there is no parallellism in the pipeline: the eating takes place sequentially and since the eating drives the entire pipeline, everything else is sequential as well
//   What we can do is have each node in the pipeline build up its own little cache of ready product and yield to order
//   that way for example we can start cleaning the pans earlier on and send the cooks home

const numberOfGuests = 8
// assuming each guest eats exactly three pancakes
const numberOfPancakesPerGuest = 3
const totalNumberOfPancakes = numberOfGuests * numberOfPancakesPerGuest

// the number of pans at this point does not change the time either start to finish or to first pancake on plate
const numberOfPans = 4

// times in milliseconds
const timeToBakeOnePancake = 3000;
const timeToDecoratePancake = 1200;
const timeToSliceAndDicePancake = 600;
const timeToEatPancake = 2700;

const timeSpeedUpFactor = 10;

const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, Math.floor(milliseconds / timeSpeedUpFactor)))
}

const lg = (msg) => {
    const d = new Date()
    console.log(`${d.getSeconds()}.${Math.round(d.getMilliseconds() / 100)}  - ${msg}`)
}


// the function that describes eating the pancake by a guest
// the promise of pancake (an empty plate with cutlery?) is the input
// as soon as the promise materializes into a pancake
// a message is logged and the guest starts eating; when done eating (representedby sleep) another message is logged
eatPancake = function (guest, pancakePromise) {
    return pancakePromise.then(
        (pancake) => {
            if (firstPancake) { firstPancake = false; firstPancakeOnPlateTime = Date.now(); }
            lg(`Guest ${guest} is happily eating ${JSON.stringify(pancake)}`);
            return sleep(timeToEatPancake).then(() => {
                lg(`Guest ${guest} is done eating ${JSON.stringify(pancake)}.`);
            })
        })
}//eatPancake

// this function represents the baking process for a single pancake;
// baking is represented by sleep() and a simplistic pancake object is returned
bakeOnePancake = async function (index) {
    return sleep((0.9+0.2*(Math.random())) * timeToBakeOnePancake).then(() => { return { index: index } })
}

bakeAllPancakes = async function* (numberOfPancakes) {
    let stacksize = 0
    var freshPancakes;
    while (stacksize< numberOfPancakes) {
        let bakingNow = []
        for (var pan = 0; pan < numberOfPans; pan++) {
            lg(`.. baking pancake ${stacksize + pan + 1} in pan ${pan}`)
            // add promise for pancake to bakingNow collection
            bakingNow.push(bakeOnePancake(stacksize + pan + 1))
        }// for pans
        await Promise.all(bakingNow).then((pancakes) => {
            lg(` .. round of baking pancakes complete, all pans done. `)
            freshPancakes = pancakes
        });

        // yield all pancakes - executed after Promise.all
        for (pancake of freshPancakes) yield pancake;
        stacksize = stacksize + freshPancakes.length
        freshPancakes = null;

        lg(`.. all pans free, next round`)
          
    }// while
}//bakeAllPancakes

const toppings = ['syrup', 'chocolate sprinkles', 'strawberry jam']
decoratePancakes = async function* (stackOfPancakes) {
    for await (pancake of stackOfPancakes) {
        lg(`.. decorating pancake ${pancake.index}`)
        await sleep(timeToDecoratePancake)
        pancake.topping = toppings[Math.floor(Math.random() * 3)];
        yield pancake
    }
}//decoratePancakes

sliceAndDicePancakes = async function* (stackOfPancakes) {
    for await (pancake of stackOfPancakes) {
        lg(`.. slicing and dicing pancake ${pancake.index}`)
        await sleep(timeToSliceAndDicePancake)
        pancake.sliced = `${4 + Math.floor(Math.random() * 3)} pieces`;
        yield pancake
    }
}//sliceAndDicePancakes

var firstPancakeOnPlateTime
var firstPancake = true;

party = async function () {
    var startTime = Date.now();
    // pipeline the pancakes from baking through decorating and slicingNDicing to eating
    // readyToEatPancakes is an iterable - a promise with multiple deliveries
    readyToEatPancakes = sliceAndDicePancakes(decoratePancakes(bakeAllPancakes(totalNumberOfPancakes)))
    // in three eating rounds
    for (var eatingRound = 0; eatingRound < numberOfPancakesPerGuest; eatingRound++) {
        var eatingGuests = []
        // we get pancakes to all guest as quickly as possible
        for (var guest = 1; guest <= numberOfGuests; guest++) {
            var pk = readyToEatPancakes.next()
            eatingGuests.push(eatPancake(guest, pk))
        }// guests
        lg(`All guests have been handed a pancake promise`)
        // and then we wait for all guests to have finished eating their pancake
        await Promise.all(eatingGuests).then((values) => {
            lg(`.. eating round ${eatingRound + 1} complete.`)
        })
    }
    var endTime = Date.now();
    console.log(`Time from start to first pancake on plate ${(firstPancakeOnPlateTime - startTime) / 1000}`)
    console.log(`Time from start to finish ${(endTime - startTime) / 1000}`)

}// party

// go and have that party!
party()