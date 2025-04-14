-- Supprime la table users si elle existe déjà
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- Crée la table users avec les champs requis
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL UNIQUE,
  date_naissance DATE NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  is_admin BOOLEAN DEFAULT FALSE
);

-- Insère un utilisateur administrateur avec un mot de passe haché (exemple : 'admin123')
INSERT INTO users (full_name, username, date_naissance, email, password_hash, is_admin)
VALUES (
  'Admin',
  'admin',
  '1990-01-01',
  'admin@gmail.com',
  '$2b$10$2FeW1E8rPzH7Fdc5ndm8DuAKDR89jMcekn5xFlDnAGvZ9SRx.3HZm',
  TRUE
);

