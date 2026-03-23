# 📎 Paperasse

**Des skills Claude pour automatiser la bureaucratie française.**

*Parce que quelqu'un devait le faire, et ce quelqu'un n'a pas besoin de pause café.*

---

## 🤖 C'est quoi ce bordel ?

Paperasse est une collection de skills pour [Claude Code](https://claude.ai/claude-code) qui transforment votre IA préférée en armée de cols blancs infatigables.

Vous savez, ces métiers où on passe 80% du temps à chercher le bon formulaire CERFA et 20% à se demander si on a bien coché la case 7DB ?

**On a automatisé ça.**

---

## 📦 Skills Disponibles

| Skill | Rôle | Ce qu'il fait |
|-------|------|---------------|
| [`comptable`](#-comptable--expert-comptable-ia) | Expert-Comptable | Écritures, PCG, TVA, IS/IR, clôture, échéances fiscales |
| [`controleur-fiscal`](#-controleur-fiscal--contrôle-fiscal-ia) | Inspecteur des Finances Publiques | Simulation de contrôle fiscal DGFIP, chefs de redressement, FEC |
| [`commissaire-aux-comptes`](#-commissaire-aux-comptes--commissaire-aux-comptes-ia) | Commissaire aux Comptes | Audit NEP, validation bilan/CR/liasse, opinion sur les comptes |

---

### 🧮 `comptable` — Expert-Comptable IA

**Remplace :** L'expert-comptable qui vous facture 150€ pour vous expliquer que non, votre abonnement Netflix n'est pas déductible.

**Fait :**
- Écritures comptables (débits à gauche, crédits à droite, comme papa nous l'a appris)
- Classification PCG (parce que retenir 800 numéros de compte c'est pour les faibles)
- Déclarations TVA (CA3, CA12, et autres formulaires aux noms sexy)
- Calcul IS/IR (spoiler: l'État gagne toujours)
- Clôture annuelle (amortissements, provisions, et autres joyeusetés)
- Gestion des échéances (pour ne plus recevoir de lettres recommandées)

**Ne fait pas :**
- Les apéros du vendredi
- Signer la liasse fiscale (il vous faut encore un vrai expert-comptable pour ça, désolé)
- Vous consoler quand vous voyez le montant de vos charges sociales

---

### 🔍 `controleur-fiscal` — Contrôle Fiscal IA

**Remplace :** L'angoisse de recevoir un avis de vérification sans avoir la moindre idée de ce qui va se passer.

**Fait :**
- Simulation complète d'un contrôle fiscal DGFIP (8 axes de vérification)
- Analyse du FEC (conformité, équilibre, numérotation)
- Vérification de la déductibilité de chaque catégorie de charges
- Contrôle du compte courant d'associé 455 (la zone de tous les dangers)
- Rédaction de chefs de redressement avec montants et pénalités
- Évaluation du risque par poste (élevé / moyen / faible)

**Ne fait pas :**
- Débarquer chez vous un mardi matin à 8h avec un avis de vérification
- Vous regarder avec un air suspicieux pendant que vous cherchez vos factures
- Trouver que c'est normal de payer 40% de majoration

---

### 🏛️ `commissaire-aux-comptes` — Commissaire aux Comptes IA

**Remplace :** L'audit à 5 000€ qui vous dit que vos comptes sont "globalement corrects, sous réserve de quelques observations mineures".

**Fait :**
- Audit complet en 7 phases selon les normes NEP (CNCC)
- Contrôle du FEC, bilan, compte de résultat, balance, grand livre
- Vérification de la liasse fiscale (2033-A à 2033-E, 2572-SD)
- Réconciliation bancaire et contrôle de coupure
- Calcul du seuil de signification et matérialité
- Émission d'une opinion (sans réserve, avec réserve, refus)

**Ne fait pas :**
- Facturer au temps passé plus cher qu'un avocat
- Vous envoyer une "lettre de recommandations" de 47 pages
- Tourner autour du pot pendant 3 mois avant de vous donner son avis

---

## 🪦 Métiers Menacés

| Métier | Niveau de Menace | Commentaire |
|--------|------------------|-------------|
| Expert-comptable junior | ☠️☠️☠️☠️☠️ | RIP. Apprends à coder. |
| Aide-comptable | ☠️☠️☠️☠️☠️ | F in the chat |
| Auditeur junior | ☠️☠️☠️☠️ | Les checklists c'est le premier truc qu'on automatise |
| Expert-comptable senior | ☠️☠️☠️ | Encore utile pour signer et rassurer mémé |
| Commissaire aux comptes | ☠️☠️ | Le tampon officiel reste humain (pour l'instant) |
| Contrôleur fiscal | ☠️ | Malheureusement toujours là |
| Stagiaire qui fait les photocopies | ☠️☠️☠️☠️ | Personne ne faisait de photocopies de toute façon |

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

# C'est tout. Oui, vraiment.
# Pas de npm install avec 847 dépendances.
# Pas de Docker.
# Pas de Kubernetes.
# Juste des fichiers markdown.
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

Ces skills sont juste du Markdown. Ils marchent partout où un LLM peut lire des fichiers :

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

Lancez Claude Code et posez vos questions en français (ou en anglais si vous êtes un traître) :

```
> Comment je comptabilise un achat chez AWS ?

> C'est quoi le taux de TVA sur les formations en ligne ?

> J'ai oublié de payer ma CFE, je vais en prison ?

> Simule un contrôle fiscal sur mes comptes 2025

> Audite mes comptes annuels avant l'AG d'approbation

> Mon compte courant 455 est à 15 000€, c'est risqué ?
```

Les skills vont d'abord chercher votre entreprise sur l'annuaire des entreprises (oui, ils font leurs devoirs) puis vous répondre avec :
- Les faits (ce qu'on sait)
- Les hypothèses (ce qu'on suppose)
- L'analyse (ce qu'il faut faire)
- Les risques (ce qui peut merder)
- Les actions (votre todo list)

---

## 🗓️ Fonctionnalités Anti-Conneries

### Vérification des échéances

À chaque conversation, l'agent consulte le **vrai** calendrier fiscal :

```
https://www.impots.gouv.fr/professionnel/calendrier-fiscal
```

Et vous balance un rappel si vous êtes sur le point de rater une deadline :

```
⏰ PROCHAINES ÉCHÉANCES
━━━━━━━━━━━━━━━━━━━━━━
🔴 15/03 - Acompte IS n°1 (dans 5 jours)
🟡 25/03 - TVA février CA3 (dans 15 jours)
```

Parce que recevoir une majoration de 10% pour retard, c'est con.

### Fraîcheur des données (`last_updated`)

Chaque skill a une date de dernière mise à jour dans son frontmatter :

```yaml
metadata:
  last_updated: 2026-03-23
```

**Si le skill a plus de 6 mois**, l'agent affiche :

```
⚠️ SKILL POTENTIELLEMENT OBSOLÈTE
Dernière MAJ: 2026-03-23 — Vérification requise
```

Et il va **vérifier en ligne** avant de vous balancer un chiffre :
- Seuils TVA
- Taux IS/IR
- Plafonds micro-entreprise
- Cotisations sociales
- etc.

Parce que le législateur français change les règles plus souvent que vous changez de mot de passe. Et contrairement à votre mot de passe, là ça peut vraiment vous coûter cher.

### Données open source (`data/`)

Le repo embarque des jeux de données open source pour que les skills ne travaillent pas à l'aveugle :

| Fichier | Contenu | Source |
|---------|---------|--------|
| `data/pcg_YYYY.json` | Plan Comptable Général complet (comptes et libellés) | [Arrhes/PCG](https://github.com/arrhes/PCG) via data.gouv.fr |
| `data/nomenclature-liasse-fiscale.csv` | Clés/libellés des cases de la liasse fiscale | [data.gouv.fr](https://www.data.gouv.fr/datasets/nomenclature-fiscale-du-compte-de-resultat/) |

Les skills utilisent aussi des APIs publiques (BOFiP, Sirene) sans stocker de données localement. Tout est décrit dans `data/sources.json`.

**Vérifier la fraîcheur et mettre à jour :**

```bash
# Vérifier sans rien télécharger
python3 scripts/update_data.py --check

# Vérifier et mettre à jour si nécessaire
python3 scripts/update_data.py

# Forcer le re-téléchargement de tout
python3 scripts/update_data.py --force
```

Le script vérifie :
1. Les dates `last_updated` de chaque SKILL.md (alerte si > 6 mois)
2. Les dates `last_fetched` de chaque source de données (alerte si obsolète)
3. La disponibilité des sources distantes (APIs, repos GitHub)

---

## 🗺️ Roadmap

Skills à venir pour compléter l'armée bureaucratique :

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

**Ces skills ne remplacent pas un vrai expert-comptable inscrit à l'Ordre, ni un commissaire aux comptes certifié.**

Si vous utilisez ces outils pour faire votre comptabilité et que le fisc débarque, ne venez pas pleurer. On vous avait prévenus. En tout petit. Dans un README. Que vous n'avez probablement pas lu.

Pour les trucs sérieux (litiges, contrôles fiscaux, montages à la con), consultez un vrai professionnel qui a une assurance responsabilité civile professionnelle et un numéro SIRET.

---

## 🤝 Contribuer

Vous avez un métier de la paperasse que vous aimeriez voir automatisé ?

1. Fork le repo
2. Ajoutez votre skill dans un dossier au nom du métier en français
3. Incluez un `SKILL.md` avec frontmatter (name, description, last_updated)
4. Ajoutez des `references/` pour les textes de loi et barèmes
5. Faites une PR
6. Attendez qu'on review (ou pas, on est occupés à automatiser nos propres jobs)

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

MIT — Faites-en ce que vous voulez. Même vendre des formations à 2000€ "Comment utiliser l'IA pour la comptabilité". On ne jugera pas. Enfin si, un peu.

---

## 🙏 Remerciements

- **L'administration française** — Pour avoir créé un système si complexe qu'il nécessite une IA pour le comprendre
- **Le Plan Comptable Général** — 800 comptes, vraiment ?
- **Les formulaires CERFA** — Une source inépuisable d'inspiration
- **Le Code Général des Impôts** — 2 000 articles, et ils en rajoutent chaque année
- **La CNCC** — Pour les NEP, ces documents que personne ne lit mais que tout le monde cite
- **Claude** — Pour faire le travail pendant qu'on scroll sur Twitter

---

<p align="center">
  <i>« La paperasse, c'est comme le cholestérol : y'en a du bon et du mauvais, mais surtout y'en a trop. »</i>
  <br>
  — Personne de célèbre, jamais
</p>

---

**Made with 🥐 and existential dread in France**
