const mysql = require("mysql");

const connection = mysql.createConnection({
    host: "localhost",
    user: "db_user",
    password: "secretuserpassword",
    database: "db"
});

connection.connect(function(error) {
    if (!!error) {
        console.log(error);
    } else {
        console.log("Connected!:)");
    }
});

module.exports = connection;
