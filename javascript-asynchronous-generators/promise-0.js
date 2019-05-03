let promiseToProduceARandomNumber = function () { 
    const myPledge = new Promise(function(resolve, reject) {
                                    const random = Math.random()
                                    resolve(random);
                                 });
    return myPledge
}                                 
  
  var r ;
  promiseToProduceARandomNumber().then((result)=> {r = result; console.log(`random number is ${r}`)});
  console.log(`Eagerly produced random number is ${r}`)