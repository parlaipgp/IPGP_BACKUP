#!/bin/bash

for dir in */; do
    if [ -d "$dir" ]; then
        echo "-------------------------------------------------------------------------------------------------------->>>>>>  Entering directory: $dir"
        (cd "$dir" && ./resampleDataGMT.sh && ./Plot_Output_SPECFEMX.sh)
    fi
done
