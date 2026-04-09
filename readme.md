# 🎬 ytstream — Stream YouTube depuis le terminal (Mac)

Un script simple, puissant et automatisé pour **lire des vidéos YouTube directement depuis le terminal**, sans téléchargement, avec **haute qualité** et **mode audio optionnel**.

---

## 🚀 Fonctionnalités

- ▶️ Streaming direct depuis une URL YouTube
- 🎬 Mode vidéo (par défaut, haute qualité)
- 🎧 Mode audio uniquement
- ⚙️ Installation automatique des dépendances
- 🧠 Détection intelligente des outils manquants
- ⚡ Zéro pub, rapide et léger

---

## 📦 Prérequis

- macOS
- Accès internet
- Terminal (zsh/bash)

---

## 📥 Installation

### 1. Cloner le projet

```bash
git clone https://github.com/PrinceLeBon/youtube_stream.git
cd youtube_stream
```

### 2. Rendre le script exécutable

```bash
chmod +x ytstream.sh
```

---

## ▶️ Utilisation

### 🔹 Lire une vidéo (mode vidéo par défaut)

```bash
./ytstream.sh "https://www.youtube.com/watch?v=VIDEO_ID"
```

### 🔹 Lire en mode audio uniquement

```bash
./ytstream.sh "https://www.youtube.com/watch?v=VIDEO_ID" audio
```

---

## 🧪 Exemple concret

```bash
./ytstream.sh "https://www.youtube.com/watch?v=UBO8yngC-o0"
```

👉 Lance immédiatement la vidéo en haute qualité.

---

## ⚙️ Fonctionnement interne

Le script :

1. Vérifie si `brew` est installé
2. Installe automatiquement `mpv` (lecteur vidéo) et `yt-dlp` (récupération des flux)
3. Lance le streaming directement dans le terminal

---

## 🧠 Astuce — Alias

Ajoute un alias dans ton `~/.zshrc` pour gagner du temps :

```bash
alias ytplay="~/chemin/vers/ytstream.sh"
```

Puis utilise-le simplement :

```bash
ytplay "URL"
```

---

## 🛠 Structure du projet

```
youtube_stream/
├── ytstream.sh
└── README.md
```

---

## 🔥 Roadmap

| Fonctionnalité | Statut |
|---|---|
| 🎶 Support des playlists | 🔜 Prévu |
| ⏱ Reprendre la lecture | 🔜 Prévu |
| �� Contrôle avancé (pause, skip, volume) | 🔜 Prévu |
| 📜 Historique des vidéos | 🔜 Prévu |
| 🔍 Recherche depuis le terminal | 🔜 Prévu |
| 📥 Mode téléchargement (vidéo/audio) | 🔜 Prévu |
| ⚡ Cache intelligent | 🔜 Prévu |

---

## 🤝 Contribution

Les contributions sont les bienvenues !

1. Fork le projet
2. Crée une branche (`git checkout -b feature/ma-feature`)
3. Commit tes changements (`git commit -m 'feat: ma feature'`)
4. Push la branche (`git push origin feature/ma-feature`)
5. Ouvre une Pull Request

---

## 📄 Licence

[MIT](LICENSE) — libre d'utilisation et de modification.

---

> 🔥 *Enjoy le terminal power.*
