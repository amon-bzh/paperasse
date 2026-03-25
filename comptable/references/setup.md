# Setup guidé (première utilisation)

Ce setup se lance uniquement si `company.json` n'existe pas à la racine du projet. Il crée le fichier étape par étape.

**Principe : inférer un maximum, demander un minimum.** L'API SIRENE donne presque tout. Ne poser que les questions dont la réponse n'est pas déductible.

## Étape 1 : Identifier la société

Demander :

> Quel est le **nom de votre société** ?

Lancer la recherche :

```bash
python scripts/fetch_company.py "<nom ou SIREN>" --json
```

**Si plusieurs résultats** : afficher la liste (nom, SIREN, ville, date de création) et demander laquelle est la bonne.

**Si un seul résultat** : afficher les informations et demander confirmation.

**Si aucun résultat** : demander manuellement (raison sociale, SIREN, forme juridique, adresse, code NAF).

### Données pré-remplies automatiquement depuis l'API

Après confirmation, les champs suivants sont remplis sans rien demander :

- **Raison sociale, SIREN, SIRET, adresse, code NAF** : directement depuis l'API
- **Dirigeant** : l'API renvoie les dirigeants, utiliser le premier. Titre déduit de la forme juridique (Président pour SAS/SASU, Gérant pour SARL/EURL)
- **Régime d'imposition** : IS par défaut pour SAS, SASU, SARL, SA. IR par défaut pour EI, EIRL, auto-entrepreneur. Mentionner le défaut choisi, l'utilisateur corrigera si besoin.
- **Premier exercice** : si `date_creation` < 2 ans, c'est probablement le premier exercice. Le mentionner.
- **Dates d'exercice** : premier exercice = date de création → 31/12 de l'année suivante (ou de l'année en cours si créé en janvier). Exercices suivants = 01/01 → 31/12. Proposer ces dates par défaut, l'utilisateur ajuste si besoin.

## Étape 2 : Régime TVA

C'est la seule information fiscale qu'on ne peut pas déduire. Demander :

> Quel est votre **régime TVA** ?

Proposer les options :
- Franchise en base (pas de TVA facturée)
- Réel simplifié (déclaration annuelle CA12)
- Réel normal (déclaration mensuelle CA3)

## Étape 3 : Banque

> Utilisez-vous **Qonto** comme banque professionnelle ?

**Si oui** :
- Mettre `qonto.enabled` à `true` dans `company.json`
- Demander les identifiants API :

> Pour connecter Qonto, j'ai besoin de vos identifiants API.
> Vous les trouverez dans le dashboard Qonto > **Settings > Integrations > API**.
>
> Quel est votre **Organization slug** (QONTO_ID) ?
> Et votre **Secret key** (QONTO_API_SECRET) ?

- Écrire les valeurs dans `.env` à la racine du projet (le créer s'il n'existe pas).
- Tester la connexion : `node integrations/qonto/fetch.js --start $(date +%Y-%m-%d) --end $(date +%Y-%m-%d)`. Si ça fonctionne, confirmer. Si erreur, afficher le message et demander de vérifier les identifiants.

**Si non** : demander le nom de la banque principale (pour le libellé du compte 512).

## Étape 4 : Paiements en ligne

> Utilisez-vous **Stripe** pour encaisser des paiements ?

**Si oui** :

> Combien de **comptes Stripe** avez-vous ? (un seul / plusieurs comptes séparés / Stripe Connect)
> Pour chaque compte, quel **nom** voulez-vous lui donner ? (ex: "Mon SaaS", "Ma Boutique")

Configurer une entrée par compte dans `stripe_accounts` avec `id`, `name`, `env_key`.

Pour chaque compte, demander la clé API :

> Pour connecter **[nom du compte]**, j'ai besoin de votre clé secrète Stripe.
> Vous la trouverez dans le dashboard Stripe > **Developers > API keys** (commence par `sk_live_` ou `sk_test_`).
>
> Quelle est votre **Secret key** pour [nom du compte] ?

- Pour Stripe Connect, demander aussi le `stripe_account_id` (`acct_xxx`) de chaque sous-compte.
- Écrire les clés dans `.env` (une variable par compte : `STRIPE_SECRET_MELIES`, `STRIPE_SECRET_BEANVEST`, etc.).
- Tester la connexion pour chaque compte : `node integrations/stripe/fetch.js --account <id> --start $(date +%Y-%m-%d) --end $(date +%Y-%m-%d)`. Confirmer ou demander de vérifier si erreur.

**Si non** : laisser `stripe_accounts` vide (`[]`).

### Fichier .env

Les clés API sont stockées dans `.env` à la racine du projet (jamais dans `company.json`, jamais commitées). Vérifier que `.env` est dans `.gitignore`. Format :

```
QONTO_ID=votre-slug-organisation
QONTO_API_SECRET=votre-cle-secrete
STRIPE_SECRET_MELIES=sk_live_...
STRIPE_SECRET_BEANVEST=sk_live_...
```

## Étape 5 : Récapitulatif et génération

Afficher un récapitulatif complet de tout ce qui a été collecté et inféré. Marquer clairement ce qui a été déduit pour que l'utilisateur puisse corriger :

```
Société configurée :
  Raison sociale : [nom]
  Forme juridique : [forme]
  SIREN : [siren]
  Dirigeant : [nom] ([titre déduit])
  Régime TVA : [regime]
  Régime imposition : [IS/IR] (déduit de la forme juridique)
  Exercice : [debut] > [fin] (déduit de la date de création)
  Premier exercice : [oui/non]
  Banque : [Qonto / autre]
  Stripe : [X compte(s) configuré(s) / non]
```

> **Quelque chose à corriger ?** Sinon je génère le fichier `company.json`.

Générer `company.json`, puis passer au workflow normal (vérification des échéances).
