// backend/database.js
const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',        
    password: 'aya',  
    database: 'quizdb'
});

db.connect((err) => {
    if (err) {
        console.error('Erreur de connexion à la base:', err);
        return;
    }
    console.log('Connexion à la base de données réussie.');
});

module.exports = db;
