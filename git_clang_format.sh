#!/usr/bin/env sh

bold=$(tput bold)
normal=$(tput sgr0)
orange=$(tput setaf 4)
green=$(tput setaf 2)
cyan=$(tput setaf 3)
white=$(tput setaf 7)

function printboldcolor() {
  COLOR=$1
  TEXT=$2

  printf "${bold}${COLOR}${TEXT}${white}${normal}\n"
}


printboldcolor $cyan "Running clang-format on the staged changes...\n"

CF_DIFF=$(git -c color.ui=always clang-format --style=file --diff)

if [ $? -eq 0 ]; then
  printboldcolor $green "Nothing to format!"
else
  printboldcolor $orange "Applying the following changes:"
  printf "$CF_DIFF\n"

  git clang-format --style=file --quiet
  git add --update
  exit 0
fi
