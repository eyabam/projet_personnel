DROP TABLE IF EXISTS seed_quizzes;

-- PHISHING
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Email suspect', 'Quel est un signe courant d’un email de phishing ?', '["Fautes d’orthographe", "Nom du destinataire correct", "Adresse officielle"]', 'Fautes d’orthographe', (SELECT id FROM categories WHERE nom = "Phishing")),
('Lien douteux', 'Que faut-il vérifier avant de cliquer sur un lien dans un email ?', '["Le nom de domaine", "Le style de l’email", "La couleur du bouton"]', 'Le nom de domaine', (SELECT id FROM categories WHERE nom = "Phishing")),
('Demande urgente', 'Pourquoi les emails de phishing insistent-ils souvent sur l’urgence ?', '["Pour attirer l’attention", "Pour contourner les antivirus", "Pour tester le système"]', 'Pour attirer l’attention', (SELECT id FROM categories WHERE nom = "Phishing")),
('Fichier joint suspect', 'Quel type de fichier est le plus risqué dans un email ?', '[".exe", ".pdf", ".jpg"]', '.exe', (SELECT id FROM categories WHERE nom = "Phishing")),
('Expéditeur inconnu', 'Que faut-il faire si on ne connaît pas l’expéditeur d’un email ?', '["Supprimer ou signaler", "Répondre pour vérifier", "Cliquer sur les liens"]', 'Supprimer ou signaler', (SELECT id FROM categories WHERE nom = "Phishing")),
('Adresse falsifiée', 'Quelle technique est utilisée pour masquer une fausse adresse email ?', '["Spoofing", "Sniffing", "Hashing"]', 'Spoofing', (SELECT id FROM categories WHERE nom = "Phishing")),
('Authentification', 'Quel protocole peut aider à authentifier les expéditeurs d’email ?', '["DKIM", "FTP", "NAT"]', 'DKIM', (SELECT id FROM categories WHERE nom = "Phishing")),
('Indicateur de phishing', 'Lequel de ces éléments peut signaler une tentative de phishing ?', '["Demande d’informations sensibles", "Offre de réduction", "Newsletter mensuelle"]', 'Demande d’informations sensibles', (SELECT id FROM categories WHERE nom = "Phishing")),
('Phishing vocal', 'Comment s’appelle le phishing par téléphone ?', '["Vishing", "Smishing", "Phoning"]', 'Vishing', (SELECT id FROM categories WHERE nom = "Phishing")),
('Phishing par SMS', 'Quel est le terme pour désigner le phishing via SMS ?', '["Smishing", "Vishing", "Spamming"]', 'Smishing', (SELECT id FROM categories WHERE nom = "Phishing"));

-- RÉSEAUX
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Adresse IPv4', 'Quel est un exemple valide d’adresse IPv4 ?', '["192.168.1.1", "300.400.500.600", "abc.def.ghi.jkl"]', '192.168.1.1', (SELECT id FROM categories WHERE nom = "Réseaux")),
('Adresse IPv6', 'Quel format est utilisé par une adresse IPv6 ?', '["Hexadécimal", "Décimal", "Binaire"]', 'Hexadécimal', (SELECT id FROM categories WHERE nom = "Réseaux")),
('Port HTTP', 'Quel est le port par défaut pour HTTP ?', '["80", "443", "21"]', '80', (SELECT id FROM categories WHERE nom = "Réseaux")),
('Ping', 'À quoi sert la commande ping ?', '["Tester la connectivité réseau", "Ouvrir une session", "Analyser un virus"]', 'Tester la connectivité réseau', (SELECT id FROM categories WHERE nom = "Réseaux")),
('DNS', 'Que fait un serveur DNS ?', '["Traduit les noms de domaine en IP", "Analyse les emails", "Chiffre les connexions"]', 'Traduit les noms de domaine en IP', (SELECT id FROM categories WHERE nom = "Réseaux")),
('Pare-feu', 'Quel est le rôle d’un pare-feu ?', '["Filtrer le trafic réseau", "Afficher des pages web", "Héberger un site"]', 'Filtrer le trafic réseau', (SELECT id FROM categories WHERE nom = "Réseaux")),
('VPN', 'Quel est le but principal d’un VPN ?', '["Sécuriser la connexion", "Accélérer Internet", "Bloquer les publicités"]', 'Sécuriser la connexion', (SELECT id FROM categories WHERE nom = "Réseaux")),
('Protocole HTTPS', 'HTTPS est une version sécurisée de quel protocole ?', '["HTTP", "FTP", "SMTP"]', 'HTTP', (SELECT id FROM categories WHERE nom = "Réseaux")),
('Adresse MAC', 'À quoi sert une adresse MAC ?', '["Identifier une carte réseau", "Envoyer des emails", "Nommer un domaine"]', 'Identifier une carte réseau', (SELECT id FROM categories WHERE nom = "Réseaux")),
('NAT', 'Que signifie NAT ?', '["Network Address Translation", "New Access Tool", "National Access Token"]', 'Network Address Translation', (SELECT id FROM categories WHERE nom = "Réseaux"));


