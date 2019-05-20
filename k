#!/bin/bash

ensure_requirements_met() {
  MAX_FILES=$(launchctl limit maxfiles | awk '{print $2}')
  ENTR=$(command -v entr)
  AG=$(command -v ag)


  if test "$MAX_FILES" -lt "10000"; then
    echo "maxfiles is too low"
    echo "try:"
    echo "  sudo curl http://eradman.com/entrproject/etc/limit.maxfiles.plist > /Library/LaunchDaemons/"
    echo "  sudo launchctl load /Library/LaunchDaemons/limit.maxfiles.plist"
    echo

    REQUIREMENTS_NOT_MET=true
  fi

  if ! test "$ENTR"; then
    echo "'entr' is required"
    echo "try:"
    echo "  brew install entr"
    echo

    REQUIREMENTS_NOT_MET=true
  fi


  if ! test "$AG"; then
    echo "'ag' is required"
    echo "try:"
    echo "  brew install ag"
    echo

    REQUIREMENTS_NOT_MET=true
  fi

  if test $REQUIREMENTS_NOT_MET; then
    echo "Try resolving the above requirements and then try again"
    exit 1
  fi

  if ! test "$COMMAND"; then
    echo "Usage:"
    echo "  k <your command>"
    exit
  fi
}

setup() {
  ensure_requirements_met

  SKIP_RUN=false
  ENTR_DIRECTORY_ALTERED=2
  BYELLOW="\033[33m"
  RESET="\033[0m"

  while true; do
    if $SKIP_RUN; then
      SKIP_RUN=false
      ag -l | entr -cdp k run "$COMMAND"
    else
      SKIP_RUN=false
      ag -l | entr -cd k run "$COMMAND"
    fi

    EXIT_CODE="$?"

    if test $EXIT_CODE == $ENTR_DIRECTORY_ALTERED; then
      SKIP_RUN=true
    else
      echo
      echo -en "$BYELLOW \bpress CTRL-C again to exit$RESET"
      echo
      sleep 1
    fi
  done
}

run() {
  echo "$COMMAND"
  echo

  $COMMAND
}

FIRST_ARG="$1"

if test "$FIRST_ARG" == 'run'; then
  COMMAND="${*:2}"
  run
else
  COMMAND="$*"
  setup
fi
