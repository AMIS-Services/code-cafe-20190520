// here we see pipelining in action using Promises: 
// The first results from function Capitalize are returned while function alphabet is still producing and yielding new values
// using many Promises - with all promises pending at the same time, and each result yielded as soon as the Promise as resolved.
// the use of async generator function with the Promise.race allows us to return results one by one and allowing parallel processing.

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

const produceLetterDelay = 200

// function alphabet produces all letters in the alphabet. Each letter is produced when a Promise resolves (after a a certain delay)
// in order to yield values as soon as they become available, all letter promises are held in a set that is input for Promise.race.
// as soon as one promise is resolved, its value is yielded; that promise is removed from the set and the race is on again (waiting for the next letterpromise to resolve)
const alphabet = async function* () {
    var n = 0
    var letterPromises= new Set()
    var letterValues = new Set()
    while (n < 26) {
       letterPromises.add( 
            // alternative line with randomized delay: 
            // new Promise(resolve => {  sleep( produceLetterDelay * (0.5+ Math.random()),n++)
            // the time to produce a letter is artifically increased for each letter; note: all promises start processing at almost the same time
            new Promise(resolve => {  sleep(n*produceLetterDelay,n++)
                .then((value)=> {
                                                          var letter = String.fromCharCode(97 + value)
                                                          lg(`Letter ${letter} is produced` )
                                                          resolve(letter)
                                                        })
                                   }
                       )) 
            // a little pause between creating letterPromises            
            await sleep(20)
    }//while
      // wrap each promise in an additional promise that ensures that the promise is removed from the pool letterPromises after resolving, while its value is retained in letterValues 
    letterPromises.forEach((promise, i) => {
      promise.then(value => {
        letterPromises.delete(promise);
        letterValues.add(value)
      });
    });
    lg(`let's wait for letter promises to resolve`)
    // loop for as long as there are letterValues to be returned or letterPromises to resolve (resulting in letterValues)
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
      await sleep(200)
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