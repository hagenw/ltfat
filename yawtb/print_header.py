#!/usr/bin/python

import sys

fname=sys.argv[1]

f=file(fname,'r')

buf=f.readlines()

f.close

ii=0

while buf[ii][0]!='%':
    ii=ii+1

while buf[ii][0]=='%':
    print buf[ii][1:],
    ii=ii+1



    
