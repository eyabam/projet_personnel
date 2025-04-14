
CREATE TABLE IF NOT EXISTS quizzes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titre VARCHAR(255),
  question TEXT,
  choix JSON,
  bonne_reponse VARCHAR(255),
  categorie_id INT,
  FOREIGN KEY (categorie_id) REFERENCES categories(id)
);
