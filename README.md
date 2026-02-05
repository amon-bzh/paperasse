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

### 🧮 `french-accountant` — Expert-Comptable IA

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

## 🪦 Métiers Menacés

| Métier | Niveau de Menace | Commentaire |
|--------|------------------|-------------|
| Expert-comptable junior | ☠️☠️☠️☠️☠️ | RIP. Apprends à coder. |
| Aide-comptable | ☠️☠️☠️☠️☠️ | F in the chat |
| Expert-comptable senior | ☠️☠️☠️ | Encore utile pour signer et rassurer mémé |
| Contrôleur fiscal | ☠️ | Malheureusement toujours là |
| Stagiaire qui fait les photocopies | ☠️☠️☠️☠️ | Personne ne faisait de photocopies de toute façon |

---

## 🚀 Installation

### Claude Code (CLI)

```bash
# Copier le skill dans votre dossier Claude
cp -r french-accountant ~/.claude/skills/

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
   git clone https://github.com/votre-username/paperasse.git
   ```

2. **Ajouter au CLAUDE.md de l'agent**
   ```markdown
   ## Skills

   This agent has access to accounting skills in `./paperasse/french-accountant/`.
   Load SKILL.md when handling French accounting, tax, or bookkeeping questions.
   ```

3. **Ou copier directement dans le projet**
   ```bash
   cp -r paperasse/french-accountant ./skills/
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
cp -r french-accountant .ai/skills/

# Puis dans vos instructions système / CLAUDE.md / rules :
# "Pour les questions comptables, consulter .ai/skills/french-accountant/SKILL.md"
```

### Installation via le .skill package

Le fichier `.skill` est juste un zip renommé :

```bash
# Extraire le package
unzip french-accountant.skill -d ~/.claude/skills/

# Ou pour les paranoïaques qui veulent voir ce qu'il y a dedans
unzip -l french-accountant.skill
```

---

## 🎯 Utilisation

Lancez Claude Code et posez vos questions en français (ou en anglais si vous êtes un traître) :

```
> Comment je comptabilise un achat chez AWS ?

> C'est quoi le taux de TVA sur les formations en ligne ?

> J'ai oublié de payer ma CFE, je vais en prison ?
```

Le skill va d'abord chercher votre entreprise sur l'annuaire des entreprises (oui, il fait ses devoirs) puis vous répondre avec :
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
last_updated: 2026-02-05
```

**Si le skill a plus de 6 mois**, l'agent affiche :

```
⚠️ SKILL POTENTIELLEMENT OBSOLÈTE
Dernière MAJ: 2026-02-05 — Vérification requise
```

Et il va **vérifier en ligne** avant de vous balancer un chiffre :
- Seuils TVA
- Taux IS/IR
- Plafonds micro-entreprise
- Cotisations sociales
- etc.

Parce que le législateur français change les règles plus souvent que vous changez de mot de passe. Et contrairement à votre mot de passe, là ça peut vraiment vous coûter cher.

---

## 🗺️ Roadmap

Skills à venir pour compléter l'armée bureaucratique :

| Skill | Description | Statut |
|-------|-------------|--------|
| `french-accountant` | Expert-comptable | ✅ Done |
| `french-lawyer` | Avocat d'affaires | 🔜 Bientôt |
| `french-hr` | DRH | 🔜 Bientôt |
| `french-notary` | Notaire | 🤔 Un jour |
| `french-tax-inspector` | Contrôleur fiscal | ❌ Jamais (on n'aide pas l'ennemi) |

---

## ⚠️ Avertissement Légal

*Ce projet est fourni "tel quel", sans garantie d'aucune sorte.*

**Ce skill ne remplace pas un vrai expert-comptable inscrit à l'Ordre.**

Si vous utilisez ces outils pour faire votre comptabilité et que le fisc débarque, ne venez pas pleurer. On vous avait prévenus. En tout petit. Dans un README. Que vous n'avez probablement pas lu.

Pour les trucs sérieux (litiges, contrôles fiscaux, montages à la con), consultez un vrai professionnel qui a une assurance responsabilité civile professionnelle et un numéro SIRET.

---

## 🤝 Contribuer

Vous avez un métier de la paperasse que vous aimeriez voir automatisé ?

1. Fork le repo
2. Ajoutez votre skill
3. Faites une PR
4. Attendez qu'on review (ou pas, on est occupés à automatiser nos propres jobs)

---

## 📜 Licence

MIT — Faites-en ce que vous voulez. Même vendre des formations à 2000€ "Comment utiliser l'IA pour la comptabilité". On ne jugera pas. Enfin si, un peu.

---

## 🙏 Remerciements

- **L'administration française** — Pour avoir créé un système si complexe qu'il nécessite une IA pour le comprendre
- **Le Plan Comptable Général** — 800 comptes, vraiment ?
- **Les formulaires CERFA** — Une source inépuisable d'inspiration
- **Claude** — Pour faire le travail pendant qu'on scroll sur Twitter

---

<p align="center">
  <i>« La paperasse, c'est comme le cholestérol : y'en a du bon et du mauvais, mais surtout y'en a trop. »</i>
  <br>
  — Personne de célèbre, jamais
</p>

---

**Made with 🥐 and existential dread in France**
