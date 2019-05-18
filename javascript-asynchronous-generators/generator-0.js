// introduction of a generator function - a function that returns a set of results - one by one, every time the caller asks for the next result

const alphabet = function* () {
    var n = 0
    while (n < 26) 
        yield String.fromCharCode(97 + n++);   
}

//print the alphabet
for (let ch of alphabet()) {
    console.log(ch)
}
