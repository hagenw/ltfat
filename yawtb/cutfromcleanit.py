print sections




for (key,match) in patterns:
    hh=hh.replace(key,match)



# Remove the license, it is always last. Count on this to remove it.
hh=hh[0:hh.find('LICENSE')]

# Join the sections.
for m in [fup,'Usage:','See also:']:
    
    p1=hh.find(m)+len(m)
    nextword=re.search('\w',hh[p1:])
    if nextword==None:
        # Special check: we reached the end of the file.
        p2=len(hh)-1
    else:
        p2=nextword.start()

    hh=hh[0:p1]+' '+hh[p1+p2:]
