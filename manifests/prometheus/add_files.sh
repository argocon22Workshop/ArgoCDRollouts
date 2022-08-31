#/bin/bash

files=$(find upstream/ -type f -name "*.yaml")
for f in ${files[@]}; do
  FILENAME=$(basename $f)
  kustomize edit add resource upstream/$FILENAME
done
