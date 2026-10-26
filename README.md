# vocalize

Plugin Claude Code pour macOS : à la fin de chaque réponse, Claude énonce à voix haute, avec la synthèse vocale du système (`say`), un résumé rapide de ce qu'il a fait ou la question qu'il te pose. Tu peux donc travailler sur une autre fenêtre et être prévenu à l'oreille.

## Installation

Dans une session Claude Code :

```
/plugin install vocalize --marketplace baotista/vocalize
```

Réponds `y` pour ajouter la marketplace, puis choisis une portée (la portée utilisateur l'active dans tous tes projets).

Depuis un shell :

```
claude plugin install vocalize --marketplace baotista/vocalize
```

## Fonctionnement

- **Au démarrage de session**, une règle demande à Claude de terminer chaque réponse par une ligne `🔊 <phrase>` (25 mots maximum, en français, sans code).
- **À la fin de chaque réponse**, cette ligne est lue, précédée du nom du projet : « vocalize : les tests passent, je pousse ? ». Si la ligne manque, la voix dit « terminé ».
- **Quand Claude attend ta permission**, la voix dit « j'ai besoin de ta permission ».
- Un nouveau message coupe celui en cours de lecture.

## Commandes

- `/voice` bascule entre voix activée et coupée
- `/voice on` et `/voice off` activent ou coupent explicitement la voix

L'état est global à toutes les sessions et stocké dans le fichier `~/.claude/vocalize-off` (présent = muet).

## Voix

Le plugin utilise la voix système. Pour la changer ou télécharger une voix française de meilleure qualité (« Améliorée » ou « Premium ») : *Réglages Système → Accessibilité → Contenu énoncé → Voix du système*.

## Prérequis

macOS avec `jq` (fourni avec le système depuis macOS 15). Sur un autre système, le plugin reste silencieux.
