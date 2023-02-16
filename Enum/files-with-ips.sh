#!/bin/sh
grep –rnHoE –exclude-dir={boot,dev,lib,media,mnt,proc,root,run,sys,tmp,tmpfs,var} “([0-9]{1,3}[\.]){3}[0-9]{1,3}” /* 2>/dev/null | tee ~/results.txt 
