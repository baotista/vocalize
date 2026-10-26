#!/bin/bash
# Hooks du plugin vocalize. Usage : vocalize.sh session-start|stop|notification
# L'entrée JSON du hook arrive sur stdin.

OFF_FILE="$HOME/.claude/vocalize-off"
DIR="$(cd "$(dirname "$0")" && pwd)"
input="$(cat)"

speak() {
  command -v say >/dev/null 2>&1 || return 0
  [ -e "$OFF_FILE" ] && return 0
  local project
  project="$(basename "${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' <<<"$input")}")"
  # Le dernier message gagne : on coupe la lecture en cours.
  killall say >/dev/null 2>&1
  # Détaché, pour ne pas bloquer Claude Code pendant la lecture.
  nohup say "${project:+$project : }$1" >/dev/null 2>&1 &
}

# Texte de la dernière réponse de l'assistant.
last_assistant_text() {
  local text transcript
  text="$(jq -r '.last_assistant_message // empty' <<<"$input")"
  if [ -z "$text" ]; then
    transcript="$(jq -r '.transcript_path // empty' <<<"$input")"
    [ -f "$transcript" ] || return 0
    text="$(tail -n 500 "$transcript" \
      | jq -c 'select(.type == "assistant")
               | [.message.content[]? | select(.type == "text") | .text]
               | select(length > 0) | join("\n")' 2>/dev/null \
      | tail -n 1 | jq -r '.')"
  fi
  printf '%s' "$text"
}

case "$1" in
  session-start)
    jq -n --rawfile rule "$DIR/rule.md" \
      '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $rule}}'
    ;;
  stop)
    line="$(last_assistant_text | grep '^[[:space:]]*🔊' | tail -n 1 \
      | sed -e 's/^[[:space:]]*🔊[[:space:]]*//' -e 's/[*_`]//g')"
    speak "${line:-terminé.}"
    ;;
  notification)
    case "$(jq -r '.notification_type // empty' <<<"$input")" in
      permission_prompt) speak "j'ai besoin de ta permission." ;;
      idle_prompt) ;;
      *) speak "j'ai besoin de toi." ;;
    esac
    ;;
esac
exit 0
