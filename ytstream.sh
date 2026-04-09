#!/bin/bash

# =============================================================
# ytstream.sh — Stream YouTube optimisé pour développeur (Mac)
# Qualité : 720p max (fallback auto) | Lecteur flottant PiP
# Usage : ./ytstream.sh <url> [audio]
# =============================================================

# ─────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────
URL="$1"
MODE="$2"  # "audio" ou vide (vidéo par défaut)

# Qualité cible : 720p max, H.264 uniquement (avc1) pour VideoToolbox natif macOS
# AV1 et VP9 exclus : pas de hwdec fiable sur Mac Intel / Apple Silicon < M3
# Fallback : 480p H.264 → 360p H.264 → n'importe quelle 720p → best
VIDEO_FORMAT="bestvideo[height<=720][vcodec^=avc1]+bestaudio/bestvideo[height<=480][vcodec^=avc1]+bestaudio/bestvideo[height<=360][vcodec^=avc1]+bestaudio/bestvideo[height<=720]+bestaudio/best"

# ─────────────────────────────────────────
# FONCTIONS UTILITAIRES
# ─────────────────────────────────────────
log()   { echo "  $1"; }
ok()    { echo "  ✅ $1"; }
warn()  { echo "  ⚠️  $1"; }
error() { echo "  ❌ $1"; }

# ─────────────────────────────────────────
# VALIDATION URL
# ─────────────────────────────────────────
if [ -z "$URL" ]; then
  error "URL manquante."
  echo ""
  echo "  Usage : ./ytstream.sh <youtube_url> [audio]"
  echo ""
  echo "  Exemples :"
  echo "    ./ytstream.sh \"https://www.youtube.com/watch?v=VIDEO_ID\""
  echo "    ./ytstream.sh \"https://www.youtube.com/watch?v=VIDEO_ID\" audio"
  echo ""
  exit 1
fi

# Vérification format URL basique
if [[ "$URL" != http* ]]; then
  error "URL invalide. Elle doit commencer par http:// ou https://"
  exit 1
fi

# ─────────────────────────────────────────
# VÉRIFICATION RÉSEAU
# ─────────────────────────────────────────
log "🌐 Vérification de la connexion réseau..."
if ! curl -s --max-time 5 https://www.youtube.com > /dev/null 2>&1; then
  error "Pas de connexion internet détectée. Vérifie ton réseau."
  exit 1
fi
ok "Connexion OK"

# ─────────────────────────────────────────
# INSTALLATION DES DÉPENDANCES
# ─────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  log "🍺 Installation de Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v mpv >/dev/null 2>&1; then
  log "📦 Installation de mpv..."
  brew install mpv
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  log "📦 Installation de yt-dlp..."
  brew install yt-dlp
fi

# ─────────────────────────────────────────
# STREAM
# ─────────────────────────────────────────
echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║       🎬  ytstream               ║"
echo "  ╚══════════════════════════════════╝"
echo ""

if [ "$MODE" = "audio" ]; then
  log "🎧 Mode : audio uniquement"
  log "🔗 $URL"
  echo ""
  log "⏳ Récupération du flux audio..."

  mpv \
    --no-video \
    --audio-buffer=2 \
    --cache=yes \
    --demuxer-max-bytes=20MiB \
    --term-status-msg="  ▶ En cours : \${time-pos} / \${duration} — \${percent-pos}%" \
    "$URL"

else
  log "🎬 Mode : vidéo (720p H.264, fallback automatique)"
  log "🔗 $URL"
  echo ""
  log "⏳ Étape 1/3 — Analyse de l'URL via yt-dlp..."

  # Récupère le titre de la vidéo avant de lancer mpv (feedback immédiat)
  VIDEO_TITLE=$(yt-dlp --get-title --no-playlist --quiet "$URL" 2>/dev/null)
  if [ -n "$VIDEO_TITLE" ]; then
    ok "Vidéo trouvée : \"$VIDEO_TITLE\""
  else
    warn "Titre non récupéré (live ou accès restreint), on continue..."
  fi

  log "⏳ Étape 2/3 — Sélection du flux H.264 720p..."

  # Vérifie si un flux H.264 est disponible, sinon avertit
  CODEC_CHECK=$(yt-dlp --list-formats --no-playlist --quiet "$URL" 2>/dev/null | grep -i "avc1" | head -1)
  if [ -n "$CODEC_CHECK" ]; then
    ok "Flux H.264 disponible — décodage VideoToolbox activé"
  else
    warn "Aucun flux H.264 trouvé — fallback sur le meilleur disponible"
  fi

  log "⏳ Étape 3/3 — Ouverture du lecteur flottant..."
  echo ""

  mpv \
    --ontop \
    --geometry="40%x40%+95%+95%" \
    --autofit="40%" \
    --ytdl-format="$VIDEO_FORMAT" \
    --cache=yes \
    --demuxer-max-bytes=30MiB \
    --hwdec=videotoolbox \
    --video-sync=display-resample \
    --force-window=yes \
    --really-quiet \
    --term-status-msg="  ▶ En cours : \${time-pos} — buffer : \${demuxer-cache-duration}s" \
    --keep-open=no \
    "$URL"
fi

EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
  ok "Lecture terminée."
else
  error "mpv s'est arrêté avec une erreur (code $EXIT_CODE)."
  warn "Vérifie que l'URL est valide et accessible."
fi
