const jwt = require('jsonwebtoken');
require('dotenv').config();

function generateToken(user) {
  return jwt.sign(
    {
      id: user.id,
      username: user.username,
      email: user.email
    }, 
    process.env.JWT_SECRET, 
    { 
      expiresIn: '24h' // or another appropriate duration
    }
  );
}

module.exports = { generateToken };