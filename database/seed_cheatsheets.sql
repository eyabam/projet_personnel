DROP TABLE IF EXISTS cheatsheets;

CREATE TABLE cheatsheets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  categorie VARCHAR(100) NOT NULL,
  titre VARCHAR(255) NOT NULL,
  contenu TEXT NOT NULL
);

-- 📧 Phishing
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Phishing', 'Reconnaître un email de phishing', 'Vérifie l\'adresse de l\'expéditeur, liens suspects, fautes, urgences.'),
('Phishing', 'Ne jamais cliquer sans réfléchir', 'Passe la souris sur le lien pour voir la vraie URL.'),
('Phishing', 'Faux formulaires de connexion', 'Vérifie l’URL dans la barre d’adresse, évite les pages suspects.'),
('Phishing', 'SMS frauduleux', 'Le smishing est une forme de phishing par SMS. Même prudence que les emails.'),
('Phishing', 'Attaques ciblées (spear phishing)', 'Personnalisées et plus dangereuses. Vérifie les moindres détails.'),
('Phishing', 'Protection de la boîte mail', 'Antispam, MFA, mot de passe fort.'),
('Phishing', 'Signaler un phishing', 'Utilise les outils de signalement intégrés dans les services email.'),
('Phishing', 'Sites clonés', 'Comparer avec le site officiel, mauvaise qualité visuelle, fautes.'),
('Phishing', 'Faux appels téléphoniques', 'Appel avec faux numéro officiel pour obtenir tes infos.'),
('Phishing', 'Exemples récents d’attaques', 'Tiens-toi informé des nouvelles campagnes de phishing.');

-- 🔐 Cryptographie
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Cryptographie', 'Symétrique vs Asymétrique', 'Symétrique (1 clé), Asymétrique (2 clés).'),
('Cryptographie', 'RSA', 'Algorithme asymétrique basé sur la difficulté de factoriser.'),
('Cryptographie', 'AES', 'Algorithme de chiffrement symétrique rapide et sécurisé.'),
('Cryptographie', 'ECC', 'Elliptic Curve Cryptography, sécurisé avec clés plus petites.'),
('Cryptographie', 'Hachage', 'Transforme données en empreinte unique.'),
('Cryptographie', 'SHA-256', 'Fonction de hachage courante, irréversible.'),
('Cryptographie', 'Certificats SSL/TLS', 'Sécurisent les échanges sur Internet.'),
('Cryptographie', 'PGP/GPG', 'Chiffrement des emails, clé publique/privée.'),
('Cryptographie', 'Chiffrement des bases de données', 'Protège les données en cas d’intrusion.'),
('Cryptographie', 'Protocoles sécurisés', 'HTTPS, FTPS, SFTP : utilisent la cryptographie.');

-- 🌐 Réseaux
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Réseaux', 'Modèle OSI', '7 couches : Physique à Application.'),
('Réseaux', 'TCP vs UDP', 'TCP fiable, UDP rapide mais sans garantie.'),
('Réseaux', 'Adresse IP', 'Adresse unique sur un réseau. IPv4 / IPv6.'),
('Réseaux', 'Firewall', 'Filtre le trafic réseau selon des règles.'),
('Réseaux', 'VPN', 'Chiffre le trafic réseau pour le protéger.'),
('Réseaux', 'NAT', 'Traduit les adresses internes en IP publique.'),
('Réseaux', 'Proxy', 'Intermédiaire entre client et serveur.'),
('Réseaux', 'DHCP', 'Attribue automatiquement une IP.'),
('Réseaux', 'DNS', 'Traduit un nom de domaine en adresse IP.'),
('Réseaux', 'Port scanning', 'Technique pour détecter les services ouverts.');

-- 🐛 Malware
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Malware', 'Types de malwares', 'Virus, vers, chevaux de Troie, ransomwares, spywares.'),
('Malware', 'Infection par USB', 'Les périphériques USB peuvent contenir des malwares.'),
('Malware', 'Cheval de Troie', 'Semble légitime mais exécute du code malveillant.'),
('Malware', 'Ransomware', 'Chiffre les fichiers et demande une rançon.'),
('Malware', 'Spyware', 'Surveille l’utilisateur à son insu.'),
('Malware', 'Rootkit', 'Cache des activités malveillantes sur le système.'),
('Malware', 'Anti-malware', 'Logiciel conçu pour détecter et bloquer les malwares.'),
('Malware', 'Signature vs Heuristique', 'Deux méthodes de détection utilisées par les antivirus.'),
('Malware', 'Analyse comportementale', 'Surveille les comportements suspects.'),
('Malware', 'Sandboxes', 'Exécution isolée de logiciels pour détection.');

-- 🌐 Sécurité Web
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Sécurité Web', 'XSS', 'Injection de scripts dans les pages web. Protection : validation des entrées.'),
('Sécurité Web', 'Injection SQL', 'Manipulation des requêtes SQL. Protection : requêtes préparées.'),
('Sécurité Web', 'CSRF', 'Falsification de requête. Protection : token anti-CSRF.'),
('Sécurité Web', 'CSP', 'Content Security Policy limite les ressources externes.'),
('Sécurité Web', 'HTTPS obligatoire', 'Chiffre les données échangées.'),
('Sécurité Web', 'Cookies sécurisés', 'Utiliser Secure, HttpOnly, SameSite.'),
('Sécurité Web', 'Scanners de vulnérabilité', 'Permettent de détecter les failles.'),
('Sécurité Web', 'Contrôle d’accès', 'Vérifier les droits côté serveur.'),
('Sécurité Web', 'Gestion des erreurs', 'Ne pas exposer les messages d’erreur aux utilisateurs.'),
('Sécurité Web', 'Mises à jour régulières', 'Corrige les vulnérabilités connues.');

