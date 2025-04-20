require('dotenv').config();

const express = require('express');
const cors = require('cors');
const app = express();
const adminRouter = express.Router(); 
const quizController = require('./controllers/quizController');
const authController = require('./controllers/authController');
const scoreController = require('./controllers/scoreController');
const cheatsheetController = require('./controllers/cheatsheetController');
const adminController = require('./controllers/adminController');
const verifyToken = require('./middlewares/auth');
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

app.get('/api/quizzes', quizController.getAllQuizzes);
app.get('/api/quizzes/:id', quizController.getQuizById);

app.post('/api/register', authController.register);
app.post('/api/login', authController.login);

app.post('/api/scores', verifyToken, scoreController.saveScore);
app.get('/api/scores', verifyToken, scoreController.getUserScores);

app.get('/api/cheatsheets', cheatsheetController.getAllCheatsheets);


adminRouter.post('/quizzes', adminController.createQuiz);

app.use('/api/admin', adminRouter);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(` Serveur démarré sur le port ${PORT}`);
});