-- CRYPTOGRAPHIE
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Quel est un exemple d’algorithme de hachage ?', 'Quel est un algorithme de hachage sécurisé ?', '["RSA", "SHA-256", "AES"]', 'SHA-256', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Clé publique', 'Dans une paire de clés asymétriques, la clé publique sert à ?', '["Signer", "Chiffrer", "Compresser"]', 'Chiffrer', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Chiffrement symétrique', 'Quel algorithme est symétrique ?', '["RSA", "AES", "ECC"]', 'AES', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Utilité du chiffrement', 'Pourquoi chiffre-t-on les données ?', '["Pour les cacher", "Pour les détruire", "Pour les afficher"]', 'Pour les cacher', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Brute force', 'Une attaque par brute force tente de ?', '["Deviner un mot de passe", "Injecter du code", "Éteindre le serveur"]', 'Deviner un mot de passe', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Clé privée', 'À quoi sert une clé privée ?', '["Chiffrer", "Déchiffrer", "Envoyer"]', 'Déchiffrer', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Signature numérique', 'Une signature numérique garantit ?', '["Authenticité", "Confidentialité", "Stockage"]', 'Authenticité', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('SSL/TLS', 'SSL/TLS sert à ?', '["Sécuriser les communications", "Partager des fichiers", "Écrire du code"]', 'Sécuriser les communications', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Diffie-Hellman', 'Diffie-Hellman est utilisé pour ?', '["Le chiffrement symétrique", "L’échange de clés", "Le hachage"]', 'L’échange de clés', (SELECT id FROM categories WHERE nom = "Cryptographie")),
('Collision de hachage', 'Une collision de hachage signifie que ?', '["Deux entrées ont le même hash", "Un fichier est corrompu", "La clé est perdue"]', 'Deux entrées ont le même hash', (SELECT id FROM categories WHERE nom = "Cryptographie"));

-- MALWARE
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Type de malware', 'Quel est un malware courant ?', '["Cheval de Troie", "Firewall", "Routeur"]', 'Cheval de Troie', (SELECT id FROM categories WHERE nom = "Malware")),
('Spyware', 'Un spyware sert à ?', '["Surveiller", "Chiffrer", "Détecter des virus"]', 'Surveiller', (SELECT id FROM categories WHERE nom = "Malware")),
('Ransomware', 'Que fait un ransomware ?', '["Crypte les fichiers", "Efface les logs", "Installe un OS"]', 'Crypte les fichiers', (SELECT id FROM categories WHERE nom = "Malware")),
('Propagation automatique', 'Quel malware se propage sans action humaine ?', '["Ver", "Adware", "Keylogger"]', 'Ver', (SELECT id FROM categories WHERE nom = "Malware")),
('Rootkit', 'Un rootkit permet ?', '["Un accès caché", "Un scan antivirus", "Un changement d’écran"]', 'Un accès caché', (SELECT id FROM categories WHERE nom = "Malware")),
('Détection de virus', 'Quel outil détecte les malwares ?', '["Antivirus", "Navigateur", "Clavier"]', 'Antivirus', (SELECT id FROM categories WHERE nom = "Malware")),
('Backdoor', 'Une backdoor donne ?', '["Un accès non autorisé", "Un nouveau PC", "Un mot de passe"]', 'Un accès non autorisé', (SELECT id FROM categories WHERE nom = "Malware")),
('Keylogger', 'Un keylogger enregistre ?', '["Les frappes clavier", "Les vidéos", "Les mots de passe hashés"]', 'Les frappes clavier', (SELECT id FROM categories WHERE nom = "Malware")),
('Cheval de Troie', 'Pourquoi un cheval de Troie est dangereux ?', '["Il cache une menace", "Il envoie un mail", "Il imprime des logs"]', 'Il cache une menace', (SELECT id FROM categories WHERE nom = "Malware")),
('Adware', 'Un adware affiche ?', '["Des publicités", "Des logs", "Un écran bleu"]', 'Des publicités', (SELECT id FROM categories WHERE nom = "Malware"));

