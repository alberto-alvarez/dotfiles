#!/bin/bash

# my bash functions

function submit-cartas() {
  mkdir ../cartas-$1 && find ./ -name email_\* -exec cp {} ../cartas-$1/ \;
  cd ../cartas-$1/
  rename 's/tpl$/txt/' *.tpl
}