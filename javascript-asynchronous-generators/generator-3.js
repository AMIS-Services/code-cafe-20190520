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
        lg(ch)
}

doIt()