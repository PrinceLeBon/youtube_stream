#!/bin/bash

# =========================
# CONFIG
# =========================
URL="$1"
MODE="$2" # video (default) ou audio

# =========================
# CHECK URL
# =========================
if [ -z "$URL" ]; then
  echo "❌ Usage: ./ytstream.sh <youtube_url> [audio]"
  exit 1
fi

# =========================
# INSTALL HOMEBREW SI ABSENT
# =========================
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installation de Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# =========================
# INSTALL MPV SI ABSENT
# =========================
if ! command -v mpv >/dev/null 2>&1; then
  echo "📦 Installation de mpv..."
  brew install mpv
fi

# =========================
# INSTALL YT-DLP SI ABSENT
# =========================
if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "📦 Installation de yt-dlp..."
  brew install yt-dlp
fi

# =========================
# STREAM
# =========================
echo "🚀 Lancement du stream..."

if [ "$MODE" = "audio" ]; then
  echo "🎧 Mode audio"
  mpv --no-video "$URL"
else
  echo "🎬 Mode vidéo (haute qualité)"
  mpv --ytdl-format="bestvideo+bestaudio/best" "$URL"
fi
