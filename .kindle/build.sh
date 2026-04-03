#!/usr/bin/env bash
# ============================================================
# build.sh — Génère un EPUB (et optionnellement un PDF)
#            à partir d'un manifest de fichiers Markdown.
# Usage : ./build.sh [--pdf] [--send]
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CONFIG="$SCRIPT_DIR/config.yaml"
MANIFEST="$SCRIPT_DIR/manifest.yaml"
CSS="$SCRIPT_DIR/styles/kindle.css"
OUTPUT_DIR="$SCRIPT_DIR/output"

# ── Couleurs ────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ── Modules lib/ ─────────────────────────────────────────────
source "$SCRIPT_DIR/lib/uuid.sh"
source "$SCRIPT_DIR/lib/cover.sh"

# ── Options ─────────────────────────────────────────────────
BUILD_PDF=false
BUILD_HTML=false
SEND_TO_KINDLE=false
for arg in "$@"; do
  case $arg in
    --pdf)  BUILD_PDF=true ;;
    --html) BUILD_HTML=true ;;
    --send) SEND_TO_KINDLE=true ;;
    --help)
      echo "Usage: $0 [--pdf] [--html] [--send]"
      echo "  --pdf   Génère aussi un PDF"
      echo "  --html  Génère aussi un fichier HTML standalone"
      echo "  --send  Envoie l'EPUB à ton Kindle (configure kindle_email dans config.yaml)"
      exit 0 ;;
  esac
done

# ── Vérifications ────────────────────────────────────────────
command -v pandoc  &>/dev/null || error "Pandoc n'est pas installé. Voir INSTALL.md"
command -v python3 &>/dev/null || error "Python3 requis pour lire le YAML"

ARCH=$(uname -m)
PANDOC_VERSION=$(pandoc --version | head -1)
info "Architecture : $ARCH"
info "Pandoc       : $PANDOC_VERSION"

# ── Lecture du config.yaml ───────────────────────────────────
read_yaml() {
  python3 - "$CONFIG" "$1" <<'EOF'
import sys, re
path, key = sys.argv[1], sys.argv[2]
with open(path) as f:
    for line in f:
        m = re.match(rf'^{re.escape(key)}:\s*"?([^"#\n]+)"?\s*$', line)
        if m:
            print(m.group(1).strip())
            break
EOF
}

TITLE=$(read_yaml "title")
AUTHOR=$(read_yaml "author")
LANG=$(read_yaml "language")
EPUB_VERSION=$(read_yaml "epub_version")
TOC=$(read_yaml "toc")
TOC_DEPTH=$(read_yaml "toc_depth")
HIGHLIGHT=$(read_yaml "highlight_style")
OUTPUT_STEM=$(read_yaml "output_filename")
KINDLE_EMAIL=$(read_yaml "kindle_email")
NUMBER_CHAPTERS=$(read_yaml "number_chapters" || echo "false")

OUTPUT_EPUB="$OUTPUT_DIR/${OUTPUT_STEM}.epub"
OUTPUT_PDF="$OUTPUT_DIR/${OUTPUT_STEM}.pdf"
OUTPUT_HTML="$OUTPUT_DIR/${OUTPUT_STEM}.html"

# ── UUID ──────────────────────────────────────────────────────
ensure_uuid "$CONFIG"

# ── Couverture ────────────────────────────────────────────────
REPO_NAME=$(basename "$REPO_ROOT")
BUILD_TIMESTAMP=$(date '+%d/%m/%Y %H:%M')
COVER="$SCRIPT_DIR/cover.png"
generate_cover "$COVER" "$TITLE" "$AUTHOR" "$REPO_NAME" "$BUILD_TIMESTAMP"

# ── Lecture du manifest.yaml ─────────────────────────────────
info "Lecture du manifest..."
INPUT_FILES=()
while IFS= read -r line; do
  # Ignorer commentaires et lignes vides
  [[ "$line" =~ ^[[:space:]]*#  ]] && continue
  [[ "$line" =~ ^[[:space:]]*$  ]] && continue
  # Lignes de liste YAML : "  - path/to/file.md"
  if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+(.+)$ ]]; then
    rel_path="${BASH_REMATCH[1]}"
    abs_path="$REPO_ROOT/$rel_path"
    if [[ -f "$abs_path" ]]; then
      INPUT_FILES+=("$abs_path")
      info "  ✓ $rel_path"
    else
      warn "  ✗ Fichier introuvable : $rel_path (ignoré)"
    fi
  fi
done < "$MANIFEST"