-- SÉCURITÉ WEB
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('XSS', 'XSS est une attaque qui ?', '["Injecte du JavaScript", "Formate le disque", "Télécharge un logiciel"]', 'Injecte du JavaScript', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('CSRF', 'CSRF utilise ?', '["Des requêtes à l’insu", "Un mot de passe", "Un script local"]', 'Des requêtes à l’insu', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('HTTPS', 'HTTPS est sécurisé car ?', '["Il chiffre les échanges", "Il est rapide", "Il coûte cher"]', 'Il chiffre les échanges', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('SQL Injection', 'Quel type de vulnérabilité est une injection SQL ?', '["Accès non autorisé", "Phishing", "Spam"]', 'Accès non autorisé', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('Header sécurisé', 'Quel header protège contre le XSS ?', '["Content-Security-Policy", "Date", "Accept"]', 'Content-Security-Policy', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('Captcha', 'Pourquoi utiliser un captcha ?', '["Éviter les bots", "Améliorer le design", "Ajouter du contenu"]', 'Éviter les bots', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('HSTS', 'HSTS sert à ?', '["Forcer HTTPS", "Activer Java", "Bloquer les cookies"]', 'Forcer HTTPS', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('Cookie HttpOnly', 'Un cookie HttpOnly est ?', '["Inaccessible par JS", "Visible par tous", "Exécuté en PHP"]', 'Inaccessible par JS', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('Séparation des privilèges', 'Cela aide à ?', '["Réduire les attaques", "Envoyer des mails", "Optimiser le CSS"]', 'Réduire les attaques', (SELECT id FROM categories WHERE nom = "Sécurité Web")),
('Sécurité formulaire', 'Que faut-il valider ?', '["Toutes les entrées", "Seulement les mails", "Rien"]', 'Toutes les entrées', (SELECT id FROM categories WHERE nom = "Sécurité Web"));

-- CLOUD
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Cloud #1', 'Quel service est essentiel pour sécuriser les données dans le cloud ?', '["Chiffrement", "Streaming", "Compression"]', 'Chiffrement', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #2', 'Qu’est-ce que le modèle SaaS ?', '["Software as a Service", "Storage as a Service", "Security as a Solution"]', 'Software as a Service', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #3', 'Quel est un avantage du cloud computing ?', '["Scalabilité", "Latence élevée", "Stockage local uniquement"]', 'Scalabilité', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #4', 'Quel type de cloud est partagé entre plusieurs organisations ?', '["Cloud privé", "Cloud public", "Cloud communautaire"]', 'Cloud communautaire', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #5', 'Quelle technologie est utilisée pour déployer des applications cloud ?', '["Conteneurs", "Disquettes", "Ports série"]', 'Conteneurs', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #6', 'Qu’est-ce que la haute disponibilité dans le cloud ?', '["Accès limité", "Temps de disponibilité maximal", "Sauvegarde automatique"]', 'Temps de disponibilité maximal', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #7', 'Quel outil est couramment utilisé pour gérer des ressources cloud ?', '["Terraform", "Paint", "Excel"]', 'Terraform', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #8', 'Qu’est-ce qu’un cloud hybride ?', '["Mix de cloud privé et public", "Un cloud sans internet", "Stockage sur disques physiques"]', 'Mix de cloud privé et public', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #9', 'Quelle menace est spécifique au cloud ?', '["Hyperviseur compromis", "Électrocution", "Manque de Wi-Fi"]', 'Hyperviseur compromis', (SELECT id FROM categories WHERE nom = "Cloud")),
('Cloud #10', 'Quel est un risque lié à la dépendance au fournisseur cloud ?', '["Verrouillage du fournisseur", "Sécurité renforcée", "Accès illimité"]', 'Verrouillage du fournisseur', (SELECT id FROM categories WHERE nom = "Cloud"));

-- SÉCURITÉ MOBILE
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Sécurité mobile #1', 'Quel comportement améliore la sécurité d’une app mobile ?', '["Télécharger via app store officiel", "Rooter son téléphone", "Partager son mot de passe"]', 'Télécharger via app store officiel', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #2', 'Que signifie le chiffrement de bout en bout ?', '["Chiffrement entre deux serveurs", "Chiffrement entre l’expéditeur et le destinataire", "Pas de chiffrement"]', 'Chiffrement entre l’expéditeur et le destinataire', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #3', 'Quelle autorisation est la plus critique pour une app ?', '["Accès caméra", "Changer fond d’écran", "Utiliser vibreur"]', 'Accès caméra', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #4', 'Quelle option protège mieux contre les accès non autorisés ?', '["Code PIN", "Aucun verrou", "Désactivation Wi-Fi"]', 'Code PIN', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #5', 'Que signifie le terme "jailbreak" ?', '["Accès root à un appareil Apple", "Suppression d’apps", "Partage de connexion"]', 'Accès root à un appareil Apple', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #6', 'Quel protocole est utilisé pour sécuriser les connexions mobiles ?', '["HTTPS", "HTTP", "FTP"]', 'HTTPS', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #7', 'Pourquoi faut-il faire les mises à jour régulières ?', '["Ajouter des jeux", "Corriger des vulnérabilités", "Changer de thème"]', 'Corriger des vulnérabilités', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #8', 'Quel type de malware cible les mobiles ?', '["Rogue app", "Rootkit", "Bootloader"]', 'Rogue app', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #9', 'Quelle bonne pratique concerne le Wi-Fi public ?', '["Utiliser un VPN", "Se connecter sans mot de passe", "Partager sa connexion"]', 'Utiliser un VPN', (SELECT id FROM categories WHERE nom = "Sécurité mobile")),
('Sécurité mobile #10', 'Que signifie l’authentification biométrique ?', '["Utiliser une photo", "Utiliser empreinte ou reconnaissance faciale", "Saisie de mot de passe"]', 'Utiliser empreinte ou reconnaissance faciale', (SELECT id FROM categories WHERE nom = "Sécurité mobile"));

-- SÉCURITÉ PHYSIQUE
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Sécurité physique #1', 'Quel moyen protège l’accès à un bâtiment sensible ?', '["Carte d’accès", "Télécommande TV", "Badge de visiteur"]', 'Carte d’accès', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #2', 'Quel outil est utilisé pour la surveillance vidéo ?', '["Caméra IP", "Smartphone", "Thermomètre"]', 'Caméra IP', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #3', 'Quel personnel assure la sécurité sur site ?', '["Agent de sécurité", "Responsable RH", "Stagiaire"]', 'Agent de sécurité', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #4', 'Quel type de protection empêche l’intrusion physique ?', '["Porte blindée", "Rideau", "Plante verte"]', 'Porte blindée', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #5', 'Qu’est-ce qu’une alarme anti-intrusion ?', '["Un système de détection et alerte", "Un extincteur", "Un climatiseur"]', 'Un système de détection et alerte', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #6', 'Quel dispositif permet le contrôle d’accès ?', '["Lecteur d’empreintes", "Interrupteur", "Thermostat"]', 'Lecteur d’empreintes', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #7', 'Pourquoi limiter les accès physiques ?', '["Réduire les risques de sabotage", "Augmenter les visites", "Ouvrir à tous les employés"]', 'Réduire les risques de sabotage', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #8', 'Quel risque est lié à l’absence de sécurité physique ?', '["Vol de données", "Fatigue oculaire", "Surconsommation électrique"]', 'Vol de données', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #9', 'Où place-t-on les équipements critiques ?', '["Salle sécurisée", "Bureau ouvert", "Couloir"]', 'Salle sécurisée', (SELECT id FROM categories WHERE nom = "Sécurité physique")),
('Sécurité physique #10', 'Comment limiter l’accès aux serveurs ?', '["Badge ou mot de passe", "Affiche informative", "Tableau blanc"]', 'Badge ou mot de passe', (SELECT id FROM categories WHERE nom = "Sécurité physique"));

-- GESTION DES ACCÈS
INSERT INTO quizzes (titre, question, choix, bonne_reponse, categorie_id) VALUES
('Gestion des accès #1', 'Quel est le principe du moindre privilège ?', '["Accès minimal nécessaire", "Accès illimité", "Accès partagé à tous"]', 'Accès minimal nécessaire', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #2', 'Qu’est-ce que l’authentification à deux facteurs ?', '["Deux niveaux d’identification", "Une seule vérification", "Aucun contrôle"]', 'Deux niveaux d’identification', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #3', 'Pourquoi créer des comptes utilisateurs distincts ?', '["Suivi des actions", "Réduction des coûts", "Ajout de pub"]', 'Suivi des actions', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #4', 'Que signifie RBAC ?', '["Role-Based Access Control", "Remote Backup Access Controller", "Random Backup And Control"]', 'Role-Based Access Control', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #5', 'Quelle méthode est plus sûre qu’un mot de passe seul ?', '["Authentification biométrique", "Nom d’utilisateur", "Adresse IP"]', 'Authentification biométrique', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #6', 'Que permet un journal d’audit ?', '["Suivre les accès", "Supprimer les erreurs", "Changer de mot de passe"]', 'Suivre les accès', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #7', 'Quand faut-il désactiver un compte ?', '["Après un départ", "Après une pause café", "Après un bug"]', 'Après un départ', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #8', 'Pourquoi utiliser un gestionnaire de mots de passe ?', '["Stockage sécurisé", "Partager les accès", "Envoyer des e-mails"]', 'Stockage sécurisé', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #9', 'Qu’est-ce que le SSO ?', '["Single Sign-On", "Secure Server Option", "Safe Software Operation"]', 'Single Sign-On', (SELECT id FROM categories WHERE nom = "Gestion des accès")),
('Gestion des accès #10', 'Comment détecter un accès non autorisé ?', '["Analyse des logs", "Appel téléphonique", "Envoi de SMS"]', 'Analyse des logs', (SELECT id FROM categories WHERE nom = "Gestion des accès"));