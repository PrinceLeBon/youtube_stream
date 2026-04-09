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

# Qualité cible : 720p max pour préserver CPU/RAM
# AV1 exclu : non supporté en hwdec sur la majorité des Mac (Intel/Apple Silicon < M3)
# Fallback automatique vers la meilleure qualité inférieure disponible en H.264/H.265
VIDEO_FORMAT="bestvideo[height<=720][vcodec!*=av01]+bestaudio/bestvideo[height<=480][vcodec!*=av01]+bestaudio/bestvideo[height<=360][vcodec!*=av01]+bestaudio/bestvideo[height<=720]+bestaudio/best"

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

  mpv \
    --no-video \
    --audio-buffer=2 \
    --cache=yes \
    --demuxer-max-bytes=20MiB \
    "$URL"

else
  log "🎬 Mode : vidéo (720p max, fallback automatique)"
  log "🔗 $URL"
  echo ""

  # Options mpv :
  #   --ontop              → fenêtre toujours au-dessus (Picture-in-Picture)
  #   --geometry           → taille et position par défaut (coin bas-droite)
  #   --autofit            → limite la taille max à 40% de l'écran
  #   --ytdl-format        → qualité 720p max avec fallback
  #   --cache              → buffer pour éviter les saccades réseau
  #   --hwdec              → décodage matériel pour économiser le CPU
  #   --video-sync         → synchronisation fluide
  mpv \
    --ontop \
    --geometry="40%x40%+95%+95%" \
    --autofit="40%" \
    --ytdl-format="$VIDEO_FORMAT" \
    --cache=yes \
    --demuxer-max-bytes=30MiB \
    --hwdec=videotoolbox \
    --video-sync=display-resample \
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
