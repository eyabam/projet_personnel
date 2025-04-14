const db = require('../database');

exports.saveScore = (req, res) => {
  const { titre, categorie, score, total } = req.body;
  const userId = req.user.id; 

  if (!titre || !categorie || score === undefined || total === undefined) {
    return res.status(400).json({ error: "Champs manquants." });
  }

  const sql = `
    INSERT INTO scores (user_id, titre, categorie, score, total)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(sql, [userId, titre, categorie, score, total], (err, result) => {
    if (err) {
      console.error("Erreur lors de l'enregistrement du score :", err);
      return res.status(500).json({ error: "Erreur serveur" });
    }

    res.status(201).json({ message: "Score enregistré avec succès" });
  });
};

// ✅ Récupérer les scores d'un utilisateur (GET /api/scores)
exports.getUserScores = (req, res) => {
  const userId = req.user.id;

  const sql = `
    SELECT titre, categorie, score, total, created_at
    FROM scores
    WHERE user_id = ?
    ORDER BY created_at DESC
  `;

  db.query(sql, [userId], (err, results) => {
    if (err) {
      console.error("Erreur lors de la récupération des scores :", err);
      return res.status(500).json({ error: "Erreur serveur" });
    }

    res.json(results);
  });
};
