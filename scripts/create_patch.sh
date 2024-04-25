#!/bin/bash

ref="../Configurations/config/examples/Creality/Ender-3/BigTreeTech SKR Mini E3 3.0"
new="../Marlin/Marlin"
diff="patch"

git diff "$ref/Configuration.h" "$new/Configuration.h" > "$diff/Configuration.h.diff"
git diff "$ref/Configuration_adv.h" "$new/Configuration_adv.h" > "$diff/Configuration_adv.h.diff"
