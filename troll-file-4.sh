#!/bin/bash

# ===== DEPENDANCES =====
for cmd in zenity xdotool xrandr espeak; do
  if ! command -v $cmd &>/dev/null; then
    echo "Commande manquante : $cmd"
    exit 1
  fi
done

# ===== CONFIG =====
MESSAGES=(
  "Oops… poste non verrouillé 😈"
  "Trop tard."
  "Redémarrage requis."
  "La souris ne t'obéit plus."
)

TTS=(
  "Tu aurais dû verrouiller."
  "Contrôle perdu."
  "Redémarre le système."
)

ROTATIONS=("normal" "left" "inverted" "right")

# ===== BLOQUE L'ÉCRAN =====
xset s off
xset -dpms
xset s noblank

# ===== LOOP PRINCIPALE =====
i=0
while true; do

  # Message
  zenity --warning \
    --no-wrap \
    --title="Troll IT" \
    --text="${MESSAGES[$RANDOM % ${#MESSAGES[@]}]}" \
    --timeout=3 &

  # TTS
  espeak "${TTS[$RANDOM % ${#TTS[@]}]}" &

  # Souris qui se téléporte
  xdotool mousemove $((RANDOM % 1920)) $((RANDOM % 1080))

  # Rotation écran
  xrandr -o ${ROTATIONS[$i % 4]}

  sleep 2
  ((i++))
done
