# JavaScript - Promises and Generators, Pipelines, Streaming Analyses, First past the Post
This document walks you through Promises and how to use them easily in an seemingly synchronous, imperative way using *await* and *async* functions. It then introduces *generator functions*  that return sets of data, one element at a time - thereby allowing unending streams of events to be processed almost as simple arrays of data. The finishing touch in this article consists of *aysnchronous generator functions* (introduced in ES 2018); these make it possible to return results from asynchronous operations from a generator, paving the way for pipelining: multiple functions chained together, each processing results from their predecessor and passing their result onto their successor in the chain. Thanks to the parallel processing that is now possible within the pipeline, first results can be produced much earlier one and in a more elegant way, with far less use of memory resources. It may not be sliced bread, but it is pretty cool all the same.

## Recap of Promises
A Promise [in JavaScript] is like a coupon, voucher or claim tag (Gutschein, IOU, Consumptiebon): it is light weight and easily acquired and it holds the promise of a future result. That future result is the outcome of an asynchronous action. If you are new to Promises, this is a very clear, straightforward tutorial [https://javascript.info/promise-basics].

For a code example, check out `promise-0.js`. This code defines a function that returns a promise. The promise itself is not yet a value. The promise is returned synchronously, but its result will follow later on, asynchronously. The *.then* function defined on a Promise is invoked when the Promise is resolved (successfully). If you run this code, you will probably see that the eager beaver does not have its result (the last line), but the promise does deliver and a random number is printed.

We can force our program to wait for the result of one or more promises. The keyword *await* is used to indicate that execution should not continue until the (asynchronous) statement following *await* has been resolved. See in `promise-1.js` how this is done. Note that a function doIt() was introduced as well - and that this function is labeled with *async* . The reason for this function is that *await* can only be used inside a function - that itself has been declared an asynchronous function using the *async* label.

Promises can be chained: the result from one Promise is fed into its *then* which in turn can be function that produces a Promise and so on. An example of this is `promise-2.js`. Here a second promise producing function is introduced: *sleep*. This function returns a Promise that returns the exact same result that was passed as input parameter into *sleep*, but it waits for *delay* milliseconds before doing so. Note how *setTimeout* is used: the function in the first parameter to setTimeout is executed after the delay has passed. This function then resolves the Promise its closure was part of, and returns the *result* variable from that same closure. In function doIt(), you see a chain of Promise-resolutions:
```
promiseToProduceARandomNumber()
           .then((random)=>sleep(1000, random))
           .then((result)=>sleep(400, result))
           .then((result)=> {r = result; console.log(`random number is ${r}`)});
```
You will not be surprised to hear that after about 1.4 seconds, a random number is printed to the console. Note how elegant and compact this code is, that sits on top of quite a bit of complex asynchronous activity.  See for more background: https://javascript.info/promise-chaining 

Multiple promises can be collected for pending work.
Additional work can be done (while the work associated with promises is perhaps performed in parallel)
Then the results of these promises can be cashed in:
- (wait for) resolution of a specific promise
- wait for all promises to be resolved
- wait for the first promise to be resolved

Check out `promise-3.js` that uses `Promise.all` and `Promise.race` to wait for the resolution of multiple Promises - to get all or to get the first result. Note how Promise.race() resolves before Promise.all() - despite the fact that Promise.race() is on a lower line of code. Also notice how all the work (and delay) happening between creating the promise and trying to get the result from the promise does not have an effect on the delivery time from the promises. Note how the promise for value 2 resolves before the promise for value 0 resolves, even if the outcome of Promise.race is returned only when all synchronous work has been done. 

One question that you may have: somewhere between Promise.race (that gives us the first result quickly) and Promise.all (that makes us wait for all results), can't we get the results of each promise as soon as it becomes available, in the order in which they become available, without waiting for all of them before starting to process the first one? And what if the Promises represent an unending stream of events?

One approach - that answers the first question - is shown in `promise-4.js`. Here all promises we wait for are combined in a set and we use Promise.race() on the set. Nothing new. When the first of the promises resolves, we remove it from the set, do whatever we have to do with the result from the resolved promise and return to Promise.race() on the set, that now contains one Promise less. This loop continues until all promises in the set have resolved. 

Before we provide a better answer for the first question and first answer for the second question(although the short answer of course is *yes, we can* ), let's look at Generators.

## Generators
Wikipedia provides an excellent definition of generators:

> In computer science, a generator is a special routine that can be used to control the iteration behaviour of a loop. In fact, all generators are iterators.[1] A generator is very similar to a function that returns an array, in that a generator has parameters, can be called, and generates a sequence of values. However, instead of building an array containing all the values and returning them all at once, a generator yields the values one at a time, which requires less memory and allows the caller to get started processing the first few values immediately. In short, a generator looks like a function but behaves like an iterator.

See (https://en.wikipedia.org/wiki/Generator_(computer_programming)) for this and a further an introduction into the concept of generators in computer programming.

Generators have been around for a long time (1975) but have appeared in modern programming languages only fairly recently (Python since 2.2 , C# since version 2.0, Ruby since version 1.9, PHP since release 5.5). Generators are fairly new in JavaScript/ECMA Script (ECMAScript 6, extended in ES 2018)

A generator function returns an iterable - a promise of a series of results that can be retrieved one by one. The caller of the generator function can iterate over the generator's result just as if it were a normal array. It retrieves values from the iterable and processes them. The fact that there is no array and that the values read from the iterable are produced by the generator function per request and potentially without end is of no concern to the caller. In fact, the caller does not even know.

The main benefits of using generator functions compared to alternative implementations typically are:
- clean code, elegant, compact, encapsulated with separation of concerns
- save memory (the entire result set eventually produced by the result set does not have be created in memory at any one time)
- process streams as easily sets (for the consumer, what is actually an stream of events appears as a simple array )
- start processing before the entire set is available (especially convenient with unending streams) - which means that final results can much earlier become available.
- implement pipelines with one generator taking input from another to combine multiple processing steps in an elegant pipeline that can perform work in parallel and can produce initial results early on

### Simple Generator Function
The first example is in `generator-0.js`. Here a simple for loop gets all letters from the alphabet:
```
//print the alphabet
for (let ch of alphabet()) {
    console.log(ch)
}// for of alphabet()
```
Nothing spectacular so far. However: the function alphabet is not a straightforward function that constructs and array and adds 26 elements to the array before returning the full array. It does not construct any array at all. Instead, this function is a generator function - indicated by the * postfix to its name:
```
const alphabet = function* () {
    var n = 0
    while (n < 26) 
        yield String.fromCharCode(97 + n++);   
}
```
It produces all of its elements by yielding them. *yield* is the keyword used by generator functions to produce a single value. Whenever the caller of the generator asks for the next value, the result is delivered from the yield operation. And the generator function will execute code until it reaches the next yield command; there it will pause until its consumer asks for another value.

In `generator-1.js` you will find these two lines of code:
```
for (let ch of capitalize(vowelFilter(alphabet()))) 
    console.log(ch)
```
The starting point in understanding this code is again function alphabet(), still a generator function. Its result (an iterable that produces 26 values) is passed as input in function vowelFilter(); this is a function that expects and accepts an iterable and is itself a generator function too. It produces its result by yielding values. This result from vowelFilter is passed into function capitalize - you guessed it: another generator function, that accepts an iterable and produces results through yielding. 

In this case, the code would have looked the same if all three functions would have produced regular array. But then of course, full blown arrays would have to be constructed and passed around. And processing would only start in the next step in pipeline when all values are available. The importance of this last statement will become clear in the next section.

### Asynchronous Generators
Only recently was ECMA Script (the formal name for what is informally known as JavaScript) extended with asynchronous generator functions. Prior to ES 2018, generator functions could not be asynchronous. Which put a limited on the usefulness of piping results from one generator function to the next in a multistep pipeline. And to my ability to demonstrate how useful pipelining is. But now, in ES 2018 and in Node 10 and above and in modern browsers we can have asynchronous generator functions and await in the for..of loop used to extract results from a generator function.

Look at `generator2.js` for an extended example of what we saw in `generator-1.js`. The main changes:
* asynchronous function sleep() was added
* alphabet has turned lazy: it sleeps between producing letters. As a result, it now too is an asynchronous function; both vowelFilter and capitalize are now asynchronous functions as well - this too is required for generator functions participating in an synchronous pipeline
* the main loop that calls alphabet is now inside a function - required because an asynchronous function can only be called from an asynchronous function

We can see in this code that function alphabet() will sleep 300 ms before producing a letter. So it will take 26 * 300ms or close to 8 seconds before the entire alphabet is produced by this function. How long will it take for the first letter to be produced in function doIt()? Run the code to find out. 

This is the essence of the asynchronous and pipelined generator: functions that produce sets of values, one value at a time, in an asynchronous way and that accept the output from another asynchronous generator as their input. Whenever function alphabet() yiels a value, the machinery is triggered and while alphabet stews on its next value, *vowelFilter* and *capitalize* are hard at work to complete the processing for the value yielded.

Of course delays can occur in any step along the way. Suppose *vowelFilter* and *capitalize* have to engage with external services that all take their time to respond. In `generator-3.js` this is simulated with two additional sleep steps. When you run this code you will notice that even though alphabet() could produce letters faster than *vowelFilter* and *capitalize* can process them, it does not actually do so. Only when *capitalize* is done will it ask for a next value and will *vowelFilter* yield a value and in turn ask itself for a next value from alphabet(). The functions in the pipeline move in step.

#### Advanced Approach: collect results ahead of yield requests
(feel free to skip this section)
In *generator-4.js* a quite farfetched workaround is used to not only produce results to order - and perhaps waste precious time - but continue producing results in function alphabet even though the request to yield is not yet received. In *alphabet*, all work orders for creating letters are created as promises. All these promises are collected in the Set *letterPromises*. Each promise is chained to a function to remove the promise from *letterPromises* upon resolution. When a letterPromise is resolved, it adds the value produced to the Set *letterValues*. The while loop will continue for as long as there are either letterPromises to be resolved or letterValues to be yielded. When we have no more promises that we are waiting for and no more values to deliver, function *alphabet* is done.

Note the time delay between producing a letter and yielding a letter. You could play a little with the delay introduced for producing a letter. Each letter is produced in its own time - when its corresponding Promise resolved. This means that with more randomized times, this approach with collecting results ahead of yield requests will result in out-of-order results. 

## Pipelined Functions Processing Data Streams
A question we discussed a little while back: if the Promises represent an unending stream of events, can we get results from the generator function as soon as they become available, in the order in which they become available, without waiting for all of them before starting to process the first one. And we said *yes we can*  and then we discussed *asynchronous generator functions* to clarify that answer.

We will now take another look at precisely that question: we are dealing with a potentially never ending stream of events (Tweets, sensor-measurements, log-output, website analytics, IoT data etc) and we want to write code to deal with these events. Asynchronous generator functions make this possible - and easy.

### Running Aggregates on Continuous Streams of (simulated) Sensor Measurements
In `sensor-analysis-0.js` you will find a pipeline for producing the the average temperature value per sensor - calculated over 15 subsequent measurements per sensor and produced once every 10 values.

Three Promises represent three temperature sensors; in this case the values are simply generated. However, these Promises could just as well read values from an external source or consume incoming events. Each Promise when resolved produces a sensor readout. The promise is wrapped in a promise (this happens in `function addSensor`) that writes the sensor value to temporary store (latestValue) and removes itself from the sensorPool – the set of promises `function sensorValues()` is waiting on using `Promise.race([…sensorPool])`. 

![sensors](https://technology.amis.nl/wp-content/uploads/2019/04/image_thumb-26.png)

In asynchronous generator function `sensorValues()` we wait in a endless loop for one or sensorPromises to resolve (Promise.race resolves to first of the set of promises to resolve). When that happens, the latestValue – written when the sensor promise resolved – is yielded.

Another asynchronous generator function – `runningSensorAverages` – is triggered by the yield from sensorValues (in the loop `for await (sensorReading of sensorReadings))`. The value yielded added to the values collection for the current sensor in the sensors map. The value of ticks is increased; ticks counts the number of values received since the last calculation of the running aggregate. If the value of `ticks` equals the value of `period` (the parameter that specifies after how many values a new aggregate should be calculated), then a new aggregate is calculated, using the last *windowSize* values in the *values* collection for the current sensor. The value calculated is yielded (and *ticks* is reset).

The yielded running aggregate is received in `function doIt()`. This function writes the yielded value to the console – from another for await loop.

The pipelining nature of this application is best captured by this line:

```
for await (runningAverage of runningSensorAverages(filterOutliersFromSensorReadings( sensorValues()), 15, 10)) {..}
```
The streaming result from sensorValues() is piped – one reading at a time – to the filter function and the output from that function to runningSensorAverages whose output appears as subsequent values in the for await loop.

### Adding Time Windowed Aggregates
While we are at it, let’s add Time Windowed aggregates: averages produced every X seconds. The implementation is in file `sensor-analysis-1.js`.

The implementation is done using a cache – a temporary store for the sensor readings that is written by *runningSensorAverages()*. The cache is implemented through a simple object called *recordedValues*. Function *timeWindowedAggregates()* is triggered by a time out after a period specified by parameter *timeWindow*. When the function ‘wakes up’ , it reads the current contents from the cache, calculates and yields the averages. 
![Time Windowed Aggregates](https://technology.amis.nl/wp-content/uploads/2019/04/image_thumb-28.png)

Function doIt2() contains a loop over the generator timeWindowedAggregates():  await for (timedWindowAggregate of timeWindowedAggregates(6000)) that prints the averages to the console.

Note that all timed window averages are produced at the same time (over different numbers of readings between the sensors) and the running aggregates are produced at different times (over the same numbers of readings).

This pipelined processing of a stream of data is also described in this blog article: https://technology.amis.nl/2019/04/30/javascript-pipelining-using-asynchronous-generators-to-implement-running-aggregates/.

## Pancake Extravaganza - Putting it altogether
The business case at hand… a pancake party (this may be a very Dutch example). The situation is like this: eight children attend a birthday party. At some point, they are done running around and want to be fed. They have been promised pancakes, a typical treat for a Dutch birthday party. The challenge now is to get pancakes to the young and perhaps not so patient guests. Starting from a naïve approach (when my son turned 6) to a smarter approach (we acquired skills over the years), we managed to get the time-to-first-pancake-on-plate down to less than 5% of what it originally was and the time to done-baking-start-cleaning down to less than 35% of what is was at first.

The process is outlined in this visualization: (I left out the preparation of the batter, as that can be done ahead of time, as well as all cleaning and washing up – as I leave that to my wife)

* Bake the pancake
* Decorate the pancake with toppings and happy faces
* Cut the pancake in bitesize pieces for quick and smooth processing
* Handout the pancake to the loudest person
*(eat the pancake) (of course done by the guests themselves, but part of the overall process and time lapse)

![Pancake Party overall process](https://technology.amis.nl/wp-content/uploads/2019/04/image-31.png)

We will assume eight guests that each eat three pancakes.

### Naïve approach (no pipelining, no parallelism, no generators)
The naïve approach I applied to the first pancake party was the following:

Using a single pan, bake a big stack of pancakes. Decorate all pancakes. Cut all pancakes. Using a single plate: tut one pancake on the plate and hand it to child number one. When that child is done with that pancake, put the second baked, decorated and sliced pancake on the plate and hand it to child number two.

You may get the feeling that this approach is not ideal. And it is not.

However, in programming, we may not have capabilities in our language to make use of parallelism, asynchronous operations and pipelining. And we may very well be forced to come up with something like a naïve approach.

The code corresponding to the following naïve approach is found in file `pancake-party-0.js`
![Naïve approach](https://technology.amis.nl/wp-content/uploads/2019/04/image-33.png)

Function *bakeAllPancakes()* is invoked from orchestrator function *party* to produce the full stack of pancakes, returned as an array of pancake objects. Function *bakeOnePancake()* is invoked as many times as the number of required pancakes. The function sleeps for approximately *timeToBakeOnePancake* to simulate the actual baking of the pancake.

Function *party* next invokes function *decoratePancakes()* with the full stack of pancakes (the entire array). This function iterates over the pancakes and decorates each one with a randomly selected topping. It sleeps during *timeToDecoratePancake* , to simulate the decoration processing time. When all pancakes have been decorated, the full stack of all decorated pancakes is returned – a complete array again. Function *party* next invokes function *sliceAndDicePancakes()*. This function slices the pancakes, processing one by one in much the same way as *decoratePancakes()* does. The result – an array of sliced and diced and ready to eat pancakes – is returned when all processing is done.

Function *party* can now start to make eaters happy. This function does a loop over three eating rounds (based on the assumption that each guest eats exactly three pancakes), and then loops over the guests. Then, a pancake is handed to a guest – a call is made to function *eatPancake()*. This too is an asynchronous function – because it uses the *sleep() function* to simulate the time it takes to eat a pancake. Only when *eatPancake* returns does *party* continue with handing the next pancake to the next guest. Excruciating, isn’t it? It results in very long time to first pancake delivery and of course much longer to all pancakes eaten.

Note: When a close comparison is made to the real world (of the pancake party), this code feels incredibly stupid. However, are you sure that your code would never be so laughably sequential when the comparison is not so easily made?

### Smart Approach – Using Asynchronous and Parallel Processing and Pipelining
In real life, we know we can be much smarter about the pancake birthday party.

Why use only a single pan. Why not leverage the stove (and our collection of pans) to the fullest? Doing things in parallel is typically one of the best ways to speed things up – if we have the resources available for running the processes in parallel. The code in file `pancake-party-1.js` use multiple pans for baking pancakes in parallel. It is not a very advanced approach yet - no asynchronous generators are involved, just a set of promises that are resolved concurrently (check function *bakeAllPancakes*)

Why not take the pancakes immediately when they have been baked to be decorated, followed by slicing and dicing and handing to a guest for eating? Pipeline all the way through all steps. If we have the resources, we can have baking, decorating, slicing and eating taking place all at the same time.

And why use a single plate and hand out one pancake at a time? Why not handout pancakes to all guests so they can eat at the same time?

Check the code in `pancake-party-2.js` for the implementation of the smarter approach, visualized in this figure:
![Smarter Approach](https://technology.amis.nl/wp-content/uploads/2019/04/image-35.png)

Even though JavaScript runs in a single thread execution environment, many actions involve waiting for input from the external world and can be executed in an asynchronous way. Multiple asynchronous activities can be executed in parallel – assuming that they are waiting for a substantial portion of the time. Promises are a fairly recent addition to JavaScript that make handling asynchronous activities fairly easy to program.

Note: the asynchronous activity in this example application is represented by the *sleep()* function. In real application, there would not be a sleep() function, but instead a call to an external service, a query against a database or a file read or write activity – all actions that involve substantial wait time and allow for parallelization to be taken advantage of.

Function *bakeAllPancakes()* has been improved with support for parallelism: it works with multiple pans and the pans are put to work in parallel. A promise is returned from function *bakeOnePancake()*. These promises will at some point resolve to real results – in our case: real pancakes. `Promise.all(bakingNow)` is our instruction to wait on all pans to deliver their pancake. When the fresh pancakes are in, they are yielded.

Yield is similar to return. Yet different. JavaScript has introduced support for generator functions. These are functions that return multiple results. But instead of returning the result set as one chunk of data – as an array or set for example – the result is returned one by one. And the invoker of the generator function can start processing the results one by one as soon as they become available. This is the foundation for pipelining in JavaScript. In ES 2018, support was added for asynchronous generator functions. This means that the results can be produced by the generator function using promises or other asynchronous mechanisms. That is the crucial link for pipelining asynchronously produced results.

In our code, this mechanism enables some drastic changes. Function party is still in the driving seat. However instead of calling *bakeAllPancakes()*, *decoratePancakes()* and *sliceandDicePancakes* one by one, strictly sequentially and passing the complete array of pancakes back and forth, *party()* now uses a single pipe line that engages these functions (now all generator functions) on elements generated at the initial generator function to have these elements processed through the entire pipeline as quickly as possible.

This single line of code defines the pipeline and triggers most of the processing.
```
readyToEatPancakes = sliceAndDicePancakes(decoratePancakes(bakeAllPancakes(totalNumberOfPancakes)))
```
Variable *readyToEatPancake* hold an iterable – which can be regarded as a Promise to multiple results. By calling *next()* on this iterable, these results can be retrieved – as promises (to a real result). When *bakeAllPancakes* yields the first batch, the first pancake of that batch is decorated, sliced and becomes available for eating. Function *party* hands pancake promises retrieved  to function *eatPancake()*. This function also returns a promise that resolves when the pancake has been eaten. Function *party* does not await the resolution of the promise – it hands out pancake promises to all eaters as quickly as it can. When all guests have received a pancake (promise), function party uses `Promise.all(<all handed out pancake promises>)` to wait for all guests to finish eating their pancakes. When all guests are done with their pancake, all promises are resolved and *Promise.all()* completes. The next round can start in *party()* until all rounds are complete.

The new implementation can be visualized as follows:
![Implementation of the smarter approach](https://technology.amis.nl/wp-content/uploads/2019/04/image-36.png)

Run the new code, for two pans and otherwise the same settings as before. You will see parallel activity – with Guest 1 eating their pancake very early on while at that same time pancake two is decorated and sliced and pancakes three and four are baked. What you hopefully notice are the vast improvements in time (from 11 to 0.5 for the first pancake on a plate an from 18.2 to 8.9 for all pancakes eaten; with four pans, we are completely done in 7.1). What should also strike you is the massive parallel activity. While Guest 5 is eating pancake #21, pancake 22 is decorated and sliced, pancakes 23 and 24 are baked and pancake 22 is attacked by Guest 6

## Additional Resources

Example: lazy map/reduce/filter - https://dev.to/nestedsoftware/lazy-evaluation-in-javascript-with-generators-map-filter-and-reduce--36h5
and : https://gist.github.com/maetl/2d973084e703530d9ef18d3f0e5a153f (https://maetl.net/notes/experiments/lazy-pipelines-js-generators )
Pipeline Experiments: https://medium.freecodecamp.org/lets-experiment-with-functional-generators-and-the-pipeline-operator-in-javascript-520364f97448
