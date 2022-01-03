#! /bin/bash

tput setaf 1; echo -----ERRORS FOR "$1" SEND TO ~/checkerror.txt----- 2>>~/checkerror.txt
tput sgr0; sleep 2
bash "$1" 2>>~/checkerror.txt
