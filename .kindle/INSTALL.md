# INSTALL.md — Installation & Setup

## Prérequis

### 1. Pandoc

Pandoc est le seul prérequis obligatoire.

**macOS (M1 & Intel)**
```bash
brew install pandoc
```

**Vérification**
```bash
pandoc --version
# pandoc 3.x.x
```

---

### 2. Python 3 _(déjà présent sur macOS)_

Utilisé uniquement pour lire les fichiers YAML de config.
```bash
python3 --version
```

---

### 3. PDF (optionnel)

Uniquement si tu veux utiliser `--pdf` :
```bash
brew install --cask mactex-no-gui   # ~500 Mo, moteur lualatex
```

---

### 4. Envoi Kindle par email (optionnel)

Si tu veux utiliser `--send`, installe `msmtp` :
```bash
brew install msmtp
```

Configure `~/.msmtprc` avec ton compte SMTP (Gmail, etc.) :
```ini
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/cert.pem
logfile        ~/.msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           ton-adresse@gmail.com
user           ton-adresse@gmail.com
password       ton-mot-de-passe-application

account default : gmail
```

> **Note Gmail** : utilise un [mot de passe d'application](https://myaccount.google.com/apppasswords),
> pas ton mot de passe principal. Active la validation en deux étapes d'abord.

Puis ajoute l'adresse Gmail dans les appareils approuvés de ton compte Amazon :
> Compte Amazon → Contenu et appareils → Paramètres → Documents personnels

---

## Installation dans un dépôt

### Copie du kit

```bash
# Depuis la racine de ton dépôt cible
cp -r /chemin/vers/kindle-kit/.kindle .
```

Ou clone ce repo et copie le dossier `.kindle/` :
```bash
git clone https://github.com/toi/kindle-kit.git
cp -r kindle-kit/.kindle /chemin/vers/mon-repo/
```

### Rendre le script exécutable

```bash
chmod +x .kindle/build.sh
```

### Configuration

1. Édite `.kindle/config.yaml` : titre, auteur, kindle_email
2. Édite `.kindle/manifest.yaml` : liste tes fichiers dans l'ordre voulu
3. Édite `.kindle/book.md` : ton introduction personnalisée

---

## Utilisation

```bash
# Générer l'EPUB
./.kindle/build.sh

# Générer l'EPUB + PDF
./.kindle/build.sh --pdf

# Générer et envoyer au Kindle
./.kindle/build.sh --send

# Tout à la fois
./.kindle/build.sh --pdf --send
```

L'EPUB est généré dans `.kindle/output/ebook.epub`.

---

## GitHub Actions

Le workflow `.github/workflows/build-ebook.yml` est déjà configuré.

### Déclenchement manuel (workflow_dispatch)

1. Va sur ton repo GitHub → **Actions**
2. Sélectionne **Build Kindle eBook**
3. Clique **Run workflow**
4. Choisis le format (epub ou epub+pdf)
5. L'artefact est disponible en téléchargement à la fin du job

### Déclenchement sur tag

```bash
git tag kindle-v1.0
git push origin kindle-v1.0
```

L'EPUB est automatiquement joint en **Release Asset**.

### Envoi automatique au Kindle depuis GitHub Actions

Configure le secret `KINDLE_EMAIL` dans les settings du repo :
> Settings → Secrets and variables → Actions → New repository secret

Et configure `GMAIL_USER` + `GMAIL_APP_PASSWORD` de la même façon.

---

## Structure des fichiers

```
.kindle/
├── build.sh              ← Script principal
├── config.yaml           ← Métadonnées et paramètres Pandoc
├── manifest.yaml         ← Liste ordonnée des fichiers
├── book.md               ← Fichier racine (introduction)
├── styles/
│   └── kindle.css        ← CSS optimisé e-ink
├── output/               ← Fichiers générés (gitignorés)
│   └── ebook.epub
├── INSTALL.md            ← Ce fichier
└── .github/
    └── workflows/
        └── build-ebook.yml
```

---

## .gitignore recommandé

Ajoute dans le `.gitignore` de ton repo :
```
.kindle/output/
```
