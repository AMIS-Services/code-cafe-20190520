// pancake party for my son's birthday
// I have promised him pancakes. Each pancake has to be baked, decorated (syrup, sugar, jam, ..) and sliced (in bite size sections)
const numberOfGuests = 8
// assuming each guest eats exactly three pancakes
const totalNumberOfPancakes = numberOfGuests * 3

const numberOfPans = 1

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
    await sleep(timeToEatPancake).then(() => {
        lg(`Guest ${guest} is done eating ${JSON.stringify(pancake)}.`);
    })
    return
}


// this function represents the baking process for a single pancake;
// baking is represented by sleep() and a simplistic pancake object is returned
bakeOnePancake = async function (index) {
    return sleep((0.9+0.2*(Math.random())) * timeToBakeOnePancake).then(() => { return { index: index } })
}
bakeAllPancakes = async function (numberOfPancakes) {
    let stack = []
    while (stack.length < numberOfPancakes) {
        lg(`.. baking pancake ${stack.length+1}`)
        var pancake = await bakeOnePancake(stack.length)
        stack.push(pancake)
    }
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
            // hand pancake to guest and wait for the guest to finish eating
            await eatPancake(guest + 1, readyToEatPancakes.pop())
        }// guests
    }// eatingRounds
    var endTime = Date.now();
    console.log(`Time from start to first pancake on plate ${(firstPancakeOnPlateTime - startTime) / 1000}`)
    console.log(`Time from start to finish ${(endTime - startTime) / 1000}`)

}// party

// go and have that party!
party()