[[ ${#INPUT_FILES[@]} -eq 0 ]] && error "Aucun fichier valide dans le manifest."
info "${#INPUT_FILES[@]} fichier(s) à compiler."

# ── Création du dossier output ───────────────────────────────
mkdir -p "$OUTPUT_DIR"

# ── Construction EPUB ────────────────────────────────────────
info "Génération de l'EPUB..."

PANDOC_ARGS=(
  --from markdown+smart+pipe_tables+fenced_code_blocks+auto_identifiers
  --to epub"${EPUB_VERSION:-3}"
  --output "$OUTPUT_EPUB"
  --css "$CSS"
  --metadata "title=$TITLE"
  --metadata "author=$AUTHOR"
  --metadata "lang=$LANG"
  --metadata "identifier=urn:uuid:$UUID"
  --highlight-style "${HIGHLIGHT:-pygments}"
  --split-level=1
)

# Table des matières
[[ "$TOC" == "true" ]] && PANDOC_ARGS+=(--toc --toc-depth="${TOC_DEPTH:-3}")

# Numérotation des chapitres
[[ "$NUMBER_CHAPTERS" == "true" ]] && PANDOC_ARGS+=(--number-sections)

# Image de couverture (optionnelle)
[[ -f "$COVER" ]] && PANDOC_ARGS+=(--epub-cover-image="$COVER")

# Fichier de métadonnées (optionnel)
META="$SCRIPT_DIR/metadata.xml"
[[ -f "$META" ]] && PANDOC_ARGS+=(--epub-metadata="$META")

pandoc "${PANDOC_ARGS[@]}" "${INPUT_FILES[@]}"
success "EPUB généré : $OUTPUT_EPUB"

# ── Construction PDF (optionnel) ─────────────────────────────
if [[ "$BUILD_PDF" == true ]]; then
  info "Génération du PDF..."
  if command -v xelatex &>/dev/null || command -v lualatex &>/dev/null; then
    PDF_ENGINE="lualatex"
    command -v lualatex &>/dev/null || PDF_ENGINE="xelatex"
    pandoc \
      --from markdown+smart+pipe_tables+fenced_code_blocks \
      --to pdf \
      --pdf-engine="$PDF_ENGINE" \
      --output "$OUTPUT_PDF" \
      --highlight-style "${HIGHLIGHT:-pygments}" \
      --metadata "title=$TITLE" \
      --metadata "author=$AUTHOR" \
      "${INPUT_FILES[@]}"
    success "PDF généré : $OUTPUT_PDF"
  else
    warn "xelatex/lualatex non trouvé, PDF ignoré. Installe MacTeX si besoin."
  fi
fi

# ── Construction HTML standalone (optionnel) ─────────────────
if [[ "$BUILD_HTML" == true ]]; then
  info "Génération du HTML..."
  pandoc \
    --from markdown+smart+pipe_tables+fenced_code_blocks \
    --to html5 \
    --standalone \
    --embed-resources \
    --output "$OUTPUT_HTML" \
    --css "$CSS" \
    --metadata "title=$TITLE" \
    --metadata "author=$AUTHOR" \
    --highlight-style "${HIGHLIGHT:-pygments}" \
    "${INPUT_FILES[@]}"
  success "HTML généré : $OUTPUT_HTML"
fi

# ── Envoi Kindle par email ───────────────────────────────────
if [[ "$SEND_TO_KINDLE" == true ]]; then
  [[ -z "$KINDLE_EMAIL" || "$KINDLE_EMAIL" == "ton-kindle@kindle.com" ]] && \
    error "Configure kindle_email dans config.yaml avant d'utiliser --send"

  command -v msmtp &>/dev/null || command -v sendmail &>/dev/null || \
    error "msmtp ou sendmail requis pour l'envoi. Voir INSTALL.md"

  info "Envoi à $KINDLE_EMAIL..."
  FILENAME=$(basename "$OUTPUT_EPUB")

  # Envoi via msmtp (ou sendmail en fallback)
  if command -v msmtp &>/dev/null; then
    {
      echo "To: $KINDLE_EMAIL"
      echo "Subject: $TITLE"
      echo "MIME-Version: 1.0"
      echo "Content-Type: multipart/mixed; boundary=\"BOUNDARY\""
      echo ""
      echo "--BOUNDARY"
      echo "Content-Type: text/plain"
      echo ""
      echo "Envoyé par kindle-kit"
      echo "--BOUNDARY"
      echo "Content-Type: application/epub+zip"
      echo "Content-Disposition: attachment; filename=\"$FILENAME\""
      echo "Content-Transfer-Encoding: base64"
      echo ""
      base64 "$OUTPUT_EPUB"
      echo "--BOUNDARY--"
    } | msmtp "$KINDLE_EMAIL"
    success "Envoyé à $KINDLE_EMAIL"
  else
    warn "Envoi manuel : copie $OUTPUT_EPUB dans l'app Kindle ou envoie-le à $KINDLE_EMAIL"
  fi
fi

# ── Résumé ───────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Build terminé avec succès               ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo -e "  EPUB : $OUTPUT_EPUB"
[[ "$BUILD_PDF" == true && -f "$OUTPUT_PDF" ]] && echo -e "  PDF  : $OUTPUT_PDF"
[[ "$BUILD_HTML" == true && -f "$OUTPUT_HTML" ]] && echo -e "  HTML : $OUTPUT_HTML"
echo ""
