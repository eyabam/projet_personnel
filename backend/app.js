require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

const quizController = require('./controllers/quizController');
const authController = require('./controllers/authController');
const scoreController = require('./controllers/scoreController');
const adminController = require('./controllers/adminController');
const verifyToken = require('./middlewares/auth');
const cheatsheetController = require('./controllers/cheatsheetController');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

// Routes
app.get('/api/quizzes', quizController.getAllQuizzes);
app.get('/api/quizzes/:id', quizController.getQuizById);
app.post('/api/register', authController.register);
app.post('/api/login', authController.login);
app.post('/api/scores', verifyToken, scoreController.saveScore);
app.get('/api/scores', verifyToken, scoreController.getUserScores);
app.post('/api/admin/quizzes', adminController.createQuiz);
app.get('/api/cheatsheets', cheatsheetController.getAllCheatsheets);

// Lancement
app.listen(3000, () => console.log('Serveur démarré sur le port 3000'));
