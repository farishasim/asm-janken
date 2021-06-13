#!/bin/bash

nasm -f elf game.asm -o game.o
ld -m elf_i386 -s -o game game.o