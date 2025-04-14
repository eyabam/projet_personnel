const db = require('../database');
const jwt = require('jsonwebtoken');
const SECRET_KEY = "ton_secret_super_secret";

function isAdmin(req) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return false;

  try {
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, SECRET_KEY);
    return decoded.is_admin === true;
  } catch {
    return false;
  }
}

exports.createQuiz = (req, res) => {
  if (!isAdmin(req)) return res.status(403).json({ error: 'Accès refusé' });

  const { titre, question, choix, bonne_reponse } = req.body;

  db.query(
    'INSERT INTO quizzes (titre, question, choix, bonne_reponse) VALUES (?, ?, ?, ?)',
    [titre, question, JSON.stringify(choix), bonne_reponse],
    (err) => {
      if (err) return res.status(500).json({ error: 'Erreur SQL' });
      res.status(201).json({ message: 'Quiz créé avec succès' });
    }
  );
};

