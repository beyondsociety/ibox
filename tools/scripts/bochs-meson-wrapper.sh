#!/bin/bash

export DISPLAY=:0
if [ "$NAME" == "cross" ]; then
  bochs -f ${PWD}/.bochsrc -q
else [ "$NAME" == "clang" ]
  bochs -f ${PWD}/.bochsrc -q
fi
