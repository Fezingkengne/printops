# PrintOps – application de bureau (Windows et Mac)

© Fezing Kengne Thierry Yann

## 1. Avant tout
La clé « anon public » et la base Supabase sont déjà configurées (`dist/config.js`). Le script `supabase-setup.sql` a déjà été appliqué.

## 1 bis. Installateur Windows prêt à l'emploi
`installateur-windows/PrintOps-Setup.exe` : double-clic, choisis le dossier, colle ta clé Supabase (ou laisse vide et modifie `dist\config.js` plus tard). Il crée les raccourcis Bureau et Menu Démarrer, et un désinstalleur.
Cet installateur ouvre PrintOps dans une fenêtre d'application Edge ou Chrome (l'un des deux doit être installé). Ce n'est pas la version Tauri : pas de connexion Google, et l'avertissement SmartScreen s'affichera (fichier non signé).
Pour le reconstruire : `makensis installateur-windows/PrintOps.nsi` (sur Windows : NSIS installé).

## 2. Obtenir les installateurs sans rien installer (gratuit)
1. Crée un dépôt GitHub (privé ou public) et envoie-y tout ce dossier.
2. Onglet Actions, « Construire PrintOps », bouton Run workflow.
3. Après quelques minutes, ouvre Releases : le .msi / .exe (Windows) et le .dmg (Mac) sont dans le brouillon de version. Publie-le pour partager le lien.
Les minutes de construction gratuites de GitHub sont limitées pour les dépôts privés.

## 3. Construire sur ton propre PC (optionnel)
Installe Node.js et Rust, puis : `npm install`, `npx tauri icon app-icon.png`, `npm run build`.
Les installateurs sont dans `src-tauri/target/release/bundle/`.

## Notes
- Connexion par e-mail et mot de passe dans l'application de bureau (Google bloque sa connexion dans les fenêtres intégrées).
- Windows 7 et 8 : configuration prévue (mode de WebView2 intégré), mais non garantie. À tester sur une vraie machine.
- Une app non signée affiche un avertissement : « Windows a protégé votre PC » (Windows) ou une autorisation manuelle (Mac).
- Si l'interface s'affiche sans style, mets `"csp": null` dans `src-tauri/tauri.conf.json`.
