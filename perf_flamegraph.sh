#! /usr/bin/env bash

C='\e[1;34m'
CU='\e[4;34m'
NC='\e[0m' # No Color

RECORD_OUTPUT=perf.data
FLAMEGRAPH_OUTPUT=perf.svg


while getopts ":r:f:" OPT; do
  case "$OPT" in
    r)
      RECORD_OUTPUT=$OPTARG
      FLAMEGRAPH_OUTPUT=${RECORD_OUTPUT%.*}.svg
      ;;
    f)
      FLAMEGRAPH_OUTPUT=$OPTARG
      ;;
    ?)
      echo "usage: $(basename $0) [-r record_output] [-f flamegraph_output] -- executable"
  esac
done

shift "$(($OPTIND - 1))"
EXECUTABLE=$@

if [[ -z ${EXECUTABLE} ]]; then
  echo "no executable provided, so I won't run"
  echo "usage: $(basename $0) [-r record_output] [-f flamegraph_output] -- executable"
  exit 1
fi

echo -e "${C}running perf record...${NC}"
perf record -o ${RECORD_OUTPUT} -F 99 --call-graph=fp -- ${EXECUTABLE}

echo -e "${C}results saved to ${CU}${RECORD_OUTPUT}${NC}"

echo -e "${C}creating flame graph...${NC}"
perf script --no-demangle -i ${RECORD_OUTPUT} | c++filt -p | stackcollapse-perf | flamegraph -w 1920 --colors java > ${FLAMEGRAPH_OUTPUT}

echo -e "${C}flame graph saved to ${CU}${FLAMEGRAPH_OUTPUT}${NC}"
