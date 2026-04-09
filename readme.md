# 🎬 ytstream — Stream YouTube optimisé pour développeur (Mac)

Un script CLI minimaliste pour **streamer YouTube directement depuis le terminal**, avec une fenêtre flottante Picture-in-Picture, une qualité adaptée aux performances, et zéro friction.

> Conçu pour les développeurs qui veulent garder une vidéo en fond sans sacrifier les performances de leur machine.

---

## 🚀 Fonctionnalités

- 🎬 **Mode vidéo** avec fenêtre flottante toujours au-dessus (PiP)
- 🎧 **Mode audio** uniquement, consommation minimale
- 🎚 **Qualité 720p max** par défaut (fallback automatique si indisponible)
- 🔌 **Décodage matériel** (`hwdec`) pour économiser le CPU
- 🌐 **Vérification réseau** avant le lancement
- 🛡 **Gestion des erreurs** (URL invalide, absence réseau, crash mpv)
- ⚙️ **Installation automatique** des dépendances manquantes
- ⚡ Zéro dépendance lourde, approche minimaliste

---

## 📦 Prérequis

- macOS
- Accès internet
- Terminal (zsh/bash)

Les dépendances suivantes sont **installées automatiquement** si absentes :

| Outil | Rôle |
|---|---|
| `brew` | Gestionnaire de paquets macOS |
| `mpv` | Lecteur vidéo/audio performant |
| `yt-dlp` | Récupération des flux YouTube |

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

## 🎚 Qualité vidéo — Pourquoi 720p ?

Le script est pensé pour un usage **en multitâche** : tu streamlines une vidéo pendant que tu développes (Flutter, Android Studio, VS Code...).

La qualité **720p max** est le bon compromis :
- ✅ Image nette et agréable dans une petite fenêtre PiP
- ✅ Décodage léger, CPU/RAM préservés pour ton IDE
- ✅ Moins de bande passante consommée

### Logique de fallback automatique

Si le 720p n'est pas disponible sur la vidéo, le script descend automatiquement :

```
720p → 480p → 360p → meilleur disponible
```

Aucune intervention manuelle nécessaire.

---

## 🖥 Lecteur flottant — Picture-in-Picture

En mode vidéo, la fenêtre mpv est configurée pour :

| Option | Comportement |
|---|---|
| `--ontop` | Fenêtre toujours au-dessus des autres apps |
| `--geometry=40%x40%+95%+95%` | Positionnée en bas à droite de l'écran |
| `--autofit=40%` | Taille limitée à 40% de l'écran |
| `--hwdec=auto-safe` | Décodage matériel automatique (GPU) |

Tu peux **redimensionner et déplacer** la fenêtre librement avec la souris.

---

## ⚙️ Fonctionnement interne

1. Valide l'URL passée en paramètre
2. Vérifie la connexion internet (timeout 5s)
3. Installe les dépendances manquantes via Homebrew
4. Lance `mpv` avec les options optimisées selon le mode choisi

---

## 🧠 Astuce — Alias

Ajoute un alias dans ton `~/.zshrc` pour lancer ytstream de n'importe où :

```bash
alias ytplay="~/chemin/vers/ytstream.sh"
```

Recharge ton shell :

```bash
source ~/.zshrc
```

Puis utilise :

```bash
ytplay "URL"
ytplay "URL" audio
```

---

## 🛠 Structure du projet

```
youtube_stream/
├── ytstream.sh
└── README.md
```

---

## 🔥 Améliorations futures

| Fonctionnalité | Description |
|---|---|
| 🔍 Recherche depuis le terminal | Rechercher une vidéo sans ouvrir le navigateur |
| 🎶 Support des playlists | Lire une playlist YouTube complète |
| ⏱ Reprise de lecture | Reprendre là où on s'est arrêté |
| 📜 Historique des vidéos | Conserver un log des vidéos regardées |
| ⌨️ Raccourcis clavier avancés | Contrôle volume, skip, vitesse via le terminal |
| 🔐 Connexion compte YouTube | Accéder aux abonnements et vidéos privées |
| 📥 Mode téléchargement | Télécharger vidéo ou audio en local |

---

## 🤝 Contribution

Les contributions sont les bienvenues !

1. Fork le projet
2. Crée une branche (`git checkout -b feature/ma-feature`)
3. Commit tes changements (`git commit -m 'feat: ma feature'`)
4. Push la branche (`git push origin feature/ma-feature`)
5. Ouvre une Pull Request

---

## �� Licence

[MIT](LICENSE) — libre d'utilisation et de modification.

---

> 🔥 *Enjoy le terminal power.*
