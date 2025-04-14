SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE
);

INSERT IGNORE INTO categories (nom) VALUES
('Phishing'),
('Réseaux'),
('Cryptographie'),
('Malware'),
('Sécurité Web'),
('Sécurité mobile'),
('Cloud'),
('Sécurité physique'),
('Sécurité des applications'),
('Gestion des accès');

SET FOREIGN_KEY_CHECKS = 1;
