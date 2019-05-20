#!/bin/bash

ensure_requirements_met() {
  ENTR=$(command -v entr)
  AG=$(command -v ag)

  if ! test "$ENTR" && ! test "$AG"; then
    echo "'entr' and 'ag' are required to use 'k'"
    echo "try 'brew install entr ag' and then try again"
    exit 1
  elif ! test "$ENTR"; then
    echo "'entr' is required to use 'k'"
    echo "try 'brew install entr' and then try again"
    exit 1
  elif ! test "$AG"; then
    echo "'ag' is required to use 'k'"
    echo "try 'brew install ag' and then try again"
    exit 1
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
