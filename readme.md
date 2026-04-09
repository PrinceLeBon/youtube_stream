````markdown
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

### 1. Cloner le projet depuis Git

```bash
git clone https://github.com/PrinceLeBon/youtube_stream.git
cd youtube_stream
````

---

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

---

### 🔹 Lire en mode audio uniquement

```bash
./ytstream.sh "https://www.youtube.com/watch?v=VIDEO_ID" audio
```

---

## ⚙️ Fonctionnement interne

Le script :

1. Vérifie si `brew` est installé
2. Installe automatiquement :

   * `mpv` (lecteur vidéo performant)
   * `yt-dlp` (récupération des flux YouTube)
3. Lance le streaming directement dans le terminal

---

## 🧪 Exemple concret

```bash
./ytstream.sh "https://www.youtube.com/watch?v=UBO8yngC-o0"
```

👉 Lance immédiatement la vidéo en haute qualité.

---

## 🧠 Astuce (alias)

Ajoute un alias pour gagner du temps :

```bash
alias ytplay="~/chemin/vers/ytstream.sh"
```

Puis :

```bash
ytplay "URL"
```

---

## 🔥 Améliorations futures (Roadmap)

### 🎶 Support des playlists

* Lire automatiquement toutes les vidéos d’une playlist
* Navigation entre les vidéos

---

### ⏱ Reprendre là où tu t’es arrêté

* Sauvegarde de la position de lecture
* Reprise automatique sur une vidéo déjà lancée

---

### 🎛 Contrôle avancé

* Raccourcis clavier personnalisés
* Contrôle via CLI (pause, skip, volume…)

---

### 📜 Historique des vidéos

* Sauvegarde des vidéos déjà lues
* Possibilité de relancer rapidement une vidéo

---

### 🔍 Recherche depuis le terminal

* Rechercher une vidéo YouTube sans navigateur
* Lancer directement depuis les résultats

---

### 📥 Mode téléchargement (optionnel)

* Télécharger vidéo ou audio
* Choix de la qualité

---

### ⚡ Mode ultra rapide (cache intelligent)

* Mise en cache temporaire pour éviter rechargement

---

## 🛠 Structure du projet

```
ytstream/
│── ytstream.sh
│── README.md
```

---

## 🤝 Contribution

Les contributions sont les bienvenues !

1. Fork le projet
2. Crée une branche (`feature/ma-feature`)
3. Commit tes changements
4. Push et ouvre une Pull Request

---

## 📄 Licence

MIT License — libre d’utilisation et de modification.

---

## 💡 Vision

Transformer ce script en un **outil CLI complet pour consommer YouTube comme un pro**, sans navigateur, avec performance, simplicité et puissance.

---

🔥 *Enjoy le terminal power.*

```
```
