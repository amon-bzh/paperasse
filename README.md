# 📎 Paperasse

**Des skills Claude pour automatiser la bureaucratie française.**

*Parce que quelqu'un devait le faire, et ce quelqu'un n'a pas besoin de pause café.*

---

## 🤖 Qu'est-ce que c'est ?

Paperasse est une collection de skills pour [Claude Code](https://claude.ai/claude-code) spécialisés dans la comptabilité, la fiscalité et l'audit des entreprises françaises.

Chaque skill transforme Claude en copilote expert d'un métier de la paperasse : il connaît les textes (CGI, BOFiP, NEP), les formulaires, les échéances, et surtout il ne se trompe pas de case dans la liasse fiscale.

Les skills fonctionnent aussi avec Cursor, Windsurf, Cline, Aider, et tout outil capable de lire du Markdown.

---

## 📦 Skills Disponibles

| Skill | Rôle | Fonctionnalités |
|-------|------|-----------------|
| [`comptable`](#-comptable--expert-comptable) | Expert-Comptable | Écritures, PCG, TVA, IS/IR, clôture, échéances fiscales |
| [`controleur-fiscal`](#-controleur-fiscal--préparation-au-contrôle-fiscal) | Contrôleur Fiscal | Simulation de contrôle DGFIP, analyse FEC, chefs de redressement |
| [`commissaire-aux-comptes`](#%EF%B8%8F-commissaire-aux-comptes--audit-des-comptes-annuels) | Commissaire aux Comptes | Audit NEP en 7 phases, validation bilan/CR/liasse, opinion |

---

### 🧮 `comptable` — Expert-Comptable

Copilote comptable et fiscal pour les entreprises françaises (SASU, EURL, SAS, SARL, EI).

**Fonctionnalités :**
- Écritures comptables avec les bons comptes PCG
- Classification automatique dans le Plan Comptable Général (800+ comptes)
- Déclarations TVA (CA3, CA12, régimes, intra-UE, autoliquidation)
- Calcul IS et IR (taux réduit PME, prorata exercice court)
- Clôture annuelle (amortissements, provisions, CCA, cut-offs)
- Rappel des échéances fiscales via le calendrier officiel impots.gouv.fr
- Recherche d'entreprise par SIREN via l'API Annuaire des Entreprises

Il ne signe pas la liasse fiscale. Pour ça, il vous faut encore un vrai expert-comptable.

---

### 🔍 `controleur-fiscal` — Préparation au Contrôle Fiscal

Simule un contrôle fiscal tel que mené par un vérificateur de la DGFIP. L'objectif : **anticiper les risques de redressement avant que le vrai contrôleur ne les trouve**.

**Fonctionnalités :**
- Simulation complète sur 8 axes de vérification (FEC, IS, charges, CCA 455, revenus, TVA, immobilisations, international)
- Analyse du FEC : conformité format, équilibre, numérotation séquentielle, cohérence PCG
- Vérification de la déductibilité de chaque catégorie de charges (art. 39 CGI)
- Contrôle du compte courant d'associé 455 (charges pré-constitution, bureau domicile, taux conversion)
- Rédaction de chefs de redressement avec montants, pénalités et base légale
- Évaluation du risque par poste (élevé / moyen / faible)
- Synthèse récapitulative avec total des droits rappelés

Conçu pour les dirigeants et comptables qui veulent dormir tranquilles avant un contrôle. Et si un vrai inspecteur des finances publiques veut l'utiliser pour préparer ses vérifications, on est flattés. On espère juste que ce n'est pas les nôtres.

---

### 🏛️ `commissaire-aux-comptes` — Audit des Comptes Annuels

Reproduit la démarche d'un commissaire aux comptes (CAC) pour valider les comptes annuels selon les normes NEP de la CNCC.

**Fonctionnalités :**
- Audit complet en 7 phases (planification, FEC, bilan, compte de résultat, balance/grand livre, liasse fiscale, contrôles transversaux)
- Contrôle de conformité du FEC (18 colonnes, équilibre, numérotation)
- Vérification croisée bilan / compte de résultat / balance / liasse (2033-A à 2033-E, 2572-SD)
- Réconciliation bancaire et contrôle de coupure (cut-off)
- Calcul du seuil de signification (5% résultat courant ou 1-2% CA)
- Émission d'une opinion motivée (sans réserve, avec réserve, refus, impossibilité)

Utile avant l'AG d'approbation des comptes, même sans obligation légale de CAC.

---

## 🚀 Installation

### Claude Code (CLI)

```bash
# Installer un skill spécifique
cp -r comptable ~/.claude/skills/

# Ou tous les skills d'un coup
for skill in comptable controleur-fiscal commissaire-aux-comptes; do
  cp -r $skill ~/.claude/skills/
done

# C'est tout. Pas de dépendances. Juste des fichiers Markdown.
```

### Claude Cowork

Pour les agents qui bossent dans [Claude Cowork](https://cowork.anthropic.com) :

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
   ```

3. **Ou copier directement dans le projet**
   ```bash
   cp -r paperasse/comptable ./skills/
   cp -r paperasse/controleur-fiscal ./skills/
   cp -r paperasse/commissaire-aux-comptes ./skills/
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
cp -r comptable controleur-fiscal commissaire-aux-comptes .ai/skills/

# Puis dans vos instructions système / CLAUDE.md / rules :
# "Charger comptable/SKILL.md pour la comptabilité"
# "Charger controleur-fiscal/SKILL.md pour un contrôle fiscal"
# "Charger commissaire-aux-comptes/SKILL.md pour un audit"
```

---

## 🎯 Utilisation

Lancez Claude Code et posez vos questions en français :

```
> Comment je comptabilise un achat chez AWS ?

> C'est quoi le taux de TVA sur les formations en ligne ?

> Simule un contrôle fiscal sur mes comptes 2025

> Audite mes comptes annuels avant l'AG d'approbation

> Mon compte courant 455 est à 15 000€, c'est risqué ?
```

Les skills commencent par chercher votre entreprise sur l'annuaire des entreprises (SIREN, forme juridique, régime), puis structurent leur réponse :
- **Faits** : ce qui est certain et documenté
- **Hypothèses** : ce qui est supposé, à confirmer
- **Analyse** : traitement comptable et fiscal
- **Risques** : points d'attention
- **Actions** : tâches concrètes

---

## 🛡️ Garde-fous

### Vérification des échéances

À chaque conversation, le skill comptable consulte le calendrier fiscal officiel et affiche les prochaines échéances :

```
⏰ PROCHAINES ÉCHÉANCES
━━━━━━━━━━━━━━━━━━━━━━
🔴 15/03 - Acompte IS n°1 (dans 5 jours)
🟡 25/03 - TVA février CA3 (dans 15 jours)
```

### Fraîcheur des données

Chaque skill a une date `last_updated` dans son frontmatter. Si le skill a plus de 6 mois, l'agent affiche un avertissement et va vérifier les chiffres en ligne (seuils TVA, taux IS/IR, plafonds micro-entreprise, cotisations sociales) avant de répondre.

Le législateur français change les règles plus souvent que vous changez de mot de passe. Contrairement à votre mot de passe, ça peut coûter cher.

### Données open source (`data/`)

Le repo embarque des jeux de données open source :

| Fichier | Contenu | Source |
|---------|---------|--------|
| `data/pcg_YYYY.json` | Plan Comptable Général complet (800+ comptes et libellés) | [Arrhes/PCG](https://github.com/arrhes/PCG) via data.gouv.fr |
| `data/nomenclature-liasse-fiscale.csv` | Clés/libellés des cases de la liasse fiscale | [data.gouv.fr](https://www.data.gouv.fr/datasets/nomenclature-fiscale-du-compte-de-resultat/) |

Les skills utilisent aussi des APIs publiques (BOFiP, Sirene) sans stocker de données localement. Tout est décrit dans `data/sources.json`.

**Vérifier la fraîcheur et mettre à jour :**

```bash
python3 scripts/update_data.py --check   # Vérifier sans rien télécharger
python3 scripts/update_data.py           # Vérifier et mettre à jour
python3 scripts/update_data.py --force   # Forcer le re-téléchargement
```

Le script vérifie :
1. Les dates `last_updated` de chaque SKILL.md (alerte si > 6 mois)
2. Les dates `last_fetched` de chaque source de données (alerte si obsolète)
3. La disponibilité des sources distantes (APIs, repos GitHub)

---

## 🗺️ Roadmap

| Skill | Description | Statut |
|-------|-------------|--------|
| `comptable` | Expert-comptable | ✅ Done |
| `controleur-fiscal` | Contrôle fiscal DGFIP | ✅ Done |
| `commissaire-aux-comptes` | Commissaire aux comptes | ✅ Done |
| `avocat` | Avocat d'affaires | 🔜 Bientôt |
| `drh` | DRH / Ressources humaines | 🔜 Bientôt |
| `notaire` | Notaire | 🤔 Un jour |

---

## ⚠️ Avertissement Légal

*Ce projet est fourni "tel quel", sans garantie d'aucune sorte.*

**Ces skills ne remplacent pas un expert-comptable inscrit à l'Ordre, ni un commissaire aux comptes certifié.** Ils sont conçus comme outils d'aide à la décision et de préparation.

Pour les situations complexes (litiges, montages fiscaux, contrôles en cours), consultez un professionnel avec une assurance RC Pro et un numéro SIRET.

---

## 🤝 Contribuer

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

## 📜 Licence

MIT

---

## 🙏 Remerciements

- **L'administration française** — Pour avoir créé un système si complexe qu'il nécessite une IA pour le comprendre
- **Le Plan Comptable Général** — 800 comptes, vraiment ?
- **Le Code Général des Impôts** — 2 000 articles, et ils en rajoutent chaque année
- **La CNCC** — Pour les NEP, ces documents que personne ne lit mais que tout le monde cite
- **data.gouv.fr** — Pour les données ouvertes qui alimentent les skills

---

<p align="center">
  <i>« La paperasse, c'est comme le cholestérol : y'en a du bon et du mauvais, mais surtout y'en a trop. »</i>
  <br>
  — Personne de célèbre, jamais
</p>

---

**Made with 🥐 in France**
