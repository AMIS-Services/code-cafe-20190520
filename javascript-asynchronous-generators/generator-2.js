// a generator function can be asynchronous - 
// here we see the same example as in generator-1.js, this time with the async syntax (async and await)
// and a little delay in function alphabet()
// this results in pipelining: function capitalize returns the first results (printed in doIt())
// while function alphabet is still working on more results. All three generator functions are part of the same pipeline
// where they work in parallel, one chewing on initial results of their predecessor. Time to first end result is reduced substantially,
// time to produce all results is also reduced (at least a little).

const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, milliseconds))
}

const lg = (msg) => {
    const d = new Date()
    console.log(`${d.getSeconds()}:${d.getMilliseconds()}  - ${msg}`)
}

const alphabet = async function* () {
    var n = 0
    while (n < 26) {
       await sleep(300)
       var letter = String.fromCharCode(97 + n++)
       lg(`.. yield ${letter}`)
       yield letter;
    }
}

const capitalize = async function* (letters) {
    for await (let letter of letters)
        yield letter.toUpperCase();
}

const isVowel = function (letter) {
    return "aeiou".indexOf(letter) > -1
}

const vowelFilter = async function* (letters) {
    for await (let letter of letters)
        if (!isVowel(letter)) yield letter.toUpperCase();
}

doIt = async function () {
    //print the alphabet uppercased and without vowels
    for await (let ch of capitalize(vowelFilter(alphabet()))) 
        lg(ch)
}

doIt()