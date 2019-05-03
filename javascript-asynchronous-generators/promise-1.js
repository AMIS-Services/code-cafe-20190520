let promiseToProduceARandomNumber = function () { 
    const myPledge = new Promise(function(resolve, reject) {
                                    const random = Math.random()
                                    resolve(random);
                                 });
    return myPledge
}                                 

async function doIt() {
  var r ;
  await promiseToProduceARandomNumber().then((result)=> {r = result; console.log(`random number is ${r}`)});
  console.log(`Less eagerly produced random number is ${r}`)
}

doIt()