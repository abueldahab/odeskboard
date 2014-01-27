#!/bin/bash - 
#===============================================================================
#
#          FILE: diaa.sh
# 
#         USAGE: ./diaa.sh 
# 
#   DESCRIPTION: Gets my preferred technologies ranks in odesk
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Diaa Kasem (me@diaa.me), 
#  ORGANIZATION: 
#       CREATED: 01/26/14 11:12
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
date
declare -a techs=(angularjs d3js nodejs coffeescript jasmine flask)
for tech in ${techs[@]};
do
 coffee odeskrank.coffee 'Diaa Kasem' $tech 2> /dev/null;
 sleep 10;
done 
say "I'm done Diaa. Please, check your o desk rank."
