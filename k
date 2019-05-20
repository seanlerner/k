#!/bin/sh

setup() {
  SKIP_RUN=false
  ENTR_DIRECTORY_ALTERED=2
  BYELLOW='\033[1;33m'
  RESET='\033[0m'

  while true; do
    if $SKIP_RUN; then
      SKIP_RUN=false
      ag -l | entr -cdp k echo_and_run $COMMAND
    else
      SKIP_RUN=false
      ag -l | entr -cd k echo_and_run $COMMAND
    fi

    EXIT_CODE="$?"

    if test $EXIT_CODE == $ENTR_DIRECTORY_ALTERED; then
      SKIP_RUN=true
    else
      echo
      echo "$BYELLOW \bpress CTRL-C again to exit $RESET"
      sleep 1
    fi
  done
}

echo_and_run() {
  echo $COMMAND
  echo

  $COMMAND
}

FIRST_ARG="$1"

if test $FIRST_ARG == 'echo_and_run'; then
  COMMAND="${@:2}"
  echo_and_run
else
  COMMAND="$@"
  setup
fi
