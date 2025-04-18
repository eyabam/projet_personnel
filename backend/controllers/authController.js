const db = require('../database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
require('dotenv').config();

function register(req, res) {
  const { full_name, username, date_naissance, email, password } = req.body;

  // Validation
  if (!full_name || !username || !date_naissance || !email || !password) {
    return res.status(400).json({ error: 'Tous les champs sont requis.' });
  }

  console.log("Reçu du frontend :", req.body);

  // Check if user already exists
  db.query(
    'SELECT * FROM users WHERE email = ? OR username = ?',
    [email, username],
    (err, results) => {
      if (err) {
        console.error("Erreur SELECT :", err);
        return res.status(500).json({ error: 'Erreur serveur (vérif utilisateur)' });
      }

      if (results.length > 0) {
        return res.status(400).json({ error: 'Email ou nom d\'utilisateur déjà utilisé.' });
      }

      // Hash password
      bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) {
          console.error("Erreur de hachage :", err);
          return res.status(500).json({ error: "Erreur de hachage" });
        }

        // Insert new user
        db.query(
          'INSERT INTO users (full_name, username, date_naissance, email, password_hash) VALUES (?, ?, ?, ?, ?)',
          [full_name, username, date_naissance, email, hashedPassword],
          (err, result) => {
            if (err) {
              console.error("Erreur lors de l'insertion :", err);
              return res.status(500).json({ error: 'Erreur lors de l\'enregistrement' });
            }

            // Retrieve the newly inserted user
            db.query(
              'SELECT id, full_name, username, email, date_naissance, is_admin FROM users WHERE id = ?',
              [result.insertId],
              (err, newUserResults) => {
                if (err) {
                  console.error("Erreur lors de la récupération du nouvel utilisateur :", err);
                  return res.status(500).json({ error: 'Erreur lors de la récupération de l\'utilisateur' });
                }

                const newUser = newUserResults[0];
                
                // Generate token
                const token = jwt.sign(
                  {
                    id: newUser.id,
                    full_name: newUser.full_name,
                    username: newUser.username,
                    email: newUser.email,
                    date_naissance: newUser.date_naissance,
                    is_admin: newUser.is_admin
                  },
                  process.env.JWT_SECRET,
                  { expiresIn: '24h' }
                );

                console.log("Utilisateur enregistré avec succès :", email);
                res.status(201).json({
                  message: 'Utilisateur enregistré avec succès',
                  token,
                  user: newUser
                });
              }
            );
          }
        );
      });
    }
  );
}

function login(req, res) {
  const { email, password } = req.body;

  // Validation
  if (!email || !password) {
    return res.status(400).json({ error: 'Email et mot de passe requis.' });
  }

  // Find user
  db.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
    if (err) {
      console.error("Erreur SELECT login :", err);
      return res.status(500).json({ error: 'Erreur serveur' });
    }

    if (results.length === 0) {
      return res.status(401).json({ error: 'Utilisateur non trouvé.' });
    }

    const user = results[0];

    // Verify password
    bcrypt.compare(password, user.password_hash, (err, isMatch) => {
      if (err || !isMatch) {
        return res.status(401).json({ error: 'Mot de passe incorrect.' });
      }

      // Generate token
      const token = jwt.sign(
        {
          id: user.id,
          full_name: user.full_name,
          username: user.username,
          email: user.email,
          date_naissance: user.date_naissance,
          is_admin: user.is_admin
        },
        process.env.JWT_SECRET,
        { expiresIn: '24h' }
      );

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