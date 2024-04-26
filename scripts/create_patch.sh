#!/bin/bash

ref="../Configurations/config/examples/Creality/Ender-3/BigTreeTech SKR Mini E3 3.0"
new="../Marlin/Marlin"
diff="patch"

git diff --no-index "$ref/Configuration.h" "$new/Configuration.h" > "$diff/Configuration.h.diff"
git diff --no-index "$ref/Configuration_adv.h" "$new/Configuration_adv.h" > "$diff/Configuration_adv.h.diff"


# 0924b5df56c4e5ec96c49b73e0889bac2375e89a