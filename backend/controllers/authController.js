const db = require('../database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const SECRET_KEY = process.env.JWT_SECRET;

function register(req, res) {
  const { full_name, username, date_naissance, email, password } = req.body;

  if (!full_name || !username || !date_naissance || !email || !password) {
    return res.status(400).json({ error: 'Tous les champs sont requis.' });
  }

  console.log(" Reçu du frontend :", req.body);

  const formattedDate = date_naissance;

  db.query(
    'SELECT * FROM users WHERE email = ? OR username = ?',
    [email, username],
    (err, results) => {
      if (err) {
        console.error(" Erreur SELECT :", err);
        return res.status(500).json({ error: 'Erreur serveur (vérif utilisateur)' });
      }

      if (results.length > 0) {
        return res.status(400).json({ error: 'Email ou nom d’utilisateur déjà utilisé.' });
      }

      bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) {
          console.error(" Erreur de hachage :", err);
          return res.status(500).json({ error: "Erreur de hachage" });
        }

        db.query(
          'INSERT INTO users (full_name, username, date_naissance, email, password_hash) VALUES (?, ?, ?, ?, ?)',
          [full_name, username, formattedDate, email, hashedPassword],
          (err) => {
            if (err) {
              console.error(" Erreur lors de l’insertion :", err);
              return res.status(500).json({ error: 'Erreur lors de l’enregistrement' });
            }

            console.log("Utilisateur enregistré avec succès :", email);
            res.status(201).json({ message: 'Utilisateur enregistré avec succès' });
          }
        );
      });
    }
  );
}

function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email et mot de passe requis.' });
  }

  db.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
    if (err) {
      console.error(" Erreur SELECT login :", err);
      return res.status(500).json({ error: 'Erreur serveur' });
    }

    if (results.length === 0) {
      return res.status(401).json({ error: 'Utilisateur non trouvé.' });
    }

    const user = results[0];

    // 🔐 Vérifie le mot de passe
    bcrypt.compare(password, user.password_hash, (err, isMatch) => {
      if (err || !isMatch) {
        return res.status(401).json({ error: 'Mot de passe incorrect.' });
      }

      const token = jwt.sign({
        id: user.id,
        full_name: user.full_name,
        username: user.username,
        email: user.email,
        date_naissance: user.date_naissance,
        is_admin: user.is_admin
      }, SECRET_KEY, { expiresIn: '24h' });
      

      res.json({
        message: 'Connexion réussie',
        token,
        user: {
          id: user.id,
          full_name: user.full_name,
          username: user.username,
          email: user.email,
          date_naissance: user.date_naissance,
          is_admin: user.is_admin
        }
      });
    });
  });
}

module.exports = {
  register,
  login
};
