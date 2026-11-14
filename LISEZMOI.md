# Edgelog : installation sur Mac et iPhone

Compte environ 20 minutes au total, une seule fois. Tout est gratuit.

L'app est composée de trois éléments :
- **Supabase** stocke tes données (trades, journal, setups) et tes captures, et synchronise le Mac et l'iPhone ;
- **GitHub Pages** héberge les fichiers de l'app, à une adresse du type `https://tonpseudo.github.io/journal-trading/` ;
- **Safari** installe l'app sur le Mac (dans le Dock) et sur l'iPhone (sur l'écran d'accueil).

---

## 1. Créer un compte GitHub (5 min)

1. Va sur https://github.com/signup et crée ton compte. Choisis bien ton pseudo : il apparaîtra dans l'adresse de l'app.
2. Confirme ton email.

## 2. Créer la base de données Supabase (10 min)

1. Va sur https://supabase.com, clique sur **Start your project**, puis sur **Continue with GitHub**.
2. Clique sur **New project** et remplis :
   - Name : `journal-trading`
   - Database Password : génère-le et garde-le dans ton gestionnaire de mots de passe.
   - Region : **Europe (Frankfurt)**, la plus proche de Bruxelles.
3. Attends 1 à 2 minutes que le projet soit prêt.
4. Dans le menu de gauche, ouvre **SQL Editor** puis **New query**. Colle tout le contenu du fichier `supabase.sql` et clique sur **Run**. Tu dois voir *Success. No rows returned*.
5. Ouvre **Authentication**, puis **Sign In / Providers**, puis **Email**. Désactive **Confirm email** et enregistre. Ton compte fonctionnera tout de suite, sans lien de confirmation à cliquer.
6. Récupère deux valeurs, tu en auras besoin à l'étape 3 :
   - **Project URL**, du type `https://abcdefgh.supabase.co`. Tu la trouves via le bouton **Connect** en haut de la page, ou dans **Project Settings → Data API**.
   - **Publishable key** (`sb_publishable_…`), dans **Project Settings → API Keys**. Si tu ne vois qu'un onglet *Legacy API Keys*, prends la clé `anon` (elle commence par `eyJ…`).

   Ces deux valeurs sont faites pour être publiques. Ce qui protège tes données, ce sont les règles de sécurité créées par `supabase.sql` : chaque compte ne voit que ses propres données.

## 3. Mettre l'app en ligne avec GitHub Pages (5 min)

1. Décompresse le fichier `journal-trading-app.zip`.
2. **Recommandé** : ouvre `config.js` avec TextEdit et colle tes deux valeurs entre les guillemets :
   ```js
   SUPABASE_URL: "https://abcdefgh.supabase.co",
   SUPABASE_ANON_KEY: "sb_publishable_xxxxxxxx"
   ```
   Tu n'auras alors rien à taper sur l'iPhone. Si tu sautes cette étape, l'app te demandera ces valeurs au premier lancement sur chaque appareil.
3. Sur GitHub, clique sur **+** en haut à droite puis **New repository** :
   - Repository name : `journal-trading`
   - Visibilité : **Public**. GitHub Pages est gratuit pour les dépôts publics. Seul le code est visible, jamais tes données.
   - Clique sur **Create repository**.
4. Sur la page du dépôt, clique sur **uploading an existing file**. Glisse **tout le contenu** du dossier décompressé (`index.html`, `config.js`, `sw.js`, `manifest.webmanifest`, les icônes…). Clique sur **Commit changes**.
5. Va dans **Settings → Pages**. Sous *Build and deployment*, choisis **Deploy from a branch**, branche **main**, dossier **/ (root)**, puis **Save**.
6. Attends 1 à 2 minutes : l'adresse de ton app s'affiche en haut de la page (`https://tonpseudo.github.io/journal-trading/`).

## 4. Installer l'app

**Sur le MacBook** (macOS Sonoma 14 ou plus récent) :
1. Ouvre l'adresse de ton app dans **Safari**.
2. Menu **Fichier → Ajouter au Dock…**, puis **Ajouter**.
3. Lance « Edgelog » depuis le Dock et crée ton compte (email et mot de passe d'au moins 6 caractères).

**Sur l'iPhone** :
1. Ouvre l'adresse de ton app dans **Safari**.
2. Touche le bouton **Partager**, puis **Sur l'écran d'accueil**, puis **Ajouter**.
3. Ouvre l'app depuis l'icône (pas depuis Safari) et connecte-toi avec le **même** email et mot de passe.

## 5. Sécurité : fermer les inscriptions (1 min)

Une fois ton compte créé, retourne dans Supabase : **Authentication → Sign In / Providers**. Désactive **Allow new users to sign up** et enregistre. Personne d'autre ne pourra alors créer de compte sur ta base.

---

## Bon à savoir

- **Hors ligne** : l'app s'ouvre et affiche tes trades sans connexion. Les trades saisis hors ligne partent automatiquement dès que le réseau revient. Les captures, elles, ne peuvent être envoyées qu'avec une connexion.
- **Captures** : elles sont compressées (environ 200 à 400 Ko chacune). Avec 1 Go gratuit, tu peux en stocker plusieurs milliers.
- **Pause Supabase** : un projet gratuit est mis en pause après 7 jours sans activité (par exemple pendant des vacances). Pour le relancer, ouvre supabase.com et clique sur **Restore project**. Tes données ne sont pas perdues.
- **Sauvegarde** : dans Réglages, le bouton **Télécharger la sauvegarde** crée un fichier JSON avec toutes tes données (hors images). Fais-le de temps en temps.
- **Mettre à jour l'app** : remplace les fichiers sur GitHub (*Add file → Upload files*) et change `tj-v1` en `tj-v2` dans `sw.js`. Relance ensuite l'app deux fois pour charger la nouvelle version.
