#!/bin/sh
. zbrewsetenv 

zbrewdeploy "$1" zbrew-igybin.bom
exit $? 
