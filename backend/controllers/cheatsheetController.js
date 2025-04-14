const db = require('../database');

exports.getAllCheatsheets = (req, res) => {
  db.query('SELECT * FROM cheatsheets', (err, results) => {
    if (err) {
      console.error("Erreur récupération fiches :", err);
      return res.status(500).json({ message: 'Erreur serveur' });
    }
    res.json(results);
  });
};
