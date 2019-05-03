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
                       setTimeout(() => {console.log(`sleep is resolved for value ${result}`);resolve(result)}, delay);
                    });
  console.log(`promise to sleep for ${delay} ms has been prepared`)
  return sleepPromise                  
}

async function doIt() {
  var start = Date.now() ;
  var p1 = sleep(1000, 1)
  var p2 = sleep(800, 2)
  var p3 = sleep(1200, 3)
  var p4 = sleep(1400, 4)
  for (var i=0;i<1000; i++) {
    // do lots of stuff
    
  }
  console.log(`done lots of stuff in this crazy loop... `)
  await sleep(900,0)
  console.log(`done lots more, while the Promises were being delivered on `)
  Promise.all([p1,p2,p3,p4]).then( (values) => {console.log(`All results received are ${JSON.stringify(values)} after ${Date.now() - start} milliseconds`)})

  Promise.race([p1,p2,p3,p4]).then( (value) => {console.log(`race: result received is  ${JSON.stringify(value)} after ${Date.now() - start} milliseconds`)})
  console.log(`Total milliseconds spent: ${Date.now() - start}`)
}

doIt()