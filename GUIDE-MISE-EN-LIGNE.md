# PrintOps – mise en ligne, connexions Google/Microsoft et application de bureau

© Fezing Kengne Thierry Yann

Ces étapes demandent TES comptes (GitHub, Google, Microsoft, Supabase) : personne ne peut les faire à ta place.

## A. Compte GitHub (avec ton Gmail) et site web gratuit
1. Va sur github.com, « Sign up », avec `tfezingkengne@gmail.com`. Confirme l'e-mail.
2. Crée un dépôt **public** nommé `printops` (GitHub Pages gratuit demande un dépôt public ; ta clé « anon » est publique par conception, les données sont protégées par les règles de la base).
3. Dézippe `printops-desktop.zip`, puis dans le dépôt : Add file > Upload files, glisse tout le contenu du dossier `printops-desktop` (vérifie que le dossier `.github/workflows` est bien envoyé ; sinon crée les deux fichiers à la main avec Add file > Create new file, en tapant le chemin `.github/workflows/pages.yml` puis `.github/workflows/build.yml`, et colle leur contenu).
4. Dépôt > Settings > Pages > Source : **GitHub Actions**.
5. Onglet Actions > « Publier le site PrintOps » > Run workflow. Ton site : `https://TON-IDENTIFIANT.github.io/printops/`.

## B. Supabase : adresses autorisées
Tableau de bord Supabase > Authentication > URL Configuration :
- Site URL : l'adresse de ton site GitHub Pages ;
- Redirect URLs : la même adresse (avec le `/` final).
Sans cela, « Mot de passe oublié », Google et Microsoft ne reviennent pas dans l'application.

## C. Bouton Google (Gmail)
1. console.cloud.google.com > nouveau projet > APIs et services > Écran de consentement OAuth (Externe) > renseigne le nom de l'application et ton e-mail.
2. Identifiants > Créer des identifiants > ID client OAuth > Application Web.
3. URI de redirection autorisé : `https://fbhvqzsydzfahhtzkyey.supabase.co/auth/v1/callback`
4. Copie l'ID client et le Secret client.
5. Supabase > Authentication > Providers > Google : active, colle les deux valeurs, enregistre.

## D. Bouton Microsoft (Outlook) avec ton compte Microsoft
1. portal.azure.com > Microsoft Entra ID > Inscriptions d'applications > Nouvelle inscription.
2. Types de comptes pris en charge : « Comptes dans un annuaire organisationnel et comptes Microsoft personnels » (pour que les adresses Outlook.com marchent).
3. URI de redirection (Web) : `https://fbhvqzsydzfahhtzkyey.supabase.co/auth/v1/callback`
4. Après création, copie l'**ID d'application (client)**. Certificats et secrets > Nouveau secret client > copie la **Valeur** tout de suite (elle ne s'affiche qu'une fois).
5. Configuration des jetons > Ajouter une revendication facultative > type ID > `email`.
6. Supabase > Authentication > Providers > Azure : active, colle l'ID client et le secret. Pour l'URL du locataire (tenant), les comptes mixtes demandent en général `https://login.microsoftonline.com/common` (vérifie la doc Supabase si l'interface propose autre chose).

## E. Yahoo
Pas de bouton en un clic : les employés Yahoo s'inscrivent par e-mail et mot de passe.

## F. Application de bureau (Windows et Mac) compilée par GitHub
1. Même dépôt : onglet Actions > « Construire PrintOps » > Run workflow (Windows et Mac).
2. Quand c'est fini : Releases > brouillon de version > télécharge le .msi / .exe (Windows) et le .dmg (Mac).
3. Dans l'application de bureau, la connexion Google est bloquée par Google (fenêtre intégrée) : connecte-toi avec ton **adresse Gmail + mot de passe PrintOps**. La réinitialisation du mot de passe se fait depuis le site web.

## G. Caméras
- Le lien doit être en **https**, accessible depuis Internet (ou le réseau de l'atelier) et non protégé par une page de connexion.
- Types : flux MJPEG, image fixe (actualisée toutes les 5 s) ou page web (HLS).
- Les flux RTSP ne s'affichent pas dans un navigateur : passe par un petit serveur (ex. go2rtc, MediaMTX) qui les convertit.
- N'expose jamais une caméra sans mot de passe sur Internet.