-- 📱 Sécurité mobile
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Sécurité mobile', 'Permissions d\'applications', 'Vérifie les permissions demandées par une app avant installation.'),
('Sécurité mobile', 'VPN sur mobile', 'Chiffre les données surtout en mobilité.'),
('Sécurité mobile', 'Mises à jour', 'Installe les correctifs de sécurité dès qu\'ils sont disponibles.'),
('Sécurité mobile', 'App store officiel', 'Évite d\'installer des apps depuis des sources non vérifiées.'),
('Sécurité mobile', 'Chiffrement du téléphone', 'Protège les données en cas de vol.'),
('Sécurité mobile', 'MFA', 'Double vérification pour l\'accès aux apps sensibles.'),
('Sécurité mobile', 'Effacement à distance', 'Permet d\'effacer les données après vol/perte.'),
('Sécurité mobile', 'Détection des apps malveillantes', 'Utiliser un antivirus mobile.'),
('Sécurité mobile', 'Notifications sensibles', 'Masquer sur écran verrouillé.'),
('Sécurité mobile', 'Bluetooth désactivé', 'Éviter les connexions automatiques inconnues.');

-- ☁️ Cloud
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Cloud', 'Responsabilité partagée', 'Partage des responsabilités entre client et fournisseur.'),
('Cloud', 'Chiffrement des données', 'Données chiffrées au repos et en transit.'),
('Cloud', 'Backups dans le cloud', 'Sauvegardes automatiques, versioning.'),
('Cloud', 'Authentification MFA', 'Empêche les accès non autorisés.'),
('Cloud', 'IAM', 'Gestion des accès selon les rôles.'),
('Cloud', 'Logs de sécurité', 'Surveillance et alertes en cas d\'anomalie.'),
('Cloud', 'Règles de pare-feu', 'Contrôle des connexions entrantes/sortantes.'),
('Cloud', 'Cloud privé vs public', 'Sécurité renforcée dans le cloud privé.'),
('Cloud', 'DDoS Protection', 'Protection contre les attaques par déni de service.'),
('Cloud', 'Conformité RGPD', 'Respecter les lois sur la protection des données.');

-- 🛡️ Sécurité physique
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Sécurité physique', 'Caméras de surveillance', 'Permettent de détecter les intrusions.'),
('Sécurité physique', 'Badge d\'accès', 'Contrôle les personnes autorisées à entrer.'),
('Sécurité physique', 'Alarme anti-intrusion', 'Détecte les ouvertures non autorisées.'),
('Sécurité physique', 'Verrouillage physique', 'Portes sécurisées, cadenas, grillages.'),
('Sécurité physique', 'Contrôle biométrique', 'Empreintes, reconnaissance faciale.'),
('Sécurité physique', 'Protection des serveurs', 'Accès restreint, salle dédiée.'),
('Sécurité physique', 'Surveillance humaine', 'Agents de sécurité, rondes.'),
('Sécurité physique', 'Gestion des visiteurs', 'Badges temporaires, escortes.'),
('Sécurité physique', 'Plan d\'évacuation', 'Sécurité incendie et urgence.'),
('Sécurité physique', 'Maintenance sécurisée', 'Contrôles d’accès pour les techniciens.');

-- 👥 Gestion des accès
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Gestion des accès', 'MFA', 'Ajoute une vérification pour éviter l\'usurpation.'),
('Gestion des accès', 'SSO', 'Connexion unique pour plusieurs services.'),
('Gestion des accès', 'RBAC', 'Accès selon les rôles définis.'),
('Gestion des accès', 'Révocation rapide', 'Désactiver rapidement les anciens comptes.'),
('Gestion des accès', 'Contrôle des privilèges', 'Limite les accès au strict nécessaire.'),
('Gestion des accès', 'Audit des connexions', 'Surveillance régulière des accès.'),
('Gestion des accès', 'Comptes temporaires', 'Pour les prestataires ou stagiaires.'),
('Gestion des accès', 'Renforcement des mots de passe', 'Longs, complexes, changeables.'),
('Gestion des accès', 'Gestion des sessions', 'Expiration automatique des sessions.'),
('Gestion des accès', 'Alertes d’accès suspect', 'Détection automatique des connexions anormales.');

-- 📌 Bonnes pratiques
INSERT INTO cheatsheets (categorie, titre, contenu) VALUES
('Bonnes pratiques', 'Mots de passe forts', 'Longs, complexes, uniques.'),
('Bonnes pratiques', 'Sauvegardes régulières', 'Éviter la perte de données.'),
('Bonnes pratiques', 'Verrouillage automatique', 'Écran verrouillé en cas d\'inactivité.'),
('Bonnes pratiques', 'Mise à jour automatique', 'Corriger les failles rapidement.'),
('Bonnes pratiques', 'Séparation des usages', 'Usage pro/perso sur des appareils distincts.'),
('Bonnes pratiques', 'Sensibilisation continue', 'Former régulièrement les utilisateurs.'),
('Bonnes pratiques', 'Limitation des droits', 'Accès minimum aux utilisateurs.'),
('Bonnes pratiques', 'Politiques de sécurité', 'Claires, documentées, partagées.'),
('Bonnes pratiques', 'Antivirus à jour', 'Protection active en temps réel.'),
('Bonnes pratiques', 'Éviter les réseaux publics', 'Utiliser un VPN si nécessaire.');
