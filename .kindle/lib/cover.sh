#!/usr/bin/env bash
# lib/cover.sh — Génère cover.png via ImageMagick si absent.
# Sourcé par build.sh. Requiert que info/warn/success soient définis.
# Usage : generate_cover "$OUTPUT_COVER" "$TITLE" "$AUTHOR" "$REPO_NAME" "$TIMESTAMP"
# Si cover.png existe déjà → ne fait rien.
# Si ImageMagick absent → warning non bloquant, build continue sans couverture.

generate_cover() {
  local output="$1"
  local title="$2"
  local author="$3"
  local repo_name="$4"
  local timestamp="$5"

  if [[ -f "$output" ]]; then
    info "Couverture existante conservée : $(basename "$output")"
    return 0
  fi

  if ! command -v convert &>/dev/null; then
    warn "ImageMagick non trouvé (brew install imagemagick) — build sans couverture"
    return 0
  fi

  # Génération : fond blanc 1600x2400 (ratio Kindle standard)
  # caption: gère le retour à la ligne automatique pour les titres longs
  convert \
    -size 1600x2400 xc:white \
    \( -size 1400x320 -background white -fill black \
       -pointsize 85 -gravity Center caption:"${title}" \) \
    -gravity North -geometry +0+220 -composite \
    \( -size 1400x120 -background white -fill "#444444" \
       -pointsize 48 -gravity Center caption:"${author}" \) \
    -gravity North -geometry +0+600 -composite \
    \( -size 1400x80 -background white -fill "#888888" \
       -pointsize 36 -gravity Center caption:"${repo_name}" \) \
    -gravity South -geometry +0+220 -composite \
    \( -size 1400x65 -background white -fill "#aaaaaa" \
       -pointsize 28 -gravity Center caption:"Généré le ${timestamp}" \) \
    -gravity South -geometry +0+130 -composite \
    "$output" || {
    warn "Échec de la génération de couverture (ImageMagick) — build continue sans couverture"
    return 0
  }

  success "Couverture générée : $(basename "$output")"
}
