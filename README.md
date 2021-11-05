"# covid19-screening" 
### Running Locally
To run make sure you have a local node server or any web server.

For running with a node server, add an index.js file at the root directory and paste the code below inside the index.js file:

```
var http = require('http')
var fs = require('fs')
var express = require('express')
var app = express()

//replace port number
app.use(express.static(__dirname + '/'))
app.listen(3007, function () {
    console.log('cdc screening app listening on port 3007!')
})

```