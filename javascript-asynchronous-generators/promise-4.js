promiseToProduceARandomNumber = function () {
  const myPledge = new Promise(function (resolve, reject) {
    const random = Math.random()
    console.log(`random is generated, promise is resolved`);
    resolve(random);
  });
  console.log(`promise for random has been prepared`)
  return myPledge
}

sleep = function (delay, result) {
  const sleepPromise = new Promise(function (resolve, reject) {
    setTimeout(() => {
      console.log(`sleep is resolved for value ${result}`);
      resolve(result)
    }, delay);
  });
  console.log(`promise to sleep for ${delay} ms has been prepared`)
  return sleepPromise
}

var promises
var promisesPool
var latestValue

async function doIt() {
  var start = Date.now();
  var p1 = sleep(1000, 1)
  var p2 = promiseToProduceARandomNumber().then((value) => sleep(800, 2*value))
  var p3 = sleep(1200, 3).then((value) => sleep(500, value)).then((value) => sleep(200, value))
  var p4 = sleep(1400, 4)
  promises = [p1, p2, p3, p4]
  promisesPool = new Set(promises)
  // wrap each promise in an additional promise that ensures that the promise is removed from the pool after resolving
  promises.forEach((promise, i) => {
    promise.then(value => {
      promisesPool.delete(promise);
    });
  });
  while (promisesPool.size !== 0) {
    var value = await Promise.race([...promisesPool]);
    // process the value from the promise - take any action that is required.
    console.log(`race: result received is  ${JSON.stringify(value)} after ${Date.now() - start} milliseconds`)
  }// while unresolved promises are in the pool, wait for them to resolve
  console.log(`All results are in, let's continue...`) 
}// doIt

doIt()