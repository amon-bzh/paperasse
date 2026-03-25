# Setup guidé (première utilisation)

Ce setup se lance uniquement si `company.json` n'existe pas à la racine du projet. Il crée le fichier étape par étape.

**Ne pas sauter d'étapes. Poser une question à la fois.**

## Étape 1 : Informations de la société

Demander :

> Quel est le **nom de votre société** et son **numéro SIREN** ?

Si SIREN fourni → lancer `python scripts/fetch_company.py <SIREN>` pour pré-remplir automatiquement (raison sociale, forme juridique, adresse, code NAF). Afficher et demander confirmation.

Si pas de SIREN ou échec du script → demander manuellement :
- Raison sociale
- Forme juridique (SASU, EURL, SAS, SARL, EI)
- Adresse du siège
- Code NAF

## Étape 2 : Régime fiscal

Demander :

> Quel est votre **régime TVA** ? (franchise en base / réel simplifié / réel normal)
> Quel est votre **régime d'imposition** ? (IS / IR)

Si l'utilisateur hésite, expliquer brièvement les différences entre les régimes.

## Étape 3 : Exercice comptable

Demander :

> Quelles sont les **dates de votre exercice comptable** ? (début et fin)
> Est-ce votre **premier exercice** ?

## Étape 4 : Dirigeant

Demander :

> Quel est le **nom du dirigeant** ? (prénom, nom, civilité)

Le titre est déduit automatiquement de la forme juridique : "Président" pour SAS/SASU, "Gérant" pour SARL/EURL.

## Étape 5 : Banque

Demander :

> Utilisez-vous **Qonto** comme banque professionnelle ?

**Si oui** :
- Mettre `qonto.enabled` à `true` dans `company.json`
- Expliquer : "Pour connecter Qonto, définissez deux variables d'environnement (dashboard Qonto > **Settings > Integrations > API**) :"
  ```
  export QONTO_ID="votre-slug-organisation"
  export QONTO_API_SECRET="votre-cle-secrete"
  ```

**Si non** : demander le nom de la banque principale (pour le libellé du compte 512).

## Étape 6 : Paiements en ligne

Demander :

> Utilisez-vous **Stripe** pour encaisser des paiements ?

**Si oui** :

> Combien de **comptes Stripe** avez-vous ? (un seul / plusieurs comptes séparés / Stripe Connect)
> Pour chaque compte, quel **nom** voulez-vous lui donner ? (ex: "Mon SaaS", "Ma Boutique")

Configurer une entrée par compte dans `stripe_accounts` avec `id`, `name`, `env_key`. Expliquer :
- "Définissez la variable d'environnement avec votre clé secrète (dashboard Stripe > **Developers > API keys**) :"
  ```
  export STRIPE_SECRET="sk_live_..."
  ```
- Pour Stripe Connect, demander aussi le `stripe_account_id` (`acct_xxx`) de chaque sous-compte.

**Si non** : laisser `stripe_accounts` vide (`[]`).

## Étape 7 : Générer company.json

Avec toutes les informations collectées, générer le fichier `company.json` à la racine du projet. Afficher un récapitulatif :

```
Société configurée :
  Raison sociale : [nom]
  Forme juridique : [forme]
  SIREN : [siren]
  Régime TVA : [regime]
  Exercice : [debut] > [fin]
  Banque : [Qonto / autre]
  Stripe : [X compte(s) configuré(s) / non]
```

Puis passer au workflow normal (vérification des échéances).
