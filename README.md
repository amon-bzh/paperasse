<p align="center">
  <img src="assets/banner.jpg" alt="Paperasse" width="100%">
</p>

<h1 align="center">Paperasse</h1>

<p align="center">
  <b>Des skills pour agents IA spécialisés dans la bureaucratie française.</b>
</p>

<p align="center">
  <i>Parce que quelqu'un devait le faire, et ce quelqu'un n'a pas besoin de pause café.</i>
</p>

<p align="center">
  <a href="https://github.com/romainsimon/paperasse/stargazers"><img src="https://img.shields.io/github/stars/romainsimon/paperasse" alt="GitHub stars"></a>
  <img src="https://img.shields.io/badge/evals-93%2F93_passing-brightgreen" alt="Evals 93/93 passing">
  <a href="https://github.com/romainsimon/paperasse/blob/master/LICENSE"><img src="https://img.shields.io/github/license/romainsimon/paperasse?style=flat&color=blue" alt="License"></a>
</p>

<br />

---

## Qu'est-ce que Paperasse ?

<b>Paperasse est une collection de skills pour agents IA ([Claude Code](https://claude.com/product/claude-code), [Claude Cowork](https://claude.com/product/cowork), [Codex](https://openai.com/codex/), [Cursor](https://cursor.com), [Windsurf](https://windsurf.com), [Cline](https://cline.bot), [Aider](https://aider.chat)) spécialisés dans la comptabilité, la fiscalité, le notariat et l'audit des entreprises françaises.</b>

Chaque skill transforme votre agent en copilote expert d'un métier de la paperasse : comptabilité (PCG, TVA, IS, clôture annuelle, FEC, liasse fiscale), contrôle fiscal, audit CAC, et droit notarial (immobilier, succession, donation). Il connaît les textes (CGI, BOFiP, NEP), les formulaires, les échéances, et ne se trompe pas de case dans la liasse fiscale.

Les skills sont du Markdown. Ils fonctionnent avec tout agent ou outil capable de lire des fichiers. Paperasse inclut aussi des connecteurs pour récupérer automatiquement vos transactions bancaires (Qonto) et paiements (Stripe).

---

## Installation rapide

### Option 1 : installation via agentskill.sh (recommandé)

Installe les skills depuis le registre [agentskill.sh](https://agentskill.sh/skillsets/paperasse).
Pas besoin de cloner le repo et permet d'avoir tous les skills maintenus à jour automatiquement.

Copiez-collez ces instructions dans votre agent IA :

```
Suis les instructions pour installer le skillset Paperasse depuis https://agentskill.sh/skillsets/paperasse
Lance ensuite le setup pour la gestion de toute ma paperasse
```

### Option 2 : installation via GitHub

Copiez-collez ces instructions dans votre agent IA :

```
Installe tous les skills du repo github https://github.com/romainsimon/paperasse
Lance ensuite le setup pour la gestion de toute ma paperasse
```

L'agent va cloner le repo, installer les skills, et lancer le setup guidé qui vous posera quelques questions (nom de votre société, régime TVA, comptes bancaires) pour configurer votre environnement.

---

## Ce que Paperasse automatise (et ce qu'il ne fait pas)

### Ce qui est automatisé

| Étape | Outil | Détail |
|-------|-------|--------|
| Classification des dépenses | Skill `comptable` | Mappage vendor → compte PCG (800+ comptes) |
| Écritures comptables | Skill `comptable` | Double entrée avec comptes, journaux, libellés |
| Cut-off (PCA, CCA, CAP, PAR) | Skill `comptable` | Calcul prorata temporis, écritures de régularisation |
| Amortissements | Skill `comptable` | Linéaire, dégressif, prorata première année |
| Calcul IS | Skill `comptable` | Taux réduit PME (15%), taux normal (25%), prorata exercice court |
| États financiers | Script `generate-statements.js` | Bilan, Compte de résultat, Balance depuis le journal |
| FEC | Script `generate-fec.js` | Fichier légal 18 colonnes (art. L. 47 A-I LPF) |
| PDFs professionnels | Script `generate-pdfs.js` | Tous documents avec en-tête société, pagination A4 |
| Liasse fiscale (brouillon) | Template `liasse-fiscale-2033.md` | 2033-A à 2033-D pré-structurés |
| Formulaire 2065-SD | Template `2065-sd.html` | Déclaration IS pré-remplie |
| Déclaration de confidentialité | Template `declaration-confidentialite.html` | Art. L. 232-25 C. com. |
| PV d'approbation des comptes | Template `approbation-comptes.md` | Décision de l'associé unique ou PV d'AG |
| Checklist dépôt greffe | Template `depot-greffe-checklist.md` | Documents et délais |
| Contrôle fiscal simulé | Skill `controleur-fiscal` | 8 axes de vérification DGFIP |
| Audit CAC | Skill `commissaire-aux-comptes` | 7 phases NEP, opinion motivée |
| Frais de notaire | Skill `notaire` | DMTO, émoluments, CSI, débours (ancien et neuf) |
| Plus-value immobilière | Skill `notaire` | Abattements durée de détention, surtaxe, exonérations |
| Droits de succession | Skill `notaire` | Barème progressif, abattements, partage, conjoint survivant |
| Droits de donation | Skill `notaire` | Donation simple, donation-partage, démembrement, Dutreil |
| Projets d'actes notariés | Skill `notaire` | Compromis, SCI, PACS, donation, testament (projets de travail) |
| Diagnostics immobiliers | Skill `notaire` | Checklist DDT complète selon ancienneté et localisation |
| Conseil patrimonial | Skill `notaire` | Usufruit/nue-propriété, SCI familiale, transmission |
| Collecte transactions Qonto | Connecteur `integrations/qonto` | Toutes les transactions bancaires via API |
| Collecte transactions Stripe | Connecteur `integrations/stripe` | Charges, fees, payouts, refunds via API |
| Rapprochement bancaire Stripe/Qonto | Skill `comptable` + connecteurs | Croisement automatique payouts Stripe / crédits Qonto |

### Ce qui reste manuel

| Étape | Pourquoi |
|-------|----------|
| Collecte des transactions | Automatisable avec les connecteurs Qonto et Stripe (voir ci-dessous) |
| Signature des documents | Obligation légale (seul un humain peut signer) |
| Dépôt sur Infogreffe / impots.gouv.fr | Authentification personnelle requise |
| Télépaiement IS | Accès à l'espace professionnel impots.gouv.fr |
| Validation finale des montants | Responsabilité de l'expert-comptable ou du dirigeant |
| Authentification des actes notariés | Monopole du notaire (officier public, sceau et signature) |
| Dépôt au service de la publicité foncière | Procédure réservée aux notaires |
| Consultation FICOBA (comptes bancaires du défunt) | Accès réservé aux notaires pour les successions |

---

## Workflow complet : de zéro à la clôture annuelle

Voici comment utiliser les 3 skills ensemble pour gérer la comptabilité complète d'une entreprise française.

### Phase 1 : Comptabilité courante (skill `comptable`)

```
> Voici mes transactions bancaires de janvier. Catégorise-les et génère les écritures.

> Comment comptabiliser un abonnement Stripe en USD avec commission ?

> Mon CA cumulé est de 32 000 EUR, suis-je proche du seuil TVA ?
```

Le skill `comptable` gère toute la comptabilité courante : écritures, PCG, TVA, calculs.

### Phase 2 : Clôture annuelle (skill `comptable`)

```
> Fais la clôture annuelle de ma société. Exercice du 01/01/2025 au 31/12/2025.
```

Le skill suit le workflow en 12 étapes (voir `comptable/references/cloture-workflow.md`) :

1. **Collecte** : `npm run fetch` (Qonto + Stripe) ou import manuel
2. **Catégorisation** : Mapper chaque dépense à un compte PCG
3. **Rapprochement bancaire** : Vérifier solde comptable = solde réel
4. **Amortissements** : Calculer les dotations (linéaire, prorata)
5. **PCA** : Calculer les produits constatés d'avance (abonnements annuels SaaS)
6. **Provisions** : Constater les risques et dépréciation
7. **IS** : Calculer l'impôt sur les sociétés (15% PME / 25%)
8. **Journal** : Consolider dans `data/journal-entries.json`
9. **États financiers** : `node scripts/generate-statements.js`
10. **FEC** : `node scripts/generate-fec.js`
11. **Liasse fiscale** : Remplir les templates 2065 + 2033
12. **PDFs** : `node scripts/generate-pdfs.js`

### Phase 3 : Audit (skill `commissaire-aux-comptes`)

```
> Audite mes comptes annuels avant approbation.
```

Le skill CAC valide la clôture en 7 phases :
- Vérification du FEC (format, équilibre, numérotation)
- Contrôle du bilan et du compte de résultat
- Réconciliation balance / grand livre
- Validation de la liasse fiscale (2033-A = 2033-B = comptes)
- Contrôles croisés et opinion (sans réserve / avec réserve / refus)

### Phase 4 : Préparation au contrôle fiscal (skill `controleur-fiscal`)

```
> Simule un contrôle fiscal sur mon exercice 2025.
```

Le skill simule un inspecteur DGFIP sur 8 axes :
- Conformité FEC (art. L. 47 A-I LPF)
- Vérification IS (taux réduit, réintégrations)
- Déductibilité des charges (art. 39 CGI)
- Compte courant d'associé 455
- Exhaustivité des revenus
- TVA (franchise, seuils)
- Immobilisations et amortissements
- Opérations internationales

Chaque anomalie = un **chef de redressement** avec base légale, montants et risque (élevé/moyen/faible).

---

## Skills disponibles

| Skill | Rôle | Fonctionnalités |
|-------|------|-----------------|
| [`comptable`](#comptable--expert-comptable) | Expert-Comptable | Écritures, PCG, TVA, IS/IR, clôture complète, FEC, PDFs |
| [`controleur-fiscal`](#contrôleur-fiscal--préparation-au-contrôle-fiscal) | Contrôleur Fiscal | Simulation de contrôle DGFIP, analyse FEC, chefs de redressement |
| [`commissaire-aux-comptes`](#commissaire-aux-comptes--audit-des-comptes-annuels) | Commissaire aux Comptes | Audit NEP en 7 phases, validation bilan/CR/liasse, opinion |
| [`notaire`](#notaire--droit-immobilier-successions-donations-famille) | Notaire | Frais de notaire, vente immobilière, successions, donations, SCI, PACS, plus-value |

---

### `comptable` — Expert-Comptable

Copilote comptable et fiscal pour les entreprises françaises (SASU, EURL, SAS, SARL, EI).

**Fonctionnalités :**
- Écritures comptables avec les bons comptes PCG (800+ comptes)
- Déclarations TVA (CA3, CA12, régimes, intra-UE, autoliquidation)
- Calcul IS et IR (taux réduit PME, prorata exercice court)
- Clôture annuelle complète (12 étapes, voir workflow ci-dessus)
- Cut-off : PCA, CCA, CAP, PAR avec calcul prorata temporis
- Amortissements linéaires et dégressifs
- Génération FEC, états financiers, PDFs
- Templates liasse fiscale 2065+2033, PV, déclaration de confidentialité
- Rappel des échéances fiscales via le calendrier officiel impots.gouv.fr
- Recherche d'entreprise par SIREN via l'API Annuaire des Entreprises

Il ne signe pas la liasse fiscale. Pour ça, il vous faut encore un vrai expert-comptable.

---

### `controleur-fiscal` — Préparation au Contrôle Fiscal

Simule un contrôle fiscal tel que mené par un vérificateur de la DGFIP. L'objectif : **anticiper les risques de redressement avant que le vrai contrôleur ne les trouve**.

**Fonctionnalités :**
- Simulation complète sur 8 axes de vérification (FEC, IS, charges, CCA 455, revenus, TVA, immobilisations, international)
- Analyse du FEC : conformité format, équilibre, numérotation séquentielle, cohérence PCG
- Vérification de la déductibilité de chaque catégorie de charges (art. 39 CGI)
- Contrôle du compte courant d'associé 455 (charges pré-constitution, bureau domicile, taux conversion)
- Rédaction de chefs de redressement avec montants, pénalités et base légale
- Évaluation du risque par poste (élevé / moyen / faible)
- Synthèse récapitulative avec total des droits rappelés

---

### `commissaire-aux-comptes` — Audit des Comptes Annuels

Reproduit la démarche d'un commissaire aux comptes (CAC) pour valider les comptes annuels selon les normes NEP de la CNCC.

**Fonctionnalités :**
- Audit complet en 7 phases (planification, FEC, bilan, compte de résultat, balance/grand livre, liasse fiscale, contrôles transversaux)
- Contrôle de conformité du FEC (18 colonnes, équilibre, numérotation)
- Vérification croisée bilan / compte de résultat / balance / liasse (2033-A à 2033-E, 2572-SD)
- Réconciliation bancaire et contrôle de coupure (cut-off)
- Calcul du seuil de signification (5% résultat courant ou 1-2% CA)
- Émission d'une opinion motivée (sans réserve, avec réserve, refus, impossibilité)

Utile avant l'approbation des comptes, même sans obligation légale de CAC.

---

### `notaire` — Droit immobilier, successions, donations, famille

Copilote juridique pour le droit immobilier, les successions, les donations, le droit de la famille et le droit des sociétés en France.

**Fonctionnalités :**
- Calcul complet des frais de notaire (DMTO, émoluments, CSI, débours)
- Préparation de compromis de vente et vérification des diagnostics obligatoires
- Calcul de la plus-value immobilière (abattements pour durée de détention, surtaxe, exonérations)
- Calcul des droits de succession (barème progressif, abattements, partage, conjoint survivant)
- Calcul des droits de donation (donation simple, donation-partage, démembrement, Pacte Dutreil)
- Évaluation usufruit/nue-propriété (barème art. 669 CGI)
- Rédaction de statuts de SCI (gestion, familiale, construction-vente)
- Contrats de mariage (tous régimes), conventions de PACS
- Testaments, donations entre époux (au dernier vivant)
- Vérification urbanisme (PLU, servitudes, droits de préemption)
- Conseil en optimisation patrimoniale et transmission

Ne remplace pas un notaire en exercice. Seul un officier public peut authentifier les actes.

---

## Intégrations (Qonto, Stripe)

Des connecteurs pour récupérer automatiquement les transactions bancaires et les opérations de paiement. Ils s'intègrent au workflow de clôture et au rapprochement bancaire.

### Qonto (banque en ligne)

Récupère les transactions de tous vos comptes Qonto.

```bash
# Configuration
export QONTO_ID="votre-organisation"       # Slug (dashboard > Settings > Integrations > API)
export QONTO_API_SECRET="votre-secret"      # Secret key
```

Activer dans `company.json` :
```json
"qonto": { "enabled": true }
```

```bash
npm run fetch:qonto
# ou avec filtrage par date :
node integrations/qonto/fetch.js --start 2025-01-01 --end 2025-12-31
```

### Stripe (paiements en ligne)

Récupère les charges, fees, payouts et refunds de vos comptes Stripe.

```bash
# Configuration (une variable par compte Stripe)
export STRIPE_SECRET="sk_live_..."
```

Configurer dans `company.json` :
```json
"stripe_accounts": [
  { "id": "main", "name": "Mon SaaS", "env_key": "STRIPE_SECRET" }
]
```

Si vous avez plusieurs produits avec des comptes Stripe séparés, ajoutez une entrée par compte avec un `env_key` différent.

Pour **Stripe Connect** (organisation avec sous-comptes), ajoutez le `stripe_account_id` :
```json
"stripe_accounts": [
  { "id": "client-a", "name": "Client A", "env_key": "STRIPE_PLATFORM_SECRET", "stripe_account_id": "acct_xxx" }
]
```

```bash
npm run fetch:stripe
# ou avec filtrage :
node integrations/stripe/fetch.js --start 2025-01-01 --end 2025-12-31 --account main
```

### Tout récupérer

```bash
npm run fetch    # Qonto + Stripe
```

Les transactions sont enregistrées dans `data/transactions/` au format JSON standard.

Les clés API ne sont jamais stockées dans le repo. Elles sont lues depuis les variables d'environnement. Le fichier `.env` est dans le `.gitignore`.

---

## Scripts

Des scripts Node.js pour automatiser la génération des documents comptables.

### Installation

```bash
cd paperasse
npm install
```

### Usage

```bash
# Prérequis : company.json rempli + data/journal-entries.json
cp company.example.json company.json  # Puis remplir vos infos

# Récupérer les transactions (si Qonto/Stripe configurés)
npm run fetch

# Générer les états financiers (Bilan, Compte de résultat, Balance)
node scripts/generate-statements.js

# Générer le FEC
node scripts/generate-fec.js

# Générer les PDFs professionnels
node scripts/generate-pdfs.js

# Ou tout d'un coup
npm run closing
```

### Format du journal

Les scripts lisent `data/journal-entries.json`, un tableau d'écritures au format :

```json
[
  {
    "num": 1,
    "date": "2025-03-06",
    "journal": "BQ",
    "ref": "QTO-001",
    "label": "Achat fournitures Amazon",
    "lines": [
      { "account": "606", "debit": 45.99, "credit": 0 },
      { "account": "5121", "debit": 0, "credit": 45.99 }
    ]
  }
]
```

Ce fichier est généré par le skill `comptable` lors de la clôture. Il peut aussi être exporté depuis un logiciel comptable.

---

## Templates

Des templates pré-remplis pour les documents réglementaires, dans le dossier `templates/` :

| Template | Document | Format |
|----------|----------|--------|
| `declaration-confidentialite.html` | Déclaration de confidentialité des comptes annuels | HTML → PDF |
| `2065-sd.html` | Formulaire 2065-SD (Déclaration IS) | HTML → PDF |
| `approbation-comptes.md` | Décision de l'associé unique ou PV d'AG | Markdown |
| `liasse-fiscale-2033.md` | Liasse fiscale 2033 (brouillon de travail) | Markdown |
| `depot-greffe-checklist.md` | Checklist complète du dépôt au greffe | Markdown |

Les templates HTML utilisent des placeholders (`{{company.name}}`, `{{company.siren}}`, etc.) remplis automatiquement depuis `company.json` par le script PDF.

---

## Installation

### Via [agentskill.sh](https://agentskill.sh) (recommandé)

```bash
# Installer le skill /learn (une seule fois)
npx agentskill init

# Puis dans votre agent :
/learn @paperasse/comptable
/learn @paperasse/controleur-fiscal
/learn @paperasse/commissaire-aux-comptes
/learn @paperasse/notaire
```

### Claude Code (CLI)

```bash
# Installer un skill spécifique
cp -r comptable ~/.claude/skills/

# Ou tous les skills d'un coup
for skill in comptable controleur-fiscal commissaire-aux-comptes notaire; do
  cp -r $skill ~/.claude/skills/
done
```

### Claude Cowork

Pour les agents qui travaillent dans [Claude Cowork](https://claude.com/product/cowork) :

1. **Cloner le repo dans le workspace de l'agent**
   ```bash
   cd /chemin/vers/workspace/agent
   git clone https://github.com/romainsimon/paperasse.git
   ```

2. **Ajouter au CLAUDE.md de l'agent**
   ```markdown
   ## Skills

   Cet agent a accès aux skills comptables dans `./paperasse/`.
   - Charger `comptable/SKILL.md` pour la comptabilité, TVA, IS, clôture.
   - Charger `controleur-fiscal/SKILL.md` pour simuler un contrôle fiscal.
   - Charger `commissaire-aux-comptes/SKILL.md` pour auditer les comptes annuels.
   - Charger `notaire/SKILL.md` pour le droit immobilier, successions, donations, famille.
   ```

### Codex (OpenAI)

Codex peut lire des fichiers dans son environnement. Ajoutez les skills au repo et référencez-les dans les instructions :

```bash
# Ajouter les skills au projet
cp -r comptable controleur-fiscal commissaire-aux-comptes notaire ./

# Dans les instructions de l'agent :
# "Charger comptable/SKILL.md pour la comptabilité"
```

### Autres Agents (Cursor, Windsurf, Cline, etc.)

Ces skills sont du Markdown. Ils marchent partout où un LLM peut lire des fichiers :

| Outil | Installation |
|-------|--------------|
| **Cursor** | Copier dans `.cursor/skills/` ou référencer dans les rules |
| **Windsurf** | Ajouter au context ou copier dans le projet |
| **Cline** | Référencer dans les custom instructions |
| **Continue** | Ajouter comme context provider |
| **Aider** | Inclure avec `--read` ou dans `.aider.conf.yml` |

**Méthode universelle :**
```bash
# Dans n'importe quel projet
mkdir -p .ai/skills
cp -r comptable controleur-fiscal commissaire-aux-comptes notaire .ai/skills/

# Puis dans vos instructions système / CLAUDE.md / rules :
# "Charger comptable/SKILL.md pour la comptabilité"
# "Charger controleur-fiscal/SKILL.md pour un contrôle fiscal"
# "Charger commissaire-aux-comptes/SKILL.md pour un audit"
# "Charger notaire/SKILL.md pour le droit immobilier, successions, donations"
```

---

## Utilisation

Lancez votre agent et posez vos questions en français :

```
> Comment je comptabilise un achat chez AWS ?

> C'est quoi le taux de TVA sur les formations en ligne ?

> Fais la clôture annuelle de ma société pour l'exercice 2025.

> Génère le FEC et les PDFs pour le dépôt au greffe.

> Simule un contrôle fiscal sur mes comptes 2025.

> Audite mes comptes annuels avant approbation.

> Mon compte courant 455 est à 15 000 EUR, c'est risqué ?

> Prépare la liasse fiscale 2065 + 2033 pour mon exercice.

> Calcule les frais de notaire pour un appartement à 350 000 EUR à Paris.

> Ma mère est décédée, nous sommes 3 enfants. Calcule les droits de succession.

> Je veux donner un appartement à mes enfants en gardant l'usufruit. Combien ça coûte ?

> Rédige les statuts d'une SCI familiale pour gérer un immeuble locatif.

> Quels diagnostics sont obligatoires pour vendre ma maison de 1985 ?
```

Les skills commencent par vérifier les informations sur votre entreprise (via `company.json` ou en posant des questions). Ils ne procèdent jamais sans contexte validé.

---

## Garde-fous

### Vérification du contexte entreprise

Chaque skill vérifie en premier lieu qu'il dispose des informations minimales sur l'entreprise :
- Raison sociale, SIREN, forme juridique
- Régime TVA et régime d'imposition
- Dates de l'exercice

Si un fichier `company.json` existe, il est lu automatiquement. Sinon, le skill demande les informations avant de procéder. Les documents générés s'adaptent à la forme juridique (président ou gérant, associé unique ou AG, etc.).

### Vérification des échéances

À chaque conversation, le skill comptable consulte le calendrier fiscal officiel et affiche les prochaines échéances :

```
PROCHAINES ÉCHÉANCES
━━━━━━━━━━━━━━━━━━━━━━
 15/03 - Acompte IS n°1 (dans 5 jours)
 25/03 - TVA février CA3 (dans 15 jours)
```

### Fraîcheur des données

Chaque skill a une date `last_updated` dans son frontmatter. Si le skill a plus de 6 mois, l'agent affiche un avertissement et va vérifier les chiffres en ligne (seuils TVA, taux IS/IR, plafonds micro-entreprise, cotisations sociales) avant de répondre.

Le législateur français change les règles plus souvent que vous changez de mot de passe. Contrairement à votre mot de passe, ça peut coûter cher.

### Données open source (`data/`)

Le repo embarque des jeux de données open source issus de [data.gouv.fr](https://www.data.gouv.fr) :

| Fichier | Contenu | Source |
|---------|---------|--------|
| `data/pcg_YYYY.json` | Plan Comptable Général complet (800+ comptes et libellés) | [Arrhes/PCG](https://github.com/arrhes/PCG) via [data.gouv.fr](https://www.data.gouv.fr/datasets/plan-comptable-general/) |
| `data/nomenclature-liasse-fiscale.csv` | Clés/libellés des cases de la liasse fiscale (2033, 2050) | [data.gouv.fr](https://www.data.gouv.fr/datasets/nomenclature-fiscale-du-compte-de-resultat/) |

Les skills utilisent aussi des APIs publiques sans stocker de données localement :

| API | Contenu | Source |
|-----|---------|--------|
| BOFiP Impôts | Doctrine fiscale officielle (publications en vigueur) | [data.gouv.fr](https://www.data.gouv.fr/datasets/bofip-impots-publications-en-vigueur/) |
| Base Sirene | Annuaire des entreprises (SIREN, forme juridique, activité) | [data.gouv.fr](https://www.data.gouv.fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/) |

Toutes les sources et leurs dates de dernière récupération sont décrites dans `data/sources.json`.

**Vérifier la fraîcheur et mettre à jour :**

```bash
python3 scripts/update_data.py --check   # Vérifier sans rien télécharger
python3 scripts/update_data.py           # Vérifier et mettre à jour
python3 scripts/update_data.py --force   # Forcer le re-téléchargement
```

---

## Roadmap

| Composant | Description | Statut |
|-----------|-------------|--------|
| `comptable` | Expert-comptable + clôture complète | Fait |
| `controleur-fiscal` | Contrôle fiscal DGFIP | Fait |
| `commissaire-aux-comptes` | Commissaire aux comptes | Fait |
| `notaire` | Notaire | Fait |
| `integrations/qonto` | Connecteur Qonto (transactions bancaires) | Fait |
| `integrations/stripe` | Connecteur Stripe (charges, payouts, fees) | Fait |
| `avocat` | Avocat d'affaires | Prévu |
| `drh` | DRH / Ressources humaines | Prévu |

---

## Avertissement légal

*Ce projet est fourni "tel quel", sans garantie d'aucune sorte.*

**Ces skills ne remplacent pas un expert-comptable inscrit à l'Ordre, un commissaire aux comptes certifié, ou un notaire en exercice.** Ils sont conçus comme outils d'aide à la décision et de préparation.

Pour les situations complexes (litiges, montages fiscaux, contrôles en cours), consultez un professionnel avec une assurance RC Pro et un numéro SIRET.

---

## Contribuer

Vous avez un métier de la paperasse que vous aimeriez voir automatisé ?

1. Fork le repo
2. Ajoutez votre skill dans un dossier au nom du métier en français
3. Incluez un `SKILL.md` avec frontmatter (name, description, last_updated)
4. Ajoutez des `references/` pour les textes de loi et barèmes
5. Faites une PR

### Convention de nommage

Noms de dossiers en français, en minuscules, avec tirets :
- `comptable` (expert-comptable)
- `controleur-fiscal` (contrôleur fiscal / simulation DGFIP)
- `commissaire-aux-comptes` (commissaire aux comptes)
- `avocat` (avocat d'affaires)
- `drh` (DRH / ressources humaines)
- etc.

---

## Licence

MIT

---

## Remerciements

- **L'administration française** — Pour avoir créé un système si complexe qu'il nécessite une IA pour le comprendre
- **Le Plan Comptable Général** — 800 comptes, vraiment ?
- **Le Code Général des Impôts** — 2 000 articles, et ils en rajoutent chaque année
- **La CNCC** — Pour les NEP, ces documents que personne ne lit mais que tout le monde cite
- **data.gouv.fr** — Pour les données ouvertes qui alimentent les skills

---

<p align="center">
  <i>La paperasse, c'est comme le cholestérol : y'en a du bon et du mauvais, mais surtout y'en a trop.</i>
  <br>
  — Personne de célèbre, jamais
</p>

---

<p align="center">
  Fait avec des 🥐 et beaucoup de ☕ quelque part en France
</p>
