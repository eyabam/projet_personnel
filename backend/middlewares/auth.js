const jwt = require('jsonwebtoken');
require('dotenv').config(); // For environment variables

module.exports = function verifyToken(req, res, next) {
   // Check for Authorization header
   const authHeader = req.headers['authorization'];
   if (!authHeader) {
     return res.status(401).json({ message: 'No token provided' });
   }

   // Validate header format
   const parts = authHeader.split(' ');
   if (parts.length !== 2 || parts[0] !== 'Bearer') {
     return res.status(401).json({ message: 'Token format is invalid' });
   }

   const token = parts[1];

   try {
     // Use environment variable for secret
     const decoded = jwt.verify(token, process.env.JWT_SECRET);
     req.user = decoded;
     next();
   } catch (err) {
     // More specific error handling
     if (err.name === 'TokenExpiredError') {
       return res.status(401).json({ message: 'Token has expired' });
     }
     return res.status(401).json({ message: 'Invalid token' });
   }
};