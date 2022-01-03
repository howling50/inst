#! /bin/bash
echo -----ERRORS FOR "$1" SEND TO ~/checkerror.txt----- 2>>~/checkerror.txt
sleep 1
bash "$1" 2>>~/checkerror.txt
