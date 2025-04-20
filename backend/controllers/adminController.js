require('dotenv').config(); // Charge les variables d'environnement
const db = require('../database');
const jwt = require('jsonwebtoken');

const SECRET_KEY = process.env.JWT_SECRET; // On prend la clé depuis .env

// ==== Vérification Admin ====
async function isAdmin(req) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return false;

  try {
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, SECRET_KEY);
    console.log("🔐 [DEBUG] JWT décodé :", decoded);
    // Vérifie si is_admin est true OU égal à 1
    return decoded.is_admin === true || decoded.is_admin === 1;
  } catch (error) {
    console.error('❌ [DEBUG] Erreur lors de la vérification du token:', error);
    return false;
  }
}

// ==== Création d'un Quiz ====
exports.createQuiz = async (req, res) => {
  console.log('🔵 [DEBUG] Requête reçue pour créer un quiz');
  console.log('🔵 [DEBUG] Headers:', req.headers);
  console.log('🔵 [DEBUG] Body:', req.body);

  const admin = await isAdmin(req); // ← on attend la vérification

  if (!admin) {
    console.log('❌ [DEBUG] Utilisateur NON ADMIN - accès refusé');
    return res.status(403).json({ error: 'Accès refusé' });
  }

  const { titre, question, choix, bonne_reponse, categorie_id } = req.body;

  if (!titre || !question || !choix || !bonne_reponse || !categorie_id) {
    console.log('❌ [DEBUG] Champs manquants:', { titre, question, choix, bonne_reponse, categorie_id });
    return res.status(400).json({ error: 'Tous les champs sont requis' });
  }

  console.log('🟢 [DEBUG] Données valides, insertion en base...');

  db.query(
    'INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES (?, ?, ?, ?, ?)',
    [titre, question, JSON.stringify(choix), bonne_reponse, categorie_id],
    (err, result) => {
      if (err) {
        console.error('❌ [DEBUG] Erreur SQL:', err);
        return res.status(500).json({ error: 'Erreur SQL lors de l\'insertion du quiz' });
      }
      console.log('✅ [DEBUG] Quiz inséré avec succès, ID:', result.insertId);
      res.status(201).json({ message: 'Quiz ajouté avec succès', quizId: result.insertId });
    }
  );
};
