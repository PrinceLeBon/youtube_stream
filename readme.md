# 🎬 ytstream — YouTube CLI interactif depuis le terminal (Mac)

Un outil en ligne de commande pour **regarder et écouter YouTube directement depuis le terminal**, avec un menu interactif complet : recherche, abonnements, choix de qualité, mode audio/vidéo, et connexion à ton compte.

---

## 🚀 Fonctionnalités

- 🔍 **Recherche YouTube** depuis le terminal (10 résultats, choix interactif)
- 🔗 **Lecture d'une URL directe** YouTube
- 📰 **Feed d'abonnements** (dernières vidéos de tes chaînes suivies)
- 🔐 **Connexion à ton compte YouTube** via cookies
- 🎚 **Choix de la qualité** : Meilleure / 1080p / 720p / 480p / 360p
- 🎛 **Mode vidéo ou audio uniquement**
- ⚙️ Installation automatique des dépendances
- 🔄 Mise à jour intégrée de `yt-dlp`
- ⚡ Zéro pub, rapide et léger

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
| `fzf` | Sélecteur interactif dans le terminal |

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

### 3. Lancer le script

```bash
./ytstream.sh
```

---

## ▶️ Utilisation

Lance simplement le script, sans argument :

```bash
./ytstream.sh
```

Un menu interactif s'affiche :

```
╔══════════════════════════════════════════╗
║       ��  ytstream — YouTube CLI          ║
╚══════════════════════════════════════════╝

  ● Non connecté

  1) 🔍 Rechercher une vidéo
  2) 🔗 Lire une URL directe
  3) 📰 Mes abonnements (feed)
  4) 🔐 Connexion à YouTube
  5) 🔄 Mettre à jour yt-dlp
  6) ❌ Quitter
```

---

## 🔐 Connexion à ton compte YouTube

La connexion se fait via un fichier de **cookies exportés depuis ton navigateur**. Cela te permet d'accéder à ton feed d'abonnements et aux vidéos privées/membres.

### Étapes :

1. Installe l'extension **[Get cookies.txt LOCALLY](https://chrome.google.com/webstore/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)** sur Chrome ou Firefox
2. Connecte-toi sur [youtube.com](https://www.youtube.com)
3. Clique sur l'extension et exporte les cookies au format **Netscape**
4. Renomme/déplace le fichier ici :

```
~/.ytstream_cookies.txt
```

5. Retourne dans le menu et vérifie l'option **4) Connexion** — elle confirmera que les cookies sont détectés.

> ⚠️ Les cookies sont personnels. Ne les partage jamais.

---

## 🔍 Recherche YouTube

Depuis le menu, choisis l'option **1)**.

1. Tape ta recherche (nom de vidéo, chaîne, sujet...)
2. Les 10 premiers résultats s'affichent numérotés
3. Choisis un numéro
4. Sélectionne la **qualité** et le **mode** (vidéo ou audio)
5. La lecture démarre automatiquement

---

## 📰 Feed d'abonnements

Depuis le menu, choisis l'option **3)**.

> Nécessite d'être connecté (cookies).

Les 20 dernières vidéos de tes abonnements s'affichent. Choisis une vidéo, configure la qualité et le mode, et lance la lecture.

---

## 🎚 Qualités disponibles

| Choix | Qualité |
|---|---|
| 1 | 🏆 Meilleure qualité disponible |
| 2 | 🖥 1080p |
| 3 | 📺 720p |
| 4 | 📱 480p |
| 5 | 🐢 360p (faible débit) |

---

## 🎛 Modes de lecture

| Choix | Mode |
|---|---|
| 1 | 🎬 Vidéo |
| 2 | 🎧 Audio uniquement |

---

## 🧠 Astuce — Alias

Ajoute un alias dans ton `~/.zshrc` pour lancer ytstream de n'importe où :

```bash
alias ytstream="~/chemin/vers/ytstream.sh"
```

Recharge ton shell :

```bash
source ~/.zshrc
```

Puis utilise :

```bash
ytstream
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
| 🔍 Recherche interactive | ✅ Fait |
| 🔗 Lecture URL directe | ✅ Fait |
| 🎚 Choix de qualité | ✅ Fait |
| 🎛 Mode audio/vidéo | ✅ Fait |
| 🔐 Connexion compte YouTube | ✅ Fait |
| 📰 Feed abonnements | ✅ Fait |
| 🔄 Mise à jour yt-dlp intégrée | ✅ Fait |
| 🎶 Support des playlists | 🔜 Prévu |
| ⏱ Reprendre la lecture | 🔜 Prévu |
| 📜 Historique des vidéos | 🔜 Prévu |
| 📥 Mode téléchargement (vidéo/audio) | 🔜 Prévu |

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
