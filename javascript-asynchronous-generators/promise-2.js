// introducing function sleep that returns a Promise that takes a specified time before resolution
// also: see promise chaining in action ; the next promise is prepared when the previous one resolves 

promiseToProduceARandomNumber = function () { 
    const myPledge = new Promise(function(resolve, reject) {
                                    const random = Math.random()
                                    console.log(`random is generated, promise is resolved`);
                                    resolve(random);
                                 });
    console.log(`promise for random has been prepared`)
    return myPledge
}                                 

sleep = function (delay, result) {
  const sleepPromise = new Promise(function(resolve, reject) {
                       setTimeout(() => {console.log(`sleep is resolved`);resolve(result)}, delay);
                    });
  console.log(`promise to sleep for ${delay} ms has been prepared`)
  return sleepPromise                  
}

async function doIt() {
  var r ;
  await promiseToProduceARandomNumber()
           .then((random)=>sleep(1000, random))
           .then((result)=>sleep(400, result))
           .then((result)=> {r = result; console.log(`random number is ${r}`)});
  console.log(`Less eagerly produced random number is ${r}`)
}

doIt()