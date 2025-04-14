require('dotenv').config();
const jwt = require('jsonwebtoken');

function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];

  if (!authHeader) {
    return res.status(403).json({ error: 'Token manquant' });
  }

  const token = authHeader.split(' ')[1]; 

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      console.error(" Token invalide :", err);
      return res.status(403).json({ error: 'Token invalide' });
    }

    req.user = user; // { id, email, is_admin, iat, exp }
    next();
  });
}

module.exports = verifyToken;
