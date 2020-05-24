#!/bin/bash -x

# Set the shell to expand paths to null if no matches are found.
shopt -s nullglob

# Store the current working directory. This script will cd but is not supposed to stay in the user given directories.
calldir=$(pwd)

# This is important here! Any given argument like some/directory/*.png will be expanded into individual positional command line arguments. Thus $1 would not work.
INPUTPATHS=$@

# Iterate over all input paths.
for p in $INPUTPATHS
do
  dir=$(dirname $p)
  file=$(basename $p)

  cd $dir

  convert $file -resize 1600x900 -gravity center -background white -extent 1600x900 -quality 80 -set filename:f '%t' '%[filename:f].jpg'
done

# Finally jump back to the previous directory from which the script was called.
cd $calldir
