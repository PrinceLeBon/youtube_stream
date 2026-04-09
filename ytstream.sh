#!/bin/bash

# ============================================================
# ytstream.sh — Stream YouTube interactif depuis le terminal
# ============================================================

# ========================
# COULEURS
# ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ========================
# INSTALL DÉPENDANCES
# ========================
install_deps() {
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${YELLOW}�� Installation de Homebrew...${RESET}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! command -v mpv >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Installation de mpv...${RESET}"
    brew install mpv
  fi

  if ! command -v yt-dlp >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Installation de yt-dlp...${RESET}"
    brew install yt-dlp
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Installation de fzf (sélecteur interactif)...${RESET}"
    brew install fzf
  fi
}

# ========================
# MISE À JOUR YT-DLP
# ========================
update_ytdlp() {
  echo -e "${CYAN}🔄 Mise à jour de yt-dlp...${RESET}"
  yt-dlp -U
}

# ========================
# CONNEXION COMPTE YOUTUBE
# ========================
login_youtube() {
  COOKIES_FILE="$HOME/.ytstream_cookies.txt"

  echo -e "${BOLD}${CYAN}"
  echo "╔══════════════════════════════════════╗"
  echo "║   🔐 Connexion à YouTube              ║"
  echo "╚══════════════════════════════════════╝"
  echo -e "${RESET}"
  echo -e "${YELLOW}Pour te connecter, tu dois exporter tes cookies YouTube depuis ton navigateur.${RESET}"
  echo ""
  echo -e "  1. Installe l'extension ${BOLD}«Get cookies.txt LOCALLY»${RESET} sur Chrome/Firefox"
  echo -e "  2. Connecte-toi sur ${CYAN}https://www.youtube.com${RESET}"
  echo -e "  3. Exporte les cookies au format Netscape"
  echo -e "  4. Place le fichier ici : ${BOLD}$COOKIES_FILE${RESET}"
  echo ""

  if [ -f "$COOKIES_FILE" ]; then
    echo -e "${GREEN}✅ Fichier cookies détecté : $COOKIES_FILE${RESET}"
    echo -e "${GREEN}✅ Tu es connecté à YouTube.${RESET}"
  else
    echo -e "${RED}❌ Aucun fichier cookies trouvé.${RESET}"
    echo -e "${YELLOW}💡 Place ton fichier cookies à : $COOKIES_FILE${RESET}"
  fi
  echo ""
  read -p "Appuie sur Entrée pour continuer..."
}

# ========================
# SÉLECTION DE QUALITÉ
# ========================
choose_quality() {
  echo -e "${BOLD}${CYAN}🎚  Choisis la qualité vidéo :${RESET}"
  echo ""
  echo "  1) 🏆 Meilleure qualité disponible"
  echo "  2) ��  1080p"
  echo "  3) 📺 720p"
  echo "  4) 📱 480p"
  echo "  5) 🐢 360p (faible débit)"
  echo ""
  read -p "Choix [1-5] (défaut: 1) : " QUALITY_CHOICE

  case "$QUALITY_CHOICE" in
    2) QUALITY="bestvideo[height<=1080]+bestaudio/best[height<=1080]" ;;
    3) QUALITY="bestvideo[height<=720]+bestaudio/best[height<=720]" ;;
    4) QUALITY="bestvideo[height<=480]+bestaudio/best[height<=480]" ;;
    5) QUALITY="bestvideo[height<=360]+bestaudio/best[height<=360]" ;;
    *) QUALITY="bestvideo+bestaudio/best" ;;
  esac
}

# ========================
# SÉLECTION MODE AUDIO/VIDÉO
# ========================
choose_mode() {
  echo ""
  echo -e "${BOLD}${CYAN}🎛  Choisis le mode de lecture :${RESET}"
  echo ""
  echo "  1) 🎬 Vidéo"
  echo "  2) 🎧 Audio uniquement"
  echo ""
  read -p "Choix [1-2] (défaut: 1) : " MODE_CHOICE

  case "$MODE_CHOICE" in
    2) MODE="audio" ;;
    *) MODE="video" ;;
  esac
}

# ========================
# LANCER LE STREAM
# ========================
play() {
  local URL="$1"
  local COOKIES_FILE="$HOME/.ytstream_cookies.txt"
  local COOKIES_OPT=""

  [ -f "$COOKIES_FILE" ] && COOKIES_OPT="--cookies $COOKIES_FILE"

  echo ""
  echo -e "${GREEN}🚀 Lancement du stream...${RESET}"
  echo -e "${CYAN}🔗 $URL${RESET}"
  echo ""

  if [ "$MODE" = "audio" ]; then
    echo -e "${YELLOW}🎧 Mode audio${RESET}"
    mpv --no-video $COOKIES_OPT "$URL"
  else
    echo -e "${YELLOW}🎬 Mode vidéo — Qualité : $QUALITY${RESET}"
    mpv --ytdl-format="$QUALITY" $COOKIES_OPT "$URL"
  fi
}

