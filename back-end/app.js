const express = require('express')
const app = express()
const cors = require('cors');
const path = require('path');
const port = 3000

app.use(cors());
app.use(express.urlencoded({
    'extended': 'true'
}));
app.use(express.json());

app.set('views', __dirname + '/views');
app.use('/public', express.static(path.join(__dirname, 'public')));
// require('./configs/db_connection');


app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})

const routes = require('./routes/routes');

app.use('/', routes);