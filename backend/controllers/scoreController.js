const db = require('../database');

// Save User Score
exports.saveScore = (req, res) => {
  const { titre, categorie, score, total } = req.body;
  const userId = req.user.id;

  // Input validation
  if (!titre || !categorie || score === undefined || total === undefined) {
    return res.status(400).json({ error: "Champs manquants." });
  }

  // SQL to insert score
  const sql = `
    INSERT INTO scores (user_id, titre, categorie, score, total)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(sql, [userId, titre, categorie, score, total], (err, result) => {
    if (err) {
      console.error("Erreur lors de l'enregistrement du score :", err);
      return res.status(500).json({ error: "Erreur serveur" });
    }

    res.status(201).json({ 
      message: "Score enregistré avec succès",
      scoreId: result.insertId // Optional: return the new score's ID
    });
  });
};

// Get User Scores
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

    // Optional: Add more context to the response
    res.json({
      total_scores: results.length,
      scores: results
    });
  });
};

// Optional: Additional method to get top scores
exports.getTopScores = (req, res) => {
  const { categorie } = req.query;
  
  let sql = `
    SELECT s.*, u.username 
    FROM scores s
    JOIN users u ON s.user_id = u.id
    ${categorie ? 'WHERE s.categorie = ?' : ''}
    ORDER BY s.score DESC 
    LIMIT 10
  `;

  const params = categorie ? [categorie] : [];

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error("Erreur lors de la récupération des meilleurs scores :", err);
      return res.status(500).json({ error: "Erreur serveur" });
    }

    res.json(results);
  });
};

module.exports = {
  saveScore: this.saveScore,
  getUserScores: this.getUserScores,
  getTopScores: this.getTopScores
};