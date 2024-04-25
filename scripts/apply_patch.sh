#!/bin/bash

ref="../Configurations/config/examples/Creality/Ender-3/BigTreeTech SKR Mini E3 3.0"
new="../Marlin/Marlin"
diff="patch"

cp "$ref/*" "$new/*"

git apply "$diff/Configuration.h.diff"
git apply "$diff/Configuration_adv.h.diff"