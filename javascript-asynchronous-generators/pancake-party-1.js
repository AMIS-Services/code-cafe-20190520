// pancake party for my son's birthday
// I have promised him pancakes. Each pancake has to be baked, decorated (syrup, sugar, jam, ..) and sliced (in bite size sections)

// - leverage all pans we have, to bring some parallellism into the baking process

const numberOfGuests = 8
// assuming each guest eats exactly three pancakes
const totalNumberOfPancakes = numberOfGuests * 3

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


eatPancake = async function (guest, pancake) {
    lg(`Guest ${guest} is happily eating ${JSON.stringify(pancake)}`)
    await sleep(timeToEatPancake)
    return
}

bakeAllPancakes = async function (numberOfPancakes) {
    let stack = []
    while (stack.length < numberOfPancakes) {
        // bakingNow is the collection of (Promises for) concurrently baking pancakes 
        let bakingNow = []
        // loop over all pans, if we have more than one
        for (var pan = 0; pan < numberOfPans; pan++) {
            lg(`.. baking pancake  ${stack.length + pan + 1} in pan ${pan}`)
            // add promise for pancake to bakingNow collection
            bakingNow.push(sleep(timeToBakeOnePancake))
        }
        // wait for all bakingNow pancakes to be completed, then add them all to the stack
        await Promise.all(bakingNow).then((pancakes) => {
            for (pancake of pancakes)
                stack.push({ index: stack.length })
        })
    }//while
    return stack
}//bakeAllPancakes

const toppings = ['syrup', 'chocolate sprinkles', 'strawberry jam']
decoratePancakes = async function (stackOfPancakes) {
    for (pancake of stackOfPancakes) {
        lg(`.. decorating pancake ${pancake.index}`)
        await sleep(timeToDecoratePancake)
        pancake.topping = toppings[Math.floor(Math.random() * 3)];
    }
    return stackOfPancakes
}//decoratePancakes

sliceAndDicePancakes = async function (stackOfPancakes) {
    for (pancake of stackOfPancakes) {
        lg(`.. slicing and dicing pancake ${pancake.index}`)
        await sleep(timeToSliceAndDicePancake)
        pancake.sliced = `${4 + Math.floor(Math.random() * 3)} pieces`;
    }
    return stackOfPancakes
}//sliceAndDicePancakes

// fully sequential approach

party = async function () {
    var startTime = Date.now();
    // first get the full stack of pancakes
    var pancakes = await bakeAllPancakes(totalNumberOfPancakes)
    // then decorate all pancakes
    var decoratedPancakes = await decoratePancakes(pancakes)
    // finally slice and dice all of them, turning them into ready to eat pancakes
    var readyToEatPancakes = await sliceAndDicePancakes(decoratedPancakes)

    // finally, all guests get to eat the pancakes, in three rounds
    var firstPancakeOnPlateTime = Date.now();
    for (var eatingRound = 0; eatingRound < 3; eatingRound++) {
        for (var guest = 0; guest < 8; guest++) {
            await eatPancake(guest + 1, readyToEatPancakes.pop())
        }// guests
    }// eatingRounds
    var endTime = Date.now();
    console.log(`Time from start to first pancake on plate ${(firstPancakeOnPlateTime - startTime) / 1000}`)
    console.log(`Time from start to finish ${(endTime - startTime) / 1000}`)

}// party

// go and have that party!
party()