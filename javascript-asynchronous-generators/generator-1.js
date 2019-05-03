
const alphabet = function* () {
    var n = 0
    while (n < 26) 
        yield String.fromCharCode(97 + n++);   
}

const capitalize = function* (letters) {
    for (let letter of letters) 
        yield letter.toUpperCase();   
}

const isVowel = function (letter) {
    return "aeiou".indexOf(letter) >-1
}

const vowelFilter = function* (letters) {
    for (let letter of letters) 
        if (!isVowel(letter)) yield letter.toUpperCase();   
}

//print the alphabet uppercased and without vowels
for (let ch of capitalize(vowelFilter(alphabet()))) 
    console.log(ch)
