#!/bin/bash
# Active ou coupe la voix. Usage : toggle.sh [on|off]

OFF_FILE="$HOME/.claude/vocalize-off"

case "$1" in
  on) want=on ;;
  off) want=off ;;
  *) [ -e "$OFF_FILE" ] && want=on || want=off ;;
esac

if [ "$want" = on ]; then
  rm -f "$OFF_FILE"
  # L'annonce « Voix activée » passe par la ligne 🔊 de la réponse.
  echo "vocalize : voix activée."
else
  mkdir -p "$(dirname "$OFF_FILE")"
  touch "$OFF_FILE"
  killall say >/dev/null 2>&1
  command -v say >/dev/null 2>&1 && say "Voix désactivée." >/dev/null 2>&1 &
  echo "vocalize : voix désactivée."
fi
