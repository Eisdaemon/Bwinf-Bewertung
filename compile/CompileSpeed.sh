#!/bin/bash

#Get Files
wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/compile/main.cpp
wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/compile/input.in
sudo apt install hyperfine

hyperfine 'g++ main.cpp'

rm main.cpp
rm input.in
rm a.out
rm CompileSpeed.sh
