#!/bin/bash

# project name
echo Enter the sample name of the pcHi-C project:
echo
read name

echo main project directory pcHi-C_${name} with sub directories will now be produced

# create directories for the project
mkdir -P pcHi-C_${name}/{resources,bin/{ERR,OUT},repository,hg38,output,tmp}

echo done