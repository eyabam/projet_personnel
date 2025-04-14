SET FOREIGN_KEY_CHECKS = 0;

SOURCE database/categories.sql;
SOURCE database/users.sql;
SOURCE database/quizzes.sql;        
SOURCE database/scores.sql;
SOURCE database/fiches.sql;

SOURCE database/seed_quizzes.sql;    
SOURCE database/seed_cheatsheets.sql;

SET FOREIGN_KEY_CHECKS = 1;
