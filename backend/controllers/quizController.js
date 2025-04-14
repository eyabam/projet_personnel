const db = require('../database');

exports.getAllQuizzes = (req, res) => {
  const sql = `
    SELECT q.*, c.nom AS categorie
    FROM quizzes q
    LEFT JOIN categories c ON q.categorie_id = c.id
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Erreur interne du serveur" });
    }

    const formatted = results.map(quiz => {
      let choix = [];
      if (typeof quiz.choix === 'string') {
        try {
          choix = JSON.parse(quiz.choix);
        } catch (e) {
          console.error("Erreur JSON quiz ID", quiz.id, quiz.choix);
          choix = [quiz.choix]; // fallback
        }
      } else if (Array.isArray(quiz.choix)) {
        choix = quiz.choix;
      } else {
        choix = [quiz.choix.toString()];
      }

      return {
        id: quiz.id,
        titre: quiz.titre,
        question: quiz.question,
        choix: choix,
        bonneReponse: quiz.bonne_reponse?.trim(),
        categorie: quiz.categorie || 'Autre',
      };
    });

    res.json(formatted); 
  });
};

// ✅ Obtenir un seul quiz par ID
exports.getQuizById = (req, res) => {
  const quizId = req.params.id;

  const sql = `
    SELECT q.*, c.nom AS categorie
    FROM quizzes q
    LEFT JOIN categories c ON q.categorie_id = c.id
    WHERE q.id = ?
  `;

  db.query(sql, [quizId], (err, results) => {
    if (err) return res.status(500).json({ error: 'Erreur SQL' });

    if (results.length === 0) {
      return res.status(404).json({ error: 'Quiz non trouvé' });
    }

    const quiz = results[0];
    let choix = [];

    try {
      if (Array.isArray(quiz.choix)) {
        choix = quiz.choix;
      } else if (typeof quiz.choix === 'string') {
        try {
          choix = JSON.parse(quiz.choix);
        } catch (jsonError) {
          choix = quiz.choix
            .replace(/^\[|\]$/g, '')
            .split(',')
            .map(item => item.trim().replace(/^['"]|['"]$/g, ''));
        }
      }
    } catch (e) {
      console.error("Erreur JSON quiz ID", quiz.id, quiz.choix);
      choix = typeof quiz.choix === 'string' ? [quiz.choix] : [];
    }

    const formattedQuiz = {
      id: quiz.id,
      titre: quiz.titre,
      question: quiz.question,
      choix: choix,
      bonneReponse: quiz.bonne_reponse?.trim(),
      categorie: quiz.categorie || 'Autre',
    };
    res.json(formattedQuiz);
  });
};
