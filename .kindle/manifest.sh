#!/usr/bin/env bash
# manifest.sh — Génère manifest.yaml à partir d'une sélection de fichiers .md
#
# Usage :
#   ./.kindle/manifest.sh --interactive   Sélection via fzf (TAB=cocher, ENTER=valider)
#   ./.kindle/manifest.sh --auto          Auto-discover + exclusions .kindleignore
#
# Le manifest généré liste les chemins relatifs à la racine du dépôt.
# En mode --interactive, l'ordre dans le manifest = ordre alphabétique des fichiers,
# indépendamment de l'ordre de sélection. Réordonner manifest.yaml manuellement si besoin.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$SCRIPT_DIR/manifest.yaml"
KINDLEIGNORE="$SCRIPT_DIR/.kindleignore"

# ── Couleurs ─────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ── Parsing des options ──────────────────────────────────────
MODE=""
for arg in "$@"; do
  case $arg in
    --interactive) MODE="interactive" ;;
    --auto)        MODE="auto" ;;
    --help)
      echo "Usage: $0 [--interactive|--auto]"
      echo "  --interactive  Sélection manuelle via fzf (brew install fzf)"
      echo "  --auto         Auto-discover, exclusions via .kindle/.kindleignore"
      exit 0 ;;
  esac
done

[[ -z "$MODE" ]] && error "Mode requis : --interactive ou --auto\nUsage : $0 [--interactive|--auto]"

# ── Recherche des fichiers .md ───────────────────────────────
# Exclut toujours .kindle/ et */output/*
# Retourne les chemins absolus, triés alphabétiquement
# Compatible bash 3.2 (pas de mapfile)
find_md_files() {
  find "$REPO_ROOT" -name "*.md" \
    -not -path "$SCRIPT_DIR/*" \
    -not -path "*/output/*" \
    | sort
}

# ── Vérification .kindleignore ───────────────────────────────
# Retourne 0 (vrai) si le fichier doit être ignoré
is_ignored() {
  local filepath="$1"
  local rel="${filepath#$REPO_ROOT/}"

  [[ ! -f "$KINDLEIGNORE" ]] && return 1

  while IFS= read -r pattern; do
    [[ "$pattern" =~ ^[[:space:]]*#  ]] && continue
    [[ "$pattern" =~ ^[[:space:]]*$  ]] && continue
    case "$rel" in
      $pattern) return 0 ;;
    esac
  done < "$KINDLEIGNORE"
  return 1
}

# ── Confirmation avant écrasement ───────────────────────────
confirm_overwrite() {
  if [[ -f "$MANIFEST" ]]; then
    echo ""
    warn "Un manifest.yaml existe déjà."
    printf "  Écraser ? [o/N] "
    read -r answer
    [[ "$answer" =~ ^[oO]$ ]] || { info "Annulé. manifest.yaml inchangé."; exit 0; }
  fi
}

# ── Écriture du manifest.yaml ────────────────────────────────
write_manifest() {
  local files_list="$1"   # chemin vers fichier temporaire listant les chemins absolus

  local count=0
  while IFS= read -r f; do
    (( count++ )) || true
  done < "$files_list"

  {
    echo "# manifest.yaml — généré par manifest.sh le $(date '+%Y-%m-%d %H:%M')"
    echo "files:"
    while IFS= read -r f; do
      echo "  - ${f#$REPO_ROOT/}"
    done < "$files_list"
  } > "$MANIFEST"

  success "manifest.yaml écrit avec $count fichier(s) : $MANIFEST"
}

# ── Mode interactif (fzf) ────────────────────────────────────
if [[ "$MODE" == "interactive" ]]; then
  command -v fzf &>/dev/null || \
    error "fzf n'est pas installé.\nInstallez-le : brew install fzf"

  info "Sélectionnez les fichiers Markdown à inclure :"
  info "  TAB    = cocher/décocher"
  info "  ENTER  = valider la sélection"
  echo ""

  TMPFILE=$(mktemp)
  trap 'rm -f "$TMPFILE"' EXIT
  # fzf reçoit les chemins relatifs pour l'affichage, on reconstitue les absolus
  find_md_files \
    | sed "s|$REPO_ROOT/||" \
    | fzf --multi \
          --prompt="Fichiers Markdown > " \
          --header="TAB: cocher | ENTER: valider | ESC: annuler" \
    | sed "s|^|$REPO_ROOT/|" \
    > "$TMPFILE" || true

  if [[ ! -s "$TMPFILE" ]]; then
    warn "Aucun fichier sélectionné. manifest.yaml inchangé."
    rm -f "$TMPFILE"
    exit 0
  fi

  info "Fichiers sélectionnés :"
  while IFS= read -r f; do
    info "  ✓ ${f#$REPO_ROOT/}"
  done < "$TMPFILE"

  confirm_overwrite
  write_manifest "$TMPFILE"
  rm -f "$TMPFILE"

# ── Mode auto-discover ───────────────────────────────────────
elif [[ "$MODE" == "auto" ]]; then
  TMPFILE=$(mktemp)
  trap 'rm -f "$TMPFILE"' EXIT

  info "Parcours récursif de $REPO_ROOT..."

  while IFS= read -r f; do
    if is_ignored "$f"; then
      info "  ✗ ignoré : ${f#$REPO_ROOT/}"
    else
      info "  ✓ ${f#$REPO_ROOT/}"
      echo "$f" >> "$TMPFILE"
    fi
  done < <(find_md_files)

  if [[ ! -s "$TMPFILE" ]]; then
    rm -f "$TMPFILE"
    error "Aucun fichier .md trouvé (tous ignorés ou repo vide)."
  fi

  FOUND=$(wc -l < "$TMPFILE" | tr -d ' ')
  info "$FOUND fichier(s) retenu(s)."

  confirm_overwrite
  write_manifest "$TMPFILE"
  rm -f "$TMPFILE"
fi