# ========================
# RECHERCHE YOUTUBE
# ========================
search_youtube() {
  local COOKIES_FILE="$HOME/.ytstream_cookies.txt"
  local COOKIES_OPT=""
  [ -f "$COOKIES_FILE" ] && COOKIES_OPT="--cookies $COOKIES_FILE"

  echo ""
  read -p "🔍 Recherche YouTube : " QUERY

  if [ -z "$QUERY" ]; then
    echo -e "${RED}❌ Aucune recherche saisie.${RESET}"
    return
  fi

  echo -e "${CYAN}⏳ Recherche en cours...${RESET}"

  # Récupère les 10 premiers résultats : titre|url
  RESULTS=$(yt-dlp $COOKIES_OPT \
    "ytsearch10:$QUERY" \
    --print "%(title)s|||%(webpage_url)s" \
    --no-playlist \
    --quiet 2>/dev/null)

  if [ -z "$RESULTS" ]; then
    echo -e "${RED}❌ Aucun résultat trouvé.${RESET}"
    return
  fi

  # Affichage numéroté des résultats
  echo ""
  echo -e "${BOLD}${CYAN}📋 Résultats de recherche :${RESET}"
  echo ""

  IFS=$'\n' read -rd '' -a LINES <<< "$RESULTS"
  TOTAL=${#LINES[@]}

  for i in "${!LINES[@]}"; do
    TITLE=$(echo "${LINES[$i]}" | cut -d'|' -f1)
    NUM=$((i+1))
    printf "  ${BOLD}%2d)${RESET} %s\n" "$NUM" "$TITLE"
  done

  echo ""
  read -p "Choix [1-$TOTAL] : " PICK

  if ! [[ "$PICK" =~ ^[0-9]+$ ]] || [ "$PICK" -lt 1 ] || [ "$PICK" -gt "$TOTAL" ]; then
    echo -e "${RED}❌ Choix invalide.${RESET}"
    return
  fi

  SELECTED_LINE="${LINES[$((PICK-1))]}"
  VIDEO_URL=$(echo "$SELECTED_LINE" | awk -F'|||' '{print $NF}')

  choose_quality
  choose_mode
  play "$VIDEO_URL"
}

# ========================
# LIRE UNE URL DIRECTE
# ========================
play_url() {
  echo ""
  read -p "🔗 Colle une URL YouTube : " VIDEO_URL

  if [ -z "$VIDEO_URL" ]; then
    echo -e "${RED}❌ Aucune URL saisie.${RESET}"
    return
  fi

  choose_quality
  choose_mode
  play "$VIDEO_URL"
}

# ========================
# ABONNEMENTS / FEED
# ========================
browse_feed() {
  local COOKIES_FILE="$HOME/.ytstream_cookies.txt"

  if [ ! -f "$COOKIES_FILE" ]; then
    echo -e "${RED}❌ Tu dois te connecter d'abord (option 4 du menu).${RESET}"
    read -p "Appuie sur Entrée..."
    return
  fi

  echo -e "${CYAN}⏳ Chargement des dernières vidéos de tes abonnements...${RESET}"

  RESULTS=$(yt-dlp \
    --cookies "$COOKIES_FILE" \
    "https://www.youtube.com/feed/subscriptions" \
    --print "%(title)s|||%(webpage_url)s" \
    --playlist-end 20 \
    --quiet 2>/dev/null)

  if [ -z "$RESULTS" ]; then
    echo -e "${RED}❌ Impossible de charger le feed. Vérifie tes cookies.${RESET}"
    read -p "Appuie sur Entrée..."
    return
  fi

  echo ""
  echo -e "${BOLD}${CYAN}📰 Dernières vidéos de tes abonnements :${RESET}"
  echo ""

  IFS=$'\n' read -rd '' -a LINES <<< "$RESULTS"
  TOTAL=${#LINES[@]}

  for i in "${!LINES[@]}"; do
    TITLE=$(echo "${LINES[$i]}" | cut -d'|' -f1)
    NUM=$((i+1))
    printf "  ${BOLD}%2d)${RESET} %s\n" "$NUM" "$TITLE"
  done

  echo ""
  read -p "Choix [1-$TOTAL] : " PICK

  if ! [[ "$PICK" =~ ^[0-9]+$ ]] || [ "$PICK" -lt 1 ] || [ "$PICK" -gt "$TOTAL" ]; then
    echo -e "${RED}❌ Choix invalide.${RESET}"
    return
  fi

  SELECTED_LINE="${LINES[$((PICK-1))]}"
  VIDEO_URL=$(echo "$SELECTED_LINE" | awk -F'|||' '{print $NF}')

  choose_quality
  choose_mode
  play "$VIDEO_URL"
}

# ========================
# MENU PRINCIPAL
# ========================
main_menu() {
  while true; do
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║       🎬  ytstream — YouTube CLI          ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${RESET}"

    COOKIES_FILE="$HOME/.ytstream_cookies.txt"
    if [ -f "$COOKIES_FILE" ]; then
      echo -e "  ${GREEN}● Connecté à YouTube${RESET}"
    else
      echo -e "  ${RED}● Non connecté${RESET}"
    fi

    echo ""
    echo -e "  ${BOLD}1)${RESET} 🔍 Rechercher une vidéo"
    echo -e "  ${BOLD}2)${RESET} 🔗 Lire une URL directe"
    echo -e "  ${BOLD}3)${RESET} �� Mes abonnements (feed)"
    echo -e "  ${BOLD}4)${RESET} 🔐 Connexion à YouTube"
    echo -e "  ${BOLD}5)${RESET} 🔄 Mettre à jour yt-dlp"
    echo -e "  ${BOLD}6)${RESET} ❌ Quitter"
    echo ""
    read -p "Choix [1-6] : " CHOICE

    case "$CHOICE" in
      1) search_youtube ;;
      2) play_url ;;
      3) browse_feed ;;
      4) login_youtube ;;
      5) update_ytdlp ; read -p "Appuie sur Entrée..." ;;
      6) echo -e "${GREEN}👋 À bientôt !${RESET}" ; exit 0 ;;
      *) echo -e "${RED}❌ Choix invalide.${RESET}" ; sleep 1 ;;
    esac
  done
}

# ========================
# POINT D'ENTRÉE
# ========================
install_deps
main_menu
