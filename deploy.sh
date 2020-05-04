#!/bin/sh
. zbrewsetenv 

zbrewdeploy $1 igy630.bom
exit $? 
