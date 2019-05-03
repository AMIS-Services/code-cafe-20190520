sleep = function (delay, result) {
    const sleepPromise = new Promise(function (resolve, reject) {
      setTimeout(() => {
        resolve(result)
      }, delay);
    });
    return sleepPromise
  }
  

const lg = (msg) => {
    const d = new Date()
    console.log(`${d.getSeconds()}:${d.getMilliseconds()}  - ${msg}`)
}

const produceLetterDelay = 300

const alphabet = async function* () {
    var n = 0
    var letterPromises= new Set()
    var letterValues = new Set()
    while (n < 26) {
       letterPromises.add( 
            // alternative line with randomized delay: 
            // new Promise(resolve => {  sleep( produceLetterDelay * (0.5+ Math.random()),n++)
            new Promise(resolve => {  sleep(produceLetterDelay,n++)
                .then((value)=> {
                                                          var letter = String.fromCharCode(97 + value)
                                                          lg(`Letter ${letter} is produced` )
                                                          resolve(letter)
                                                        })
                                   }
                       )) 
            await sleep(10)
    }//while
      // wrap each promise in an additional promise that ensures that the promise is removed from the pool letterPromises after resolving, while its value is retained in letterValues 
    letterPromises.forEach((promise, i) => {
      promise.then(value => {
        letterPromises.delete(promise);
        letterValues.add(value)
      });
    });
    lg(`let's wait for letter promises to resolve`)
    while (letterValues.size>0 || letterPromises.size > 0) {
      if (letterValues.size > 0 ) {
        var nextValue = letterValues.values().next().value
        letterValues.delete(nextValue)
        lg(`.. yield ${nextValue}`)
        yield nextValue
      } else 
          await Promise.race([...letterPromises]);
    }//while
    lg(`done with alphabet`)
}// alphabet

const capitalize = async function* (letters) {
    for await (let letter of letters) {
        await sleep(200)
        yield letter.toUpperCase();
    }
}

const isVowel = function (letter) {
    return "aeiou".indexOf(letter) > -1
}

const vowelFilter = async function* (letters) {
    for await (let letter of letters) {
      await sleep(400)
      if (!isVowel(letter)) yield letter.toUpperCase();
    }  
}

doIt = async function () {
    //print the alphabet uppercased and without vowels
    for await (let ch of capitalize(vowelFilter(alphabet()))) 
    //for await (let ch of alphabet()) 
        lg(`Final result: ${ch}`)
}

doIt()